
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAllSalaryHoldRefund]'))
BEGIN
DROP PROCEDURE  GetAllSalaryHoldRefund
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[GetAllSalaryHoldRefund] 
CREATE PROCEDURE [dbo].[GetAllSalaryHoldRefund] 
AS
BEGIN
SELECT HR.EmpId,EB.FullName,EB.EmpID,ED.DesignationName,EB.JoiningDate,EB.ConfirmationDate,EB.CurrentSalary,HR.Installment,HR.InstallmentAmount,HR.HoldedAmount,HR.SalaryYearId,(DATEDIFF(month,  EB.JoiningDate,EB.ProbationPeriodEndDate)) AS ProbationPeriod,EB.CategoryID FROM HR_SalaryHoldRefund HR
INNER JOIN Emp_BasicInfo EB ON EB.EmpBasicInfoID = HR.EmpId
INNER JOIN dbo.Emp_Designation  ED ON ED.DesignationID =  EB.DesignationID
WHERE HR.IsDeleted = 0
GROUP BY HR.EmpId,EB.FullName,EB.EmpID,ED.DesignationName,EB.JoiningDate,EB.ConfirmationDate,EB.CurrentSalary,HR.Installment,HR.InstallmentAmount,EB.ProbationPeriodEndDate,HR.HoldedAmount,EB.CategoryID
,HR.SalaryYearId
END