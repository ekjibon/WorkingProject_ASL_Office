/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UpdateAccounts]'))
BEGIN
DROP PROCEDURE  UpdateAccounts
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		 Arifur	
-- Create date: 12/11/2019
-- Description:	
-- =============================================

 --execute [UpdateAccounts] 1,2022,1171,'admin'
	/*
		
			DECLARE @FeesCollDetails UTT_FeesAdvanceAmount
			INSERT INTO @FeesCollDetails VALUES (1,1039,0,0) 
			INSERT INTO @FeesCollDetails VALUES (2,1040,50,0) 
			INSERT INTO @FeesCollDetails VALUES (3,2039,200,0) 
			INSERT INTO @FeesCollDetails VALUES (4,2041,50,0) 

			EXEC UpdateAccounts 'admin', @FeesCollDetails

		
		*/

CREATE  PROCEDURE [dbo].UpdateAccounts 
	
	@AddBy VARCHAR(128),
	@FeesCollDetails dbo.UTT_FeesAdvanceAmount readonly  
AS
BEGIN
set transaction isolation level read uncommitted;
BEGIN TRANSACTION 
BEGIN TRY


	DECLARE @COUNTER INT, @RCount INT =2, @HeadId INT,@HeadAmount DECIMAL(10,2) = 0,@CashAmount DECIMAL(10,2) = 0,@AdvAmount DECIMAL(10,2) = 0, @TotalAdvAmt DECIMAL(10,2) = 0,
			@MAXID INT,@totalloop int=0,@tt int=34, @dd int=0 , @CurrDate DATETIME = GETDATE(),@AccCode VARCHAR(50); 
			DECLARE @TransactionDetail UTT_TRANSACTIONDETAIL ,@AccId1 INT ,@AccId2 INT,@AccId3 INT

	--SELECT @HeadId = HeadId FROM dbo.Fees_Student WHERE ProcessId = @ProcessTypeId AND FeesSessionYearId = @FeesSessionYearId
	SELECT @CashAmount = SUM(Amount) + SUM(AdvanceAmount) FROM @FeesCollDetails 
	
	PRINT ' CASH Amount : ' + CAST(@CashAmount AS VARCHAR(50))

	SELECT @AccId1 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'Cash In Hand'
	--SELECT @AccId3 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'Accounts Receivable'
	INSERT INTO @TransactionDetail VALUES (1,@AccId1,@CashAmount,0,0,0,1)
	
	SELECT @TotalAdvAmt = ISNULL(SUM(AdvanceAmount),0) FROM @FeesCollDetails WHERE AdvanceAmount>0
		PRINT 'Advance : ' +  CAST(@TotalAdvAmt AS VARCHAR(50))
	SELECT @AccId1 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'Accounts Receivable'
	INSERT INTO @TransactionDetail VALUES (2,@AccId1,0,(@CashAmount - @TotalAdvAmt ),0,0,2)


	SELECT @MAXID = COUNT(*) FROM @FeesCollDetails; 
	PRINT 'MAXID : ' + CAST(@MAXID AS VARCHAR(50))
	SET @COUNTER = 1;
	WHILE (@COUNTER <= @MAXID)
	BEGIN
		
		SET @RCount = @RCount + 1
		SELECT @HeadAmount  = Amount , @HeadId = HeadId , @AdvAmount = AdvanceAmount FROM @FeesCollDetails WHERE ID =  @COUNTER
		
		--SELECT @AccId2 = LedgerId FROM dbo.ACC_Ledgers WHERE Code = (SELECT  AccCode1  FROM Fees_Head WHERE FeesHeadId = @HeadId)

		--INSERT INTO @TransactionDetail VALUES (@RCount,@AccId2,0,0,0,0,2)
		
		--INSERT INTO @TransactionDetail VALUES (@RCount,@AccId2,@HeadAmount,0,0,0,1)

		IF(@AdvAmount>0)
		BEGIN			
			SELECT @AccId2 = LedgerId FROM dbo.ACC_Ledgers WHERE Code = (SELECT  AccCode2  FROM Fees_Head WHERE FeesHeadId = @HeadId)
			INSERT INTO @TransactionDetail VALUES (@RCount,@AccId2,0,@AdvAmount,0,0,2)
			
		END

		
		SET @COUNTER = @COUNTER +1
	END

	




	 SELECT * FROM @TransactionDetail

	 EXEC Transactiondetailinsert NULL,0,'',4,@CurrDate,@CashAmount, @CashAmount, @AddBy,'Add_Fees_Coll_Pro','IP','MAC', @TransactionDetail
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



