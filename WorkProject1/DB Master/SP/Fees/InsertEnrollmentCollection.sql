

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[InsertEnrollmentCollection]'))
BEGIN
DROP PROCEDURE  [InsertEnrollmentCollection]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Khaled
-- Create date: Jan 21, 2020
-- Description:	
-- =============================================


CREATE  PROCEDURE [dbo].[InsertEnrollmentCollection]
(
    @StudnetIID INT =0,
	@FiscalSessionId INT = 0,
	@FeesSessionYearId INT = 0,
	@IsEnrollment BIT = 0,
	@IsOldStudent BIT = 0,
	@IsCashCollec BIT = 0,
	@StuTypeId INT = 0,
	@BankDate SMALLDATETIME,	
	@PostingDate SMALLDATETIME,
	@TotalAmount DECIMAL (10,0) = 0,
	@AddBy VARCHAR(50)=null,
	@TotalSum DECIMAL (10,0) = 0,
	@FeesDetails dbo.UTT_FeesHead READONLY
)	
AS
BEGIN
BEGIN TRANSACTION

	BEGIN TRY

	DECLARE @SessionId INT = 0,@MasterId INT =0,@MonthId INT =0 ,@year INT = 0,@ReciveAmt DECIMAL(10,2),@Counter INT =0,@MAXID INT =0,@HeadId INT = 0,@RowCount1 INT =0,@RowCount2 INT=0,@BranchId INT=0,@AccBranchId INT=0,@AccRemarks NVARCHAR(200)='';
	DECLARE @TransactionDetail UTT_TRANSACTIONDETAIL ,@AccId1 INT ,@AccId2 INT,@AccId3 INT,@CurrDate DATETIME = GETDATE(),@AccId4 INT

	SELECT @SessionId =SessionId FROM dbo.Fees_FiscalSession WHERE FeesFiscalSessionId = @FiscalSessionId

	SELECT @MonthId=MonthId, @year = [Year] FROM dbo.Fees_FeesSessionYear WHERE FeesSessionYearId = @FeesSessionYearId

	SET @BranchId=(select top 1 BranchID from [dbo].[Student_BasicInfo] where StudentIID=@StudnetIID)
	IF(@BranchId=8)
	BEGIN
	SET @AccBranchId=1;
	END
	IF(@BranchId=9)
	BEGIN
	SET @AccBranchId=2;
	END

		INSERT INTO [dbo].[Fees_Student]
		 ([ProcessId],[StudentIID] ,[HeadId],[TotalAmount] ,[DueAmount] ,[ScholarshipAmount] ,[DiscountAmount] ,[PaidAmount] ,[IsPaid] ,[IsCompleted] ,[IsDeleted]
		 ,[AddBy] ,[AddDate] ,[UpdateBy],[UpdateDate]
		 ,[Remarks] ,[Status] ,[IP] ,[MacAddress] ,[MonthId] ,[AdvanceAmount] ,[Narration] ,[FeesBookNo] ,[SessionId] ,[ProcessType] ,[NoModifiedDueAmount]
		 ,[FeesSessionYearId] ,[EmpId] ,[IsVerification] ,[AppVerificationNo] ,[AutomatedDays],[IsPublished] ,[Year]
		 ,[InvoiceAmount] ,[ProcessedAmount] ,[IsLatePayPublished],[IsLatePay] ,[IsEnrollment] ,[IsOldStudent] ,[IsCashCollection],[Stutype])
		
			SELECT 0,@StudnetIID,[FeesHeadId],[TotalAmount],0,0,0,[PaidAmount],1,1,0,@AddBy,GETDATE(),'','','E','A','','',@MonthId
					,[Advance],[Narration],'',@SessionId,'E',[TotalAmount]
					,@FeesSessionYearId,0,0,0,0,0,@year,@TotalAmount,0,0,0,@IsEnrollment,@IsOldStudent,@IsCashCollec,@StuTypeId
				 FROM @FeesDetails

		    IF( @@ROWCOUNT = 0 ) 
			 BEGIN 
				 RAISERROR ('Fees Student Does not Insert.',16,1); 
			 END 
			 PRINT 'Layer >>> 1'

			INSERT INTO [dbo].[Fees_CollectionMaster]
			([StudentIID],[PaymentDate],[TotalAmount],[ReceivedAmount],[TotalDiscountAmount],[PaymentMonth],[MoneyReceipt]
			,[PaymentType],[ChequeNo],[BankName],[Narration],[IsPosted],[BoothID],[ScrollNumber],[BankCollectionDate]
			,[IsDeleted],[AddBy],[AddDate],[Remarks],[Status],[MonthId],[SessionId],[PayModeNo],[IsEnrollment],[IsCashCollection])
			 
			 VALUES(@StudnetIID,@PostingDate,@TotalSum,@TotalSum,0,@MonthId,[dbo].[MoneyReceiptGenerate](),1,'','','',0,0,'',@BankDate,0,@AddBy,GETDATE(),'Enrollment','A',@MonthId,@SessionId,1,@IsEnrollment,@IsCashCollec)
			 
			  SET @MasterId  = @@IDENTITY;

			 IF(@@ROWCOUNT = 0)
			 BEGIN 
				 RAISERROR ('Fees Collection Master Does not Insert.',16,1); 
			 END 

			 
			 PRINT 'Layer >>> 2'

			INSERT INTO [dbo].[Fees_CollectionDetails]
			([MasterID],[Amount],[DueAmount],[AdvanceAmount],[ScholarshipAmount],[DiscountAmount],[ReceiveAmount]
			,[IsLateFine],[IsDeleted],[AddBy],[AddDate],[Remarks],[Status],[HeadId],[MonthId],[Year],[Narration])
			SELECT @MasterId,[TotalAmount],0,[Advance],0,0,[PaidAmount],0,0,@AddBy,GETDATE(),'Enrollment','A',[FeesHeadId],@MonthId,@year,[Narration] FROM @FeesDetails

			 --SELECT @@ROWCOUNT AS RowsCount

			 IF(@@ROWCOUNT = 0)
			 BEGIN 
				 RAISERROR ('Fees Collection Details Does not Insert.',16,1); 
			 END 
			
			 PRINT 'Layer >>> 3'




	SELECT ROW_NUMBER() OVER(ORDER BY FeesHeadId ASC) AS ID, [FeesHeadId],[Advance],[PaidAmount],[TotalAmount]  INTO #FeesHeadList FROM @FeesDetails  
	SELECT @MAXID = @@ROWCOUNT
	SET @COUNTER = 1

	--SELECT * FROM #FeesHeadList
	WHILE(@COUNTER <= @MAXID)
	BEGIN
		DECLARE @AdvAmount DECIMAL(10,2)=0,@CurAmount DECIMAL(10,2)=0;
		
		SELECT @HeadId= FeesHeadId FROM #FeesHeadList WHERE ID = @Counter
		PRINT 'Fees HeadID : >>' + CAST(@HeadId AS VARCHAR(50))
	
			SELECT @AccId2 = LedgerId FROM ACC_Ledgers  ACC	INNER JOIN Fees_Head FH ON ACC.Code = FH.AccCode2
							 WHERE FH.FeesHeadId =@HeadId
			SELECT @AdvAmount = [AdvanceAmount]  FROM dbo.Fees_Student WHERE StudentIID = @StudnetIID 
						AND HeadId = @HeadId AND IsDeleted=0 AND FeesSessionYearId = @FeesSessionYearId AND MonthId = @MonthId AND [Year] = @year --GROUP BY HeadId
				PRINT 'Advance  : >> ' + CAST(@AdvAmount AS VARCHAR(50))

			SELECT @AccId3 = LedgerId FROM ACC_Ledgers  ACC	INNER JOIN Fees_Head FH ON ACC.Code = FH.AccCode1
						 WHERE FH.FeesHeadId =@HeadId
			SELECT @CurAmount = [PaidAmount]  FROM dbo.Fees_Student WHERE StudentIID = @StudnetIID 
						AND HeadId = @HeadId AND IsDeleted=0 AND FeesSessionYearId = @FeesSessionYearId AND MonthId = @MonthId AND [Year] = @year --GROUP BY HeadId
				PRINT 'Current  : >> ' + CAST(@CurAmount AS VARCHAR(50))
				IF( @AdvAmount>0 AND @CurAmount>0)
				BEGIN
				    PRINT 'HI Advance and Currtent Insert'
					IF(@RowCount1=0)
					SET @RowCount1 =@Counter;
					INSERT INTO @TransactionDetail VALUES (@RowCount1,@AccId2,0,@AdvAmount,0,0,2) -- Creadit DC=2
					SET @RowCount1 = @RowCount1 + 1;
                   	
					SET @RowCount2 = @RowCount1;
					INSERT INTO @TransactionDetail VALUES (@RowCount2,@AccId3,0,@CurAmount,0,0,2) -- Creadit DC=2
					SET @RowCount1 = @RowCount2 + 1;
				END
				ELSE
				BEGIN 
				IF(@AdvAmount>0)
				BEGIN
					PRINT 'HI Advance Insert'
					IF(@RowCount1=0)
					SET @RowCount1 =@Counter;
					INSERT INTO @TransactionDetail VALUES (@RowCount1,@AccId2,0,@AdvAmount,0,0,2) -- Creadit DC=2
					SET @RowCount1 = @RowCount1 + 1;
				END


				IF(@CurAmount>0)
				BEGIN
				IF(@RowCount1=0)
				SET @RowCount2 = @Counter;
				ELSE
				SET @RowCount2 = @RowCount1 + 1;
					INSERT INTO @TransactionDetail VALUES (@RowCount2,@AccId3,0,@CurAmount,0,0,2) -- Creadit DC=2	
				END
				END

	
	SET @Counter = @Counter + 1;
	END
	

			-- SELECT @AdvAmount =SUM(Advance),@ReciveAmt = SUM(PaidAmount) FROM @FeesDetails
			SELECT @ReciveAmt = SUM(TotalAmount) FROM @FeesDetails

			 
			PRINT @AdvAmount 
			PRINT @ReciveAmt
			IF(@RowCount1>0)
			SET @Counter = @RowCount1;
			ELSE
			SET @Counter= @Counter;

			SELECT @AccId1 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'Cash In Hand'
			INSERT INTO @TransactionDetail VALUES (@Counter,@AccId1,@ReciveAmt,0,0,0,1) -- Debit DC= 1

	--	SELECT * FROM @TransactionDetail
		
		--	RETURN
			SELECT @MasterId AS Id
			SELECT * FROM @TransactionDetail
		--	RETURN
			SET @AccRemarks='Fees_Coll_SP_'+CAST(@StudnetIID AS NVARCHAR(50));

			EXEC Transactiondetailinsert NULL,@AccBranchId,'',4,@CurrDate,@ReciveAmt, @ReciveAmt, 'admin',@AccRemarks,'IP','MAC', @TransactionDetail
			DELETE FROM @TransactionDetail
			DROP TABLE #FeesHeadList
			
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

