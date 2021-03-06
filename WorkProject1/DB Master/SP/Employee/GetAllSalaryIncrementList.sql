IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[GetAllSalaryIncrementList]')) 
  BEGIN 
      DROP PROCEDURE [GetAllSalaryIncrementList] 
  END 

go 
/****** Object:  StoredProcedure [dbo].[GetAllSalaryIncrementList]    Script Date: 7/15/2019 11:46:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create procedure [dbo].[GetAllSalaryIncrementList]

as 
begin
	
	select c.Id,c.Amount,
	case c.IsPercentage 
	When 0 then 'No'
	When 1 then 'Yes'
	end IsPercentage,
	c.IsPercentage as Percentage,
	c.Type,
	c.Status,e.FullName,e.EmpBasicInfoID from HR_SalaryIncrement c
	inner join Emp_BasicInfo e on c.EmpId=e.EmpBasicInfoID
	where c.IsDeleted=0 and c.Status = 'A' order by c.Type
end