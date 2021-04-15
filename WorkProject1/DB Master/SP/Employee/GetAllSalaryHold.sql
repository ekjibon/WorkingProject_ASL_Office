
GO
/****** Object:  StoredProcedure [dbo].[GetAllSalaryHold]    Script Date: 4/26/2020 4:01:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[GetAllSalaryHold]

as 
begin
	
	select A.*,EMP.FullName,EMP.EmpId EmpoyeeId,D.DesignationName ,
	CASE WHEN ISDATE(JoiningDate)=1 THEN  CONVERT(NVARCHAR(12),CAST(JoiningDate AS DATE), 106) ELSE '' END JoiningDate,
	CASE WHEN ISDATE(ProbationPeriodEndDate)=1 THEN  CONVERT(NVARCHAR(12),CAST(ProbationPeriodEndDate AS DATE), 106) ELSE '' END ProbationPeriodEndDate,
	CASE WHEN Isnull((SELECT count(Id) FROM HR_SalaryHoldPayment WHERE SalaryHoldId=A.Id group by SalaryHoldId),0)=A.NoOfInstallment then 'Close' ELSE 'Active' END HoldStatus
	from HR_SalaryHold A
	INNER JOIN Emp_BasicInfo EMP ON A.EmpId = EMP.EmpBasicInfoID 
	INNER JOIN Emp_Designation D ON D.DesignationID=EMP.DesignationID
	where A.IsDeleted=0 and A.Status='A'
end