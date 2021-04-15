/****** Object:  StoredProcedure [dbo].[GetStudentInfoForResult]    Script Date: 7/22/2017 4:19:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmployeeWithSalaryPersentage]'))
BEGIN
DROP PROCEDURE  GetEmployeeWithSalaryPersentage
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec GetEmployeeWithSalaryPersentage 1136

CREATE PROCEDURE [dbo].[GetEmployeeWithSalaryPersentage] -- Total 1 param
	
	@EmpID INT = NULL

	
AS
BEGIN
PRINT ''
	
SELECT DISTINCT SS.Id, SS.HeadId,EB.EmpID,SS.CurrentSalary,SS.Amount,SS.CategoryID,SH.HeadName,EB.EmpBasicInfoID,EB.FullName 
FROM [dbo].[HR_SalaryStructure] SS
INNER JOIN HR_SalaryHead SH ON SH.Id = SS.HeadId
INNER JOIN Emp_BasicInfo EB ON EB.EmpBasicInfoID = SS.EmpId
WHERE SS.EmpId = @EmpID

END


--EXEC GetStudentInfoForResult
