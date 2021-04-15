/****** Object:  StoredProcedure [dbo].[SP_GetEmpAllInfo]    Script Date: 11/18/2017 6:37:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmpDepartment]'))
BEGIN
DROP PROCEDURE  GetEmpDepartment
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEmpDepartment]   --GetEmpDepartment NULL

@UserId VARCHAR(MAX) = NULL

AS
BEGIN
	DECLARE @DepartmentId INT =0 
	SELECT @DepartmentId = EB.DepartmentID FROM Emp_BasicInfo EB  INNER JOIN
					AspNetUsers U ON U.EmpId = EB.EmpBasicInfoID AND U.Id = @UserId
	IF(@DepartmentId>0)
	BEGIN
	PRINT('Dept :')
	SELECT EB.EmpBasicInfoID,EB.EmpID,EB.FullName,EB.DepartmentID ,ED.DepartmentName
		FROM	Emp_BasicInfo EB 	
		LEFT JOIN Emp_Department ED ON ED.DepartmentID = EB.DepartmentID			
		WHERE EB.DepartmentID = @DepartmentId AND EB.IsDeleted = 0 AND EB.Status = 'A'
		ORDER BY EB.DisOrder ASC
	END
	ELSE
	BEGIN
		SELECT EB.EmpBasicInfoID,EB.EmpID,EB.FullName,EB.DepartmentID,EB.MobileNo,EB.ShortName,EB.Email,EB.DisOrder  ,ED.DepartmentName,D.DesignationName
		FROM
			Emp_BasicInfo EB 	
			LEFT JOIN Emp_Department ED ON ED.DepartmentID = EB.DepartmentID	
			LEFT JOIN Emp_Designation D ON D.DesignationID = EB.DesignationID	
		WHERE  EB.IsDeleted = 0  AND EB.Status = 'A'
		ORDER BY ED.DisOrder ASC
	END
END



