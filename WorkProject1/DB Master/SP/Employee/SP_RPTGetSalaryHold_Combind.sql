GO
/****** Object:  StoredProcedure [dbo].[SP_RPTGetSalaryHold_Combind]    Script Date: 7/13/2020 6:25:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Azmal
-- Create date: 07/13/2020
-- Description:	
-- =============================================
	--- EXEC SP_RPTGetSalaryHold_Combind 9
alter PROCEDURE [dbo].[SP_RPTGetSalaryHold_Combind] 
(
@BranchId int =null
)
AS
BEGIN
	SELECT  CONVERT(VARCHAR,ROW_NUMBER() Over (Order by EI.FullName,H.Id,H.EmpId)) As Sl, EI.FullName,EI.EmpId IDNumber,D.DesignationName,Convert(nvarchar(15), cast(JoiningDate as Date),106)JoiningDate,
	Convert(nvarchar(15), cast(ConfirmationDate as Date),106)ConfirmationDate,DATEDIFF(month,  JoiningDate,ConfirmationDate)ProbitionPeriod,GrossSalary, HoldPerMonthAmount,
	NoOfInstallment, case when EI.BranchName='CGSD Primary' then 'Primary Campus' else 'Secondary Campus' end BranchName,
	isnull((select sum(PaymentAmount) from HR_SalaryHoldPayment where EmpId=H.EmpId group by EmpId),0)DeductedAmount,isnull(H.Remarks,'')Remarks
	FROM  Emp_BasicInfo EI 
	INNER JOIN HR_SalaryHold H ON H.EmpId=EI.EmpBasicInfoID 
	LEFT JOIN Emp_Designation D ON D.DesignationID=EI.DesignationID
	WHERE  EI.BranchId=@BranchId
	AND H.IsDeleted = 0 AND H.Status='A' 
	order by EI.FullName



END

