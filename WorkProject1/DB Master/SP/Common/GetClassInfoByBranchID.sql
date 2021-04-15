
GO
/****** Object:  StoredProcedure [dbo].[GetClassInfoByBranchID]    Script Date: 6/07/2020 4:06:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec GetClassInfoByBranchID 8
alter PROCEDURE [dbo].[GetClassInfoByBranchID] 

@BranchID int
AS
BEGIN
	IF(@BranchID=8)
	BEGIN
	SELECT ClassId, ClassName, CalssCode, Class_HasGroup, Class_ForCollege, Remarks FROM Ins_ClassInfo where IsDeleted=0
	AND  ClassId IN(19,20,21,22,23,24,25,26,27)
	END
	ELSE
	BEGIN
	SELECT ClassId, ClassName, CalssCode, Class_HasGroup, Class_ForCollege, Remarks FROM Ins_ClassInfo where IsDeleted=0 
	AND  ClassId NOT IN(19,20,21,22,23,24,25,26)
	END	

END