
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmpCalendarListByCategory]'))
BEGIN
DROP PROCEDURE  [GetEmpCalendarListByCategory]
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
CREATE PROCEDURE [dbo].[GetEmpCalendarListByCategory] 

@EmpCategory INT

AS
BEGIN
 

	SELECT EAC.*
	,EC.CategoryName 
	FROM Att_EmpAcademicCalendar EAC
	INNER JOIN Emp_Category EC ON EC.CategoryID = EAC.EmpCategory
	WHERE EAC.EmpCategory = @EmpCategory AND  EAC.IsDeleted = 0 AND EAC.[Status] = 'A'

END