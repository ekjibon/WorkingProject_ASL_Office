/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF EXISTS (SELECT
    *
  FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[ConsicutiveCalculation]'))
BEGIN
  DROP PROCEDURE ConsicutiveCalculation
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Kawsar 
-- Create date: 
-- Description:	
-- =============================================
-- execute ProcessFeesAutomated 1069,25,'2018-01-1','2018-01-31','A'

CREATE PROCEDURE [dbo].[ConsicutiveCalculation] 
@StudentIID bigint,
@FromDate smalldatetime = NULL,
@ToDate smalldatetime = NULL,
@Period int,
@Status varchar(1)
AS
BEGIN
  DECLARE @TotalConPeriod int = 0, @ConsecutiveDay int = 0, @Signal bit = 0,@COUNTER int, @MAXID int;

  IF (@Status = 'A')
  BEGIN
    CREATE TABLE #WorkingDay (
      [Id] [int] IDENTITY (1, 1) NOT NULL,
      [Date] [DateTime] NOT NULL
    )
    INSERT INTO #WorkingDay ([Date])
      SELECT CalendarDate
      FROM [dbo].[Att_AcademicCalendar] AC
      WHERE DayType = 'Regular' AND CalendarDate BETWEEN @FromDate AND @ToDate
    SET @COUNTER = 1
    SELECT  @MAXID = COUNT(*)  FROM #WorkingDay


    WHILE (@COUNTER <= @MAXID)
    BEGIN
      DECLARE @CalenderDate datetime
      SELECT
        @CalenderDate = [Date]
      FROM #WorkingDay
      WHERE [Id] = @COUNTER

      IF NOT EXISTS (SELECT
          A.IsPresent
        FROM [Att_StudentAttendance] A
        WHERE A.StudentId = @StudentIID
        AND DATEPART(MONTH, @CalenderDate) = DATEPART(MONTH, A.InTime)
        AND DATEPART(YEAR, @CalenderDate) = DATEPART(YEAR, A.InTime)
        AND DATEPART(DAY, @CalenderDate) = DATEPART(DAY, A.InTime)
        AND A.IsPresent = 1)
      BEGIN
        SET @Signal = 1
      END
      ELSE
        SET @Signal = 0


      IF (@Signal = 1)
      BEGIN
        SET @ConsecutiveDay = @ConsecutiveDay + 1

        IF (@ConsecutiveDay = @Period)
        BEGIN
          SET @TotalConPeriod = @TotalConPeriod + 1
          SET @ConsecutiveDay = 0
        END

      END
      ELSE
        SET @ConsecutiveDay = 0

      SET @COUNTER = @COUNTER + 1
    END

    DROP TABLE #WorkingDay
  END
  ELSE
  BEGIN
    CREATE TABLE #Att_StudentAttendance (
      [Id] [int] IDENTITY (1, 1) NOT NULL,
      [StudentId] [bigint] NOT NULL,
      [InTime] [datetime] NOT NULL,
      [OutTime] [datetime] NULL,
      [IsPresent] [bit] NOT NULL,
      [IsLeave] [bit] NOT NULL,
      [LeaveId] [int] NULL,
      [IsAbsconding] [bit] NOT NULL,
      [AbscondingPeriod] [nvarchar](30) NULL,
      [IsLate] [bit] NOT NULL,
      [LateTime] [int] NULL,
      [IsEarlyOut] [bit] NOT NULL,
      [EarlyOutTime] [int] NULL

    )
    INSERT INTO #Att_StudentAttendance ([StudentId],
    [InTime],
    [OutTime],
    [IsPresent],
    [IsLeave],
    [LeaveId],
    [IsAbsconding],
    [AbscondingPeriod],
    [IsLate],
    [LateTime],
    [IsEarlyOut],
    [EarlyOutTime])
      SELECT
        [StudentId],
        [InTime],
        [OutTime],
        [IsPresent],
        [IsLeave],
        [LeaveId],
        [IsAbsconding],
        [AbscondingPeriod],
        [IsLate],
        [LateTime],
        [IsEarlyOut],
        [EarlyOutTime]
      FROM Att_StudentAttendance
      WHERE ([InTime] BETWEEN @FromDate AND @ToDate)
      AND StudentID = @StudentIID
      AND IsDeleted = 0
      ORDER BY [InTime] ASC

    SET @COUNTER = 1
    SELECT @MAXID = COUNT(*) FROM #Att_StudentAttendance
	---------------------------------------------------------------------- BEGIN LOOP ------------------------------------------------------------------------------
    WHILE (@COUNTER <= @MAXID)
    BEGIN
      IF (@Status = 'B')
      BEGIN
        IF EXISTS (SELECT A.IsAbsconding FROM [#Att_StudentAttendance] A  WHERE A.StudentId = @StudentIID  AND A.IsPresent = 1 AND A.IsAbsconding = 1 AND A.Id = @COUNTER)
        BEGIN
          SET @Signal = 1
        END
        ELSE
          SET @Signal = 0
        IF (@Signal = 1)
        BEGIN
          SET @ConsecutiveDay = @ConsecutiveDay + 1

          IF (@ConsecutiveDay = @Period)
          BEGIN
            SET @TotalConPeriod = @TotalConPeriod + 1
            SET @ConsecutiveDay = 0
          END

        END
        ELSE
          SET @ConsecutiveDay = 0

      END
      ELSE
      IF (@Status = 'I')
      BEGIN
        IF EXISTS (SELECT A.IsLate FROM #Att_StudentAttendance A WHERE A.StudentId = @StudentIID AND A.IsPresent = 1 AND A.IsLate = 1 AND A.Id = @COUNTER)
        BEGIN
          SET @Signal = 1
        END
        ELSE
          SET @Signal = 0


        IF (@Signal = 1)
        BEGIN
          SET @ConsecutiveDay = @ConsecutiveDay + 1

          IF (@ConsecutiveDay = @Period)
          BEGIN
            SET @TotalConPeriod = @TotalConPeriod + 1
            SET @ConsecutiveDay = 0
          END
        END
        ELSE
          SET @ConsecutiveDay = 0

      END

      ELSE
      IF (@Status = 'L')
      BEGIN
        IF NOT EXISTS (SELECT
            A.IsPresent
          FROM [Att_StudentAttendance] A
          WHERE A.StudentId = @StudentIID
          AND DATEPART(MONTH, @CalenderDate) = DATEPART(MONTH, A.InTime)
          AND DATEPART(YEAR, @CalenderDate) = DATEPART(YEAR, A.InTime)
          AND DATEPART(DAY, @CalenderDate) = DATEPART(DAY, A.InTime)
          AND A.IsPresent = 1)
        BEGIN
          SET @Signal = 1
        END
        ELSE
          SET @Signal = 0


        IF (@Signal = 1)
        BEGIN
          SET @ConsecutiveDay = @ConsecutiveDay + 1

          IF (@ConsecutiveDay = @Period)
          BEGIN
            SET @TotalConPeriod = @TotalConPeriod + 1
            SET @ConsecutiveDay = 0
          END

        END
        ELSE
          SET @ConsecutiveDay = 0

      END
      SET @COUNTER = @COUNTER + 1

    END
    DROP TABLE #Att_StudentAttendance
  END
  -- print '@TotalConPeriod' print @TotalConPeriod
  RETURN @TotalConPeriod;
END