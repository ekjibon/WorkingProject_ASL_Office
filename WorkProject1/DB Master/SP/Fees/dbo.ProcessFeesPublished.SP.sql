/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ProcessFeesPublished]'))
BEGIN
DROP PROCEDURE  [ProcessFeesPublished]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		 Arifur	
-- Create date: 11/11/2019
-- Description:	
-- =============================================

 --execute [ProcessFeesPublished] 1,1018,1030,'admin'
CREATE  PROCEDURE [dbo].[ProcessFeesPublished] 
   @Block int=0,
    @ProcessTypeId int=null,
	@FeesSessionYearId int,
	@AddBy VARCHAR(128)
AS
BEGIN
set transaction isolation level read uncommitted;
BEGIN TRANSACTION 
BEGIN TRY
DECLARE @COUNTER INT, @MAXID INT,@totalloop int=0,@tt int=34, @dd int=0 , @CurrDate DATETIME = GETDATE(),@TotalAmount Decimal = 0,@BranchId INT=0,@AccBranchId INT=0,@AccRemarks NVARCHAR(200)=''; 

 Update  Fees_Student SET IsPublished=1 WHERE ProcessId=@ProcessTypeId AND FeesSessionYearId = @FeesSessionYearId 

 SET @BranchId=(select TOP 1 BranchID from [dbo].[Fees_HeadAmountConfig] WHERE ProcessId=@ProcessTypeId)
	IF(@BranchId=8)
	BEGIN
	SET @AccBranchId=1;
	END
	IF(@BranchId=9)
	BEGIN
	SET @AccBranchId=2;
	END

 CREATE TABLE #TEMPFeesACCOUNTS
 (
       [Id] [int] IDENTITY (1, 1) NOT NULL,
        ProcessId bigint,
		FeesSessionYearId INT,
		HeadId VARCHAR(MAX),
		AmountType VARCHAR(10),
		Amount DECIMAL(10,2)
 )

 INSERT INTO #TEMPFeesACCOUNTS
 SELECT ProcessId,FeesSessionYearId,HeadId,AmountType,SUM(Amount) AS Amount FROM dbo.Fees_Accounts 
 WHERE IsApplied = 0 AND ProcessId = @ProcessTypeId AND FeesSessionYearId = @FeesSessionYearId
 GROUP BY ProcessId,FeesSessionYearId,HeadId,AmountType
 
		DECLARE @Amount DECIMAL,@HeadId INT,@AccId1 INT ,@AccId2 INT,@AccCode VARCHAR(MAX),@AmountType VARCHAR(10)

SET @MAXID = @@ROWCOUNT; 
SET @COUNTER = 1;

