/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAllSalaryHeadaList]'))
BEGIN
DROP PROCEDURE  [GetAllSalaryHeadaList]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [dbo].[GetAllSalaryHeadaList] 1
  CREATE PROCEDURE [dbo].[GetAllSalaryHeadaList] 
  @Block INT
AS

BEGIN
IF(@Block = 1)
BEGIN
	SELECT h.Id,h.HeadName, h.HeadCode,h.Category,h.IsBasic,h.DisplayOrder,h.IsAccLedger,h.IsEdit
	FROM HR_SalaryHead  h
	WHERE h.IsDeleted=0 
END
IF(@Block = 2)
BEGIN
	SELECT h.Id,h.HeadName, h.HeadCode,h.Category,h.IsBasic,h.DisplayOrder,h.IsAccLedger
	FROM HR_SalaryHead  h
	WHERE h.IsDeleted=0 AND h.Category = 1 AND h.HeadName <> 'Salary Hold Refund'
END
	
END









