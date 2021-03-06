--USE [cgsd_new_2019_test_20200112]
GO
/****** Object:  StoredProcedure [dbo].[SP_ProcessEmpSalary]    Script Date: 4/23/2020 5:41:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Azmal
-- Create date: 2020-05-14
-- Description:	
-- =============================================
	--- EXEC SP_ProcessEmpSalary 1002
ALTER PROCEDURE [dbo].[SP_ProcessEmpSalary]
(
@PeriodID AS Int = 0


)
AS

BEGIN
DECLARE @StartDate as DATETIME
DECLARE @EndDate as DATETIME
DECLARE @EmpId AS INT
DECLARE @NoOfDays AS INT
DECLARE @CategoryID AS INT
DECLARE @IsDeductTax AS INT
DECLARE @IsLongHoliday AS INT
DECLARE @StartDatelongDays as DATETIME
DECLARE @Count AS INT

	SELECT @StartDate= StartDate , @EndDate= EndDate , @CategoryID =CategoryID , @IsDeductTax= IsDeductTax , @IsLongHoliday =IsLongHoliday
	FROM HR_SalaryPeriod WHERE ID=@PeriodID
	SELECT @Count = Count(*)FROM HR_SalaryHoldRefund WHERE SalaryPeriodId = @PeriodID AND [Status] = 'Pending'
	--PRINT @IsDeductTax
	DELETE HR_SalaryStructurePeriod
	WHERE PeriodId = @PeriodID AND CategoryID=@CategoryID
	

	INSERT INTO HR_SalaryStructurePeriod( PeriodId, HeadId, EmpId, TaxYearId, Amount, ProccessDate, CategoryID)
	SELECT  @PeriodID, HeadId,SS.EmpId,TaxYearId,Amount,getdate(),SS.CategoryID
	FROM HR_SalaryStructure SS
	INNER JOIN Emp_BasicInfo EI ON  EI.EmpBasicInfoID = SS.EmpId 
	WHERE EI.IsDeleted = 0 AND EI.Status='A' AND EI.CategoryID=@CategoryID --AND (EI.IsResignationApplied = 0 AND EI.ServeDate <= @StartDatelongDays) 
	
	
	
	EXEC SP_ProcessEmployeeSalaryPayDetails @PeriodID
	EXEC SP_ProcessResignationMonthSalary @PeriodID
	EXEC SP_ProcessDeductLate @PeriodID
	EXEC SP_ProcessDeductHalfDayLeave @PeriodID
	EXEC SP_ProcessDeductAbsent @PeriodID
	EXEC SP_ProcessDeductAbsentAfterLongHoliday @PeriodID
	EXEC SP_ProcessDeductLeaveWithOutPay @PeriodID
	EXEC SP_ProcessDeductECAAbsent @PeriodID
	IF(@IsDeductTax>0)
	BEGIN
		EXEC SP_ProcessIncomeTax @PeriodID
	END
	
	EXEC SP_ProcessAdvanceAdjustment @PeriodID
	EXEC SP_ProcessDeductSalaryHold @PeriodID
	

	IF(@IsLongHoliday>0)
	BEGIN
		EXEC SP_ProcessLongHolidaySalary @PeriodID
	END
	
	EXEC SP_ProcessMaternityLeaveSalary @PeriodID
	IF(@Count> 0)
	BEGIN
	EXEC SP_ProcessSalaryHoldRefund @PeriodID
	END
	

END