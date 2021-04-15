
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptSalaryHoldRefundInndividual]'))
BEGIN
DROP PROCEDURE  [rptSalaryHoldRefundInndividual]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [dbo].[rptSalaryHoldRefundInndividual] 1119
  CREATE PROCEDURE [dbo].[rptSalaryHoldRefundInndividual] 
  @EmpId INT
AS

BEGIN
SELECT EB.FullName,EB.EmpID,ED.DesignationName,EB.JoiningDate,EB.ConfirmationDate,EB.CurrentSalary,
(DATEDIFF(month,  EB.JoiningDate,EB.ProbationPeriodEndDate)) AS ProbationPeriod,SHR.Installment,SHR.InstallmentAmount,
SHR.SalaryPeriodId,(SUM(SHR.InstallmentAmount)) AS TotalAmount,SP.PeriodName,SP.PeriodEndDate,
CASE WHEN EB.BranchName='CGSD Primary' THEN 'Primary Campus' ELSE 'Secondary Campus' END BranchName
FROM HR_SalaryHoldRefund SHR
INNER JOIN Emp_BasicInfo EB ON EB.EmpBasicInfoID = SHR.EmpId
INNER JOIN dbo.Emp_Designation  ED ON ED.DesignationID =  EB.DesignationID
INNER JOIN HR_SalaryPeriod SP ON SP.Id = SHR.SalaryPeriodId
WHERE SHR.EmpId = @EmpId AND (SHR.[Status] = 'Refund' OR SHR.[Status] = 'Forfiet') AND SHR.IsDeleted =0

GROUP BY EB.FullName,EB.EmpID,ED.DesignationName,EB.JoiningDate,EB.ConfirmationDate,EB.CurrentSalary,
EB.ProbationPeriodEndDate,SHR.Installment,SHR.InstallmentAmount,SHR.SalaryPeriodId,SP.PeriodName,
SP.PeriodEndDate,EB.BranchName
	
END