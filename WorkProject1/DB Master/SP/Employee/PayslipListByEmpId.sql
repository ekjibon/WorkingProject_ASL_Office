/****** Object:  StoredProcedure [dbo].[PayslipListByEmpId]    Script Date: 04/19/2020 6:19:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PayslipListByEmpId]'))
BEGIN
DROP PROCEDURE  PayslipListByEmpId
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--- exec [dbo].[PayslipListByEmpId] 11
CREATE PROCEDURE [dbo].[PayslipListByEmpId] 
(

@EmpId INT = Null

)
AS
BEGIN
   
   --SELECT DISTINCT HS.*,SP.MonthName,SP.Year,SP.StartDate,SP.EndDate      //permission was denied on the object 'HR_SalaryPayDetails'
   --FROM [dbo].[HR_SalaryPayDetails] HS
   --INNER JOIN [dbo].[HR_SalaryPeriod] SP ON SP.Id = HS.SalaryPeriodId 
   --WHERE HS.EmpId = @EmpId 
		   

	SELECT DISTINCT BI.*,SP.MonthName,SP.Year,SP.StartDate,SP.EndDate
   FROM [dbo].[HR_EmployeeSalary] BI
   INNER JOIN [dbo].[HR_SalaryPeriod] SP ON SP.Id = BI.PeriodId
   WHERE BI.EmpID = @EmpId 
    
END
  go 
 --  select * from [dbo].[HR_EmployeeSalary]; 

   --  select * from [dbo].[HR_SalaryPeriod]   

  -- select * from [dbo].[Emp_BasicInfo]    where EmpBasicInfoID = 11;

