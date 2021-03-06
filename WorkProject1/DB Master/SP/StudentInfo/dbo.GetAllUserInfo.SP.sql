IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAllUserInfo]'))
BEGIN
DROP PROCEDURE  GetAllUserInfo
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO --- GetAllUserInfo 1
CREATE PROC [dbo].[GetAllUserInfo] 
(
@BlockNo INT
)
AS
BEGIN

IF(@BlockNo =1)
BEGIN
	SELECT 
	   U.[Id]
      ,[FullName]
      ,[MobileNo]
     
      ,[Address]
      ,[Email]
      ,[EmailConfirmed]
     
      ,[PhoneNumber]
      ,[PhoneNumberConfirmed]
      ,[TwoFactorEnabled]
     ,LockoutEnabled
      ,[UserName]
      ,ISNULL([EmpId],0) 
	   ,R.Name AS RoleName 
	   ,R.Id AS RoleId
	   FROM AspNetUsers U 
	INNER JOIN AspNetUserRoles UR ON UR.UserId = U.id
	INNER JOIN AspNetRoles R  ON R.Id = UR.RoleId

	ORDER BY [FullName]
END
IF(@BlockNo =2)
BEGIN
	SELECT 
	  U.[FullName]
      ,U.[MobileNo]
      ,[Address]
      ,U.[Email]
      ,[EmailConfirmed]
      ,[PhoneNumber]
      ,[PhoneNumberConfirmed]
      ,[TwoFactorEnabled]
      ,LockoutEnabled
      ,[UserName]
      ,E.EmpID
	  ,E.Remarks
	  , (CASE WHEN E.Remarks IS NOT NULL THEN 'Dear ' + U.FullName + ',,Your account has been created.User Id: ' + U.UserName + ' Password: ' + E.Remarks
	  ELSE ''
	  END ) AS SMSBody
	   ,R.Name AS RoleName
	    FROM AspNetUsers U 
	INNER JOIN AspNetUserRoles UR ON UR.UserId = U.id
	INNER JOIN AspNetRoles R  ON R.Id = UR.RoleId
	INNER JOIN Emp_BasicInfo E ON E.EmpBasicInfoID = U.EmpId

	ORDER BY [FullName]
END


END

-- EXEC GetAllUserInfo 2