IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[InsertAdjustMent]'))
BEGIN
DROP PROCEDURE  [InsertAdjustMent]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Khaled
-- Create date: 
-- Description:	
-- =============================================


CREATE  PROCEDURE [dbo].[InsertAdjustMent]
(
    @StudnetIID INT =0,
	@FeesAdjust dbo.UTT_FeesAdjust READONLY
)
AS
BEGIN
	DECLARE @Counter INT =0,@MAXID INT =0,@TotalAmount DECIMAL(10,2) = 0,@HeadId INT = 0,@TemptotalAmount DECIMAL(10,2) = 0,@MonthId INT = 0,@FeesSessionYearId INT =0;
		DECLARE @TransactionDetail UTT_TRANSACTIONDETAIL ,@AccId1 INT ,@AccId2 INT,@AccId3 INT,@CurrDate DATETIME = GETDATE(),@AccId4 INT

    UPDATE [dbo].[Fees_SecurityDepositDetails]
	SET IsAdjusted = 1 WHERE StudentIID = @StudnetIID
  
	SELECT ROW_NUMBER() OVER(ORDER BY HeadId ASC) AS ID, HeadId,[DueAmount],[MonthId],[FeesSessionYearId]  INTO #FeesHeadList FROM @FeesAdjust  
	SELECT @MAXID = @@ROWCOUNT
	SET @COUNTER = 1
	WHILE(@COUNTER <= @MAXID)
	BEGIN
	SELECT @HeadId= HeadId,@MonthId=[MonthId],@FeesSessionYearId = [FeesSessionYearId] FROM #FeesHeadList WHERE ID = @Counter

	   INSERT INTO [dbo].[FeesAdjustHistories]
	 ([ProcessId],[StudentIID] ,[HeadId],[TotalAmount] ,[DueAmount] ,[ScholarshipAmount] ,[DiscountAmount] ,[PaidAmount] ,[IsPaid] ,[IsCompleted] ,[IsDeleted]
		 ,[AddBy] ,[AddDate] ,[UpdateBy],[UpdateDate],[Remarks] ,[Status] ,[IP] ,[MacAddress] ,[MonthId] ,[AdvanceAmount],[IsAdjust],[IsRefund],[IsResolved],[Narration] ,[SessionId],[NoModifiedDueAmount]
		 ,[FeesSessionYearId] 
		 ,[InvoiceAmount] ,[ProcessedAmount] ,[IsEnrollment] ,[IsOldStudent] ,[IsCashCollection],[Stutype])
		 SELECT 0,@StudnetIID,[HeadId],[TotalAmount],[DueAmount],[ScholarshipAmount],[DiscountAmount],[PaidAmount],[IsPaid],[IsCompleted],[IsDeleted]
		 ,[AddBy],[AddDate],[UpdateBy],[UpdateDate],[Remarks],[Status],[IP],[MacAddress],[MonthId],[AdvanceAmount],1,0,0,[Narration],[SessionId],[NoModifiedDueAmount]
					,[FeesSessionYearId],[InvoiceAmount],0,[IsEnrollment],[IsOldStudent],[IsCashCollection],[Stutype]
				 FROM [dbo].[Fees_Student] FS WHERE FS.StudentIID=@StudnetIID AND FS.MonthId = @MonthId AND FS.HeadId = @HeadId  AND FS.FeesSessionYearId = @FeesSessionYearId

	PRINT 'Fees HeadID : >>' + CAST(@HeadId AS VARCHAR(50))
	--SELECT @AccId1 = LedgerId FROM ACC_Ledgers  ACC	INNER JOIN Fees_Head FH ON ACC.Code = FH.AccCode1
	--				 WHERE FH.FeesHeadId =@HeadId
		SELECT @AccId1 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'Accounts Receivable'
		SELECT @TotalAmount = SUM(DueAmount)  FROM dbo.Fees_Student WHERE StudentIID = @StudnetIID 
					AND HeadId = @HeadId AND IsPaid = 0 AND IsCompleted = 0 AND DueAmount<>0 AND IsDeleted=0 AND MonthId = @MonthId AND FeesSessionYearId = @FeesSessionYearId GROUP BY HeadId
			SET	@TemptotalAmount = @TemptotalAmount  +	@TotalAmount;
			INSERT INTO @TransactionDetail VALUES (@Counter,@AccId1,0,@TotalAmount,0,0,2) -- Creadit DC=2
		
	SET @Counter = @Counter + 1;
	END
		SELECT @AccId2 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'Security Deposit'
		--SELECT @TotalAmount = SUM(ReceiveAmount) FROM dbo.SecurityDepositDetails WHERE StudentIID = @StudnetIID 
	
	INSERT INTO @TransactionDetail VALUES (@Counter,@AccId2,@TemptotalAmount,0,0,0,1) -- DEbit DC=1
		
	
	--SELECT * FROM @TransactionDetail
	--RETURN
	EXEC Transactiondetailinsert NULL,0,'',4,@CurrDate,@TotalAmount, @TotalAmount, 'admin','Fees_Ins_Adst_SP','IP','MAC', @TransactionDetail

	DELETE FROM @TransactionDetail
	DROP TABLE #FeesHeadList
END

/*
	DECLARE @FeesAdjust dbo.UTT_FeesAdjust , @DATE SMALLDATETIME  


	INSERT INTO @FeesAdjust VALUES (1,5000) 
	INSERT INTO @FeesAdjust VALUES (8,4545) 
	--SP Calling: 
	EXEC [InsertAdjustMent] 4391, @FeesAdjust





*/