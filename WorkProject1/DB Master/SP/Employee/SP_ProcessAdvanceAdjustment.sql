
-- EXEC SP_ProcessAdvanceAdjustment 1
ALTER PROCEDURE [dbo].[SP_ProcessAdvanceAdjustment]
(
@PeriodID AS Int = 0


)
AS
BEGIN
DECLARE @CategoryID AS INT


	SELECT  @CategoryID =CategoryID
	FROM HR_SalaryPeriod WHERE ID=@PeriodID

	DELETE FROM HR_AdvanceSalaryPayment WHERE SalaryPeriodId=@PeriodID 
	and AdvanceSalaryId in(select Id from HR_AdvanceSalary)
	AND EmpId IN(SELECT EmpBasicInfoID FROM Emp_BasicInfo WHERE CategoryID=@CategoryID)



	INSERT INTO HR_AdvanceSalaryPayment ( AdvanceSalaryId, SalaryPeriodId, PaymentAmount,EmpId,IsDeleted)
	SELECT Id,@PeriodID,InstallmentAmount,EmpId,0
	From(
	SELECT aa.Id,aa.InstallmentAmount,aa.EmpId,aa.noOfInstallment ,Isnull((SELECT top 1 Id FROM HR_SalaryPeriod WHERE Year=aa.Year and Month=aa.Month and IsDeleted=0 and CategoryID=EI.CategoryID),0)AdvancePeriodId
	FROM HR_AdvanceSalary AS aa 
	inner join Emp_BasicInfo EI ON EI.EmpBasicInfoID=aa.EmpId and EI.CategoryID=@CategoryID AND aa.IsDeleted=0)D
	LEFT JOIN (SELECT AdvanceSalaryId, COUNT(AdvanceSalaryId) AS AdvPaid FROM HR_AdvanceSalaryPayment Group by AdvanceSalaryId )  AS ap ON D.Id=ap.AdvanceSalaryId
	Where noOfInstallment> Isnull(ap.AdvPaid,0)   AND AdvancePeriodId<= @PeriodID and AdvancePeriodId>0
	AND D.EmpId IN(SELECT EmpId FROM HR_SalaryStructure)
	


	INSERT INTO HR_SalaryStructurePeriod( PeriodId, HeadId, EmpId , Amount, ProccessDate, CategoryID,Remarks)
	SELECT  @PeriodID, 1014,EI.EmpBasicInfoID,ISNULL(AP.PaymentAmount,0),getdate(),EI.CategoryID,
	CASE WHEN  cast((select count(Id) from  HR_AdvanceSalaryPayment where AdvanceSalaryId=AP.AdvanceSalaryId group by AdvanceSalaryId)as nvarchar(50))='1' THEN +'1st Installment Advance Salary Reimburse'
		 WHEN  cast((select count(Id) from  HR_AdvanceSalaryPayment where AdvanceSalaryId=AP.AdvanceSalaryId group by AdvanceSalaryId)as nvarchar(50))='2' THEN +'2nd Installment Advance Salary Reimburse'
		 WHEN  cast((select count(Id) from  HR_AdvanceSalaryPayment where AdvanceSalaryId=AP.AdvanceSalaryId group by AdvanceSalaryId)as nvarchar(50))='3' THEN +'3rd Installment Advance Salary Reimburse'
	     ELSE  cast((select count(Id) from  HR_AdvanceSalaryPayment where AdvanceSalaryId=AP.AdvanceSalaryId group by AdvanceSalaryId)as nvarchar(50))+' th Installment Advance Salary Reimburse' END
	FROM  Emp_BasicInfo EI 
	INNER JOIN HR_AdvanceSalaryPayment AP ON AP.EmpId=EI.EmpBasicInfoID AND AP.SalaryPeriodId=@PeriodID
	WHERE  EI.IsDeleted = 0 AND EI.Status='A' AND EI.CategoryID=@CategoryID
	AND EI.EmpBasicInfoID IN(SELECT EmpId FROM HR_SalaryStructure)
	AND AP.IsDeleted=0


END


