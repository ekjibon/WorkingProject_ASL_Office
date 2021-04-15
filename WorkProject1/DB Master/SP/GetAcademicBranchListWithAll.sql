IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAcademicBranchListWithAll]'))
BEGIN
DROP PROCEDURE  GetAcademicBranchListWithAll
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[GetAcademicBranchListWithAll] 
CREATE PROCEDURE [dbo].[GetAcademicBranchListWithAll]  		
AS
BEGIN

	SELECT 0 AS BranchId,'All' AS Name
	UNION ALL
	SELECT BranchId,BranchName FROM Ins_Branch WHERE IsDeleted = 0

END

