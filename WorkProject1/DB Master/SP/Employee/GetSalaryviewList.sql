/****** Object:  StoredProcedure [dbo].[GetSalaryviewList]    Script Date: 04/19/2020 6:19:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetSalaryviewList]'))
BEGIN
DROP PROCEDURE  GetSalaryviewList
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---[dbo].[GetSalaryviewList] 2,9,1002
CREATE PROCEDURE [dbo].[GetSalaryviewList] 
(

@CategoryID INT = Null,
@BranchID INT = Null,
@PeriodId INT = Null
)
AS
BEGIN
   
   SELECT DISTINCT HS.*,(EB.EmpID) AS EmployeeId ,EB.FullName ,
   (SELECT SUM(Amount) FROM HR_SalaryStructurePeriod 
   INNER JOIN [dbo].[HR_SalaryHead] SH ON SH.Id = HeadId
   WHERE EmpId = HS.EmpId AND SH.Category= 2 AND PeriodId = @PeriodId  ) AS Deduction,
   (SELECT SUM(Amount) FROM HR_SalaryStructurePeriod 
   --INNER JOIN [dbo].[HR_SalaryHead] SH ON SH.Id = HeadId
   WHERE EmpId IN (HS.EmpId) AND HeadId IN (1027)) AS Arrear
   FROM  [dbo].[HR_SalaryPayDetails] HS
   INNER JOIN [dbo].[Emp_BasicInfo] EB ON EB.CategoryID = HS.CategoryID  AND EB.EmpBasicInfoID = HS.EmpId
   INNER JOIN [dbo].[HR_SalaryStructurePeriod] HSSP ON HSSP.PeriodId = @PeriodId
   
   WHERE EB.CategoryID = @CategoryID  AND EB.BranchID = @BranchID AND HS.SalaryPeriodId = @PeriodId AND HS.IsConfirmed = 0

		   
END