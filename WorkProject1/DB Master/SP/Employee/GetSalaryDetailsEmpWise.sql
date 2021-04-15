/****** Object:  StoredProcedure [dbo].[GetSalaryDetailsEmpWise]    Script Date: 04/26/2020 3:19:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetSalaryDetailsEmpWise]'))
BEGIN
DROP PROCEDURE GetSalaryDetailsEmpWise
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---[dbo].[GetSalaryDetailsEmpWise] 327
CREATE PROCEDURE [dbo].[GetSalaryDetailsEmpWise] 
(

@ID INT = Null

)
AS
BEGIN
   
   SELECT DISTINCT HS.Id,HS.CategoryID,HS.EmpId,HS.GrossAmount,HS.NetAmount,HS.SalaryPeriodId,(EB.EmpID) AS EmployeeId ,EB.FullName,SH.HeadName,HSSP.HeadId,SH.Category,(HSSP.Id) AS SalaryStructurePeriodId,HSSP.HeadId,SH.Category,HSSP.Amount,HSSP.Remarks
   FROM  [dbo].[HR_SalaryPayDetails] HS
   INNER JOIN [dbo].[Emp_BasicInfo] EB ON EB.CategoryID = HS.CategoryID  AND EB.EmpBasicInfoID = HS.EmpId
   INNER JOIN [dbo].[HR_SalaryStructurePeriod] HSSP ON HSSP.EmpId = HS.EmpId
   INNER JOIN [dbo].[HR_SalaryHead] SH ON SH.Id = HSSP.HeadId
   
   WHERE HS.Id= @ID AND HSSP.PeriodId = HS.SalaryPeriodId
     ORDER BY HSSP.HeadId
		   
END