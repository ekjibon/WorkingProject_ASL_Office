IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAssignRoleList]'))
BEGIN
DROP PROCEDURE  GetAssignRoleList
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].GetAssignRoleList   -- [GetAssignRoleList] 'd11bbf50-e848-45e2-9deb-78bf8c48b202'
(
 @UserId Varchar(MAX)
)	
AS
BEGIN

SELECT UR.*,R.Name
		,(SELECT ISNULL((CASE WHEN COUNT(*)>0 THEN 1 ELSE 0 END),0) FROM [dbo].[AspNetRoles] WHERE Id = UR.RoleId) AS ISSelected
	FROM [dbo].[AspNetUserRoles] UR
	LEFT JOIN  [dbo].[AspNetRoles] R ON R.Id = UR.RoleId
	WHERE UR.UserId = @UserId

	--Select * FROM Emp_Designation
END

 
