--USE [cgsd_new_2019_test_20200112]
GO
/****** Object:  StoredProcedure [dbo].[SP_ProcessDeductSalaryHold]    Script Date: 4/1/2020 4:51:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  EXEC SP_ProcessDeductSalaryHold 1
alter PROCEDURE [dbo].[SP_ProcessDeductSalaryHold]
(
@PeriodID AS Int = 0


)
AS

BEGIN
DECLARE @CategoryID AS INT


	SELECT  @CategoryID =CategoryID
	FROM HR_SalaryPeriod WHERE ID=@PeriodID

	DELETE FROM HR_SalaryHoldPayment WHERE SalaryPeriodId=@PeriodID 
	and SalaryHoldId in(select Id from HR_SalaryHold)
	AND EmpId IN(SELECT EmpBasicInfoID FROM Emp_BasicInfo WHERE CategoryID=@CategoryID)



	INSERT INTO HR_SalaryHoldPayment ( SalaryHoldId, SalaryPeriodId, PaymentAmount,EmpId,ToptalPaymentAmount,IsDeleted,Status,AddDate)
	SELECT Id ,@PeriodID,HoldPerMonthAmount,EmpId,(isnull(PaymentAmount,0) + HoldPerMonthAmount),0,'A',GetDate()
	FROM(
	SELECT H.Id , H.HoldPerMonthAmount,H.EmpId,H.NoOfInstallment,
	Isnull((SELECT top 1 Id FROM HR_SalaryPeriod WHERE Year=H.Year and Month=H.Month and IsDeleted=0 and CategoryID=EI.CategoryID),0)HoldPeriodId
    FROM HR_SalaryHold AS H 
	inner join Emp_BasicInfo EI ON EI.EmpBasicInfoID=H.EmpId and EI.CategoryID=@CategoryID AND H.IsDeleted=0)D
	LEFT JOIN (SELECT SalaryHoldId, COUNT(SalaryHoldId) AS Paid,isnull(sum(PaymentAmount),0)PaymentAmount FROM HR_SalaryHoldPayment Group by SalaryHoldId )  AS p ON D.Id=p.SalaryHoldId
	Where NoOfInstallment> Isnull(p.Paid,0)   AND HoldPeriodId<= @PeriodID and HoldPeriodId>0
	AND D.EmpId IN(SELECT EmpId FROM HR_SalaryStructure)
	

	


	INSERT INTO HR_SalaryStructurePeriod( PeriodId, HeadId, EmpId , Amount, ProccessDate, CategoryID,Remarks)
	SELECT  @PeriodID, 1013,EI.EmpBasicInfoID,ISNULL(P.PaymentAmount,0),getdate(),EI.CategoryID,
	CASE WHEN   cast((select count(Id) from  HR_SalaryHoldPayment where SalaryHoldId=P.SalaryHoldId group by SalaryHoldId)as nvarchar(50))='1' THEN '1st Installment Salary Hold'
		 WHEN   cast((select count(Id) from  HR_SalaryHoldPayment where SalaryHoldId=P.SalaryHoldId group by SalaryHoldId)as nvarchar(50))='2' THEN '2nd Installment Salary Hold'
		 WHEN   cast((select count(Id) from  HR_SalaryHoldPayment where SalaryHoldId=P.SalaryHoldId group by SalaryHoldId)as nvarchar(50))='3' THEN '3rd Installment Salary Hold'
		 ELSE   cast((select count(Id) from  HR_SalaryHoldPayment where SalaryHoldId=P.SalaryHoldId group by SalaryHoldId)as nvarchar(50))+' th Installment Salary Hold' END
	FROM  Emp_BasicInfo EI 
	INNER JOIN HR_SalaryHoldPayment P ON P.EmpId=EI.EmpBasicInfoID AND P.SalaryPeriodId=@PeriodID
	WHERE  EI.IsDeleted = 0 AND EI.Status='A' AND EI.CategoryID=@CategoryID
	AND EI.EmpBasicInfoID IN(SELECT EmpId FROM HR_SalaryStructure)
	AND P.IsDeleted=0
		
	

END
