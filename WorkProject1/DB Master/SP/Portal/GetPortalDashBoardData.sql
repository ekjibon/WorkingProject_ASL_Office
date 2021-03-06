
/****** Object:  StoredProcedure [dbo].[GetPortalDashBoardData]    Script Date: 1/22/2019 11:49:53 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetPortalDashBoardData]'))
BEGIN
DROP PROCEDURE  GetPortalDashBoardData
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Comments --
-- EXEC GetPortalDashBoardData 4838

CREATE PROCEDURE [dbo].[GetPortalDashBoardData] 
	@SId INT
AS
BEGIN
Declare @WorkingDay INT=0, @PresentDay int=0,@HolliDay INT=0, @AbsentDay int =0 ,@TotalDue DECIMAL = 0 , @FeesMonth VARCHAR(50),@FeesYear INT=0


SELECT @WorkingDay = COUNT(*) FROM Att_AcademicCalendar where DayType='Regular'

  SELECT
	  StudentIID, StudentInsID, RollNo, FullName, [Year], [Month], [Day], [CalendarDate], [DayType], [HolidayName],
	  [dbo].[fnGetDayStatus](CalendarDate,[dbo].[Student_BasicInfo].StudentIID) AS DayStaus  ,
	  dbo.FuncGetDayLIEOStatus(CalendarDate,[dbo].[Student_BasicInfo].StudentIID,'LI') AS LI, 	 
	  dbo.FuncGetDayLIEOStatus(CalendarDate,[dbo].[Student_BasicInfo].StudentIID,'EO') AS EO
	 INTO #ATTENDANCE  FROM [dbo].[Att_AcademicCalendar], [dbo].[Student_BasicInfo] 
	  WHERE 
	  --[Year] = YEAR(GETDATE())  AND 
	  [dbo].[Att_AcademicCalendar].IsDeleted=0 AND  
	   [dbo].[Student_BasicInfo].IsDeleted=0 AND [Student_BasicInfo].StudentIID =  @SId

	  --Select * from #ATTENDANCE RETURN

	    

SELECT @PresentDay = COUNT(StudentIID) FROM #ATTENDANCE WHERE DayStaus = 'P' 
SELECT @AbsentDay  = COUNT(StudentIID)  FROM #ATTENDANCE WHERE DayStaus = 'A' 
SELECT @HolliDay  = COUNT(StudentIID)  FROM #ATTENDANCE WHERE DayStaus = 'W' or DayStaus = 'H' 


SELECT  @TotalDue = ISNULL( sum(fs.DueAmount),0)  ,@FeesMonth =
	ISNULL(((SELECT MonthName FROM Fees_FeesMonth WHERE FeesMonthId = MIN(fs.MonthId))   + '-' + 
	(SELECT MonthName FROM Fees_FeesMonth WHERE FeesMonthId = MAX(fs.MonthId))   ) ,'')	,
	@FeesYear = ISNULL((SELECT Year FROM Fees_FeesSessionYear WHERE FeesSessionYearId =(fs.FeesSessionYearId)),0)
	 from dbo.Fees_Student as fs	 
	 WHERE StudentIID = @SId --AND [Year] = YEAR(GETDATE())
	 group by fs.StudentIID , fs.FeesSessionYearId
	 print '@PresentDay'  
	 print @PresentDay
	  print '@@WorkingDay'  
	 print @WorkingDay
SELECT @SId AS StudentIID, @TotalDue AS TotalDue ,@FeesMonth AS FeesMonth, @PresentDay AS TotalPresent,@HolliDay as HolliDay,@FeesYear AS FeesYear,
	@AbsentDay AS TotalAbsent, (case when @PresentDay <>0 or @WorkingDay <>0  then
	CAST((CAST(ISNULL(@PresentDay,0) as decimal(10,2))/CAST(ISNULL(@WorkingDay,0) as decimal(10,2))) * 100 as decimal(10,2))else 00 end)
	PeresentPercent,(case when @AbsentDay <>0 or @WorkingDay <>0  then
	CAST((CAST(ISNULL(@AbsentDay,0) as decimal(10,2))/CAST(ISNULL(@WorkingDay,0) as decimal(10,2))) * 100 as decimal(10,2))else 00 end) AbsentPercent,
	@WorkingDay AS WorkingDay
	


	
	--SELECT COUNT(*) as Present , MONTH(ata.InTime) AS [MonthName]
	--FROM dbo.Att_StudentAttendance ata INNER JOIN dbo.Student_BasicInfo SB ON sb.StudentIID = ata.StudentId
	--where sb.StudentIID = @SId and MONTH(ata.InTime) = MONTH(GETDATE()) and YEAR(ata.InTime)= Year(GETDATE()) and ata.IsPresent = 1
	--GROUP BY MONTH(ata.InTime)

	SELECT top 5 SMSBody,SendDateTime FROM SMS_SMSSendHistroy WHERE StudentIId = @SId ORDER BY SendDateTime DESC

	SELECT [CalendarDate], [DayType], [HolidayName],DayStaus , 
	CASE  
	WHEN DayStaus = 'A' THEN 'absent'
	WHEN DayStaus = 'P' THEN 'present'
	WHEN DayStaus = 'W' THEN 'weekend'
	WHEN DayStaus = 'L' THEN 'leave'
	WHEN DayStaus = 'H' THEN 'holiday'
	 END AS ClassName  , LI, EO  FROM #ATTENDANCE ORDER BY CalendarDate

	 SELECT top(5) D.DocumentId, D.FileName,D.TypeId,D.AddDate,D.Title,D.[File]
	 FROM Portal_Document D INNER JOIN Student_BasicInfo S ON D.ClassId=S.ClassId and D.BranchId=S.BranchID and
	 D.SessionId=S.SessionId
	 WHERE S.StudentIID=@SId and D.TypeId=4 and D.IsDeleted=0 and D.DocType=1
	 ORDER BY DocumentId DESC

	 Select  top(10) sa.AttendId,sa.StudentId,sa.InTime,sa.OutTime,sa.IsPresent,sa.IsLeave from dbo.Att_StudentAttendance sa Where StudentId = @SId order by AttendId desc 
	DROP TABLE #ATTENDANCE
	--portal dashbard result part
	SELECT '2018-2019' PreviousYear, 'PG' ClassName,'Promoted' StdStatus,'ECA award' Award
END
