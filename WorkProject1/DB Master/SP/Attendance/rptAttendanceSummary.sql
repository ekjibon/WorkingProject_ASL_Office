--USE [cgsd_new_2019_test_20200112]
GO
/****** Object:  StoredProcedure [dbo].[rptEMPAttendanceSummary]    Script Date: 5/2/2020 2:40:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Azmal
-- Create date: 5/2/2020
-- Description:	
-- =============================================
-- rptEMPAttendanceSummary   9,'2020-08-31','2020-08-31'
ALTER PROCEDURE [dbo].[rptEMPAttendanceSummary]     
	@BranchID int,
	@FromDate nvarchar(max)=null,
	@ToDate nvarchar(max)=null
	
AS
BEGIN

DECLARE @WorkingDays INT = 0;
SELECT @WorkingDays = COUNT(*)  FROM Att_EmpAcademicCalendarDetails WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE)
PRINT @WorkingDays


	 SELECT DISTINCT [EmpID], IsPresent, IsLeave, [IsLate], [IsEarlyOut],IsWithPay,IsWithOutPay,IsHalfDay,IsAbsetLongHoliday, Convert(DATE,[InTime]) AS [InTime]  INTO #Att_Attendance1 FROM [dbo].[Emp_Attendance] 
            WHERE  CONVERT(DATE,InTime) BETWEEN CONVERT(DATE,@FromDate) AND CONVERT(DATE,@ToDate) AND IsDeleted=0		

			--SELECT DISTINCT B.EmpBasicInfoID, B.EmpID EmployeeID ,B.FullName, @WorkingDays WorkingDays,				
			--ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsPresent=1 GROUP BY EmpId),0) AS [PresentDay], 
			--ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsLeave=1 GROUP BY EmpId),0) AS [LeaveDay],
			--@WorkingDays-(ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsPresent=1 GROUP BY EmpId),0)+
			--ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsLeave=1 GROUP BY EmpId),0)) AS [AbsentDay],
			--ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsLate=1 GROUP BY EmpId),0) AS [LateDay],
			--ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsEarlyOut=1 GROUP BY EmpId),0) AS [EarlyOutDay],
			--ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsWithPay=1 GROUP BY EmpId),0) AS [WithPayDay],
			--ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsWithOutPay=1 GROUP BY EmpId),0) AS [WithOutPayDay],
			--ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsHalfDay=1 GROUP BY EmpId),0) AS [HalfDay],
			--ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsAbsetLongHoliday=1 GROUP BY EmpId),0) AS [AbsentLongHoliyDay],
			
			--CAST(ISNULL((100*ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsPresent=1 GROUP BY EmpId),0)/@WorkingDays),0)AS DECIMAL) AS [Percentage],
			--Convert(nvarchar(15), cast(@FromDate as Date),106) FromDate,
	  --      Convert(nvarchar(15), cast(@ToDate as Date),106) ToDate
	  			SELECT DISTINCT B.EmpBasicInfoID, B.EmpID EmployeeID ,B.FullName,
			(CASE WHEN B.CategoryID =1 THEN (SELECT COUNT(*)  FROM Att_EmpAcademicCalendarDetails WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE) AND CalendarId = (SELECT TOP(1) Id FROM Att_EmpAcademicCalendar WHERE EmpCategory= 1 ORDER BY Id DESC))
			      WHEN B.CategoryID =2 THEN (SELECT COUNT(*)  FROM Att_EmpAcademicCalendarDetails WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE) AND CalendarId = (SELECT TOP(1) Id FROM Att_EmpAcademicCalendar WHERE EmpCategory= 2 ORDER BY Id DESC))
			      WHEN B.CategoryID =3 THEN (SELECT COUNT(*)  FROM Att_EmpAcademicCalendarDetails WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE) AND CalendarId = (SELECT TOP(1) Id FROM Att_EmpAcademicCalendar WHERE EmpCategory= 3 ORDER BY Id DESC))
				  WHEN B.CategoryID =4 THEN (SELECT COUNT(*)  FROM Att_EmpAcademicCalendarDetails WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE) AND CalendarId = (SELECT TOP(1) Id FROM Att_EmpAcademicCalendar WHERE EmpCategory= 4 ORDER BY Id DESC))
				  WHEN B.CategoryID =5 THEN (SELECT NULLIF(COUNT(*),0)  FROM Att_EmpAcademicCalendarDetails WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE) AND CalendarId = (SELECT TOP(1) Id FROM Att_EmpAcademicCalendar WHERE EmpCategory= 5 ORDER BY Id DESC))
				  WHEN B.CategoryID =10 THEN (SELECT COUNT(*)  FROM Att_EmpAcademicCalendarDetails WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE) AND CalendarId = (SELECT TOP(1) Id FROM Att_EmpAcademicCalendar WHERE EmpCategory= 10 ORDER BY Id DESC))
				  ELSE '' END) AS WorkingDays,				
			ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsPresent=1  GROUP BY EmpId),0) AS [PresentDay], 
	        ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsLeave=1 GROUP BY EmpId),0) AS [LeaveDay],
					(CASE WHEN ((CASE WHEN B.CategoryID =1 THEN (SELECT COUNT(*)  FROM Att_EmpAcademicCalendarDetails WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE) AND CalendarId = (SELECT TOP(1) Id FROM Att_EmpAcademicCalendar WHERE EmpCategory= 1 ORDER BY Id DESC))
			      WHEN B.CategoryID =2 THEN (SELECT COUNT(*)  FROM Att_EmpAcademicCalendarDetails WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE) AND CalendarId = (SELECT TOP(1) Id FROM Att_EmpAcademicCalendar WHERE EmpCategory= 2 ORDER BY Id DESC))
			      WHEN B.CategoryID =3 THEN (SELECT COUNT(*)  FROM Att_EmpAcademicCalendarDetails WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE) AND CalendarId = (SELECT TOP(1) Id FROM Att_EmpAcademicCalendar WHERE EmpCategory= 3 ORDER BY Id DESC))
				  WHEN B.CategoryID =4 THEN (SELECT COUNT(*)  FROM Att_EmpAcademicCalendarDetails WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE) AND CalendarId = (SELECT TOP(1) Id FROM Att_EmpAcademicCalendar WHERE EmpCategory= 4 ORDER BY Id DESC))
				  WHEN B.CategoryID =5 THEN (SELECT COUNT(*)  FROM Att_EmpAcademicCalendarDetails WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE) AND CalendarId = (SELECT TOP(1) Id FROM Att_EmpAcademicCalendar WHERE EmpCategory= 5 ORDER BY Id DESC))
				  WHEN B.CategoryID =10 THEN (SELECT COUNT(*)  FROM Att_EmpAcademicCalendarDetails WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE) AND CalendarId = (SELECT TOP(1) Id FROM Att_EmpAcademicCalendar WHERE EmpCategory= 10 ORDER BY Id DESC))
				  ELSE '' END)-(ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsPresent=1 GROUP BY EmpId),0)) - ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsLeave=1 GROUP BY EmpId),0))<0 THEN '0' 
				  ELSE ((CASE WHEN B.CategoryID =1 THEN (SELECT COUNT(*)  FROM Att_EmpAcademicCalendarDetails WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE) AND CalendarId = (SELECT TOP(1) Id FROM Att_EmpAcademicCalendar WHERE EmpCategory= 1 ORDER BY Id DESC))
			      WHEN B.CategoryID =2 THEN (SELECT COUNT(*)  FROM Att_EmpAcademicCalendarDetails WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE) AND CalendarId = (SELECT TOP(1) Id FROM Att_EmpAcademicCalendar WHERE EmpCategory= 2 ORDER BY Id DESC))
			      WHEN B.CategoryID =3 THEN (SELECT COUNT(*)  FROM Att_EmpAcademicCalendarDetails WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE) AND CalendarId = (SELECT TOP(1) Id FROM Att_EmpAcademicCalendar WHERE EmpCategory= 3 ORDER BY Id DESC))
				  WHEN B.CategoryID =4 THEN (SELECT COUNT(*)  FROM Att_EmpAcademicCalendarDetails WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE) AND CalendarId = (SELECT TOP(1) Id FROM Att_EmpAcademicCalendar WHERE EmpCategory= 4 ORDER BY Id DESC))
				  WHEN B.CategoryID =5 THEN (SELECT COUNT(*)  FROM Att_EmpAcademicCalendarDetails WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE) AND CalendarId = (SELECT TOP(1) Id FROM Att_EmpAcademicCalendar WHERE EmpCategory= 5 ORDER BY Id DESC))
				  WHEN B.CategoryID =10 THEN (SELECT COUNT(*)  FROM Att_EmpAcademicCalendarDetails WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE) AND CalendarId = (SELECT TOP(1) Id FROM Att_EmpAcademicCalendar WHERE EmpCategory= 10 ORDER BY Id DESC))
				  ELSE '' END)-(ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsPresent=1 GROUP BY EmpId),0)) - ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsLeave=1 GROUP BY EmpId),0)) END) AS [AbsentDay],
			ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsLate=1 GROUP BY EmpId),0) AS [LateDay],
			ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsEarlyOut=1 GROUP BY EmpId),0) AS [EarlyOutDay],
			ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsWithPay=1 GROUP BY EmpId),0) AS [WithPayDay],
			ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsWithOutPay=1 GROUP BY EmpId),0) AS [WithOutPayDay],
			ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsHalfDay=1 GROUP BY EmpId),0) AS [HalfDay],
			ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsAbsetLongHoliday=1 GROUP BY EmpId),0) AS [AbsentLongHoliyDay],
			
			CAST(ISNULL((100*ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsPresent=1 GROUP BY EmpId),0)/		NULLIF((CASE WHEN B.CategoryID =1 THEN (SELECT COUNT(*)  FROM Att_EmpAcademicCalendarDetails WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE) AND CalendarId = (SELECT TOP(1) Id FROM Att_EmpAcademicCalendar WHERE EmpCategory= 1 ORDER BY Id DESC))
			      WHEN B.CategoryID =2 THEN (SELECT COUNT(*)  FROM Att_EmpAcademicCalendarDetails WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE) AND CalendarId = (SELECT TOP(1) Id FROM Att_EmpAcademicCalendar WHERE EmpCategory= 2 ORDER BY Id DESC))
			      WHEN B.CategoryID =3 THEN (SELECT COUNT(*)  FROM Att_EmpAcademicCalendarDetails WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE) AND CalendarId = (SELECT TOP(1) Id FROM Att_EmpAcademicCalendar WHERE EmpCategory= 3 ORDER BY Id DESC))
				  WHEN B.CategoryID =4 THEN (SELECT COUNT(*)  FROM Att_EmpAcademicCalendarDetails WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE) AND CalendarId = (SELECT TOP(1) Id FROM Att_EmpAcademicCalendar WHERE EmpCategory= 4 ORDER BY Id DESC))
				  WHEN B.CategoryID =5 THEN (SELECT COUNT(*)  FROM Att_EmpAcademicCalendarDetails WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE) AND CalendarId = (SELECT TOP(1) Id FROM Att_EmpAcademicCalendar WHERE EmpCategory= 5 ORDER BY Id DESC))
				  WHEN B.CategoryID =10 THEN (SELECT COUNT(*)  FROM Att_EmpAcademicCalendarDetails WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE) AND CalendarId = (SELECT TOP(1) Id FROM Att_EmpAcademicCalendar WHERE EmpCategory= 10 ORDER BY Id DESC))
				  ELSE '' END),0)),0)AS DECIMAL) AS [Percentage],
			Convert(nvarchar(15), cast(@FromDate as Date),106) FromDate,
	        Convert(nvarchar(15), cast(@ToDate as Date),106) ToDate
			FROM Emp_BasicInfo AS B 
			INNER JOIN Emp_Attendance EA ON  B.EmpBasicInfoID = EA.EmpId AND B.BranchID = @BranchId
	        INNER JOIN dbo.Ins_Branch Br ON Br.BranchId = B.BranchID
	        WHERE (CAST(EA.InTime as date)) BETWEEN  (CAST(@FromDate AS date)) AND (CAST(@ToDate AS date)) 
			AND B.BranchID = @BranchId
			ORDER BY B.FullName

	 DROP TABLE #Att_Attendance1

END
