/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetEmployeeRegularRosterList]'))
BEGIN
DROP PROCEDURE  [rptGetEmployeeRegularRosterList]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Khaled
-- Create date: 
-- Description:	
-- =============================================

CREATE PROCEDURE [dbo].[rptGetEmployeeRegularRosterList]
--	@Block INT, 
	@BranchId INT,
	--@CategoryId INT,
	@CalendarId INT
--	@Year INT, 
--	@MonthId INT


AS


     --[dbo].[rptGetEmployeeRegularRosterList] 10,6
  BEGIN
  
 SELECT DISTINCT EB.EmpBasicInfoID
        ,EB.EmpID
		,ED.DesignationName
		,EB.FullName
		,EAC.EmpCategory
		,EC.CategoryName
		,B.BranchId
		,B.BranchName
		,EAC.StartDate
		,EAC.Id AS CalendarId
		--,EACD.Year
		--,EACD.Month
		,(SELECT TOP 1  CAST(InTime AS DATETIME) FROM dbo.Att_EmpRoster WHERE EmpId = EB.EmpBasicInfoID AND IsTemporary = 0 AND CalendarId = @CalendarId AND IsApproved=0) AS InTime
		,(SELECT TOP 1  CAST(OutTime AS DATETIME) FROM dbo.Att_EmpRoster WHERE EmpId = EB.EmpBasicInfoID AND IsTemporary = 0 AND CalendarId = @CalendarId AND IsApproved=0) AS OutTime
		,EAC.EndDate 
	FROM [dbo].[Emp_BasicInfo] EB
	INNER JOIN [dbo].[Emp_Category] EC ON EC.CategoryID = EB.CategoryID
	INNER JOIN [dbo].[Ins_Branch] B ON B.BranchId = EB.BranchID
	INNER JOIN [dbo].[Att_EmpAcademicCalendar] EAC ON EAC.EmpCategory = EB.CategoryID
	INNER JOIN [dbo].[Emp_Designation] ED ON ED.DesignationID = EB.DesignationID
	INNER JOIN  [dbo].[Att_EmpAcademicCalendarDetails] EACD ON EACD.CalendarId = EAC.Id
	WHERE --EB.CategoryID = @CategoryId AND 
	EB.BranchID = @BranchId AND EB.Status='A'
				AND EAC.Id = @CalendarId
			  --AND EACD.Year = @Year
			  --AND EACD.Month = @MonthId
			  AND EACD.DayType = 'Regular'
	GROUP BY EB.EmpID,EB.FullName,ED.DesignationName,EAC.EmpCategory,EC.CategoryName,B.BranchId,B.BranchName,EAC.StartDate,EAC.EndDate,EB.EmpBasicInfoID,EAC.Id--,EACD.Year--,EACD.Month
			   		--GROUP BY ER.EmpId,ER.InTime,EB.FullName,ER.OutTime,EA.StartDate,EA.EndDate ,ER.Remarks,ER.Id
  



END



