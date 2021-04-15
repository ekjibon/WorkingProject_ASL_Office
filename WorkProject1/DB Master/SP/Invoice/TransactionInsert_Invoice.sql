/****** Object:  StoredProcedure   Script Date: 03/02/2021 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[TransactionInsert_Invoice]'))
BEGIN
DROP PROCEDURE  [TransactionInsert_Invoice]
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

 -- execute [TransactionInsert_Invoice] 1,2022,12,8,3,'admin'
CREATE  PROCEDURE [dbo].[TransactionInsert_Invoice] 
	@Block int=0,
	@YearID INT = 0,
	@MonthId INT = 0,
	@ClientId INT = 0,
	@BillingHeadId INT = 0,
	@AddBy VARCHAR(128)
AS
BEGIN
set transaction isolation level read uncommitted;
BEGIN TRANSACTION 
BEGIN TRY
DECLARE @COUNTERIN INT=0, @MAXIDIN INT=0,@COUNTEREX INT=0, @MAXIDEX INT=0,@AccIdClient INT=0,@AccIdIN INT=0,@AccIdEX INT=0, @BillingHeadIdIN INT=0,@BillingHeadIdEX INT=0, @CurrDate DATETIME = GETDATE(),@TotalAmount Decimal(18,2) = 0,@TotalAmountDis Decimal(18,2) = 0,@TotalAmountClient Decimal(18,2) = 0,@TotalAmountIN Decimal(18,2) = 0,@TotalAmountEX Decimal(18,2) = 0,@InvoiceTransType INT=0,@AccBranchId INT=0,@AccRemarks NVARCHAR(200)=''; 
 DECLARE @TransactionDetail UTT_TRANSACTIONDETAIL
 

 
	
	CREATE TABLE #tmpInvoice_Income(
	[Id] [int] IDENTITY(1,1) NOT NULL,	
	[BillingHeadId] [int] NOT NULL,
	[TotalAmount] [decimal](18, 2) NOT NULL
	)
	CREATE TABLE #tmpInvoice_Expense(
	[Id] [int] IDENTITY(1,1) NOT NULL,	
	[BillingHeadId] [int] NOT NULL,
	[TotalAmount] [decimal](18, 2) NOT NULL
	)

	INSERT INTO #tmpInvoice_Income([BillingHeadId],[TotalAmount])
	SELECT [BillingHeadId],[TotalAmount] FROM Invoice_InvoiceGenerate WHERE ClientId=@ClientId AND  Year=@YearID AND MonthId=@MonthId AND BillingHeadId=@BillingHeadId  AND InvoiceStatus is null
	INSERT INTO #tmpInvoice_Expense([BillingHeadId],[TotalAmount])
	SELECT [BillingHeadId],[TotalAmount] FROM Invoice_InvoiceGenerate WHERE ClientId=@ClientId AND  Year=@YearID AND MonthId=@MonthId AND DiscountlinkBillingHeadId=@BillingHeadId AND InvoiceStatus='Discount' 

	SELECT @TotalAmount=sum([TotalAmount]) FROM #tmpInvoice_Income
	SELECT @TotalAmountDis=sum([TotalAmount]) FROM #tmpInvoice_Expense
	 
If(@Block=1) -- Invoice Process Publish
BEGIN
	SET @TotalAmountClient=@TotalAmount-isnull(@TotalAmountDis,0)
	SELECT @AccIdClient = LedgerId FROM CRM_Client WHERE Id = @ClientId

	INSERT INTO @TransactionDetail VALUES (1,@AccIdClient,@TotalAmountClient,0,0,0,1) 

SET @MAXIDEX =(SELECT count(Id) FROM #tmpInvoice_Expense ); 
SET @COUNTEREX = 1;
	WHILE (@COUNTEREX <= @MAXIDEX)
	BEGIN
			SELECT @BillingHeadIdEX = [BillingHeadId],@TotalAmountEX=[TotalAmount] FROM #tmpInvoice_Expense WHERE Id = @COUNTEREX
			SELECT @AccIdEX = LedgerId FROM Invoice_BillingHead WHERE Id = @BillingHeadIdEX

			INSERT INTO @TransactionDetail VALUES (2,@AccIdEX,@TotalAmountEX,0,0,0,1) 

	SET @COUNTEREX = @COUNTEREX+1;
	END
	SET @MAXIDIN =(SELECT count(Id) FROM #tmpInvoice_Income); 
SET @COUNTERIN = 1;
	WHILE (@COUNTERIN <= @MAXIDIN)
	BEGIN
			SELECT @BillingHeadIdIN = [BillingHeadId],@TotalAmountIN=[TotalAmount] FROM #tmpInvoice_Income WHERE Id = @COUNTERIN
			SELECT @AccIdIN = LedgerId FROM Invoice_BillingHead WHERE Id = @BillingHeadIdIN

			INSERT INTO @TransactionDetail VALUES (3,@AccIdIN,0,@TotalAmountIN,0,0,2) 

	SET @COUNTERIN = @COUNTERIN+1;
	END

			SET @AccBranchId=(select BranchId from ACC_Branchs where IsDeleted=0 AND Status='A')
			--SP Calling: 
			SET @AccRemarks='Add_Income_Invoice_Due_Process'+CAST(@ClientId AS NVARCHAR(100));
			SET @InvoiceTransType=1
			EXEC Transactiondetailinsert NULL,@AccBranchId,'',4,@CurrDate,@TotalAmount, @TotalAmount, @AddBy,@AccRemarks,'IP','Invoice',@InvoiceTransType, @TransactionDetail

			UPDATE  Invoice_InvoiceGenerate SET IsPublish=1 WHERE ClientId=@ClientId AND  Year=@YearID AND MonthId=@MonthId AND BillingHeadId=@BillingHeadId  AND InvoiceStatus is null
			UPDATE  Invoice_InvoiceGenerate SET IsPublish=1 WHERE ClientId=@ClientId AND  Year=@YearID AND MonthId=@MonthId AND DiscountlinkBillingHeadId=@BillingHeadId  AND InvoiceStatus='Discount'
			

END
If(@Block=2) -- Invoice Process Clear
BEGIN
	SET @TotalAmountClient=@TotalAmount-isnull(@TotalAmountDis,0)
	SELECT @AccIdClient = LedgerId FROM CRM_Client WHERE Id = @ClientId

	SET @MAXIDIN =(SELECT count(Id) FROM #tmpInvoice_Income); 
SET @COUNTERIN = 1;
	WHILE (@COUNTERIN <= @MAXIDIN)
	BEGIN
			SELECT @BillingHeadIdIN = [BillingHeadId],@TotalAmountIN=[TotalAmount] FROM #tmpInvoice_Income WHERE Id = @COUNTERIN
			SELECT @AccIdIN = LedgerId FROM Invoice_BillingHead WHERE Id = @BillingHeadIdIN

			INSERT INTO @TransactionDetail VALUES (1,@AccIdIN,@TotalAmountIN,0,0,0,1) 

	SET @COUNTERIN = @COUNTERIN+1;
	END

	INSERT INTO @TransactionDetail VALUES (2,@AccIdClient,0,@TotalAmountClient,0,0,2) 

SET @MAXIDEX =(SELECT count(Id) FROM #tmpInvoice_Expense); 
SET @COUNTEREX = 1;
	WHILE (@COUNTEREX <= @MAXIDEX)
	BEGIN
			SELECT @BillingHeadIdEX = [BillingHeadId],@TotalAmountEX=[TotalAmount] FROM #tmpInvoice_Expense WHERE Id = @COUNTEREX
			SELECT @AccIdEX = LedgerId FROM Invoice_BillingHead WHERE Id = @BillingHeadIdEX

			INSERT INTO @TransactionDetail VALUES (3,@AccIdEX,0,@TotalAmountEX,0,0,2) 

	SET @COUNTEREX = @COUNTEREX+1;
	END
	

			SET @AccBranchId=(select BranchId from ACC_Branchs where IsDeleted=0 AND Status='A')
			--SP Calling: 
			SET @AccRemarks='Add_Income_Invoice_Process_Clear'+CAST(@ClientId AS NVARCHAR(100));
			SET @InvoiceTransType=2
			EXEC Transactiondetailinsert NULL,@AccBranchId,'',4,@CurrDate,@TotalAmount, @TotalAmount, @AddBy,@AccRemarks,'IP','Invoice',@InvoiceTransType, @TransactionDetail

			 DELETE FROM dbo.Invoice_InvoiceGenerate WHERE ClientId =@ClientId  AND BillingHeadId=@BillingHeadId AND Year=@YearID AND MonthId =@MonthId
             DELETE FROM dbo.Invoice_BillingProcess WHERE ClientId =@ClientId  AND BillingHeadId=@BillingHeadId AND Year=@YearID AND MonthId =@MonthId
			 DELETE FROM dbo.Invoice_InvoiceGenerate WHERE ClientId=@ClientId AND  Year=@YearID AND MonthId=@MonthId AND DiscountlinkBillingHeadId=@BillingHeadId  AND InvoiceStatus='Discount'
			

END

 DROP TABLE #tmpInvoice_Income,#tmpInvoice_Expense
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



