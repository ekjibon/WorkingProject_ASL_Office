   
/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetEmployeeTemRosterList]'))
BEGIN
DROP PROCEDURE  [rptGetEmployeeTemRosterList]
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

CREATE PROCEDURE [dbo].[rptGetEmployeeTemRosterList]

	@EmpId INT


AS
BEGIN

  SELECT DISTINCT EB.EmpBasicInfoID
        ,EB.EmpID 
		,ED.DesignationName
		,EB.FullName
		,ER.CalendarDate
		,ER.IsTempApproved		
		,EC.CategoryName
		,B.BranchId
		,B.BranchName	
		,ER.Id AS RosterId
		,ER.[Day]
		,CAST(ER.TempInTime AS DATETIME) AS TempInTime
		,CAST(ER.TempOutTime AS DATETIME) AS TempOutTime
	    ,CASE ER.IsTempApproved
		 WHEN 1 THEN 'Approved'
         ELSE 'Pending'END AS TemApproveStatus
		,CASE ER.IsTempRejected
		 WHEN 1 THEN 'Rejected'
         ELSE 'Pending'END AS TemRejecteStatus
 
	FROM dbo.Att_EmpRoster ER 
	INNER JOIN  [dbo].[Emp_BasicInfo] EB ON  ER.EmpId = EB.EmpBasicInfoID
	INNER JOIN [dbo].[Emp_Category] EC ON EC.CategoryID = EB.CategoryID
	INNER JOIN [dbo].[Ins_Branch] B ON B.BranchId = EB.BranchID
	INNER JOIN [dbo].[Emp_Designation] ED ON ED.DesignationID = EB.DesignationID


	WHERE ER.EmpId = @EmpId AND ER.IsTemporary = 1  AND ER.IsTempApproved=0
END