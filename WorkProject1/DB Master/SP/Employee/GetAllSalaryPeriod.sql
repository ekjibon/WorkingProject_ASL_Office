USE [cgsd_new_2019_test_20200112]
GO
/****** Object:  StoredProcedure [dbo].[GetAllSalaryPeriod]    Script Date: 4/28/2020 3:18:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[GetAllSalaryPeriod]

as 
begin
	
	select p.*,y.YearName
	,p.FiscalYearId,p.Month 
	from HR_SalaryPeriod p
	inner join HR_SalaryYear Y on Y.Id=p.SalaryYearId
	where p.IsDeleted=0 and p.Status='A'
end