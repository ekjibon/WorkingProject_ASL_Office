
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptSalaryHoldRefund]'))
BEGIN
DROP PROCEDURE  [rptSalaryHoldRefund]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [dbo].[rptSalaryHoldRefund] 0
  CREATE PROCEDURE [dbo].[rptSalaryHoldRefund] 
  @BranchID INT
AS

BEGIN
SELECT EB.FullName,EB.EmpID,ED.DesignationName,EB.JoiningDate,EB.ConfirmationDate,EB.CurrentSalary,
(DATEDIFF(month,EB.JoiningDate,EB.ProbationPeriodEndDate)) AS ProbitionPeriod,SHR.Installment,SHR.InstallmentAmount,
(SUM(SHR.InstallmentAmount)) AS TotalAmount,SP.PeriodEndDate,SHR.HoldedAmount,SH.NoOfInstallment,SHR.SalaryPeriodId,
(SELECT TOP(1)P.[MonthName] FROM HR_SalaryHoldRefund HSHR INNER JOIN HR_SalaryPeriod P ON P.Id = HSHR.SalaryPeriodId WHERE HSHR.[Status] = 'Pending' AND HSHR.EmpId = EB.EmpBasicInfoID) AS MonthName,
(CASE WHEN SHR.Remarks = '1' THEN SHR.Remarks+'st Installment' 
      WHEN SHR.Remarks = '2' THEN SHR.Remarks+'nd Installment'
	  WHEN SHR.Remarks = '3' THEN SHR.Remarks+'rd Installment'
	  ELSE SHR.Remarks+'th Installment' END ) AS Remarks,
CASE WHEN @BranchID = 8 THEN 'Primary Campus' WHEN @BranchID = 9 THEN 'Secondary Campus'ELSE 'All' END BranchName,(SHR.HoldedAmount-SUM(SHR.InstallmentAmount)) AS DueAmount
FROM Emp_BasicInfo EB
INNER JOIN HR_SalaryHoldRefund SHR  ON EB.EmpBasicInfoID = SHR.EmpId
INNER JOIN dbo.Emp_Designation  ED ON ED.DesignationID =  EB.DesignationID
INNER JOIN HR_SalaryHold SH ON SH.EmpId = SHR.EmpId
INNER JOIN HR_SalaryPeriod SP ON SP.Id = SHR.SalaryPeriodId
WHERE EB.BranchID=CASE WHEN  @BranchID >0 THEN @BranchID ELSE EB.BranchID END AND 
(SHR.[Status] = 'Refund' OR SHR.[Status] = 'Forfiet') AND SHR.IsDeleted =0

GROUP BY EB.FullName,EB.EmpID,ED.DesignationName,EB.JoiningDate,EB.ConfirmationDate,EB.CurrentSalary,
EB.ProbationPeriodEndDate,SHR.Installment,SHR.InstallmentAmount,
SP.PeriodEndDate,SHR.HoldedAmount,SH.NoOfInstallment,SHR.SalaryPeriodId,SP.[MonthName],SHR.Remarks,EB.EmpBasicInfoID
	
END