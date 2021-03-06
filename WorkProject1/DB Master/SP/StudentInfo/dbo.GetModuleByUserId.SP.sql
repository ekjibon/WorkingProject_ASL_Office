/****** Object:  StoredProcedure [dbo].[GetModuleByUserId]    Script Date: 7/22/2017 4:12:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetModuleByUserId]'))
BEGIN
DROP PROCEDURE  GetModuleByUserId
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Kawsa Ahmed>
-- Create date: <4/3/2017>
-- Description:	<Description,,>
-- =============================================
-- EXEC GetModuleByUserId 'a824790f-6be8-4218-9c10-72eea8d83f89'

CREATE PROCEDURE [dbo].[GetModuleByUserId]
@UserName VARCHAR(128)
AS
BEGIN
	
	--SELECT FROM 

	--SELECT P.* FROM  [dbo].[AspNetPages] P
	--INNER JOIN [dbo].[AspNetPagesRoles] PR ON PR.PageId = P.PageID
	--INNER JOIN [dbo].[AspNetRoles] R ON R.Id = pr.RoleId AND R.Id = (SELECT RoleId FROM [dbo].[AspNetUserRoles] WHERE UserId = @UserName )


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
		select Distinct ModuleId INTO #temp
		from name_tree 
		Group BY ModuleId

		SELECT * FROM #temp INNER JOIN AspNetPages P ON #temp.ModuleId = P.PageID
		WHERE #temp.ModuleId != 12
		--where  ParentID = 0 AND IsModule = 1 AND ModuleId !=12
		--order by ParentID
END

--- GetModuleByUserId 'a824790f-6be8-4218-9c10-72eea8d83f89',0
