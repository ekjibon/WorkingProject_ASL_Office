/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF EXISTS (SELECT    *  FROM sys.objects  WHERE object_id = OBJECT_ID(N'[ProcessFeesAutomated]'))
BEGIN
  DROP PROCEDURE ProcessFeesAutomated
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:  	Kawsar 
-- Create date: 
-- Description:	
-- =============================================
-- execute ProcessFeesAutomated 1069,25,'2018-01-1','2018-01-31','A'

CREATE PROCEDURE ProcessFeesAutomated
@ProcessId int,
@FeesSessionYearId int,
@FromDate date = '2018-02-01',
@ToDate date = '2018-03-28',
@Type varchar(1),
@ProcessSessionId int = 1
AS
BEGIN

  BEGIN TRANSACTION
    BEGIN TRY
      DECLARE @Month int,
              @YearValue int,
			  @COUNTER int,
              @MAXID int,
              @totalloop int = 0,
              @tt int = 34,
              @dd int = 0,
              @Year int = 0;
      SELECT
        @Month = MonthId,
        @YearValue = [YEAR]
      FROM Fees_FeesSessionYear
      WHERE FeesSessionYearId = @FeesSessionYearId

      PRINT 'MonthId : ' + CAST(@Month AS VARCHAR)
      PRINT 'YearValue : ' + CAST(@YearValue AS VARCHAR)
	   SET @year = DATEPART(YEAR, @ToDate)
      PRINT 'year of Todate : ' + CAST(@year AS VARCHAR)

      CREATE TABLE #tmpFees_AutomatedFeesConfig (
        [Id] [int] IDENTITY (1, 1) NOT NULL,
        [AutomatedConfigId] int,
        [VersionId] [int] NOT NULL,
        [SessionId] [int] NOT NULL,
        [BranchId] [int] NULL,
        [ShiftId] [int] NULL,
        [ClassId] [int] NOT NULL,
        [GroupId] [int] NULL,
        [SectionId] [int] NULL,
        [ProcessId] [int] NOT NULL,
        [LatePayHeadId] [int] NULL,
        [LatePayDay] [int] NULL,
        [IsFixed] [bit] NOT NULL,
        [LatePayAmount] [decimal](18, 2) NULL,
        [LatePayHeadIdAmount] [int] NULL,
        [LatePayLongRange] [int] NULL,
        [LatePayLongRangeAmount] [decimal](18, 2) NULL,
        [LatePayLongRangeAmountIsPercentage] [bit] NOT NULL,
        [LatePayLongRangeHeadIdAmount] [int] NULL,
        [LatePayIsPreviouseFine] [bit] NOT NULL,

        [LateInHead] [int] NULL,
        [LateInPeriod] [int] NULL,
        [LateInAmount] [decimal](18, 2) NULL,
        [LateInHeadIdAmount] [int] NULL,
        [LateInAbsConfigDay] [int] NULL,

        [LateInConsecutiveDay] [int] NULL,
        [LateInConsecutiveAmount] [decimal](18, 2) NULL,
        [LateInConsecutiveIsPercentage] [bit] NOT NULL,
        [LateInConsecutiveHeadId] [int] NULL,

        [AbsAHead] [int] NULL,
        [AbsPeriod] [int] NULL,
        [AbsAmount] [decimal](18, 2) NULL,
        [AbsHeadIdAmount] [int] NULL,

        [AbsConsecutiveDay] [int] NULL,
        [AbsConsecutiveAmount] [decimal](18, 2) NULL,
        [AbsConsecutiveIsPercentage] [bit] NOT NULL,
        [AbsConsecutiveHeadId] [int] NULL,

        [AbsConPeriod] [int] NULL,
        [AbsConAHead] [int] NULL,
        [AbsConAmount] [decimal](18, 2) NULL,
        [AbsConHeadIdAmount] [int] NULL,
        [AbsConConsecutiveDay] [int] NULL,
        [AbsConConsecutiveAmount] [decimal](18, 2) NULL,
        [AbsConConsecutiveIsPercentage] [bit] NOT NULL,
        [AbsConConsecutiveHeadId] [int] NULL,
        [Type] [nvarchar](MAX) NULL,
        [IsDeleted] [bit] NOT NULL,
        [FessGroupId] [int] NULL,
        [LatePayHeadIdAmountIsPercentage] [bit] NOT NULL,
        [LateInHeadIdAmountIsPercentage] [bit] NOT NULL,
        [AbsHeadIdAmountIsPercentage] [bit] NOT NULL,
        [AbsConHeadIdAmountIsPercentage] [bit] NOT NULL
      )


      INSERT INTO #tmpFees_AutomatedFeesConfig ([AutomatedConfigId],
      [VersionId],
      [SessionId],
      [BranchId],
      [ShiftId],
      [ClassId],
      [GroupId],
      [SectionId],
      [ProcessId],
      [LatePayHeadId],
      [LatePayDay],
      [IsFixed],
      [LatePayAmount],
      [LatePayHeadIdAmount],
      [LatePayLongRange],
      [LatePayLongRangeAmount],
      [LatePayLongRangeAmountIsPercentage],
      [LatePayLongRangeHeadIdAmount],
      [LatePayIsPreviouseFine],

      [LateInHead],
      [LateInPeriod],
      [LateInAmount],
      [LateInHeadIdAmount],
      [LateInAbsConfigDay],

      [LateInConsecutiveDay],
      [LateInConsecutiveAmount],
      [LateInConsecutiveIsPercentage],
      [LateInConsecutiveHeadId],
      [AbsAHead],
      [AbsPeriod],
      [AbsAmount],
      [AbsHeadIdAmount],

      [AbsConsecutiveDay],
      [AbsConsecutiveAmount],
      [AbsConsecutiveIsPercentage],
      [AbsConsecutiveHeadId],

      [AbsConPeriod],
      [AbsConAHead],
      [AbsConAmount],
      [AbsConHeadIdAmount],

      [AbsConConsecutiveDay],
      [AbsConConsecutiveAmount],
      [AbsConConsecutiveIsPercentage],
      [AbsConConsecutiveHeadId],
      [Type],
      [IsDeleted],
      [FessGroupId],
      [LatePayHeadIdAmountIsPercentage],
      [LateInHeadIdAmountIsPercentage],
      [AbsHeadIdAmountIsPercentage],
      [AbsConHeadIdAmountIsPercentage])
        SELECT
          [AutomatedConfigId],
          [VersionId],
          [SessionId],
          [BranchId],
          [ShiftId],
          [ClassId],
          [GroupId],
          [SectionId],
          [ProcessId],
          [LatePayHeadId],
          [LatePayDay],
          [IsFixed],
          [LatePayAmount],
          [LatePayHeadIdAmount],
          [LatePayLongRange],
          [LatePayLongRangeAmount],
          [LatePayLongRangeAmountIsPercentage],
          [LatePayLongRangeHeadIdAmount],
          [LatePayIsPreviouseFine],

          [LateInHead],
          [LateInPeriod],
          [LateInAmount],
          [LateInHeadIdAmount],
          [LateInAbsConfigDay],

          [LateInConsecutiveDay],
          [LateInConsecutiveAmount],
          [LateInConsecutiveIsPercentage],
          [LateInConsecutiveHeadId],
          [AbsAHead],
          [AbsPeriod],
          [AbsAmount],
          [AbsHeadIdAmount],

          [AbsConsecutiveDay],
          [AbsConsecutiveAmount],
          [AbsConsecutiveIsPercentage],
          [AbsConsecutiveHeadId],

          [AbsConPeriod],
          [AbsConAHead],
          [AbsConAmount],
          [AbsConHeadIdAmount],

          [AbsConConsecutiveDay],
          [AbsConConsecutiveAmount],
          [AbsConConsecutiveIsPercentage],
          [AbsConConsecutiveHeadId],
          [Type],
          [IsDeleted],
          [FessGroupId],
          [LatePayHeadIdAmountIsPercentage],
          [LateInHeadIdAmountIsPercentage],
          [AbsHeadIdAmountIsPercentage],
          [AbsConHeadIdAmountIsPercentage]
        FROM Fees_AutomatedFeesConfig
        WHERE ISNULL(IsDeleted, 0) = 0
        AND [Type] = @Type

      CREATE TABLE #tmpStudent (
        [Id] [int] IDENTITY (1, 1) NOT NULL,
        StudentIID bigint
      )

      SET @COUNTER = 1
      SELECT  @MAXID = COUNT(*) FROM #tmpFees_AutomatedFeesConfig
      PRINT 'Total Setup Found : ' + CAST(@MAXID AS VARCHAR)
       

      INSERT INTO Fees_TempCollection ([ProcessId],
      [SessionId],
      [MonthId],
      [StudentIID],
      [HeadId],
      [TotalAmount],
      [DueAmount],
      [NoModifiedDueAmount],
      [ScholarshipAmount],
      [DiscountAmount],
      [PaidAmount],
      [AdvanceAmount],
      [IsPaid],
      [IsCompleted],
      [Narration],
      [FeesBookNo],
      [ProcessType],
      [IsDeleted],
      [AddBy],
      [AddDate],
      [UpdateBy],
      [UpdateDate],
      [Remarks],
      [Status],
      [IP],
      [MacAddress])
        SELECT
          [ProcessId],
          [SessionId],
          [MonthId],
          [StudentIID],
          [HeadId],
          [TotalAmount],
          [DueAmount],
          [NoModifiedDueAmount],
          [ScholarshipAmount],
          [DiscountAmount],
          [PaidAmount],
          [AdvanceAmount],
          [IsPaid],
          [IsCompleted],
          [Narration],
          [FeesBookNo],
          [ProcessType],
          [IsDeleted],
          [AddBy],
          [AddDate],
          [UpdateBy],
          [UpdateDate],
          [Remarks],
          [Status],
          [IP],
          [MacAddress]
        FROM Fees_Student
        WHERE ProcessId = @ProcessId
        AND MonthId = @Month
        AND ProcessType = @Type
        AND PaidAmount > 0
        AND IsPaid = 1

      CREATE TABLE #Fees_TempCollection (
        [Id] [int] IDENTITY (1, 1) NOT NULL,
        [ProcessId] int,
        [MonthId] int,
        [StudentIID] int,
        [HeadId] int,
        [PaidAmount] decimal(18, 2),
        [AdvanceAmount] decimal(18, 2)
      )

      INSERT INTO #Fees_TempCollection ([ProcessId],[MonthId],[StudentIID],[HeadId],[PaidAmount], [AdvanceAmount])
        SELECT [ProcessId],[MonthId],[StudentIID],[HeadId],[PaidAmount],[AdvanceAmount]
        FROM Fees_TempCollection WHERE ProcessId = @ProcessId  AND MonthId = @Month AND ProcessType = @Type AND PaidAmount > 0 AND IsPaid = 1

      --delete Fees_Student where ProcessId=@ProcessTypeId and MonthId=@MonthId
      -- select * from Fees_Student
      --  ProcessFeesAutomated
	  -- DELETE The Student Fees 
      DELETE Fees_Student    WHERE ProcessId = @ProcessId AND MonthId = @Month AND ProcessType = @Type AND FeesSessionYearId = @FeesSessionYearId
      WHILE (@COUNTER <= @MAXID)
      BEGIN
	  PRINT CAST(@COUNTER AS VARCHAR) + ' Settings BEGIN >>>>> '
        DECLARE @versionId int,
                @SessionId int,
                @BranchId int,
                @ShiftId int,
                @ClassId int,
                @GroupId int,
                @SectionId int,
                @FessGroupId int,
                @StudentIID int,
                @RC int,
                @AbsPeriod int,
                @AbsAmount decimal(18, 2),
                @AbsHeadIdAmount int = NULL,
                @AbsHead int,
                @AbsConsecutiveDay int = NULL,
                @AbsConsecutiveAmount decimal(18, 2) = NULL,
                @AbsConsecutiveIsPercentage bit = 0,
                @AbsConsecutiveHeadId int = NULL,
                @AbsConHead int,
                @AbsConPeriod int,
                @AbsConAmount decimal(18, 2),
                @AbsConHeadIdAmount int = NULL,
                @AbsConConsecutiveDay int = NULL,
                @AbsConConsecutiveAmount decimal(18, 2) = NULL,
                @AbsConConsecutiveIsPercentage bit = 0,
                @AbsConConsecutiveHeadId int = NULL,
				@AbsConHeadIdAmountIsPercentage bit =0,

                @LateInPeriod int,
                @LateInAmount decimal(18, 2),
                @LateInHeadIdAmount int = NULL,
                @LateInHead int,
                @LateInAbsConfigDay int = NULL,
                @LateInConsecutiveDay int = NULL,
                @LateInConsecutiveAmount decimal(18, 2) = NULL,
                @LateInConsecutiveIsPercentage bit = 0,
                @LateInConsecutiveHeadId int = NULL,
                @LatePayAmount decimal(18, 2),
                @LatePayHeadIdAmount int = NULL,
                @LatePayHead int,
                @LatePayConsecutiveDay int = NULL,
                @LatePayConsecutiveAmount decimal(18, 2) = NULL,
                @LatePayConsecutiveIsPercentage bit = 0,
                @LatePayConsecutiveHeadId int = NULL,
                @LatePayLongRange int = NULL,
                @LatePayLongRangeAmount decimal(18, 2) = 0,
                @LatePayLongRangeAmountIsPercentage bit = 0,
                @LatePayLongRangeHeadIdAmount int = NULL,
                @LatePayIsPreviouseFine bit = 0,
                @IsFixed bit = 0,
                @LatePayDay int = 0,
                @Pk int,
                @AbsHeadIdAmountIsPercentage bit = 0,
				 @LateInHeadIdAmountIsPercentage bit = 0

        SELECT
          @versionId = VersionId,
          @SessionId = SessionId,
          @BranchId = BranchId,
          @ShiftId = ShiftId,
          @ClassId = ClassId,
          @GroupId = GroupId,
          @SectionId = SectionId,
          @FessGroupId = FessGroupId,
          @AbsPeriod = AbsPeriod,
          @AbsAmount = AbsAmount,
          @AbsHeadIdAmount = AbsHeadIdAmount,
          @AbsHead = AbsAHead,
          @AbsConsecutiveDay = AbsConsecutiveDay,
          @AbsConsecutiveAmount = AbsConsecutiveAmount,
          @AbsConsecutiveIsPercentage = AbsConsecutiveIsPercentage,
          @AbsConsecutiveHeadId = AbsConsecutiveHeadId,
          @AbsConHead = AbsConAHead,
          @AbsConPeriod = AbsConPeriod,
          @AbsConAmount = AbsConAmount,
          @AbsConHeadIdAmount = AbsConHeadIdAmount,
          @AbsConConsecutiveDay = AbsConConsecutiveDay,
          @AbsConConsecutiveAmount = AbsConConsecutiveAmount,
          @AbsConConsecutiveIsPercentage = AbsConConsecutiveIsPercentage,
          @AbsConConsecutiveHeadId = AbsConConsecutiveHeadId,
		  @AbsConHeadIdAmountIsPercentage = AbsConHeadIdAmountIsPercentage,
          @LateInPeriod = LateInPeriod,
          @LateInAmount = LateInAmount,
          @LateInHeadIdAmount = LateInHeadIdAmount,
          @LateInHead = LateInHead,
          @LateInAbsConfigDay = LateInAbsConfigDay,
          @LateInConsecutiveDay = LateInConsecutiveDay,
          @LateInConsecutiveAmount = LateInConsecutiveAmount,
          @LateInConsecutiveIsPercentage = LateInConsecutiveIsPercentage,
          @LateInConsecutiveHeadId = LateInConsecutiveHeadId,
          @LatePayAmount = LatePayAmount,
          @LatePayHeadIdAmount = LatePayHeadIdAmount,
          @LatePayHead = LatePayHeadId,
          @LatePayLongRange = LatePayLongRange,
          @LatePayLongRangeAmount = LatePayLongRangeAmount,
          @LatePayLongRangeAmountIsPercentage = LatePayLongRangeAmountIsPercentage,
          @LatePayLongRangeHeadIdAmount = LatePayLongRangeHeadIdAmount,
          @LatePayIsPreviouseFine = LatePayIsPreviouseFine,
          @IsFixed = IsFixed,
          @LatePayDay = LatePayDay,
          @Pk = AutomatedConfigId,
          @AbsHeadIdAmountIsPercentage = AbsHeadIdAmountIsPercentage,
		  @LateInHeadIdAmountIsPercentage = LateInHeadIdAmountIsPercentage

        FROM #tmpFees_AutomatedFeesConfig tmp
        WHERE id = @COUNTER

        INSERT INTO #tmpStudent
          SELECT
            StudentIID
          FROM Student_BasicInfo sb
          WHERE 
			  sb.VersionID = @versionId
          AND sb.SessionId = @SessionId
          AND sb.BranchID = @BranchId
          AND sb.ShiftID = @ShiftId
          AND sb.ClassId = @ClassID
          AND sb.GroupId = @GroupId
          AND sb.SectionId = @SectionId
		 -- AND sb.StudentIID = 28819 ---  Fixed by Kawsar
		  AND  sb.StudentTypeID = COALESCE(@FessGroupId,sb.StudentTypeID)
        
		PRINT 'Fees Group ' + CAST(@FessGroupId AS VARCHAR)
        DECLARE @Counter2 int = 1,  @MaxId2 int = 0;
        SET @MaxId2 = (SELECT COUNT(*) FROM #tmpStudent);
		
        PRINT 'Total Student Found : ' + CAST(@MaxId2 AS VARCHAR)
     
        
        
        -------------------------------------------------------Loop Started ----------------------------------------------------------------
        WHILE (@Counter2 <= @MaxId2)
        BEGIN
          SET @StudentIID = (SELECT StudentIID FROM #tmpStudent  WHERE Id = @Counter2);
          DECLARE @PeriodNo int = 0, @Amount decimal(18, 2) = 0, @PaidAmount decimal(18, 2) = 0, @ConsecutiveAmount decimal(18, 2) = 0;
		  PRINT 'StudentId : ' + CAST(@StudentIID AS VARCHAR)
				    --------------------------------------------------------For Absent----------------------------------------------------------------
          IF (@Type = 'A')-- absent
          BEGIN
            DECLARE @TotalAbs int = 0,
                    @TotalAbsConsPeriod int = 0;

            SELECT  @TotalAbs = [dbo].[APLClaculation]('', '', '', '', '', '', '', @StudentIID, '', @Year, 'TA', @FromDate, @ToDate)
            PRINT 'Total Absent : ' + CAST(@TotalAbs AS VARCHAR)
             
            IF (@AbsConsecutiveDay IS NOT NULL AND @AbsConsecutiveAmount IS NOT NULL)
            BEGIN
              PRINT 'AbsConsecutiveDay : ' + CAST(@AbsConsecutiveDay AS VARCHAR)
              EXECUTE @TotalAbsConsPeriod = [dbo].[ConsicutiveCalculation] @StudentIID, @FromDate, @ToDate,  @AbsConsecutiveDay, @Type;
            END
            ELSE
              SET @TotalAbsConsPeriod = 0

			PRINT 'TotalAbsConsPeriod : ' + CAST(@TotalAbsConsPeriod AS VARCHAR)  

            SET @TotalAbs = @TotalAbs - @TotalAbsConsPeriod * ISNULL(@AbsConsecutiveDay, 0)
            PRINT 'TotalAbs After deduct Consuctive : ' + CAST(@TotalAbs AS VARCHAR)             
            PRINT 'AbsPeriod : ' + CAST(@AbsPeriod AS VARCHAR)             
            
            PRINT 'AbsAmount : '+ CAST(@AbsAmount AS VARCHAR)  
            PRINT 'AbsHeadId : '+ CAST(@AbsHeadIdAmount AS VARCHAR) +  ' >>> AbsConsecutiveHeadId : '+ CAST(@AbsConsecutiveHeadId AS VARCHAR) 
             

            IF ((ISNULL(@TotalAbs, 0) >= @AbsPeriod) OR @TotalAbsConsPeriod > 0)
            BEGIN
              PRINT 'AbsPeriod : ' + CAST(@AbsPeriod AS VARCHAR) 
             
              SET @PeriodNo = ISNULL(FLOOR(@TotalAbs / @AbsPeriod), 0)
			   PRINT 'Period After divided : ' + CAST(@PeriodNo AS VARCHAR) 
              
              IF (@AbsHeadIdAmount IS NOT NULL AND @AbsHeadIdAmount !=0 )
              BEGIN
                DECLARE @AbsHeadAmount decimal(18, 2) = 0
                SELECT TOP (1)  @AbsHeadAmount = ISNULL( HA.Amount ,0) FROM Fees_HeadAmountConfig HA
									 WHERE HA.HeadId = @AbsHeadIdAmount AND HA.ProcessId = @ProcessId  
									 AND  HA.FessGroupId = COALESCE(@FessGroupId,HA.FessGroupId) --AND HA.StudentIID  = @StudentIID
									 AND HA.SectionId = @SectionId
									 AND HA.ClassId  = @ClassId
									 AND HA.IsDeleted = 0
              
					IF (@AbsHeadIdAmountIsPercentage = 1)
					BEGIN
					  SET @Amount = ((@AbsAmount * @AbsHeadAmount) / 100)
					END
					ELSE
					BEGIN
					  SET @Amount = @AbsHeadAmount
					END

              END
              ELSE
              BEGIN
                SET @Amount = @AbsAmount
              END

              SET @Amount = @PeriodNo * @Amount
              PRINT 'Amount W/O Consecutive After Gen : '+ CAST(@Amount AS VARCHAR) 
              IF (@AbsConsecutiveHeadId IS NOT NULL)
              BEGIN
                DECLARE @AbsConsecutiveHeadAmount decimal(18, 2) = 0
                SELECT TOP (1) @AbsConsecutiveHeadAmount = ISNULL( HA.Amount,0) FROM Fees_HeadAmountConfig HA
                WHERE HA.HeadId = @AbsConsecutiveHeadId AND HA.ProcessId = @ProcessId 
				AND  HA.FessGroupId = COALESCE(@FessGroupId,HA.FessGroupId) --AND HA.StudentIID  = @StudentIID
				AND HA.SectionId = @SectionId
				AND HA.ClassId  = @ClassId
				AND HA.IsDeleted = 0
               PRINT 'fff'+ CAST(@SectionId AS VARCHAR) 

                IF (@AbsConsecutiveIsPercentage = 1)
                BEGIN
                  PRINT 'Has Percentage >>> AbsConsecutiveAmount : ' + CAST(@AbsConsecutiveAmount AS VARCHAR) +  ' >>> AbsConsecutiveHeadAmount : ' + CAST(@AbsConsecutiveHeadAmount AS VARCHAR)                
                  
				   SET @ConsecutiveAmount = ((@AbsConsecutiveAmount * @AbsConsecutiveHeadAmount) / 100)                
                END
                ELSE
                  SET @ConsecutiveAmount = @AbsConsecutiveHeadAmount

                PRINT 'ConsecutiveAmount After : '+ CAST(@ConsecutiveAmount AS VARCHAR) 
              END
              ELSE
              BEGIN
                SET @ConsecutiveAmount = @AbsConsecutiveAmount
              END

              SET @Amount = @Amount + ISNULL((@ConsecutiveAmount * @TotalAbsConsPeriod), 0)

             
              
              IF EXISTS (SELECT StudentIID FROM #Fees_TempCollection WHERE StudentIID = @StudentIID) -- Need Here Also seesion yearId
              BEGIN
                SELECT TOP (1) @PaidAmount = PaidAmount FROM #Fees_TempCollection
                WHERE StudentIID = @StudentIID AND ProcessId = @ProcessId AND MonthId = @Month AND HeadId = @AbsHead
                DELETE Fees_TempCollection
                WHERE ProcessId = @ProcessId AND MonthId = @Month AND ProcessType = @Type
                  AND PaidAmount > 0 AND IsPaid = 1 AND StudentIID = @StudentIID AND HeadId = @AbsHead
              END

              PRINT 'Final Amount : ' + CAST(@Amount AS VARCHAR) 
              PRINT 'Paid Amount : ' + CAST(@PaidAmount AS VARCHAR)

              SET @AbsConsecutiveDay = ISNULL(@AbsConsecutiveDay, 0)
              EXECUTE @RC = [dbo].[InsertSingleStudentFee] @ProcessId, @Month,  @SessionId, @StudentIID,  @Amount,  @PaidAmount, @AbsHead, @Type, @FeesSessionYearId, @TotalAbs,@TotalAbsConsPeriod, @YearValue;
              SET @StudentIID = NULL
            END
          END

          ELSE --------------------------------------------------------For Absconding ----------------------------------------------------------------
          IF (@Type = 'B')-- absConding
          BEGIN
			PRINT 'Start B'
            DECLARE @TotalAbsCond int = 0,  @TotalAbsConConsPeriod int = 0, @StuHeadAmout INT =0; 
			-- GET Total Abosconding from Student Attendance table
            SELECT  @TotalAbsCond = COUNT(*) FROM Att_StudentAttendance A
            WHERE A.StudentId = @StudentIID   AND ( CAST(A.InTime AS date) BETWEEN @FromDate AND @ToDate )  AND ISNULL(A.IsPresent, 0) = 1 AND A.IsAbsconding = 1 AND A.IsDeleted = 0
                             
            PRINT 'Total Absconding from db ' +CAST( @TotalAbsCond AS VARCHAR)

			--  Check if Abosconding has Cosucutive Setup
            IF (@AbsConConsecutiveDay IS NOT NULL  AND @AbsConConsecutiveAmount IS NOT NULL) 
            BEGIN	          
              -- Get The Total Absconding Period  Using Function By StudentIID 
              EXECUTE @TotalAbsConConsPeriod = [dbo].[ConsicutiveCalculation] @StudentIID, @FromDate, @ToDate,@AbsConConsecutiveDay,  @Type;
			  PRINT 'Consucutive Absconding Period ' +CAST( @TotalAbsConConsPeriod AS VARCHAR) 
            END
           
		   -- DEDUCT Couscutive Days from Total Absconding
            SET @TotalAbsCond = @TotalAbsCond - (@TotalAbsConConsPeriod * ISNULL(@AbsConConsecutiveDay, 0))
           PRINT 'TotalAbsCond W/O Consecutive : ' +CAST( @TotalAbsCond AS VARCHAR) 
          
		   -- Total Absconding if greater than period 
            IF ((ISNULL(@TotalAbsCond, 0) >= @AbsConPeriod)  OR @TotalAbsConConsPeriod > 0)
            BEGIN

              SET @PeriodNo = FLOOR(@TotalAbsCond / @AbsConPeriod)
              IF (@AbsConHeadIdAmount IS NOT NULL AND @AbsConHeadIdAmount!=0)
              BEGIN
			 
					-- Get the Amount from Amount Config Table By ProccesId and HeadId
					SELECT TOP (1)   @StuHeadAmout = ISNULL( HA.Amount,0)  FROM Fees_HeadAmountConfig HA
					WHERE HA.HeadId = @AbsConHeadIdAmount AND HA.ProcessId = @ProcessId AND  HA.FessGroupId = COALESCE(@FessGroupId,HA.FessGroupId)
					AND HA.SectionId = @SectionId AND HA.ClassId  = @ClassId AND HA.IsDeleted = 0

				  IF(@AbsConHeadIdAmountIsPercentage=1)
					BEGIN
						 SET @Amount = ((@AbsConAmount * @StuHeadAmout) / 100)
						 PRINT 'AMOUNT = ' + CAST( @AbsConAmount AS VARCHAR)
					END
				ELSE
				SET @Amount = @StuHeadAmout
              END
			  ELSE
              BEGIN
                SET @Amount = @AbsConAmount
              END			  
				SET @Amount = @PeriodNo * @Amount

				PRINT 'AMOUNT W/O Conscutive : ' + CAST(@Amount AS VARCHAR)
				-- For Conscutive Calculation 
				
              IF (@AbsConConsecutiveHeadId IS NOT NULL AND  @AbsConConsecutiveHeadId != 0)
              BEGIN
			
                DECLARE @AbsConConsecutiveHeadAmount decimal(18, 2) = 0
                SELECT TOP (1)  @AbsConConsecutiveHeadAmount = ISNULL( HA.Amount ,0)    FROM Fees_HeadAmountConfig HA
					 WHERE HA.HeadId = @AbsConConsecutiveHeadId  AND HA.ProcessId = @ProcessId  AND  HA.FessGroupId = COALESCE(@FessGroupId,HA.FessGroupId)
					AND HA.SectionId = @SectionId AND HA.ClassId  = @ClassId AND HA.IsDeleted = 0

                IF (@AbsConConsecutiveIsPercentage = 1)
                  SET @ConsecutiveAmount = (@AbsConConsecutiveAmount * @AbsConConsecutiveHeadAmount) / 100
                ELSE
                  SET @ConsecutiveAmount = @AbsConConsecutiveAmount
              END
			  ELSE
			  BEGIN
				SET @ConsecutiveAmount = @AbsConConsecutiveAmount
			  END

			 -- SET @ConsecutiveAmount = @TotalAbsConConsPeriod * @ConsecutiveAmount

			  PRINT 'With  Consss = ' + CAST(@ConsecutiveAmount AS VARCHAR)

              SET @Amount = @Amount + ISNULL((@ConsecutiveAmount * @TotalAbsConConsPeriod), 0)

              IF EXISTS (SELECT StudentIID   FROM #Fees_TempCollection      WHERE StudentIID = @StudentIID)
              BEGIN
                SELECT TOP (1) @PaidAmount = PaidAmount  FROM #Fees_TempCollection
                WHERE StudentIID = @StudentIID AND ProcessId = @ProcessId  AND MonthId = @Month AND HeadId = @AbsConHead

                DELETE Fees_TempCollection
                WHERE ProcessId = @ProcessId
                  AND MonthId = @Month
                  AND ProcessType = @Type
                  AND PaidAmount > 0
                  AND IsPaid = 1
                  AND StudentIID = @StudentIID
                  AND HeadId = @AbsConHead
              END
              SET @AbsConConsecutiveDay = ISNULL(@AbsConConsecutiveDay, 0)
              EXECUTE @RC = [dbo].[InsertSingleStudentFee] @ProcessId, @Month, @SessionId, @StudentIID, @Amount, @PaidAmount, @AbsConHead, @Type, @FeesSessionYearId, @TotalAbsCond, @TotalAbsConConsPeriod, @YearValue;
              SET @StudentIID = NULL
            END
          END

          ELSE
          IF (@Type = 'I')-- Late IN/LIEO
          BEGIN
            DECLARE @TotalLIO int = 0, @lateIn int = 0, @EarlyOut int = 0, @TotalLateInConsPeriod int = 0,@lateInAmountPer int=0;
            SELECT @lateIn = COUNT(*) FROM Att_StudentAttendance A
            WHERE A.StudentId = @StudentIID AND CAST(A.InTime AS date) BETWEEN @FromDate AND @ToDate
            AND ISNULL(A.IsPresent, 0) = 1 AND A.IsLate = 1 AND A.IsDeleted = 0
			PRINT 'Total Late IN : ' + CAST(@lateIn AS VARCHAR)

            SELECT  @EarlyOut = COUNT(*)  FROM Att_StudentAttendance A
            WHERE A.StudentId = @StudentIID AND CAST(A.InTime AS date) BETWEEN @FromDate AND @ToDate
            AND ISNULL(A.IsPresent, 0) = 1 AND A.IsEarlyOut = 1 AND A.IsDeleted = 0
			PRINT 'Total Early Out : ' + CAST(@EarlyOut AS VARCHAR)

            SET @TotalLIO = @lateIn + @EarlyOut
			PRINT 'Total LIEO : ' + CAST(@TotalLIO AS VARCHAR)

			-- Calculate Total Consucutive
            IF (@lateInConsecutiveDay IS NOT NULL  AND @lateInConsecutiveAmount IS NOT NULL)

              EXECUTE @TotallateInConsPeriod = [dbo].[ConsicutiveCalculation] @StudentIID, @FromDate, @ToDate, @lateInConsecutiveDay, @Type;
            ELSE
              SET @TotallateInConsPeriod = 0
			  PRINT 'Total LI Consecutive : ' + CAST(@TotallateInConsPeriod AS VARCHAR)



            SET @TotalLIO = @TotalLIO - @TotallateInConsPeriod * ISNULL(@lateInConsecutiveDay, 0)
			PRINT 'Total LIEO W/O Con: ' + CAST(@TotalLIO AS VARCHAR)

            IF ((ISNULL(@TotalLIO, 0) >= @LateInPeriod) OR @TotalLateInConsPeriod > 0)
            BEGIN

              SET @PeriodNo = FLOOR(@TotalLIO / @LateInPeriod)
              IF (@LateInHeadIdAmount IS NOT NULL AND @LateInHeadIdAmount!=0)
              BEGIN
                SELECT TOP (1) @lateInAmountPer = ISNULL(HA.Amount,0) FROM Fees_HeadAmountConfig HA
                WHERE HA.HeadId = @lateInHeadIdAmount AND HA.ProcessId = @ProcessId 
				 AND  HA.FessGroupId = COALESCE(@FessGroupId,HA.FessGroupId)
				 AND HA.SectionId = @SectionId
				 AND HA.ClassId  = @ClassId
				 AND HA.IsDeleted = 0
              

              -- Need Here develop Head Percentage Amount 
			  IF (@LateInHeadIdAmountIsPercentage = 1)
					BEGIN
					  SET @Amount = ((@LateInAmount * @lateInAmountPer) / 100)
					END
					ELSE
					BEGIN
					  SET @Amount = @lateInAmountPer
					END

              END
			  ELSE
              BEGIN
                SET @Amount = @lateInAmount
              END

              SET @Amount = @PeriodNo * @Amount
			  PRINT 'Total Amount W/O Con : ' + CAST(@Amount AS VARCHAR)

              IF (@LateInConsecutiveHeadId IS NOT NULL)
              BEGIN
                DECLARE @lateInConsecutiveHeadAmount decimal(18, 2) = 0
                SELECT TOP (1) @lateInConsecutiveHeadAmount = ISNULL( HA.Amount,0) FROM Fees_HeadAmountConfig HA
                WHERE HA.HeadId = @lateInConsecutiveHeadId AND HA.ProcessId = @ProcessId  AND  HA.FessGroupId = COALESCE(@FessGroupId,HA.FessGroupId)
				 AND HA.SectionId = @SectionId
				 AND HA.ClassId  = @ClassId
				 AND HA.IsDeleted = 0

                SET @lateInConsecutiveHeadAmount = ISNULL(@lateInConsecutiveHeadAmount, 0)

                IF (@lateInConsecutiveIsPercentage = 1)
                  SET @ConsecutiveAmount = (@lateInConsecutiveAmount * @LateInConsecutiveHeadAmount) / 100
                ELSE
                  SET @ConsecutiveAmount = @LateInConsecutiveHeadAmount
              END
			 ELSE
				SET @ConsecutiveAmount = @lateInConsecutiveAmount

			   PRINT 'Total Amount After Con : ' + CAST(@ConsecutiveAmount AS VARCHAR)

              SET @Amount = @Amount + ISNULL((@ConsecutiveAmount * @TotalLateInConsPeriod), 0)

			   PRINT 'Final Amount : ' + CAST(@Amount AS VARCHAR)

              IF EXISTS (SELECT StudentIID FROM #Fees_TempCollection  WHERE StudentIID = @StudentIID)
              BEGIN
                SELECT TOP (1)
                  @PaidAmount = PaidAmount
                FROM #Fees_TempCollection
                WHERE StudentIID = @StudentIID
                AND ProcessId = @ProcessId
                AND MonthId = @Month
                AND HeadId = @lateInHead
                DELETE Fees_TempCollection
                WHERE ProcessId = @ProcessId
                  AND MonthId = @Month
                  AND ProcessType = @Type
                  AND PaidAmount > 0
                  AND IsPaid = 1
                  AND StudentIID = @StudentIID
                  AND HeadId = @lateInHead
              END
              SET @lateInConsecutiveDay = ISNULL(@lateInConsecutiveDay, 0)
              EXECUTE @RC = [dbo].[InsertSingleStudentFee] @ProcessId, @Month, @SessionId, @StudentIID, @Amount, @PaidAmount, @lateInHead, @Type, @FeesSessionYearId, @TotalLIO, @TotallateInConsPeriod, @YearValue;
              SET @StudentIID = NULL
            END
          --END


          END

          ELSE
          IF (@Type = 'L')-- Late Pay
		  PRINT 'LatePayHead Id : '  + CAST(@LatePayHead AS VARCHAR)
		  
            IF EXISTS (SELECT   StudentIID FROM Fees_Student 
						WHERE StudentIID = @StudentIID AND ProcessId = @ProcessId AND MonthId = @Month AND FeesSessionYearId = @FeesSessionYearId
								AND IsCompleted = 0 AND DueAmount > 0)
            
            --execute ProcessFeesAutomated 1068,1190,'2018-03-1','2018-03-31','L'
            BEGIN
              PRINT 'latePayAmount : ' + CAST(@latePayAmount AS VARCHAR)
              DECLARE @Days int = 0;
              SET @Days = ((SELECT DAY(GETDATE())) - @LatePayDay)
              IF (@Days > 0)
              BEGIN
                PRINT 'Day Status(IsFixed) : ' + CAST(@IsFixed AS VARCHAR)
                IF (@IsFixed = 1)
                BEGIN
                  PRINT 'LatePayHeadIdAmount : ' + CAST(@LatePayHeadIdAmount AS VARCHAR)
                  IF (@LatePayHeadIdAmount IS NOT NULL AND @LatePayHeadIdAmount != 0)
                  BEGIN
                    SELECT TOP (1) @latePayAmount = ISNULL( HA.Amount,0) FROM Fees_HeadAmountConfig HA
						  WHERE HA.HeadId = @latePayHeadIdAmount  AND HA.ProcessId = @ProcessId 
						   AND  HA.FessGroupId = COALESCE(@FessGroupId,HA.FessGroupId)
						  AND HA.SectionId = @SectionId AND HA.ClassId  = @ClassId AND HA.IsDeleted = 0
                    
                  -- Need Here develop Head Amount Persentage
                  END

                  SET @Amount = @latePayAmount

                  PRINT 'Amount for Fixed Head : '+ CAST(@Amount AS VARCHAR)
                END
                ELSE
                BEGIN
                  SET @Amount = 0;
                  DECLARE @COUNTERSlab int,@MAXIDSlab int;
                  CREATE TABLE #Fees_FeesLatePaySlab (
                    [Id] [int] IDENTITY (1, 1) NOT NULL,
                    [AutomatedId] [int] NOT NULL,
                    [FromDate] [int] NOT NULL,
                    [ToDate] [int] NOT NULL,
                    [LatePayPeriod] [int] NOT NULL,
                    [IsAcademicDate] [bit] NOT NULL,
                    [Amount] [decimal](18, 2) NOT NULL,
                  )

                  INSERT INTO #Fees_FeesLatePaySlab ([AutomatedId], [FromDate],[ToDate], [LatePayPeriod],[IsAcademicDate], [Amount])
                    SELECT AutomatedId,[FromDate],[ToDate],[LatePayPeriod],[IsAcademicDate],[Amount]
                    FROM Fees_FeesLatePaySlab WHERE AutomatedId = @Pk AND IsDeleted = 0

                  SET @COUNTERSlab = 1
                  SELECT @MAXIDSlab = COUNT(*) FROM #Fees_FeesLatePaySlab
                  WHILE (@MAXIDSlab >= @COUNTERSlab)
                  BEGIN
                    DECLARE @slabPeriodDay int = 1, @IsAcademicDate bit = 0, @FromDateslab int, @TodateSlab int, @AmountSlab decimal(18, 2) = 0, @SlabPeriodNo int, @SlabDays int, @TotalAmountSlab decimal(18, 2) = 0;
                    SELECT
                      @slabPeriodDay = LatePayPeriod,
                      @IsAcademicDate = IsAcademicDate,
                      @FromDateslab = FromDate,
                      @TodateSlab = Todate,
                      @AmountSlab = Amount
                    FROM #Fees_FeesLatePaySlab
                    WHERE id = @COUNTERSlab
                    IF (@TodateSlab > (SELECT DAY(GETDATE())))
                    BEGIN
                      SET @TodateSlab = (SELECT DAY(GETDATE()))
                    END

                    SET @SlabDays = @TodateSlab - @FromDateslab
                    IF (@IsAcademicDate = 1) --- If Settings Has lay pay Only for Regular Day
                    BEGIN
                      SELECT @SlabDays = COUNT(AC.[DayType])
                      FROM [dbo].[Att_AcademicCalendar] AC  WHERE DayType = 'Regular'
                      AND (SELECT MONTH(GETDATE())) = AC.[Month]
                      AND (SELECT YEAR(GETDATE())) = AC.[Year]
                      AND (@FromDateslab <= AC.[Day]
                      AND @TodateSlab >= AC.[Day])
                      SET @SlabPeriodNo = FLOOR(@SlabDays / @slabPeriodDay)
                    END
                    ELSE --- If Settings Has lay pay Only for All Day
                    BEGIN
                      SET @SlabPeriodNo = FLOOR(@SlabDays / @slabPeriodDay)
                    END

                    SET @TotalAmountSlab = ISNULL(@AmountSlab, 0) * ISNULL(@SlabPeriodNo, 0)
                    SET @Amount = ISNULL(@Amount, 0) + ISNULL(@TotalAmountSlab, 0)

                    SET @COUNTERSlab = @COUNTERSlab + 1
                  END

                  DROP TABLE #Fees_FeesLatePaySlab
                END

				PRINT 'LatePayLongRange : ' + CAST(@LatePayLongRange AS VARCHAR)
                IF (@LatePayLongRange IS NOT NULL)
                BEGIN
		
                  DECLARE @X int = 1,
                          @IsDue int = 1 -- @x is Current Month
                  WHILE (@LatePayLongRange >= @X)
                  BEGIN
                    DECLARE @PreMonth int = 0
                    SET @PreMonth = @Month - @X
                    IF EXISTS (SELECT
                        StudentIID
                      FROM Fees_Student
                      WHERE StudentIID = @StudentIID
                      AND MonthId = @PreMonth
                      AND IsCompleted = 0
                      AND DueAmount > 0)
                    BEGIN
                      SET @IsDue = @IsDue + 1
                    END
                    SET @X = @X + 1
                  END

                  IF (@LatePayLongRange = @IsDue)
                  BEGIN
                    IF (@LatePayIsPreviouseFine = 0)   -- For 0 cleare Previus Fine 
                    BEGIN
                      WHILE (@X > 1)
                      BEGIN
                        --  DELETE FROM Fees_Student where StudentIID=@StudentIID  AND MonthId=@PreMonth AND IsCompleted=0 AND HeadId= @latePayHead ANd DueAmount>0
                        UPDATE Fees_Student
                        SET IsDeleted = 1
                        WHERE StudentIID = @StudentIID
                        AND MonthId = @PreMonth
                        AND IsCompleted = 0
                        AND HeadId = @latePayHead
                        AND DueAmount > 0

                        SET @X = @X - 1
                        SET @PreMonth = @PreMonth + 1
                      END
                    END
                    IF (@LatePayLongRangeHeadIdAmount IS NOT NULL)
                    BEGIN
                      DECLARE @LongRangeheadAmount decimal(18, 2) = 0
                      SELECT TOP (1)
                        @LongRangeheadAmount = Amount
                      FROM [dbo].[Fees_HeadAmountConfig]
                      WHERE HeadId = @LatePayLongRangeHeadIdAmount
                      AND ProcessId = @ProcessId
                      IF (@LatePayLongRangeAmountIsPercentage = 1)
                      BEGIN
                        SET @Amount = (ISNULL(@LongRangeheadAmount, 0) * ISNULL(@LatePayLongRangeAmount, 0)) / 100
                      END
                      ELSE
                        SET @Amount = @LongRangeheadAmount
                    END
                    ELSE
                    BEGIN
                      SET @Amount = ISNULL(@LatePayLongRangeAmount, 0)
                    END
                  END

                END

               
                PRINT 'Final Amount : ' +  CAST(@Amount AS VARCHAR)
               


                IF EXISTS (SELECT StudentIID FROM #Fees_TempCollection WHERE StudentIID = @StudentIID)
                BEGIN
                  SELECT TOP (1) @PaidAmount = PaidAmount FROM #Fees_TempCollection
                  WHERE StudentIID = @StudentIID  AND ProcessId = @ProcessId AND MonthId = @Month AND HeadId = @latePayHead
                  DELETE Fees_TempCollection
                  WHERE ProcessId = @ProcessId  AND MonthId = @Month  AND ProcessType = @Type AND PaidAmount > 0 AND IsPaid = 1 AND StudentIID = @StudentIID AND HeadId = @latePayHead
                END

                EXECUTE @RC = [dbo].[InsertSingleStudentFee] @ProcessId, @Month, @SessionId, @StudentIID, @Amount, @PaidAmount, @latePayHead, @Type, @FeesSessionYearId, 0, 0, @YearValue;
                SET @StudentIID = NULL
              END


            END
        

          SET @totalloop = @totalloop + 1;
          SET @Counter2 = @Counter2 + 1;
          SET @StudentIID = NULL
        END

       
        TRUNCATE TABLE #tmpStudent
        SET @COUNTER = @COUNTER + 1
      END
      ------------------------------
      DROP TABLE #tmpFees_AutomatedFeesConfig
      DROP TABLE #tmpStudent
      DROP TABLE #Fees_TempCollection

    COMMIT TRANSACTION;
  END TRY
  BEGIN CATCH;
    ROLLBACK TRANSACTION;
    DECLARE @ErrorMessage nvarchar(4000);
    DECLARE @ErrorSeverity int;
    DECLARE @ErrorState int;
    SELECT
      @ErrorMessage = ERROR_MESSAGE(),
      @ErrorSeverity = ERROR_SEVERITY(),
      @ErrorState = ERROR_STATE();
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);

  END CATCH

END
GO