IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmployeeTaxList]'))
BEGIN
DROP PROCEDURE  [GetEmployeeTaxList]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		 Khaled 
-- Create date: 
-- Description:	
-- =============================================

CREATE PROCEDURE [dbo].[GetEmployeeTaxList]

	@TaxYearId INT,
	@CategoryId INT,
	@EmpId INT,
	@BranchID INT
AS
BEGIN
 -- execute [dbo].[GetEmployeeTaxList] 1,1,0,1

 SELECT DISTINCT EB.EmpBasicInfoID
        ,EB.EmpID
		,EB.FullName
		,EB.CurrentSalary
		,ET.TaxAmount
		,ET.TaxYearId

	FROM [dbo].[Emp_BasicInfo] EB
    LEFT JOIN [dbo].[HR_EmployeeTaxSetup] ET ON ET.EmpId = EB.EmpBasicInfoID AND ET.TaxYearId = @TaxYearId 
	 
	WHERE EB.EmpBasicInfoID =CASE WHEN @EmpId<>0 THEN @EmpId ELSE EB.EmpBasicInfoID END  
	      AND EB.BranchID =  CASE WHEN @BranchID<>0 THEN @BranchID ELSE EB.BranchID END 
		  AND EB.CategoryID =  CASE WHEN @CategoryId<>0 THEN @CategoryId ELSE EB.CategoryID END
	      --AND ET.TaxYearId = @TaxYearId 
		  AND EB.Status = 'A'
				

	GROUP BY EB.FullName,EB.EmpID,EB.EmpBasicInfoID,ET.TaxAmount,EB.CurrentSalary,ET.TaxYearId
 END
