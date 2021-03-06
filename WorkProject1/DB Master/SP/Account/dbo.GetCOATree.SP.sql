/****** Object:  StoredProcedure [dbo].[GetCOATree]    Script Date: 7/22/2017 4:12:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetCOATree]'))
BEGIN
DROP PROCEDURE  GetCOATree
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Kawsa Ahmed>
-- Create date: <29/08/2019>
-- Description:	<Description,,>
-- =============================================
-- EXEC GetCOATree 

CREATE PROCEDURE [dbo].[GetCOATree]
AS
BEGIN
	
with name_tree as (
		SELECT LedgerId,ParentID, Name,Code , IsDisplay , IsLedger, DisplayOrder
		FROM  [dbo].[ACC_Ledgers]
		WHERE IsDeleted = 0 AND IsDisplay = 1 AND Status = 'A'
		union all
		SELECT P.LedgerId,P.ParentID,P.Name,P.Code,P.IsDisplay, P.IsLedger, P.DisplayOrder
		FROM  [dbo].[ACC_Ledgers] P
			join name_tree T on T.LedgerId = P.ParentId 
			WHERE IsDeleted = 0 AND P.IsDisplay = 1 AND Status = 'A'
		) 
		select Distinct *
		from name_tree 		
		ORDER BY Name
END

--- GetCOATree 'a824790f-6be8-4218-9c10-72eea8d83f89',0
