/****** Object:  StoredProcedure [dbo].[GetCommonItemForTask]    Script Date: 07/01/2021 6:37:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetCommonItemForTask]'))
BEGIN
DROP PROCEDURE  GetCommonItemForTask
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCommonItemForTask] 

AS
BEGIN  --Exec GetCommonItemForTask
--IssueType-0
SELECT * From [dbo].[Task_IssueType] where IsDeleted=0 
--Project-1
SELECT * FROM [dbo].[Task_Project] where IsDeleted=0 
--Sprint-2
SELECT * FROM [dbo].[Task_Sprint] where IsDeleted=0
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
		WHERE  EB.IsDeleted = 0  AND EB.Status = 'A'
		ORDER BY ED.DisOrder ASC
END
