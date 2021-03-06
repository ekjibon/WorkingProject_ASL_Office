--USE [cgsd_new_2019_test_20200112]
GO
/****** Object:  StoredProcedure [dbo].[SP_ProcessEmployeeSalaryPayDetails]    Script Date: 4/21/2020 2:24:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Azmal
-- Create date: 2020-05-14
-- Description:	
-- =============================================
	--- EXEC SP_ProcessEmployeeSalaryPayDetails 1002
ALTER PROCEDURE [dbo].[SP_ProcessEmployeeSalaryPayDetails]
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

	SELECT @StartDate= StartDate , @EndDate= EndDate , @CategoryID =CategoryID
	FROM HR_SalaryPeriod WHERE ID=@PeriodID

  DELETE  from HR_SalaryPayDetails where SalaryPeriodId=@PeriodId AND EmpId IN(SELECT EmpBasicInfoID FROM Emp_BasicInfo WHERE CategoryID=@CategoryID)
 
  
  Insert into  HR_SalaryPayDetails( SalaryPeriodId, EmpId,GrossAmount, NetAmount,BankAmount,CashAmount,AddDate,IsDeleted,CategoryID,DesignationName)
  
  Select PeriodId,EmpId,CurrentSalary ,ISNULL(NetPayable,0),0,0 ,getdate(),0,@CategoryID,DesignationName 
  from ( select PeriodId,ES.EmpId, EI.CurrentSalary,DesignationName,
  ((SELECT SUM(Amount) FROM HR_SalaryStructurePeriod S INNER JOIN HR_SalaryHead H ON H.Id=S.HeadId WHERE PeriodId=@PeriodID AND S.EmpId=ES.EmpId AND H.Category=1 group by S.EmpId,PeriodId) 
  -ISNULL((SELECT SUM(Amount) FROM HR_SalaryStructurePeriod S INNER JOIN HR_SalaryHead H ON H.Id=S.HeadId WHERE PeriodId=@PeriodID AND S.EmpId=ES.EmpId AND H.Category=2 group by S.EmpId,PeriodId),0))NetPayable
  FROM HR_SalaryStructurePeriod ES
  INNER JOIN Emp_BasicInfo EI ON  EI.EmpBasicInfoID = ES.EmpId 
  INNER JOIN Emp_Designation D ON D.DesignationID=EI.DesignationID
  where PeriodId=@PeriodId AND ES.CategoryID=@CategoryID 
  AND EI.EmpBasicInfoID NOT IN (SELECT EmpBasicInfoID FROM Emp_BasicInfo WHERE IsResignationApplied = 1 AND ServeDate >= @StartDate )--AND  ServeDate <= @EndDate) --AND ServeDate <= @StartDate --AND  ServeDate <= @EndDate
  --AND EI.EmpBasicInfoID NOT IN(select EmpBasicInfoID from Emp_BasicInfo 
		--where DATEDIFF(month,  JoiningDate,@StartDate)<12 AND CategoryID=@CategoryID AND EI.IsDeleted = 0 AND EI.Status='A'
		--AND (CONVERT(NVARCHAR(12),CAST(@StartDate AS DATE), 112) IN( select CONVERT(NVARCHAR(12),CAST(CalendarDate AS DATE), 112) from [dbo].[Att_EmpAcademicCalendarDetails] WHERE DayType='LongHoliday')
		--OR CONVERT(NVARCHAR(12),CAST(@EndDate AS DATE), 112) IN( select CONVERT(NVARCHAR(12),CAST(CalendarDate AS DATE), 112) from [dbo].[Att_EmpAcademicCalendarDetails] WHERE DayType='LongHoliday')))
  --AND EI.EmpBasicInfoID NOT IN(select L.EmpId from [dbo].[Emp_Request] L
		--INNER JOIN Emp_BasicInfo EI ON  EI.EmpBasicInfoID = L.EmpId 
		--WHERE EI.IsDeleted = 0 AND EI.Status='A' AND EI.CategoryID=@CategoryID
		--AND L.LeaveCategoryId=4 and L.Status='Approved' AND L.Duration/30>2
		--AND CONVERT(NVARCHAR(12),CAST(@StartDate AS DATE), 112) BETWEEN CONVERT(NVARCHAR(12),CAST(L.FromDate AS DATE), 112) AND CONVERT(NVARCHAR(12),CAST(L.ToDate AS DATE), 112)) 
  group by ES.EmpId,PeriodId, EI.CurrentSalary,D.DesignationName) as Sal
   
	

END

