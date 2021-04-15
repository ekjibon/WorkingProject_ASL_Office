/****** Object:  StoredProcedure [dbo].[SP_GetEmpAllInfo]    Script Date: 11/18/2017 6:37:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetSalarySheetold]'))
BEGIN
DROP PROCEDURE  rptGetSalarySheetold
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
	--- EXEC rptGetSalarySheet 2,1,3,10
CREATE PROCEDURE [dbo].[rptGetSalarySheetold] 
@PeriodId INT,
@Month INT,
@DepartmentID INT,
@EmpId INT = NULL
AS
BEGIN

	SELECT EmpBasicInfoID INTO #EMP
	 FROM Emp_BasicInfo WHERE DepartmentID = @DepartmentID AND IsDeleted = 0 AND Status='A'
	 AND   EmpBasicInfoID= COALESCE(@EmpId,EmpBasicInfoID) 
	 

	SELECT  EMP.FullName,JoiningDate,EMP.MobileNo ,SH.HeadName,Sh.HeadCode,SH.DisplayOrder,
	
	(CASE WHEN SH.Category=1 THEN 'Eranings' ELSE 'Deduct' END) AS Category,
	  ES.Amount , 
	  dbo.CalculateNetAmount(Es.EmpId,@PeriodId) AS NetAmount,
	  SP.PeriodName,SP.DaysWorking,SP.MonthName,SP.Year,ES.DisburseDate
	FROM HR_EmployeeSalary ES 
	INNER JOIN Emp_BasicInfo EMP ON ES.EmpId = EMP.EmpBasicInfoID
	INNER JOIN HR_SalaryHead SH ON SH.Id = ES.HeadId
	INNER JOIN HR_SalaryPeriod SP ON SP.Id = ES.PeriodId
	WHERE ES.PeriodId = @PeriodId AND ES.EmpId IN (SELECT * FROM #EMP)



	 

END

