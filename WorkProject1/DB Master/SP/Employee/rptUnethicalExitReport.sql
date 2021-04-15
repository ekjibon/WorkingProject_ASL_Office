
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptUnethicalExitReport]'))
BEGIN
DROP PROCEDURE  rptUnethicalExitReport
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[rptUnethicalExitReport] 8,0
CREATE PROCEDURE [dbo].[rptUnethicalExitReport]  
(
@BranchId INT,
@EmpId INT
)
AS
BEGIN

SELECT EB.EmpID,EB.FullName,ED.DesignationName,
(CASE WHEN EB.BranchID = 8 THEN 'Primary Campus'
     WHEN EB.BranchID = 9 THEN 'Secondary Campus'
	 ELSE 'ALL' END) AS Branch,
B.BranchName,EB.JoiningDate,EB.ConfirmationDate,(SELECT dbo.fnServiceLength(EB.JoiningDate,EB.ProbationPeriodEndDate)) AS ProbationPeriod,EB.CurrentSalary,(SELECT TOP(1) CAST(InTime AS DATE)  FROM Emp_Attendance WHERE EmpId = EB.EmpBasicInfoID ORDER BY InTime DESC) AS LastDayOffice
FROM Emp_BasicInfo EB
INNER JOIN [dbo].[Emp_Designation] ED ON ED.DesignationID = EB.DesignationID
INNER JOIN [dbo].[Ins_Branch] B ON B.BranchId =EB.BranchID
WHERE EB.[Status] = 'Unethical Exit'
AND EB.BranchID = CASE WHEN @BranchId > 0 THEN @BranchId ELSE EB.BranchID END
AND EB.EmpBasicInfoID = CASE WHEN @EmpId > 0 THEN @EmpId ELSE EB.EmpBasicInfoID END

END