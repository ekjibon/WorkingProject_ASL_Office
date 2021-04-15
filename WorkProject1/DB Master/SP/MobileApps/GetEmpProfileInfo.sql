/****** Object:  StoredProcedure [dbo].[GetEmpProfileInfo]    Script Date: 10-01-2021 6:37:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmpProfileInfo]'))
BEGIN
DROP PROCEDURE  GetEmpProfileInfo
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEmpProfileInfo]   -- GetEmpProfileInfo 3
@DepartmentId INT
AS
BEGIN
	IF @DepartmentId = 0 SET @DepartmentId = NULL
		SELECT EB.EmpBasicInfoID,EB.EmpID,EB.FullName,EB.DepartmentID,EB.MobileNo,EB.ShortName,EB.Email,EB.DisOrder  ,ED.DepartmentName,D.DesignationName--,EB.Image
		FROM
			Emp_BasicInfo EB 	
			LEFT JOIN Emp_Department ED ON ED.DepartmentID = EB.DepartmentID	
			LEFT JOIN Emp_Designation D ON D.DesignationID = EB.DesignationID	
		WHERE  EB.IsDeleted = 0  AND EB.Status = 'A' AND EB.DepartmentID = ISNULL(@DepartmentId,EB.DepartmentID)
		ORDER BY ED.DisOrder ASC	
END



