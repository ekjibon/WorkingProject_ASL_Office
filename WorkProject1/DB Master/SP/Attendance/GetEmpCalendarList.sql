/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmpCalendarList]'))
BEGIN
DROP PROCEDURE  [GetEmpCalendarList]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		KHALED
-- Create date: 
-- Description:	
-- ============================================
CREATE PROCEDURE [dbo].[GetEmpCalendarList] 


AS
BEGIN
 

	SELECT EAC.Id, EAC.Title, EAC.StartDate, EAC.EndDate, EAC.EmpBranchId,EAC.WeekendDay, CAST(EAC.InTime AS DATETIME) InTime, CAST(EAC.OutTime AS DATETIME) OutTime, EAC.DefaultLITime, EAC.DefaultEOTime
	,EC.CategoryName 
	FROM Att_EmpAcademicCalendar EAC
	LEFT JOIN Emp_Category EC ON EC.CategoryID = EAC.EmpCategory
	WHERE EAC.IsDeleted = 0 AND EAC.[Status] = 'A'

END

-- EXEC [dbo].[GetEmpCalendarList] 
-- SELECT * FROM Att_EmpAcademicCalendar


