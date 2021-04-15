IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[InsertSecurityDeposit]'))
BEGIN
DROP PROCEDURE  [InsertSecurityDeposit]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Khaled
-- Description:	
-- =============================================


CREATE PROCEDURE [dbo].[InsertSecurityDeposit]
(
    @StudnetIID INT =0,
	@FeesHeadId INT = 0,
	@DepositAmont DECIMAL (10,2) = 0,
	@TotalAmount DECIMAL (10,2) = 0,
    @ReceiveAmount DECIMAL (10,2) = 0,
	@Narration VARCHAR(50)=null,
	@BankDate SMALLDATETIME,	
	@PostingDate SMALLDATETIME,	
	@AddBy VARCHAR(50)=null,
	@Installment INT = 0,
	@InstallmentAmount DECIMAL (10,2) = 0

)	
AS
BEGIN
   
	DECLARE @TransactionDetail UTT_TRANSACTIONDETAIL ,@AccId1 INT ,@AccId2 INT,@MasterId INT =0,@CurrDate DATETIME = GETDATE();

		INSERT INTO  [dbo].[Fees_SecurityDepositDetails]
		(StudentIID,FeesHeadId,DepositAmont,TotalAmount,ReceiveAmount,Narration,BankDate,PostingDate,MoneyReceipt,AddBy,AddDate,[Status],IsDeleted,Installment,InstallmentAmount,IsAdjusted)
		VALUES(@StudnetIID,@FeesHeadId,@DepositAmont,@TotalAmount,@ReceiveAmount,@Narration,@BankDate,@PostingDate,[dbo].[DepositMoneyReceiptGenerate](),@AddBy,GETDATE(),'A',0,@Installment,@InstallmentAmount,0)
		SET @MasterId  = @@IDENTITY;
					SELECT @AccId1 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'Cash In Hand'
			        SELECT @AccId2 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'Security Deposit'

			--SELECT @AccId4 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'Late Fine'


			INSERT INTO @TransactionDetail VALUES (1,@AccId1,@ReceiveAmount,0,0,0,1) --Debit DC = 1
			INSERT INTO @TransactionDetail VALUES (2,@AccId2,0,@ReceiveAmount,0,0,2) -- Credit DC = 2

			--SELECT * FROM @TransactionDetail
			SELECT @MasterId AS Id

			EXEC Transactiondetailinsert NULL,0,'',4,@CurrDate,@ReceiveAmount, @ReceiveAmount, 'admin','Fees_Coll_SP','IP','MAC', @TransactionDetail
			DELETE FROM @TransactionDetail




END