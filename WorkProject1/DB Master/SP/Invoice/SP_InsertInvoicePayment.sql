

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_InsertInvoicePayment]'))
BEGIN
DROP PROCEDURE  [SP_InsertInvoicePayment]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Azmal
-- Create date: Nov 19, 2020
-- Description:	
-- =============================================


CREATE  PROCEDURE [dbo].[SP_InsertInvoicePayment]
(
    @ClientId INT =0,
	@Year INT = 0,
	@MonthId INT = 0,
	@InvoiceNo VARCHAR(100)=null,
	@AddBy VARCHAR(100)=null,
	@DueDate datetime=null,
	@CollectionDate datetime=null,
	@InvoicePayment dbo.UTT_InvoicePayment READONLY
)	
AS
BEGIN
BEGIN TRANSACTION

	BEGIN TRY

	DECLARE @MasterId INT =0,@COUNTEREX INT=0, @MAXIDEX INT=0,@AccIdClient INT=0,@AccIdEX INT=0,@BillingHeadIdEX INT=0,@InvoiceAmount DECIMAL(18,2),@CollectionAmount DECIMAL(18,2),@AdjustmentAmount DECIMAL(18,2),@DiscountAmount DECIMAL(18,2),@ExtraCollectionAmount DECIMAL(18,2),@TotalAmountClient Decimal(18,2) = 0,@TotalAmountDrCr Decimal(18,2) = 0,@BankCollectionAmount Decimal(18,2) = 0,@TotalAmountEX Decimal(18,2) = 0,@Counter INT =0,@MAXID INT =0,@AccBranchId INT=0,@InvoiceTransType INT=0,@AccRemarks NVARCHAR(200)='',@CurrDate DATETIME = GETDATE(),@PaymentMethod VARCHAR(100)=null,@ChequeNo VARCHAR(100)=null ;
	DECLARE @TransactionDetail UTT_TRANSACTIONDETAIL
	

	
			SELECT @InvoiceAmount=sum(TotalAmount), @CollectionAmount=sum(CollectionAmount), @PaymentMethod=PaymentMethod, @ChequeNo=ChequeNo, @AdjustmentAmount=sum(AdjustmentAmount), @DiscountAmount=sum(DiscountAmount) , @ExtraCollectionAmount=sum(ExtraCollectionAmount) from @InvoicePayment GROUP BY PaymentMethod,ChequeNo
			
			--UPDATE [Invoice_InvoiceGenerate]
			UPDATE I SET I.DueAmount=I.TotalAmount-(ISNULL(I.CollectionAmount,0)+ISNULL(P.CollectionAmount,0)) - (ISNULL(I.AdjustmentAmount,0)+ISNULL(P.AdjustmentAmount,0)) - (ISNULL(I.DiscountAmount,0)+ISNULL(P.DiscountAmount,0))
			,I.CollectionAmount=ISNULL(I.CollectionAmount,0)+ISNULL(P.CollectionAmount,0),I.AdjustmentAmount=ISNULL(I.AdjustmentAmount,0)+ISNULL(P.AdjustmentAmount,0),I.ExtraCollectionAmount=ISNULL(I.ExtraCollectionAmount,0)+ISNULL(P.ExtraCollectionAmount,0),I.CollectionNarration=P.CollectionNarration,I.IsPaid=1,I.DiscountAmount=ISNULL(I.DiscountAmount,0)+ISNULL(P.DiscountAmount,0)
			FROM [dbo].[Invoice_InvoiceGenerate] I
			INNER JOIN @InvoicePayment P on P.Id=I.Id


		  

			INSERT INTO [dbo].[Invoice_CollectionMaster]
			([InvoiceNo], [InvoiceAmount], [ClientId], [Year], [MonthId], [CollectionDate], [CollectionAmount], [IsDeleted], [AddBy], [AddDate], [Remarks], [Status], [PaymentMethod],[ChequeNo],[AdjustmentAmount],[DiscountAmount],[ExtraCollectionAmount])
			 
			 VALUES(@InvoiceNo,@InvoiceAmount,@ClientId,@Year,@MonthId,@CollectionDate,@CollectionAmount,0,@AddBy,GETDATE(),'Invoice Collection','A',@PaymentMethod,@ChequeNo,@AdjustmentAmount,@DiscountAmount,@ExtraCollectionAmount)
			 
			  SET @MasterId  = @@IDENTITY;

			 IF(@@ROWCOUNT = 0)
			 BEGIN 
				 RAISERROR ('Invoice_CollectionMaster Does not Insert.',16,1); 
			 END 

			 
			 PRINT 'Layer >>> 1'

			INSERT INTO [dbo].[Invoice_CollectionDetails]
			([MasterID], [Year], [MonthId], [BillingHeadId], [Quantity], [Rate], [TotalAmount], [DueAmount], [CollectionAmount], [IsDeleted], [AddBy], [AddDate],  [Remarks], [Status],  [AdjustmentAmount], [CollectionNarration], [DiscountAmount] ,[ExtraCollectionAmount])
			SELECT @MasterId,[Year], [MonthId], [BillingHeadId], [Quantity], [Rate], [TotalAmount], [DueAmount], [CollectionAmount],0,@AddBy,GETDATE(),'Invoice Collection','A',AdjustmentAmount,CollectionNarration,DiscountAmount,ExtraCollectionAmount FROM @InvoicePayment

			UPDATE  [dbo].[Invoice_InvoiceGenerate] set DueDate=@DueDate where DueAmount>0 and IsDeleted=0 AND InvoiceNo = @InvoiceNo
			UPDATE dbo.Invoice_InvoiceGenerate set IsPaid=1,Status='Paid' WHERE ClientId=@ClientId  AND InvoiceNo = @InvoiceNo  AND  DiscountlinkBillingHeadId in(SELECT BillingHeadId FROM @InvoicePayment WHERE  DiscountAmount>0)  AND InvoiceStatus='Discount' and IsDeleted=0 

			--Accounts Journal Start---
			SET @BankCollectionAmount=@CollectionAmount+isnull(@ExtraCollectionAmount,0)
			INSERT INTO @TransactionDetail VALUES (1,5340,@BankCollectionAmount,0,0,0,1) --5340  Bank Code - ASJamuna Bank Ltd (1971)0073

			
			IF(isnull(@AdjustmentAmount,0)>0)
			BEGIN
			INSERT INTO @TransactionDetail VALUES (1,5382,@AdjustmentAmount,0,0,0,1) --5382  Bill Adjustment - EXBill Adjustment0037
			END
			IF(isnull(@ExtraCollectionAmount,0)>0)
			BEGIN
			INSERT INTO @TransactionDetail VALUES (2,6272,0,@ExtraCollectionAmount,0,0,2) --6272  Others Income - INOthers Income0019
			END
			SET @TotalAmountClient=@CollectionAmount+isnull(@AdjustmentAmount,0)
			SELECT @AccIdClient = LedgerId FROM CRM_Client WHERE Id = @ClientId
			SET @AccBranchId=(select BranchId from ACC_Branchs where IsDeleted=0 AND Status='A')

			INSERT INTO @TransactionDetail VALUES (2,@AccIdClient,0,@TotalAmountClient,0,0,2)
			--SP Calling: 
			SET @AccRemarks='Add_Income_Invoice_Collection'+CAST(@ClientId AS NVARCHAR(100));
			SET @InvoiceTransType=3
			SET @TotalAmountDrCr=@CollectionAmount+isnull(@AdjustmentAmount,0)+isnull(@ExtraCollectionAmount,0)
			EXEC Transactiondetailinsert_InvoiceCollection NULL,@AccBranchId,'',4,@CollectionDate,@TotalAmountDrCr, @TotalAmountDrCr, @AddBy,@AccRemarks,'IP','InvoiceCollection',@InvoiceTransType,@MasterId, @TransactionDetail
			--Accounts Journal End---
			
			
            DELETE FROM @TransactionDetail
			
			
	END TRY
	BEGIN CATCH
	ROLLBACK TRAN 

			DECLARE @ErrorMessage NVARCHAR(4000); 
			DECLARE @ErrorSeverity INT; 
			DECLARE @ErrorState INT; 

			SELECT @ErrorMessage = Error_message(), 
				   @ErrorSeverity = Error_severity(), 
				   @ErrorState = Error_state(); 

			-- Use RAISERROR inside the CATCH block to return error  
			-- information about the original error that caused  
			-- execution to jump to the CATCH block.  
			RAISERROR (@ErrorMessage,-- Message text.  
					   @ErrorSeverity,-- Severity.  
					   @ErrorState -- State.  
			); 
	END CATCH
   
COMMIT TRANSACTION 
END

