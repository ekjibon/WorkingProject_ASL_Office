IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[InsertUserRole]'))
BEGIN
DROP PROCEDURE  InsertUserRole
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].InsertUserRole   -- [InsertUserRole] '61fe0515-61a5-44f2-955d-d3764892d93b','ad114318-407a-48ad-ac49-1dd6d340ffc9'
(
 @UserId Varchar(MAX),
 @UserRoles UTT_UserRoles readonly
)	
AS
BEGIN

	DELETE FROM [dbo].[AspNetUserRoles] WHERE UserId = @UserId 
	--IF(@@ROWCOUNT>0)
		INSERT INTO [dbo].[AspNetUserRoles]
			   ([UserId],[RoleId])
			SELECT UserId,RoleId FROM  @UserRoles

SELECT @@ROWCOUNT AS TOTALROWS

	--Select * FROM [dbo].[AspNetUserRoles]
END

 
