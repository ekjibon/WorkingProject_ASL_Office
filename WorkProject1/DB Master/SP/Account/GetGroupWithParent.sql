IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetGroupWithParent]'))
BEGIN
DROP PROCEDURE  GetGroupWithParent
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].GetGroupWithParent 
AS
BEGIN  
	--  GetGroupWithParent 
	
	SELECT led1.*, led2.Name as ParentName FROM dbo.ACC_Ledgers led1
	LEFT JOIN dbo.ACC_Ledgers led2	ON led1.ParentId = led2.LedgerId
	where led1.IsGroup = 1 AND led1.RootGroupId != 0
	ORDER BY led1.LedgerId DESC

END