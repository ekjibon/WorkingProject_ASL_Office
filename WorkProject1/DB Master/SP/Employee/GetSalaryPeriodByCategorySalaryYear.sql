--USE [cgsd_new_2019_test_20200112]
GO
/****** Object:  StoredProcedure [dbo].[GetSalaryPeriodByCategorySalaryYear]    Script Date: 4/29/2020 12:05:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  exec GetSalaryPeriodByCategorySalaryYear 3,1,2
ALTER procedure [dbo].[GetSalaryPeriodByCategorySalaryYear]
(
@CategoryID int,
@SalaryYearId int,
@block int
)

as 
begin
	IF(@block = 1)
	BEGIN
	select p.*,y.YearName
	,p.FiscalYearId,p.Month 
	from HR_SalaryPeriod p
	inner join HR_SalaryYear Y on Y.Id=p.SalaryYearId
	where p.IsDeleted=0 and p.Status='A' and p.CategoryID=CASE WHEN @CategoryID<>0 THEN @CategoryID ELSE p.CategoryID END 
	and p.SalaryYearId=@SalaryYearId
	and p.Id in(select SalaryPeriodId from HR_SalaryPayDetails)
	END
	IF(@block = 2)
	BEGIN
	select p.*,y.YearName
	,p.FiscalYearId,p.Month 
	from HR_SalaryPeriod p
	inner join HR_SalaryYear Y on Y.Id=p.SalaryYearId
	where p.IsDeleted=0 and p.Status='A' and p.CategoryID=CASE WHEN @CategoryID<>0 THEN @CategoryID ELSE p.CategoryID END 
	and p.SalaryYearId=@SalaryYearId	
	END
end