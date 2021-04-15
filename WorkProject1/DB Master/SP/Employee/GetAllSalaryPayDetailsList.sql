IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[GetAllSalaryPayDetailsList]')) 
  BEGIN 
      DROP PROCEDURE [GetAllSalaryPayDetailsList] 
  END 

go 
/****** Object:  StoredProcedure [dbo].[GetAllSalaryIncrementList]    Script Date: 7/15/2019 11:46:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create procedure [dbo].[GetAllSalaryPayDetailsList]

as 
begin
	
	select d.*,sp.PeriodName,
     e.FullName,e.EmpBasicInfoID from dbo.HR_SalaryPayDetails d
	inner join Emp_BasicInfo e on d.EmpId=e.EmpBasicInfoID
	inner join dbo.HR_SalaryPeriod sp on d.SalaryPeriodId=sp.Id
	where d.IsDeleted=0 and d.Status = 'A' order by d.Id
end