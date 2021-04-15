IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAllProject]'))
BEGIN
DROP PROCEDURE  GetAllProject
END
GO
/****** Object:  StoredProcedure [dbo].[GetAllProject]    Script Date:17/11/2020 3:41:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- EXEC GetAllProject
CREATE PROCEDURE [dbo].GetAllProject
@Block INT
AS
BEGIN
	IF(@Block=1)
	BEGIN
		SELECT P.*, PC.CategoryName, ED.DepartmentName
		FROM dbo.Task_Project AS P
		LEFT JOIN dbo.Task_ProjectCategory PC ON PC.Id = P.CategoryId
		LEFT JOIN dbo.Emp_Department ED ON ED.DepartmentID = P.DepartmentId
		WHERE P.IsDeleted = 0 --AND PC.IsDeleted = 0
		ORDER BY P.Id DESC
	END
	IF(@Block =2)
	BEGIN
		SELECT P.*, PC.CategoryName, ED.DepartmentName
		FROM dbo.Task_Project AS P
		LEFT JOIN dbo.Task_ProjectCategory PC ON PC.Id = P.CategoryId
		LEFT JOIN dbo.Emp_Department ED ON ED.DepartmentID = P.DepartmentId
		WHERE P.IsDeleted = 0 AND P.Status = 'A'
		ORDER BY P.Id DESC
	END
END
