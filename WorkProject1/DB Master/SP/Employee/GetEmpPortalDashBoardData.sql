
/****** Object:  StoredProcedure [dbo].[GetPortalDashBoardData]    Script Date: 1/22/2019 11:49:53 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmpPortalDashBoardData]'))
BEGIN
DROP PROCEDURE  GetEmpPortalDashBoardData
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Comments --
-- EXEC GetEmpPortalDashBoardData 15


CREATE PROCEDURE [dbo].[GetEmpPortalDashBoardData] 
	@EmpId INT
AS
BEGIN
Declare @WorkingDay INT=0, @PresentDay int=0,@HolliDay INT=0, @AbsentDay int =0 ,@TotalDue DECIMAL = 0 , @FeesMonth VARCHAR(50)
SELECT @WorkingDay = COUNT(InTime) FROM dbo.Emp_Attendance where DayType='Regular' AND YEAR(InTime) = YEAR(GETDATE()) AND Month(InTime) = MONTH(GETDATE()) AND  EmpId = @EmpId 
PRINT @WorkingDay

  SELECT
	  Emp_BasicInfo.EmpBasicInfoID, FullName, Year(Emp_Attendance.InTime) AS [Year], Month(Emp_Attendance.InTime) AS [Month], Day(InTime) AS [Day], Emp_Attendance.InTime AS [CalendarDate], [DayType], 
	  (SELECT TOP(1) HolidayName  FROM Att_EmpAcademicCalendarDetails WHERE Id = Emp_Attendance.CalanderDetailsId) AS [HolidayName],
	  [dbo].[fnGetEmpDayStatus](InTime,Emp_BasicInfo.EmpBasicInfoID) AS DayStaus, 
	  dbo.FuncGetEmpDayLIEOStatus(InTime,Emp_BasicInfo.EmpBasicInfoID,'LI') AS LI, 	 
	  dbo.FuncGetEmpDayLIEOStatus(InTime,Emp_BasicInfo.EmpBasicInfoID,'EO') AS EO
	 INTO #ATTENDANCE  FROM [dbo].Emp_Attendance, [dbo].[Emp_BasicInfo] 
	  WHERE Year(InTime) = YEAR(GETDATE()) AND Month(InTime) = MONTH(GETDATE()) AND [dbo].Emp_Attendance.IsDeleted=0 AND  [dbo].Emp_Attendance.EmpId=@EmpId AND  
	   [dbo].[Emp_BasicInfo].IsDeleted=0 AND [Emp_BasicInfo].EmpBasicInfoID =  @EmpId 

	   select * from #ATTENDANCE

SELECT @PresentDay = COUNT(EmpBasicInfoID) FROM #ATTENDANCE WHERE DayStaus = 'P' 
SELECT @AbsentDay  = COUNT(EmpBasicInfoID)  FROM #ATTENDANCE WHERE DayStaus = 'A' 
SELECT @HolliDay  = COUNT(EmpBasicInfoID)  FROM #ATTENDANCE WHERE DayStaus = 'W'  or DayStaus = 'H' 

	--PRINT CAST(@PresentDay as decimal(10,2))
	--PRINT CAST(@WorkingDay as decimal(10,2))
	--PRINT 'Divided '+ CAST((CAST(@PresentDay as decimal(10,2))/CAST(@WorkingDay as decimal(10,2))) AS VARCHAR(MAX))

SELECT @EmpId AS EmpId, @PresentDay AS TotalPresent,@HolliDay as HolliDay,
	@AbsentDay AS TotalAbsent,

	CASE WHEN @PresentDay=0 THEN 0 ELSE (CAST((CAST(@PresentDay as decimal(10,2))/CAST(@WorkingDay as decimal(10,2))) * 100 as decimal(10,2))) END AS	 PeresentPercent,
	CASE WHEN @AbsentDay = 0 THEN 0 ELSE (CAST((CAST(@AbsentDay as decimal(10,2))/CAST(@WorkingDay as decimal(10,2))) * 100 as decimal(10,2))) END AS    AbsentPercent,
	@WorkingDay AS WorkingDay
	
SELECT top 5 SMSBody,SendDateTime FROM SMS_SMSSendHistroy WHERE EmpId = @EmpId ORDER BY SendDateTime DESC


	SELECT [CalendarDate], [DayType], [HolidayName],DayStaus , 
	CASE  
	WHEN DayStaus = 'A' THEN 'absent'
	WHEN DayStaus = 'P' THEN 'present'
	WHEN DayStaus = 'W' THEN 'weekend'
	WHEN DayStaus = 'L' THEN 'leave'
	WHEN DayStaus = 'H' THEN 'holiday'
	 END AS ClassName  , LI, EO  FROM #ATTENDANCE ORDER BY CalendarDate

	SELECT top(5) D.DocumentId, D.FileName,D.TypeId,D.AddDate,D.Title,D.[File]
	 FROM Portal_Document D 
	 WHERE  D.TypeId=4 and D.IsDeleted=0 and D.DocType=2
	 ORDER BY DocumentId DESC


	  Select  top(30) sa.AttendId,sa.EmpId,sa.InTime,sa.OutTime,sa.IsPresent,sa.IsLeave from dbo.Emp_Attendance sa Where EmpId = @EmpId  AND MONTH(sa.InTime) =  MONTH(GETDATE())
	  AND YEAR(sa.InTime) =  YEAR(GETDATE()) AND sa.AttStatusType = 'A'
	  order by AttendId DESC 
	DROP TABLE #ATTENDANCE

END


