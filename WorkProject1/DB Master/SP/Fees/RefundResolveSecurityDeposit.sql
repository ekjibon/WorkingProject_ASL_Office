


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RefundResolveSecurityDeposit]'))
BEGIN
DROP PROCEDURE  [RefundResolveSecurityDeposit]
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


CREATE  PROCEDURE [dbo].[RefundResolveSecurityDeposit]
(
    @BlockId INT,
    @StudnetIID INT =0,
	@FeesHeadId INT = 0,
    @TotalDueDeposit DECIMAL (10,2) = 0


)	
AS
BEGIN
DECLARE @TransactionDetail UTT_TRANSACTIONDETAIL ,@AccId1 INT ,@AccId2 INT,@CurrDate DATETIME = GETDATE();
IF (@BlockId=1)
BEGIN
    UPDATE [dbo].[Fees_SecurityDepositDetails]
	SET IsRefund =1 , IsResolved = 0
	WHERE StudentIID = @StudnetIID
	UPDATE [dbo].[Fees_Adjust]
	SET IsRefund =1 , IsResolved = 0, TotalDueDeposit = 0
	WHERE StudentIID = @StudnetIID

	                SELECT @AccId1 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'Bank'
			        SELECT @AccId2 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'Security Deposit'

			--SELECT @AccId4 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'Late Fine'


			INSERT INTO @TransactionDetail VALUES (1,@AccId1,0,@TotalDueDeposit,0,0,2) --Debit DC = 1
			INSERT INTO @TransactionDetail VALUES (2,@AccId2,@TotalDueDeposit,0,0,0,1) -- Credit DC = 2

			--SELECT * FROM @TransactionDetail

			EXEC Transactiondetailinsert NULL,0,'',4,@CurrDate,@TotalDueDeposit, @TotalDueDeposit, 'admin','Fees_Coll_SP','IP','MAC', @TransactionDetail
			DELETE FROM @TransactionDetail
END
IF (@BlockId=2)
BEGIN
    UPDATE  [dbo].[Fees_SecurityDepositDetails]
	SET IsResolved = 1 ,IsRefund =0
	WHERE StudentIID = @StudnetIID

	UPDATE [dbo].[Fees_Adjust]
	SET IsResolved = 1 ,IsRefund =0, TotalDueDeposit = 0
	WHERE StudentIID = @StudnetIID

		                SELECT @AccId1 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'TestForResolve'
			            SELECT @AccId2 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'Security Deposit'

			--SELECT @AccId4 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'Late Fine'


			INSERT INTO @TransactionDetail VALUES (1,@AccId1,0,@TotalDueDeposit,0,0,2) --Debit DC = 1
			INSERT INTO @TransactionDetail VALUES (2,@AccId2,@TotalDueDeposit,0,0,0,1) -- Credit DC = 2

			--SELECT * FROM @TransactionDetail

			EXEC Transactiondetailinsert NULL,0,'',4,@CurrDate,@TotalDueDeposit, @TotalDueDeposit, 'admin','Fees_Coll_SP','IP','MAC', @TransactionDetail
			DELETE FROM @TransactionDetail
END

END

