/****** Object:  StoredProcedure [dbo].[SPM_GetCommonItemForTask]    Script Date: 07/01/2021 6:37:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SPM_GetCommonItemForTask]'))
BEGIN
DROP PROCEDURE  SPM_GetCommonItemForTask
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SPM_GetCommonItemForTask] 
@EmpId INT
AS
BEGIN  --Exec SPM_GetCommonItemForTask 51
	DECLARE @DepartmentId INT
--
	SELECT @DepartmentId= EB.DepartmentID --EB.EmpBasicInfoID,EB.EmpID,EB.FullName,EB.DepartmentID,EB.MobileNo,EB.ShortName,EB.Email,EB.DisOrder, EB.DesignationID ,ED.DepartmentName,D.DesignationName
		FROM
			Emp_BasicInfo EB 	
		WHERE  EB.IsDeleted = 0  AND EB.Status = 'A' AND EmpBasicInfoID = @EmpId
--IssueType-0
SELECT * From [dbo].[Task_IssueType] where IsDeleted=0 
--Project-1
SELECT * FROM [dbo].[Task_Project] where IsDeleted=0 AND DepartmentId = @DepartmentId
--Sprint-2
SELECT * FROM [dbo].[Task_Sprint] where IsDeleted=0 AND ProjectId IN (SELECT Id FROM [dbo].[Task_Project] where IsDeleted=0 AND DepartmentId = @DepartmentId)
--Status-3
SELECT * FROM [dbo].[Task_Status]  WHERE IsDeleted=0
--Client-4
SELECT * FROM [dbo].[CRM_Client] where IsDeleted=0
--Assignee-5
SELECT EB.EmpBasicInfoID,EB.EmpID,EB.FullName,EB.DepartmentID,EB.MobileNo,EB.ShortName,EB.Email,EB.DisOrder  ,ED.DepartmentName,D.DesignationName
		FROM
			Emp_BasicInfo EB 	
			LEFT JOIN Emp_Department ED ON ED.DepartmentID = EB.DepartmentID	
			LEFT JOIN Emp_Designation D ON D.DesignationID = EB.DesignationID	
		WHERE  EB.IsDeleted = 0  AND EB.Status = 'A' AND EB.DepartmentID = @DepartmentId
		ORDER BY ED.DisOrder ASC
END
