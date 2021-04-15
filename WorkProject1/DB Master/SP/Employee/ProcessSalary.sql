/****** Object:  StoredProcedure [dbo].[SP_GetEmpAllInfo]    Script Date: 11/18/2017 6:37:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ProcessSalary]'))
BEGIN
DROP PROCEDURE  ProcessSalary
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
	--- EXEC ProcessSalary 2,1,3,0
CREATE PROCEDURE [dbo].[ProcessSalary] 
@PeriodId INT,
@Month INT,
@DepartmentID INT

AS
BEGIN

	SELECT EmpBasicInfoID INTO #EMP
	 FROM Emp_BasicInfo WHERE DepartmentID = @DepartmentID AND IsDeleted = 0 AND Status='A'
	 --SELECT * FROM #EMP

	 DELETE HR_SalaryStructurePeriod WHERE PeriodId = @PeriodId AND EMPId IN (SELECT EmpBasicInfoID FROM #EMP)

	 INSERT INTO HR_SalaryStructurePeriod(PeriodId,EmpId,GradeId,HeadId,Amount, ProccessDate,TaxYearId)
	 SELECT @PeriodId,EmpId,GradeId,HeadId,Amount, GETDATE(),TaxYearId FROM HR_SalaryStructure 
	 WHERE EMPId IN (SELECT EmpBasicInfoID FROM #EMP)


	 INSERT INTO HR_EmployeeSalary(EmpId,PeriodId,HeadId,Amount,IsDeleted,AddBy,AddDate)
	 SELECT EmpId,@PeriodId,HeadId,Amount, 0,'',GETDATE() FROM HR_SalaryStructure 
	 WHERE EMPId IN (SELECT EmpBasicInfoID FROM #EMP) 


	 

END

