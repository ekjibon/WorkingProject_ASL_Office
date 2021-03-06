/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ConsicutiveCalculation]'))
BEGIN
DROP PROCEDURE  [ConsicutiveCalculation]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Biplob
-- Create date: 
-- Description:	
-- =============================================
CREATE  PROCEDURE [dbo].[ConsicutiveCalculation] 
    @StudentIID bigint,
	@FromDate SMALLDATETIME=NULL,
	@ToDate SMALLDATETIME=NULL,
	@Period Int,
	@Status VARCHAR(1)
AS
BEGIN
 DECLARE @TotalConPeriod INT=0, @ConsecutiveDay Int=0, @Signal bit =0,@COUNTER INT, @MAXID INT
 If(@Status='A')
 BEGIN
		   Create Table #WorkingDay
		   (
		   [Id] [int] IDENTITY(1,1) NOT NULL,
		   [Date] [DateTime] NOT NULL
		   )
		   Insert Into  #WorkingDay ([Date]) SELECT  CalendarDate From [dbo].[Att_AcademicCalendar] AC where DayType='Regular' 
		   and CalendarDate between @FromDate and @ToDate
		   SET @COUNTER = 1
		  SELECT @MAXID = COUNT(*) FROM #WorkingDay
  

		WHILE (@COUNTER <= @MAXID)
			BEGIN
			DECLARE @CalenderDate Datetime
			 Select @CalenderDate=[Date] From #WorkingDay where [Id]=@COUNTER

			 IF Not EXists (
			  SELECT A.IsPresent From [Att_StudentAttendance] A where A.StudentId=@StudentIID
			  And DATEPART(MONTH, @CalenderDate)= DATEPART(MONTH, A.InTime) And DATEPART(year, @CalenderDate)= DATEPART(year, A.InTime) 
			  AND DATEPART(Day, @CalenderDate)= DATEPART(Day, A.InTime)  AND A.IsPresent=1
			  )
			  BEGIN
			   set @Signal=1
			  END
			  ELSE
			  set @Signal=0

	  
				  If(@Signal=1)
				  BEGIN
				   set @ConsecutiveDay=@ConsecutiveDay +1

				   IF(@ConsecutiveDay=@Period)
					   BEGIN
						set @TotalConPeriod=@TotalConPeriod +1
						set @ConsecutiveDay=0
					   END
		   
				  END
				  ELSE
				  set @ConsecutiveDay=0

				 set @COUNTER=@COUNTER + 1
			END
   
		   Drop Table #WorkingDay
   END
   ELSE 
   BEGIN
    Create Table #Att_StudentAttendance (
	[Id] [int] IDENTITY(1,1) NOT NULL,
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
	Insert Into #Att_StudentAttendance
	(
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
	) SELECT [StudentId],
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
	[EarlyOutTime] FROM Att_StudentAttendance Where ([InTime] between @FromDate and @ToDate) and StudentID=@StudentIID and IsDeleted=0 Order by [InTime] asc

	 SET @COUNTER = 1
     SELECT @MAXID = COUNT(*) FROM #Att_StudentAttendance
	 WHILE (@COUNTER <= @MAXID)
			BEGIN
			  If(@Status='B')
			  BEGIN
			  IF EXists (
			  SELECT A.IsAbsconding From [#Att_StudentAttendance] A where A.StudentId=@StudentIID AND A.IsPresent=1 AND A.IsAbsconding=1 AND A.Id=@COUNTER
			  )
			  BEGIN
			   set @Signal=1
			  END
			  ELSE
			  set @Signal=0

	  
				  If(@Signal=1)
				  BEGIN
				   set @ConsecutiveDay=@ConsecutiveDay +1

				   IF(@ConsecutiveDay=@Period)
					   BEGIN
						set @TotalConPeriod=@TotalConPeriod +1
						set @ConsecutiveDay=0
					   END
		   
				  END
				  ELSE
				  set @ConsecutiveDay=0

			   END
			   ELSE If(@Status='I')
			   BEGIN
			  IF EXists (
			  SELECT A.IsLate From [#Att_StudentAttendance] A where A.StudentId=@StudentIID AND A.IsPresent=1 AND A.IsLate=1 AND A.Id=@COUNTER
			  )
			  BEGIN
			   set @Signal=1
			  END
			  ELSE
			  set @Signal=0

	  
				  If(@Signal=1)
				  BEGIN
				   set @ConsecutiveDay=@ConsecutiveDay +1

				   IF(@ConsecutiveDay=@Period)
					   BEGIN
						set @TotalConPeriod=@TotalConPeriod +1
						set @ConsecutiveDay=0
					   END
		   
				  END
				  ELSE
				  set @ConsecutiveDay=0

			   END

			    ELSE If(@Status='L')
			   BEGIN
			  IF Not EXists (
			  SELECT A.IsPresent From [Att_StudentAttendance] A where A.StudentId=@StudentIID
			  And DATEPART(MONTH, @CalenderDate)= DATEPART(MONTH, A.InTime) And DATEPART(year, @CalenderDate)= DATEPART(year, A.InTime) 
			  AND DATEPART(Day, @CalenderDate)= DATEPART(Day, A.InTime)  AND A.IsPresent=1
			  )
			  BEGIN
			   set @Signal=1
			  END
			  ELSE
			  set @Signal=0

	  
				  If(@Signal=1)
				  BEGIN
				   set @ConsecutiveDay=@ConsecutiveDay +1

				   IF(@ConsecutiveDay=@Period)
					   BEGIN
						set @TotalConPeriod=@TotalConPeriod +1
						set @ConsecutiveDay=0
					   END
		   
				  END
				  ELSE
				  set @ConsecutiveDay=0

			   END
		 set @COUNTER=@COUNTER + 1

			END
   Drop Table #Att_StudentAttendance
   END
   print '@TotalConPeriod' print @TotalConPeriod
   Return @TotalConPeriod;
END





