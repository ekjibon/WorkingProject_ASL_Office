/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptAttendanceDynamicByType]'))
BEGIN
DROP PROCEDURE  rptAttendanceDynamicByType
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shahin
-- Create date: 
-- Description:	
-- =============================================
-- [rptAttendanceDynamicByType]  ' AND  B.VersionID=1',1,'2018-02-1 00:00:00.000','2018-02-5 00:00:00.000'
CREATE PROCEDURE [dbo].[rptAttendanceDynamicByType]     
	@WHERE VARCHAR(MAX) = NULL,	
	@TYPE INT = NULL,
	@FromDate SMALLDATETIME,
	@ToDate SMALLDATETIME
	
AS
BEGIN
DECLARE @sql varchar(max)

DECLARE @WorkingDays INT = 0;
SELECT @WorkingDays = COUNT(*)  FROM Att_AcademicCalendar WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE)
PRINT @WorkingDays
SET @sql = 'SELECT V.SessionName, V.ClassName, V.ShiftName, V.BranchName, V.SectionName,
			B.StudentIID, B.StudentInsID, B.RollNo, B.FullName FROM dbo.Student_BasicInfo AS B
			INNER JOIN [dbo].[view_CommonTableNames] AS V ON 
		    B.SessionId=V.SessionId AND B.BranchID=V.BranchId AND B.ShiftID=V.ShiftId AND B.ClassId=V.ClassId AND B.SectionId=V.SectionId
			WHERE B.IsDeleted=0' 
			

	  IF( @Where <> '' )
	 BEGIN
	 SET @sql =@sql + @Where
	 END
	 PRINT @SQL
	 CREATE TABLE #STU
	 (
	 SessionName VARCHAR(100),
	 ClassName VARCHAR(100),
	 ShiftName VARCHAR(100),
	 BranchName VARCHAR(100),
	 SectionName VARCHAR(100),
	 StudentIID BIGINT NOT NULL,
	 STUDENTINSID VARCHAR(150) NULL,
	 RollNo VARCHAR(50) NOT NULL,
	 FULLNAME VARCHAR(150)
	 )
	 INSERT INTO #STU EXEC(@sql)
 
	  SELECT DISTINCT  SessionName, ClassName, ShiftName, BranchName, SectionName, StudentIID, StudentInsID, RollNo, FullName, [Year], [Month], [Day], [CalendarDate], [DayType], [HolidayName]	  
	  INTO #STU_CALENDAR FROM [dbo].[Att_AcademicCalendar], #STU 
	  WHERE  CONVERT(DATE,CalendarDate) BETWEEN   CONVERT(DATE, @FromDate) AND CONVERT(DATE, @ToDate) AND [dbo].[Att_AcademicCalendar].IsDeleted=0

	 IF(@TYPE=1)
	 BEGIN
		  -- [rptAttendanceDynamicByType]  ' AND  B.VersionID=1',1,'2018-02-1 00:00:00.000','2018-02-5 00:00:00.000'
		  SELECT DISTINCT  SessionName, ClassName, ShiftName, BranchName,  SectionName, 
		  StudentIID, StudentInsID, RollNo, FullName, [Year], [Month], [Day], [CalendarDate], [DayType], [HolidayName],
		  CASE WHEN A.IsPresent=1 THEN 'P' ELSE '' END DAYSTATUS
		  FROM #STU_CALENDAR AS C INNER JOIN [Att_StudentAttendance] AS A ON C.StudentIID=A.StudentId
		  AND CAST(C.CalendarDate AS DATE)=CAST(A.InTime AS DATE) AND A.IsDeleted=0	  


	 END
	 IF(@TYPE=2)
	 BEGIN			
		  -- [rptAttendanceDynamicByType]  ' AND  B.VersionID=1',2,'2018-02-1 00:00:00.000','2018-02-5 00:00:00.000'
		  SELECT DISTINCT   SessionName, ClassName, ShiftName, BranchName,  SectionName, 
		  StudentIID, StudentInsID, RollNo, FullName, [Year], [Month], [Day], [CalendarDate], [DayType], [HolidayName],
		  CASE WHEN A.IsPresent IS NULL THEN 'A' ELSE '' END DAYSTATUS
		  FROM #STU_CALENDAR AS C INNER JOIN [Att_StudentAttendance] AS A ON C.StudentIID=A.StudentId
		  AND CAST(C.CalendarDate AS DATE)=CAST(A.InTime AS DATE) AND A.IsDeleted=0	 	
	 END
	 IF(@TYPE=3)
	 BEGIN			
		  -- [rptAttendanceDynamicByType]  ' AND  B.VersionID=1',3,'2018-02-1 00:00:00.000','2018-02-5 00:00:00.000'
		  SELECT DISTINCT   SessionName, ClassName, ShiftName, BranchName,  SectionName, 
		  StudentIID, StudentInsID, RollNo, FullName, [Year], [Month], [Day], [CalendarDate], [DayType], [HolidayName],
		  CASE WHEN A.IsPresent=1 AND A.IsAbsconding=1 THEN 'AB' ELSE '' END DAYSTATUS
		  FROM #STU_CALENDAR AS C INNER JOIN [Att_StudentAttendance] AS A ON C.StudentIID=A.StudentId
		  AND CAST(C.CalendarDate AS DATE)=CAST(A.InTime AS DATE) AND A.IsDeleted=0	 	
	 END
	 IF(@TYPE=4)
	 BEGIN			
		  -- [rptAttendanceDynamicByType] ' AND  B.VersionID=1',4,'2018-02-1 00:00:00.000','2018-02-5 00:00:00.000'
		  SELECT DISTINCT   SessionName, ClassName, ShiftName, BranchName,  SectionName, 
		  StudentIID, StudentInsID, RollNo, FullName, [Year], [Month], [Day], [CalendarDate], [DayType], [HolidayName],
		  CASE WHEN A.IsLeave=1 THEN 'L' ELSE '' END DAYSTATUS
		  FROM #STU_CALENDAR AS C INNER JOIN [Att_StudentAttendance] AS A ON C.StudentIID=A.StudentId
		  AND CAST(C.CalendarDate AS DATE)=CAST(A.InTime AS DATE) AND A.IsDeleted=0	 	
	 END
	 IF(@TYPE=5)
	 BEGIN			
		  -- [rptAttendanceDynamicByType]  ' AND  B.VersionID=1',5,'2018-02-1 00:00:00.000','2018-02-5 00:00:00.000'
		  SELECT DISTINCT   SessionName, ClassName, ShiftName, BranchName,  SectionName, 
		  StudentIID, StudentInsID, RollNo, FullName, [Year], [Month], [Day], [CalendarDate], [DayType], [HolidayName],
		  CASE WHEN A.IsPresent=1 AND A.IsLate=1 THEN 'LI' ELSE '' END DAYSTATUS
		  FROM #STU_CALENDAR AS C INNER JOIN [Att_StudentAttendance] AS A ON C.StudentIID=A.StudentId
		  AND CAST(C.CalendarDate AS DATE)=CAST(A.InTime AS DATE) AND A.IsDeleted=0	 	
	 END
	 IF(@TYPE=6)
	 BEGIN			
		  -- [rptAttendanceDynamicByType]  ' AND  B.VersionID=1',6,'2018-02-1 00:00:00.000','2018-02-5 00:00:00.000'
		  SELECT DISTINCT   SessionName, ClassName, ShiftName, BranchName,  SectionName,  
		  StudentIID, StudentInsID, RollNo, FullName, [Year], [Month], [Day], [CalendarDate], [DayType], [HolidayName],
		  CASE WHEN A.IsPresent=1 AND A.IsEarlyOut=1 THEN 'EO' ELSE '' END DAYSTATUS
		  FROM #STU_CALENDAR AS C INNER JOIN [Att_StudentAttendance] AS A ON C.StudentIID=A.StudentId
		  AND CAST(C.CalendarDate AS DATE)=CAST(A.InTime AS DATE) AND A.IsDeleted=0	 	
	 END
	 IF(@TYPE=7)
	 BEGIN			
		  -- [rptAttendanceDynamicByType]  ' AND  B.VersionID=1',7,'2018-02-1 00:00:00.000','2018-02-5 00:00:00.000'
		  SELECT DISTINCT   SessionName, ClassName, ShiftName, BranchName,  SectionName, 
		  StudentIID, StudentInsID, RollNo, FullName, [Year], [Month], [Day], [CalendarDate], [DayType], [HolidayName],
		  CASE WHEN A.IsPresent=1 AND A.IsLate=1 AND A.IsEarlyOut=1 THEN 'LE' ELSE '' END DAYSTATUS
		  FROM #STU_CALENDAR AS C INNER JOIN [Att_StudentAttendance] AS A ON C.StudentIID=A.StudentId
		  AND CAST(C.CalendarDate AS DATE)=CAST(A.InTime AS DATE) AND A.IsDeleted=0	 	
	 END
	 IF(@TYPE=0)
	 BEGIN			
		  -- [rptAttendanceDynamicByType]  ' AND  B.VersionID=1',0,'2018-02-1 00:00:00.000','2018-02-5 00:00:00.000'
		  SELECT DISTINCT   SessionName, ClassName, ShiftName, BranchName,  SectionName, 
		  StudentIID, StudentInsID, RollNo, FullName, [Year], [Month], [Day], [CalendarDate], [DayType], [HolidayName],
		  CASE WHEN A.IsPresent=1 THEN 'P'
		  WHEN A.IsPresent IS NULL THEN 'A'
		  WHEN A.IsPresent=1 AND A.IsAbsconding=1 THEN 'AB'
		  WHEN A.IsLeave=1 THEN 'L'
		  WHEN A.IsPresent=1 AND A.IsLate=1 THEN 'LI'
		  WHEN A.IsPresent=1 AND A.IsEarlyOut=1 THEN 'EO'
		  WHEN A.IsPresent=1 AND A.IsLate=1 AND A.IsEarlyOut=1  THEN 'LE'		  
		  ELSE '' END DAYSTATUS
		  FROM #STU_CALENDAR AS C INNER JOIN [Att_StudentAttendance] AS A ON C.StudentIID=A.StudentId
		  AND CAST(C.CalendarDate AS DATE)=CAST(A.InTime AS DATE) AND A.IsDeleted=0	 	
	 END
END
