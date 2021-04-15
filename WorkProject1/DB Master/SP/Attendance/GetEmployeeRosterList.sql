/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmployeeRosterList]'))
BEGIN
DROP PROCEDURE  [GetEmployeeRosterList]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		ARIFUR
-- Create date: 
-- Description:	
-- =============================================
-- execute [dbo].[GetEmployeeRosterList] 1,8,1003,'2019-09-01 00:00:00.000','2019-11-01 00:00:00.000'
CREATE PROCEDURE [dbo].[GetEmployeeRosterList]
	@Block INT, 
	@BranchId INT,
	@CategoryId INT,
	@CalendarId INT,
	@Year INT, 
	@MonthId INT


AS
BEGIN
 IF(@Block=1)  -- execute [dbo].[GetEmployeeRosterList] 1,8,2,8,2020,9
 BEGIN
 SELECT DISTINCT EB.EmpBasicInfoID
		,EB.FullName
		,EAC.EmpCategory
		,EC.CategoryName
		,B.BranchId
		,B.BranchName
		,EAC.StartDate
		,EAC.Id AS CalendarId
		--,EACD.Year
		--,EACD.Month
		,EAC.EndDate 
	FROM [dbo].[Emp_BasicInfo] EB
	INNER JOIN [dbo].[Emp_Category] EC ON EC.CategoryID = EB.CategoryID
	INNER JOIN [dbo].[Ins_Branch] B ON B.BranchId = EB.BranchID
	INNER JOIN [dbo].[Att_EmpAcademicCalendar] EAC ON EAC.EmpCategory = EB.CategoryID
	INNER JOIN  [dbo].[Att_EmpAcademicCalendarDetails] EACD ON EACD.CalendarId = EAC.Id
	WHERE EB.CategoryID = @CategoryId AND EB.BranchID = @BranchId AND EB.Status='A'
				AND EAC.Id = @CalendarId
			 -- AND EACD.Year = @Year AND EACD.Month = @MonthId
				AND EACD.DayType = 'Regular'
	GROUP BY EB.FullName,EAC.EmpCategory,EC.CategoryName,B.BranchId,B.BranchName,EAC.StartDate,EAC.EndDate,EB.EmpBasicInfoID,EAC.Id--,EACD.Year--,EACD.Month
	
 END
  IF(@Block=2) -- Single Employee Temporary Setup   execute [dbo].[GetEmployeeRosterList] 2,8,16,2,2020,2
 BEGIN
  SELECT  EB.EmpBasicInfoID
		,EB.FullName
		,ER.CalendarDate
		,EAC.EmpCategory
		,EC.CategoryName
		,B.BranchId
		,B.BranchName
		,EAC.StartDate
		,ER.Id AS RosterId
		,EAC.Id AS CalendarId
		,EACD.Year,EACD.Month
		,CAST(ER.InTime AS DATETIME) AS RegularInTime
		,CAST(ER.OutTime AS DATETIME) AS RegularOutTime
		,EAC.EndDate 
	FROM dbo.Att_EmpRoster ER 
	INNER JOIN  [dbo].[Emp_BasicInfo] EB ON  ER.EmpId = EB.EmpBasicInfoID
	INNER JOIN [dbo].[Emp_Category] EC ON EC.CategoryID = EB.CategoryID
	INNER JOIN [dbo].[Ins_Branch] B ON B.BranchId = EB.BranchID
	INNER JOIN [dbo].[Att_EmpAcademicCalendar] EAC ON EAC.EmpCategory = EB.CategoryID
		INNER JOIN  [dbo].[Att_EmpAcademicCalendarDetails] EACD ON EACD.CalendarId = EAC.Id

	WHERE ER.EmpId = @CategoryId  AND EAC.Id = @CalendarId
			  AND EACD.Year = @Year
			  AND EACD.Month = @MonthId
			  AND EACD.DayType = 'Regular' AND ER.IsTempApproved = 0 --AND IsTemporary = 1
		  
 END
   IF(@Block=3)  --execute[dbo].[GetEmployeeRosterList] 3,10,10,10,0,0
  BEGIN
  
 SELECT DISTINCT EB.EmpBasicInfoID
		,EB.FullName
		,EAC.EmpCategory
		,EC.CategoryName
		,B.BranchId
		,B.BranchName
		,EAC.StartDate
		,EAC.Id AS CalendarId
		,CASE 
		 WHEN AE.IsApproved = 1 THEN 'Approved'
         ELSE 'Pending'END AS ApproveStatus
		 ,CASE 
		 WHEN AE.IsRejected = 1 THEN 'Rejected'
         ELSE 'Pending'END AS RejecteStatus
		--,EACD.Year
		--,EACD.Month
		,(SELECT TOP 1  CAST(InTime AS DATETIME) FROM dbo.Att_EmpRoster WHERE EmpId = EB.EmpBasicInfoID AND IsTemporary = 0 AND CalendarId = @CalendarId) AS InTime
		,(SELECT TOP 1  CAST(OutTime AS DATETIME) FROM dbo.Att_EmpRoster WHERE EmpId = EB.EmpBasicInfoID AND IsTemporary = 0 AND CalendarId = @CalendarId) AS OutTime
		,EAC.EndDate 
	FROM [dbo].[Emp_BasicInfo] EB
	INNER JOIN [dbo].[Emp_Category] EC ON EC.CategoryID = EB.CategoryID
	LEFT JOIN [dbo].[Att_EmpRoster] AE ON AE.EmpId=EB.EmpBasicInfoID AND AE.CalendarId=@CalendarId
	INNER JOIN [dbo].[Ins_Branch] B ON B.BranchId = EB.BranchID
	INNER JOIN [dbo].[Att_EmpAcademicCalendar] EAC ON EAC.EmpCategory = EB.CategoryID
	INNER JOIN  [dbo].[Att_EmpAcademicCalendarDetails] EACD ON EACD.CalendarId = EAC.Id
	WHERE EB.CategoryID = @CategoryId AND EB.BranchID = @BranchId AND EB.Status='A'
				AND EAC.Id = @CalendarId
			  --AND EACD.Year = @Year
			  --AND EACD.Month = @MonthId
			  AND EACD.DayType = 'Regular'
			  --AND AE.InTime IS NOT NULL;
	GROUP BY EB.FullName,EAC.EmpCategory,EC.CategoryName,B.BranchId,B.BranchName,EAC.StartDate,EAC.EndDate,EB.EmpBasicInfoID,EAC.Id,AE.IsApproved,AE.IsRejected 
	
			   		--GROUP BY ER.EmpId,ER.InTime,EB.FullName,ER.OutTime,EA.StartDate,EA.EndDate ,ER.Remarks,ER.Id
  END

    IF(@Block=4) -- Single Employee Temporary Setup   execute [dbo].[GetEmployeeRosterList] 4,0,19,54,2019,9
 BEGIN
  SELECT DISTINCT EB.EmpBasicInfoID
		,EB.FullName
		,ER.CalendarDate
		 ,ER.IsTempApproved
		,EAC.EmpCategory
		,EC.CategoryName
		,B.BranchId
		,B.BranchName
		,EAC.StartDate
		,ER.Id AS RosterId
		,EAC.Id AS CalendarId
		,EACD.Year,EACD.Month
		,CAST(ER.InTime AS DATETIME) AS RegularInTime
		,CAST(ER.OutTime AS DATETIME) AS RegularOutTime
		,CAST(ER.TempInTime AS DATETIME) AS TempInTime
		,CAST(ER.TempOutTime AS DATETIME) AS TempOutTime
		,EAC.EndDate 
	FROM dbo.Att_EmpRoster ER 
	INNER JOIN  [dbo].[Emp_BasicInfo] EB ON  ER.EmpId = EB.EmpBasicInfoID
	INNER JOIN [dbo].[Emp_Category] EC ON EC.CategoryID = EB.CategoryID
	INNER JOIN [dbo].[Ins_Branch] B ON B.BranchId = EB.BranchID
	INNER JOIN [dbo].[Att_EmpAcademicCalendar] EAC ON EAC.EmpCategory = EB.CategoryID
		INNER JOIN  [dbo].[Att_EmpAcademicCalendarDetails] EACD ON EACD.CalendarId = EAC.Id

	WHERE ER.EmpId = @CategoryId AND ER.IsTemporary = 1 AND EAC.Id = @CalendarId AND ER.IsTempApproved =0
			 -- AND EACD.Year = @Year
			 -- AND EACD.Month = @MonthId
			  --AND EACD.DayType = 'Regular'
		  
 END
 IF(@Block=5) -- Roster Setup Report   execute [dbo].[GetEmployeeRosterList] 5,10,10,10,null,Null
 
 BEGIN
  SELECT DISTINCT EB.EmpBasicInfoID
		,EB.FullName
		,ER.CalendarDate
		,ER.IsTempApproved
		,EAC.EmpCategory
		,EC.CategoryName
		,B.BranchId
		,B.BranchName
		,EAC.StartDate
		,ER.Id AS RosterId
		,EAC.Id AS CalendarId
		--,EACD.Year,EACD.Month
		,CAST(ER.InTime AS DATETIME) AS RegularInTime
		,CAST(ER.OutTime AS DATETIME) AS RegularOutTime
		,CAST(ER.TempInTime AS DATETIME) AS TempInTime
		,CAST(ER.TempOutTime AS DATETIME) AS TempOutTime
		,EAC.EndDate 
		,ER.IsApproved
		,EB.EmpID,EAC.Title
	FROM dbo.Att_EmpRoster ER 
	INNER JOIN  [dbo].[Emp_BasicInfo] EB ON  ER.EmpId = EB.EmpBasicInfoID
	INNER JOIN [dbo].[Emp_Category] EC ON EC.CategoryID = EB.CategoryID
	INNER JOIN [dbo].[Ins_Branch] B ON B.BranchId = EB.BranchID
	INNER JOIN [dbo].[Att_EmpAcademicCalendar] EAC ON EAC.EmpCategory = EB.CategoryID AND ER.CalendarId=EAC.Id
    --INNER JOIN  [dbo].[Att_EmpAcademicCalendarDetails] EACD ON EACD.CalendarId = EAC.Id
    WHERE EB.CategoryID = @CategoryId AND EB.BranchID = @BranchId 
				AND EAC.Id = @CalendarId AND EB.Status='A'
				--AND YEAR(ER.CalendarDate)=@Year
			  --AND EACD.Year = @Year
			  --AND EACD.Month = @MonthId
			  --AND EACD.DayType = 'Regular' 
			  AND ER.DayType = 'Regular' 
			  AND ER.IsApproved=1
	

		  
 END

END