/*
DECLARE @FeesDetails dbo.UTT_FeesHead,@DATE SMALLDATETIME

	SELECT @DATE  = GETDATE();
	INSERT INTO @FeesDetails VALUES (1,0,300,300,'test') 
	INSERT INTO @FeesDetails VALUES (8,50,300,350,'test') 
	INSERT INTO @FeesDetails VALUES (3,0,300,300,'test') 

	--SP Calling: 
	EXEC [InsertEnrollmentCollection] 2,1,2,1,0,0,1,@DATE,@DATE,500,'janina',500,@FeesDetails


	DECLARE @FeesDetails dbo.UTT_FeesHead,@DATE SMALLDATETIME

	SELECT @DATE  = GETDATE();
	INSERT INTO @FeesDetails VALUES (1,25000,25000,50000,'test') 
	SELECT @ReciveAmt = SUM(TotalAmount) FROM @FeesDetails

	--SP Calling: 
	EXEC [InsertEnrollmentCollection] 15177,13,1093,1,0,0,1,@DATE,@DATE,50000,'janina',50000,@FeesDetails

	DECLARE @FeesDetails dbo.UTT_FeesHead,@DATE SMALLDATETIME,@ReciveAmt DECIMAL(10,2)
	SELECT @DATE  = GETDATE();
		INSERT INTO @FeesDetails VALUES (2,50000,0,50000,'test') 
		INSERT INTO @FeesDetails VALUES (1,25000,25000,50000,'test') 
	    SELECT @ReciveAmt = SUM(TotalAmount) FROM @FeesDetails
	
		PRINT @ReciveAmt
		EXEC [InsertEnrollmentCollection] 4455,1,1002,1,0,0,1,@DATE,@DATE,100000,'janina',100000,@FeesDetails
		
		SELECT * FROM @TransactionDetail
*/