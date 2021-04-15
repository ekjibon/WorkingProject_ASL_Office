IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmpSalaryStructureList]'))
BEGIN
DROP PROCEDURE  [GetEmpSalaryStructureList]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEmpSalaryStructureList] 

AS
BEGIN
Select hs.Id as SalaryStructureId,hs.*,emp.FullName,sh.HeadName,sh.Category, sg.Name GradeName,st.YearName from dbo.HR_SalaryStructure hs
 inner  join dbo.Emp_BasicInfo emp on emp.EmpBasicInfoID =hs.EmpId

 inner Join dbo.HR_SalaryGrade sg on sg.SalaryGradeId = hs.GradeId
  inner Join dbo.HR_SalaryTaxYear st on st.Id = hs.TaxYearId
   left Join dbo.HR_SalaryHead sh on sh.Id = hs.HeadId 
   where hs.IsDeleted = 0 and hs.Status = 'A'
END