If(@Block=1) -- Update IsPublished
BEGIN

	WHILE (@COUNTER <= @MAXID)
	BEGIN

	--SELECT * FROM #TEMPFeesACCOUNTS
		SELECT @Amount=Amount , @HeadId  =HeadId,@AmountType=AmountType FROM #TEMPFeesACCOUNTS WHERE [Id] = @COUNTER
		IF(@AmountType = 'D')  --Due amount
		BEGIN
			 DECLARE @TransactionDetail UTT_TRANSACTIONDETAIL

			SELECT @AccCode = AccCode1  FROM Fees_Head WHERE FeesHeadId = @HeadId  -- AccCode1 Default 
			SELECT @AccId1 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'Accounts Receivable'
			SELECT @AccId2 = LedgerId FROM dbo.ACC_Ledgers WHERE Code = @AccCode -- Get Account Head Info
		 --   PRINT 'DUE '
			--PRINT CAST(@AccId1 AS VARCHAR(MAX))
			--PRINT CAST(@AccId2 AS VARCHAR(MAX))
			--PRINT CAST(@Amount AS VARCHAR(MAX))

			INSERT INTO @TransactionDetail VALUES (1,@AccId1,@Amount,0,0,0,1) 
			INSERT INTO @TransactionDetail VALUES (2,@AccId2,0,@Amount,0,0,2)  

			--SP Calling: 
			SET @AccRemarks='Add_Fees_D_Pro_'+CAST(@ProcessTypeId AS NVARCHAR(50));
			EXEC Transactiondetailinsert NULL,@AccBranchId,'',4,@CurrDate,@Amount, @Amount, @AddBy,@AccRemarks,'IP','MAC', @TransactionDetail
			DELETE FROM @TransactionDetail
			UPDATE Fees_Accounts  SET IsApplied = 1 WHERE ProcessId = @ProcessTypeId AND FeesSessionYearId = @FeesSessionYearId AND AmountType = 'D'

		END

		IF(@AmountType = 'A') -- Advance Amount 
		BEGIN
			 DECLARE @ATransactionDetail UTT_TRANSACTIONDETAIL  

			SELECT @AccCode = AccCode2  FROM Fees_Head WHERE FeesHeadId = @HeadId  -- AccCode2 Advance 

			SELECT @AccId1 = LedgerId FROM dbo.ACC_Ledgers WHERE Code = @AccCode -- Get Account Head Info
			SELECT @AccId2 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'Accounts Receivable'
		
			
			INSERT INTO @ATransactionDetail VALUES (1,@AccId1,@Amount,0,0,0,1) 
			INSERT INTO @ATransactionDetail VALUES (2,@AccId2,0,@Amount,0,0,2)  
			SELECT * FROM @ATransactionDetail
			--SP Calling: 
			SET @AccRemarks='Add_Fees_A_Pro_'+CAST(@ProcessTypeId AS NVARCHAR(50));
			EXEC Transactiondetailinsert NULL,@AccBranchId,'',4,@CurrDate,@Amount, @Amount, @AddBy,@AccRemarks,'IP','MAC', @ATransactionDetail
			DELETE FROM @ATransactionDetail
			UPDATE Fees_Accounts  SET IsApplied = 1 WHERE ProcessId = @ProcessTypeId AND FeesSessionYearId = @FeesSessionYearId AND AmountType = 'A'

		END


	SET @COUNTER = @COUNTER+1;
	END

END


IF(@Block=2)
BEGIN
  
 -- UPDATE Fees_Student SET IsLatePayPublished = 1 WHERE ProcessId=@ProcessTypeId AND FeesSessionYearId = @FeesSessionYearId --Add By Khaled

	WHILE (@COUNTER <= @MAXID)
		BEGIN

			SELECT @Amount=Amount , @HeadId  =HeadId,@AmountType=AmountType FROM #TEMPFeesACCOUNTS WHERE [Id] = @COUNTER
			IF(@AmountType = 'L') --Late
				BEGIN
				DECLARE @LTransactionDetail UTT_TRANSACTIONDETAIL  

					SELECT @AccCode = AccCode1  FROM Fees_Head WHERE FeesHeadId = @HeadId  -- AccCode1 Default 

					SELECT @AccId1 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'Accounts Receivable'
					SELECT @AccId2 = LedgerId FROM dbo.ACC_Ledgers WHERE Code = @AccCode -- Get Account Head Info
				 --   PRINT 'DUE '
					--PRINT CAST(@AccId1 AS VARCHAR(MAX))
					--PRINT CAST(@AccId2 AS VARCHAR(MAX))
					--PRINT CAST(@Amount AS VARCHAR(MAX))

					INSERT INTO @LTransactionDetail VALUES (1,@AccId1,@Amount,0,0,0,1) 
					INSERT INTO @LTransactionDetail VALUES (2,@AccId2,0,@Amount,0,0,2)  

					--SP Calling: 
					SET @AccRemarks='Add_Fees_L_Pro_'+CAST(@ProcessTypeId AS NVARCHAR(50));
					EXEC Transactiondetailinsert NULL,@AccBranchId,'',4,@CurrDate,@Amount, @Amount, @AddBy,@AccRemarks,'IP','MAC', @LTransactionDetail
					DELETE FROM @LTransactionDetail
					UPDATE Fees_Accounts  SET IsApplied = 1 WHERE ProcessId = @ProcessTypeId AND FeesSessionYearId = @FeesSessionYearId AND AmountType = 'L'
					UPDATE Fees_Student SET IsLatePayPublished = 1 WHERE ProcessId=@ProcessTypeId AND FeesSessionYearId = @FeesSessionYearId --Add By Khaled
				END

			SET @COUNTER = @COUNTER+1;
		END
  
END

 

  DROP TABLE #TEMPFeesACCOUNTS

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



