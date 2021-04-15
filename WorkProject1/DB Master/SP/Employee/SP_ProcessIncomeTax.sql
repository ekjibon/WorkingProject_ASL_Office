--USE [cgsd_new_2019_test_20200112]
GO
/****** Object:  StoredProcedure [dbo].[SP_ProcessIncomeTax]    Script Date: 3/31/2020 5:51:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  EXEC SP_ProcessIncomeTax 1
ALTER PROCEDURE [dbo].[SP_ProcessIncomeTax]
(
@PeriodID AS Int = 0


)
AS

BEGIN
DECLARE @CategoryID AS INT
DECLARE @TaxYearId AS INT

	SELECT  @CategoryID =CategoryID, @TaxYearId=SalaryTaxYearId
	FROM HR_SalaryPeriod WHERE ID=@PeriodID

			INSERT INTO HR_SalaryStructurePeriod( PeriodId, HeadId, EmpId , Amount, ProccessDate, CategoryID,Remarks)
			SELECT  @PeriodID, 1015,EI.EmpBasicInfoID,ISNULL(T.TaxAmount,0),getdate(),EI.CategoryID,'Tax'
			FROM  Emp_BasicInfo EI 
			INNER JOIN HR_EmployeeTaxSetup T ON T.EmpId=EI.EmpBasicInfoID AND T.TaxYearId =@TaxYearId
			WHERE  EI.IsDeleted = 0 AND EI.Status='A' AND EI.CategoryID=@CategoryID AND T.IsDeleted=0
			AND EI.EmpBasicInfoID IN(SELECT EmpId FROM HR_SalaryStructure)
	
	
	

END
