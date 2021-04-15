

/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AutomatedFeesProcess]'))
BEGIN
DROP PROCEDURE  [AutomatedFeesProcess]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		 Arifur
-- Create date: 
-- Description:	
-- =============================================

 --execute [AutomatedFeesProcess] 1041,1006,'G'
CREATE  PROCEDURE [dbo].[AutomatedFeesProcess] 
(
@ProcessId int,
@FeesSessionYearId int,
@Type VARCHAR(12)
)
AS
BEGIN
BEGIN TRANSACTION Automated;
BEGIN TRY

		DECLARE @FeesHeadId INT = null,@LatePayDate DATETIME,@Month INT, @LatePayAmount DECIMAL,@Year INT, @MAXID INT = 0,@PaidAmount DECIMAL (18,2) = 0,@AddBy VARCHAR(MAX),@TotalAmount DECIMAL(10,2);
		
		

		SELECT @LatePayDate = LateDate,@LatePayAmount = Amount FROM dbo.Fees_AutomatedFeesConfig WHERE FeesSessionYearId=@FeesSessionYearId AND IsConfigChecked = 1  AND IsDeleted = 0 
		SELECT TOP 1 @FeesHeadId = FeesHeadId FROM dbo.Fees_Head WHERE CategoryId = 3 AND IsDeleted = 0
		SELECT  @Year = [Year], @Month = MonthId FROM dbo.Fees_FeesSessionYear WHERE FeesSessionYearId = @FeesSessionYearId

		--Update  Fees_Student SET IsLatePay = 1 WHERE ProcessId=@ProcessId AND FeesSessionYearId = @FeesSessionYearId --Add By Khaled
	--PRINT @FeesHeadId

	  --  SELECT * FROM dbo.Fees_Accounts 
	IF(@LatePayDate<GETDATE())

	BEGIN
		PRINT 'Late Pay Acccess >>>>'

     CREATE TABLE #tmpStudent (
        [Id] [int] IDENTITY (1, 1) NOT NULL,
        StudentIID bigint,
		SessoinId INT,
		AddBy VARCHAR(MAX)
      )

	  INSERT INTO #tmpStudent 
	  SELECT DISTINCT StudentIID,SessionId,AddBy FROM dbo.Fees_Student WHERE ProcessId = @ProcessId AND FeesSessionYearId=@FeesSessionYearId AND IsCompleted = 0 AND IsDeleted = 0
	  SET @MAXID = @@ROWCOUNT
			

		-- DELETE dbo.Fees_Student WHERE ProcessId = @ProcessId AND FeesSessionYearId=@FeesSessionYearId AND ProcessType = 'L'

		DECLARE @Counter INT = 1,@StudentIID bigint,@SessionId INT
		WHILE(@Counter<=@MAXID)
		BEGIN
			SELECT @StudentIID = StudentIID ,@SessionId = SessoinId,@AddBy=AddBy FROM #tmpStudent WHERE Id=@Counter
			EXECUTE  [dbo].[InsertSingleStudentFee] @ProcessId, @Month, @SessionId, @StudentIID, @LatePayAmount, @PaidAmount, @FeesHeadId,'L', @FeesSessionYearId,1, 0, @Year,@AddBy ;
			SET @Counter = @Counter +1;
		END
	END
	IF(@MAXID = 0 ) 
	BEGIN 
			RAISERROR ('Automated Fees Config Check.',16,1); 
	END 
	IF(@MAXID>0)
	BEGIN

		SELECT @TotalAmount =SUM(DueAmount) FROM dbo.Fees_Student WHERE ProcessId = @ProcessId AND FeesSessionYearId = @FeesSessionYearId AND ProcessType = 'L'
		INSERT INTO [dbo].[Fees_Accounts]
		 ([ProcessId],[FeesSessionYearId],[HeadId],[Amount],[AmountType],[IsApplied],[IsDeleted])
			VALUES(@ProcessId,@FeesSessionYearId,@FeesHeadId,@TotalAmount,'L',0,0)	

		Update  Fees_Student SET IsLatePay = 1 WHERE ProcessId=@ProcessId AND FeesSessionYearId = @FeesSessionYearId --Add By Khaled
	END

	--SELECT * FROM dbo.Fees_Student
	--SELECT * FROM dbo.Fees_AutomatedFeesConfig
	--SELECT * FROM dbo.Fees_FeesSessionYear
	--SELECT * FROM dbo.Fees_Head WHERE CategoryId = 3 AND IsDeleted = 0

COMMIT TRANSACTION Automated;
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
  


