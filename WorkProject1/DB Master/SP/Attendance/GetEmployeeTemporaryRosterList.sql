/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmployeeTemporaryRosterList]'))
BEGIN
DROP PROCEDURE  [GetEmployeeTemporaryRosterList]
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
-- execute [dbo].[GetEmployeeTemporaryRosterList] 8,4,2,'2019-08-01 00:00:00.000','2019-11-01 00:00:00.000'
CREATE PROCEDURE [dbo].[GetEmployeeTemporaryRosterList]
	
	@BranchId INT,
	@EmpID INT,
	@EmpCategory INT--,
	--@CalendarId INT,
	--@FromDate VARCHAR(MAX), 
	--@ToDate VARCHAR(MAX)


AS

 
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
		--,EACD.Year,EACD.Month
		,CAST(ER.InTime AS DATETIME) AS RegularInTime
		,CAST(ER.OutTime AS DATETIME) AS RegularOutTime
		,CAST(ER.TempInTime AS DATETIME) AS InTime
		,CAST(ER.TempOutTime AS DATETIME) AS OutTime
		,EAC.EndDate 
	FROM dbo.Att_EmpRoster ER 
	INNER JOIN  [dbo].[Emp_BasicInfo] EB ON  ER.EmpId = EB.EmpBasicInfoID
	INNER JOIN [dbo].[Emp_Category] EC ON EC.CategoryID = EB.CategoryID
	INNER JOIN [dbo].[Ins_Branch] B ON B.BranchId = EB.BranchID
	INNER JOIN [dbo].[Att_EmpAcademicCalendar] EAC ON EAC.EmpCategory = EB.CategoryID
	--INNER JOIN  [dbo].[Att_EmpAcademicCalendarDetails] EACD ON EACD.CalendarId = EAC.Id

	WHERE ER.EmpId = @EmpID AND ER.EmpCategory=@EmpCategory --AND ER.CalendarDate BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE)
	          --AND EAC.Id = @CalendarId
			  --AND EACD.Year = @Year
			 -- AND EACD.Month = @MonthId
			--  AND EACD.DayType = 'Regular' 
			  AND ER.IsTempApproved = 0 --AND IsTemporary = 1
		
		  
 END






