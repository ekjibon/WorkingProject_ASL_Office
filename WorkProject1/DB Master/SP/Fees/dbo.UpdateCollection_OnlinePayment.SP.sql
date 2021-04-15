
GO
/****** Object:  StoredProcedure [dbo].[UpdateCollection_OnlinePayment]    Script Date: 6/29/2020 8:24:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- UpdateCollection_OnlinePayment 4883,10002,2019,10,100,'126789','EBL','FUQEB01SLZ'
alter Proc [dbo].[UpdateCollection_OnlinePayment] 
(
@StudentId INT,
@AccountId INT,
@Year INT,
@Month INT,
@Amount INT,
@TrxID VARCHAR(MAX),
@BankName VARCHAR(MAX),
@P2fTrxId VARCHAR(MAX)
)
As
BEGIN
DECLARE @CurDue DECIMAL , @CollId INT,@BranchId INT,@AccBranchId INT,@AccRemarks NVARCHAR(200)='',@DrLedgerId INT;

		
		SET @DrLedgerId=1732;  --'EBL Tuition Fee (1041070458160)' --1732
		SET @AccRemarks='MasterOrVisaCard'+'_Pay_'+CAST(@StudentId AS NVARCHAR(50));
		
		

SET @BranchId=(select top 1 BranchID from [dbo].[Student_BasicInfo] where StudentIID=@StudentId)
		IF(@BranchId=8)
		BEGIN
		SET @AccBranchId=1;
		END
		IF(@BranchId=9)
		BEGIN
		SET @AccBranchId=2;
		END

	

	SELECT  @CurDue = ISNULL( SUM([DueAmount]),0)   FROM Fees_Student FS  WHERE  StudentIID = @StudentId AND IsCompleted=0 AND FS.IsDeleted = 0 AND FS.DueAmount > 0
	AND	datefromparts(FS.Year, FS.MonthId, 1) <= EOMONTH(datefromparts(@Year, @Month, 1))


	PRINT @CurDue

	IF(@Amount = @CurDue AND @CurDue>0)
	BEGIN
	BEGIN TRANSACTION;
	BEGIN TRY

	-- First Insert Collection Master
		INSERT INTO [dbo].[Fees_CollectionMaster]
                        ([StudentIID] ,[PaymentDate] ,[TotalAmount] ,[ReceivedAmount] ,[TotalDiscountAmount] ,[PaymentMonth] ,[MoneyReceipt] ,[PaymentType] ,[BankName] ,[Narration] ,[IsPosted]
                         ,[BoothID] ,[ScrollNumber] ,[BankCollectionDate] ,[TrxID] ,[PCS_BankName] ,[PCS_TrxID] ,[MonthId] ,[SessionId] ,[VAT] ,[IsDeleted] ,[AddBy],[AddDate] ,[Remarks])
						 VALUES 
						 (
							@StudentId,GETDATE(),@Amount,@Amount,0,@Month,[dbo].[MoneyReceiptGenerate](),3,'','',0,0,'',GETDATE(),@TrxID,@BankName,@P2fTrxId,@Month,0,0,0,@AccountId,GETDATE(),''
						 )

		SELECT @CollId = @@IDENTITY
		---- Insert Into Collection Deatils
		INSERT INTO [dbo].[Fees_CollectionDetails] 
                             ([MasterID],[HeadId],[Amount],[DueAmount],[AdvanceAmount],[ScholarshipAmount],[DiscountAmount],[ReceiveAmount],
							 [IsLateFine],[IsDeleted],[AddBy],[AddDate],[Remarks],[MonthId],[Year])
				SELECT @CollId, F.HeadId,F.TotalAmount,F.DueAmount,0,0,0,F.DueAmount,0,0,@AccountId,GETDATE(),'',MonthId,[Year] FROM Fees_Student F   -- Modify SP F.TotalAmount Replace to F.DueAmount By Arifur Date: 29/04/2020
					WHERE IsCompleted = 0 AND StudentIID = @StudentId AND IsDeleted = 0 AND DueAmount > 0 
					AND datefromparts(Year,MonthId, 1) <= EOMONTH(datefromparts(@Year, @Month, 1)) 

	-- Update Student Fees
		UPDATE  Fees_Student    SET IsCompleted = 1 , IsPaid = 1 , PaidAmount =  DueAmount, DueAmount = 0 ,InvoiceAmount=0
		WHERE IsCompleted = 0 AND StudentIID = @StudentId  AND IsDeleted = 0 AND DueAmount > 0
		 AND  datefromparts(Year,MonthId, 1) <= EOMONTH(datefromparts(@Year, @Month, 1)) 



		DECLARE @TransactionDetail UTT_TRANSACTIONDETAIL, @CurrDate DATETIME = GETDATE()
			INSERT INTO @TransactionDetail VALUES (1,@DrLedgerId,@Amount,0,0,0,1)  ---- 'EBL Tuition Fee (1041070458160)''
			INSERT INTO @TransactionDetail VALUES (2,1678,0,@Amount,0,0,2) ----'Accounts Receivable' 1678

			--SP Calling: 
			EXEC Transactiondetailinsert_bKash NULL,@AccBranchId,'',4,@CurrDate,@Amount, @Amount, @StudentId,@AccRemarks,'IP','MAC', @TransactionDetail
			DELETE FROM @TransactionDetail


		SELECT '2001' AS MessageCode
		END TRY
		BEGIN CATCH
			SELECT '9999' AS MessageCode, ERROR_MESSAGE() AS ErrorMessage, ERROR_LINE() AS ErrorLine;

			IF @@TRANCOUNT > 0
				ROLLBACK TRANSACTION;
		END CATCH;
		IF @@TRANCOUNT > 0
			COMMIT TRANSACTION;


	END -- End Amount Check
	ELSE IF(@CurDue=0)
	BEGIN
		SELECT '1002' AS MessageCode
	END
	ELSE 
	BEGIN
		SELECT '1001' AS MessageCode
	END
END