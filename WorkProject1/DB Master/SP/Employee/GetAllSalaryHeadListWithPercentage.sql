/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAllSalaryHeadListWithPercentage]'))
BEGIN
DROP PROCEDURE  [GetAllSalaryHeadListWithPercentage]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [dbo].[GetAllSalaryHeadListWithPercentage] 
  CREATE PROCEDURE [dbo].[GetAllSalaryHeadListWithPercentage] 
 
AS

BEGIN
	SELECT SHC.*,SH.HeadName,EC.CategoryName
	FROM HR_SalaryHeadWiseConfig  SHC
	INNER JOIN HR_SalaryHead SH ON SH.Id = SHC.HeadId
	INNER JOIN Emp_Category EC ON EC.CategoryID = SHC.CategoryID
	WHERE SHC.IsDeleted=0 

END