/****** Object:  StoredProcedure [dbo].[GetPageBuUserId]    Script Date: 7/22/2017 4:12:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetPageBuUserId]'))
BEGIN
DROP PROCEDURE  GetPageBuUserId
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Kawsar Ahmed>
-- Create date: <4/3/2017>
-- Description:	<Description,,>
-- =============================================
-- EXEC GetPageBuUserId '1b66e6bd-5944-4812-8585-7eae817a46d7',0

CREATE PROCEDURE [dbo].[GetPageBuUserId]
@UserName VARCHAR(128),
@ModuleId INT 
AS
BEGIN
	
	--SELECT P.* FROM  [dbo].[AspNetPages] P
	--INNER JOIN [dbo].[AspNetPagesRoles] PR ON PR.PageId = P.PageID
	--INNER JOIN [dbo].[AspNetRoles] R ON R.Id = pr.RoleId AND R.Id = (SELECT RoleId FROM [dbo].[AspNetUserRoles] WHERE UserId = @UserName )
	if (@ModuleId=0)
	BEGIN
	SET @ModuleId=null
	END;

		with name_tree as (
		SELECT PageID,ParentID, NameOption_En,NameOption_Bn,Controller,Action,Area,IconClass,ActiveLi,Status,Displayorder,IsParent ,ModuleId , IsModule
		FROM  [dbo].[AspNetPages] 
		where PageID in  -- this is the starting point you want in your recursion
			(SELECT P.PageID FROM  [dbo].[AspNetPages] P INNER JOIN [dbo].[AspNetPagesRoles] PR ON PR.PageId = P.PageID 
			INNER JOIN [dbo].[AspNetRoles] R ON R.Id = pr.RoleId AND R.Id IN (SELECT  RoleId FROM [dbo].[AspNetUserRoles] 
			 WHERE UserId = @UserName)
			)
		union all
		SELECT P.PageID,P.ParentID,P.NameOption_En,P.NameOption_Bn,P.Controller,P.Action,P.Area,P.IconClass,P.ActiveLi,	P.Status,	P.Displayorder,P.IsParent,P.ModuleId,P.IsModule
		FROM  [dbo].[AspNetPages] P
			join name_tree T on T.ParentID = P.PageID  -- this is the recursion
		) 
		select Distinct *
		from name_tree
		where ModuleId=ISNULL(@ModuleId,ModuleId) AND ParentID <> 1 AND IsModule = 0 --AND
		order by ParentID
END

--- GetPageBuUserId 'a824790f-6be8-4218-9c10-72eea8d83f89',0
