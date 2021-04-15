/****** Object:  StoredProcedure   Script Date: 03/02/2021 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TransactionRollback_Invoice]'))
BEGIN
DROP PROCEDURE  [TransactionRollback_Invoice]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		 Azmal	
-- Create date: 03/02/2021
-- Description:	
-- =============================================

 -- execute [TransactionRollback_Invoice] 6,'admin'
CREATE  PROCEDURE [dbo].[TransactionRollback_Invoice] 
	@MasterID INT = 0,
	@AddBy VARCHAR(128)
AS
BEGIN
set transaction isolation level read uncommitted;
BEGIN TRANSACTION 
BEGIN TRY
DECLARE @COUNTERDR INT=0, @MAXIDDR INT=0,@COUNTERCR INT=0, @MAXIDCR INT=0,@AccIdDR INT=0,@AccIdCR INT=0, @ClientId INT=0,@TransactionId INT=0,@IsApproved INT=0, @CurrDate DATETIME = GETDATE(),@TotalAmount Decimal(18,2) = 0,@TotalAmountDis Decimal(18,2) = 0,@TotalAmountDR Decimal(18,2) = 0,@TotalAmountCR Decimal(18,2) = 0,@InvoiceTransType INT=0,@AccBranchId INT=0,@AccRemarks NVARCHAR(300)='',@InvoiceNo NVARCHAR(300)=''; 
 DECLARE @TransactionDetail UTT_TRANSACTIONDETAIL
 
 SELECT  @InvoiceNo = InvoiceNo , @ClientId = ClientId  FROM [dbo].[Invoice_CollectionMaster]  WHERE Id = @MasterID 
 SELECT  @IsApproved = IsApproved , @TransactionId = Id , @TotalAmount= DrTotal FROM [dbo].[ACC_Transaction]  WHERE CollectionMasterId = @MasterID 
 --Log Insert
 INSERT INTO [dbo].[Invoice_InvoiceLog]([InvoiceNo], [ClientId], [CollectionAmount], [LogType], [LogStatus], [Description], [LogDate], [UserId], [IsDeleted], [AddBy], [AddDate])
 VALUES(@InvoiceNo,@ClientId,@TotalAmount,'Collection Rollback','Collection Rollback successfully','Collection Rollback by SP',GETDATE(),@AddBy,0,@AddBy,GETDATE())
	
	
If(@IsApproved=0) -- Roll Back Transaction and voucher and due generate Un approved voucher
BEGIN

	update [dbo].[Invoice_InvoiceGenerate] set DueAmount=TotalAmount,CollectionAmount=0,CollectionNarration='',DiscountAmount=0,AdjustmentAmount=0,ExtraCollectionAmount=0,IsPaid=0,Status='Draft' where ClientId=@ClientId AND InvoiceNo= @InvoiceNo  AND IsPaid=1 AND InvoiceStatus is null AND Year IN(SELECT Year FROM [dbo].[Invoice_CollectionDetails] where MasterID=@MasterID) AND MonthId IN(SELECT MonthId FROM [dbo].[Invoice_CollectionDetails] where MasterID=@MasterID)
	update [dbo].[Invoice_InvoiceGenerate] set DueAmount=null,CollectionAmount=null,CollectionNarration='',DiscountAmount=0,AdjustmentAmount=0,ExtraCollectionAmount=0,IsPaid=0,Status='Draft' where ClientId=@ClientId AND InvoiceNo= @InvoiceNo AND IsPaid=1 AND InvoiceStatus='Discount' AND Year IN(SELECT Year FROM [dbo].[Invoice_CollectionDetails] where MasterID=@MasterID) AND MonthId IN(SELECT MonthId FROM [dbo].[Invoice_CollectionDetails] where MasterID=@MasterID) --Discount
	delete FROM [dbo].[ACC_Transaction] where Id=@TransactionId
	delete FROM [dbo].[ACC_TransactionDetail] where TransactionId=@TransactionId
	delete FROM [dbo].[Invoice_CollectionMaster] where Id=@MasterID
	delete FROM [dbo].[Invoice_CollectionDetails] where MasterID=@MasterID

END
If(@IsApproved=1) -- Roll Back Transaction and voucher and due generate  approved voucher
BEGIN

	CREATE TABLE #tmpTransaction_DR(
	[Id] [int] IDENTITY(1,1) NOT NULL,	
	LedgerId [int] NOT NULL,
	DrAmount [decimal](18, 2) NOT NULL
	)
	CREATE TABLE #tmpTransaction_CR(
	[Id] [int] IDENTITY(1,1) NOT NULL,	
	LedgerId [int] NOT NULL,
	CrAmount [decimal](18, 2) NOT NULL
	)

	INSERT INTO #tmpTransaction_DR(LedgerId,DrAmount)
	SELECT LedgerId,CrAmount FROM ACC_TransactionDetail WHERE TransactionId=@TransactionId AND DC=2
	INSERT INTO #tmpTransaction_CR(LedgerId,CrAmount)
	SELECT LedgerId,DrAmount FROM ACC_TransactionDetail WHERE TransactionId=@TransactionId AND DC=1

	

	SET @MAXIDDR =(SELECT count(Id) FROM #tmpTransaction_DR); 
SET @COUNTERDR = 1;
	WHILE (@COUNTERDR <= @MAXIDDR)
	BEGIN
			SELECT @AccIdDR = LedgerId,@TotalAmountDR=DrAmount FROM #tmpTransaction_DR WHERE Id = @COUNTERDR

			INSERT INTO @TransactionDetail VALUES (1,@AccIdDR,@TotalAmountDR,0,0,0,1) 

	SET @COUNTERDR = @COUNTERDR+1;
	END

	

SET @MAXIDCR =(SELECT count(Id) FROM #tmpTransaction_CR); 
SET @COUNTERCR = 1;
	WHILE (@COUNTERCR <= @MAXIDCR)
	BEGIN
			SELECT @AccIdCR = LedgerId,@TotalAmountCR=CrAmount FROM #tmpTransaction_CR WHERE Id = @COUNTERCR
			
			INSERT INTO @TransactionDetail VALUES (2,@AccIdCR,0,@TotalAmountCR,0,0,2) 

	SET @COUNTERCR = @COUNTERCR+1;
	END
	

			SET @AccBranchId=(select BranchId from ACC_Branchs where IsDeleted=0 AND Status='A')
			--SP Calling: 
			SET @AccRemarks='RollBack_Transaction_InvoiceNo:'+@InvoiceNo+'_'+CAST(@ClientId AS NVARCHAR(100));
			SET @InvoiceTransType=4
			EXEC Transactiondetailinsert NULL,@AccBranchId,'',4,@CurrDate,@TotalAmount, @TotalAmount, @AddBy,@AccRemarks,'IP','RollBack_Transaction',@InvoiceTransType, @TransactionDetail

	update [dbo].[Invoice_InvoiceGenerate] set DueAmount=TotalAmount,CollectionAmount=0,CollectionNarration='',DiscountAmount=0,AdjustmentAmount=0,ExtraCollectionAmount=0,IsPaid=0,Status='Draft' where ClientId=@ClientId AND InvoiceNo= @InvoiceNo AND IsPaid=1 AND InvoiceStatus is null AND Year IN(SELECT Year FROM [dbo].[Invoice_CollectionDetails] where MasterID=@MasterID) AND MonthId IN(SELECT MonthId FROM [dbo].[Invoice_CollectionDetails] where MasterID=@MasterID)
	update [dbo].[Invoice_InvoiceGenerate] set DueAmount=null,CollectionAmount=null,CollectionNarration='',DiscountAmount=0,AdjustmentAmount=0,ExtraCollectionAmount=0,IsPaid=0,Status='Draft' where ClientId=@ClientId AND InvoiceNo= @InvoiceNo AND IsPaid=1 AND InvoiceStatus='Discount' AND Year IN(SELECT Year FROM [dbo].[Invoice_CollectionDetails] where MasterID=@MasterID) AND MonthId IN(SELECT MonthId FROM [dbo].[Invoice_CollectionDetails] where MasterID=@MasterID) --Discount
	
	delete FROM [dbo].[Invoice_CollectionMaster] where Id=@MasterID
	delete FROM [dbo].[Invoice_CollectionDetails] where MasterID=@MasterID
			
	DROP TABLE #tmpTransaction_DR,#tmpTransaction_CR

END

 
 DELETE FROM @TransactionDetail
------------------------------
COMMIT TRANSACTION ;
END TRY
BEGIN CATCH;
	ROLLBACK TRANSACTION ;
	DECLARE @ErrorMessage NVARCHAR(4000);  
    DECLARE @ErrorSeverity INT;  
    DECLARE @ErrorState INT;  
    SELECT   
        @ErrorMessage = ERROR_MESSAGE(),  
        @ErrorSeverity = ERROR_SEVERITY(),  
        @ErrorState = ERROR_STATE();  
    RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);  

END CATCH  


END
GO



