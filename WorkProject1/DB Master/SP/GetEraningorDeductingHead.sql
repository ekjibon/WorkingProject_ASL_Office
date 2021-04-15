/****** Object:  StoredProcedure [dbo].[GetEraningorDeductingHead]    Script Date: 04/27/2020 12:45:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEraningorDeductingHead]'))
BEGIN
DROP PROCEDURE GetEraningorDeductingHead
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---[dbo].[GetEraningorDeductingHead] 145,1
CREATE PROCEDURE [dbo].[GetEraningorDeductingHead] 
(

@ID INT = Null,
@BLOCK INT

)
AS
BEGIN
   IF(@BLOCK = 1)
   BEGIN
   SELECT DISTINCT HS.Id,HS.SalaryPeriodId,HS.CategoryID,HS.GrossAmount,HS.NetAmount,(EB.EmpID) AS EmployeeId ,EB.FullName,SH.HeadName,(HSSP.Id) AS SalaryStructurePeriodId,HSSP.HeadId,SH.Category,HSSP.Amount
   FROM  [dbo].[HR_SalaryPayDetails] HS
   INNER JOIN [dbo].[Emp_BasicInfo] EB ON EB.CategoryID = HS.CategoryID  AND EB.EmpBasicInfoID = HS.EmpId
   INNER JOIN [dbo].[HR_SalaryStructurePeriod] HSSP ON HSSP.EmpId = HS.EmpId
   INNER JOIN [dbo].[HR_SalaryHead] SH ON SH.Id = HSSP.HeadId AND SH.Category=1
   
   WHERE HS.Id= @ID AND HSSP.PeriodId = HS.SalaryPeriodId 
   ORDER BY HSSP.HeadId
   END
	 IF(@BLOCK = 2)
   BEGIN
   SELECT DISTINCT  HS.Id,HS.SalaryPeriodId,HS.CategoryID,HS.GrossAmount,HS.NetAmount,(EB.EmpID) AS EmployeeId ,EB.FullName,SH.HeadName,(HSSP.Id) AS SalaryStructurePeriodId,HSSP.HeadId,SH.Category,HSSP.Amount
   FROM  [dbo].[HR_SalaryPayDetails] HS
   INNER JOIN [dbo].[Emp_BasicInfo] EB ON EB.CategoryID = HS.CategoryID  AND EB.EmpBasicInfoID = HS.EmpId
   INNER JOIN [dbo].[HR_SalaryStructurePeriod] HSSP ON HSSP.EmpId = HS.EmpId
   INNER JOIN [dbo].[HR_SalaryHead] SH ON SH.Id = HSSP.HeadId AND SH.Category=2
   
   WHERE HS.Id= @ID AND HSSP.PeriodId = HS.SalaryPeriodId 
   END	   
END