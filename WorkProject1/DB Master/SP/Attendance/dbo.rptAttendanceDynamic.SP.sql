/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptAttendanceDynamic]'))
BEGIN
DROP PROCEDURE  rptAttendanceDynamic
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kawsar
-- Create date: 
-- Description:	
-- =============================================
-- rptAttendanceDynamic  '',null,null,null,null,  null,  null,  null,  null,  null,  null ,'2018-02-1 00:00:00.000','2018-02-28 00:00:00.000'
CREATE PROCEDURE [dbo].[rptAttendanceDynamic]     
	@Where varchar(MAX) = NULL,
	@minPercentage nvarchar(max)=null,
	@maxPercentage nvarchar(max)=null,
	@minPeriod nvarchar(max)=null,
	@maxPeriod nvarchar(max)=null,
	@minLIEODuration nvarchar(max)=null,
	@maxLIEODuration nvarchar(max)=null,
	@minPresentDay nvarchar(max)=null,
	@maxPresentDay nvarchar(max)=null,
	@minAbscondingDay nvarchar(max)=null,
	@maxAbscondingDay nvarchar(max)=null,
	@FromDate nvarchar(max)=null,
	@ToDate nvarchar(max)=null
	
AS
BEGIN
DECLARE @sql varchar(max)
DECLARE @WHERE1 varchar(max)
DECLARE @WorkingDays INT = 0;
SELECT @WorkingDays = COUNT(*)  FROM Att_AcademicCalendar WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE)
PRINT @WorkingDays
SET @sql = 'select sb.StudentIID, sb.StudentInsID, sb.RollNo, sb.FullName FROM dbo.Student_BasicInfo SB WHERE SB.IsDeleted=0 and   '

	  IF( @Where <> '' )
	 BEGIN
	 SET @sql =@sql + @Where
	 END
	 PRINT @SQL
	 CREATE TABLE #STU
	 (
	 StudentIID BIGINT NOT NULL,
	 STUDENTINSID VARCHAR(150) NULL,
	 RollNo VARCHAR(50) NOT NULL,
	 FULLNAME VARCHAR(150)
	 )
	 INSERT INTO #STU EXEC(@sql)

	 SELECT DISTINCT [StudentId], IsPresent, IsAbsconding, IsLeave, [IsLate], [IsEarlyOut], Convert(DATE,[InTime]) AS [InTime]  INTO #Att_StudentAttendance1 FROM [dbo].[Att_StudentAttendance] 
            WHERE  CONVERT(DATE,InTime) BETWEEN CONVERT(DATE,@FromDate) AND CONVERT(DATE,@ToDate) AND IsDeleted=0		

			SELECT DISTINCT B.StudentIID, B.STUDENTINSID ,B.FullName, CAST(B.RollNo AS INT) AS RollNo,					
			ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_StudentAttendance1 WHERE StudentId=B.StudentIID AND IsPresent=1 GROUP BY StudentId),0) AS [PresentDay], 
			ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_StudentAttendance1 WHERE StudentId=B.StudentIID AND IsLeave=1 GROUP BY StudentId),0) AS [LeaveDay],
			@WorkingDays-(ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_StudentAttendance1 WHERE StudentId=B.StudentIID AND IsPresent=1 GROUP BY StudentId),0)+
			ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_StudentAttendance1 WHERE StudentId=B.StudentIID AND IsLeave=1 GROUP BY StudentId),0)) AS [AbsentDay],
			ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_StudentAttendance1 WHERE StudentId=B.StudentIID AND IsLate=1 GROUP BY StudentId),0) AS [LateDay],
			ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_StudentAttendance1 WHERE StudentId=B.StudentIID AND IsEarlyOut=1 GROUP BY StudentId),0) AS [EarlyOutDay],
			ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_StudentAttendance1 WHERE StudentId=B.StudentIID AND IsAbsconding=1 GROUP BY StudentId),0) AS [AbscondingDay],
			CAST(ISNULL((100*ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_StudentAttendance1 WHERE StudentId=B.StudentIID AND IsPresent=1 GROUP BY StudentId),0)/@WorkingDays),0)AS DECIMAL) AS [Percentage]
			FROM #STU AS B ORDER BY CAST(B.RollNo AS INT)

	 DROP TABLE #STU,#Att_StudentAttendance1

END
