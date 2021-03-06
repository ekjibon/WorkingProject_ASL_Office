GO
/****** Object:  StoredProcedure [dbo].[SP_RPTGetSalaryHold]    Script Date: 4/23/2020 6:25:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Azmal
-- Create date: 06/14/2020
-- Description:	
-- =============================================
	--- EXEC SP_RPTGetSalaryHold '13,27,2'
alter PROCEDURE [dbo].[SP_RPTGetSalaryHold] 
(
@EmpId VARCHAR(max) =null
)
AS
BEGIN
	SELECT  CONVERT(VARCHAR,ROW_NUMBER() Over (Order by EI.FullName,H.Id,H.EmpId)) As Sl, EI.FullName,EI.EmpId IDNumber,D.DesignationName,Convert(nvarchar(15), cast(JoiningDate as Date),106)JoiningDate,
	Convert(nvarchar(15), cast(ConfirmationDate as Date),106)ConfirmationDate,DATEDIFF(month,  JoiningDate,ConfirmationDate)ProbitionPeriod,SP.PeriodName,GrossSalary, HoldPerMonthAmount,
	NoOfInstallment,ISNULL(P.PaymentAmount,0)PaymentAmount,ISNULL(P.ToptalPaymentAmount,0)ToptalPaymentAmount, case when EI.BranchName='CGSD Primary' then 'Primary Campus' else 'Secondary Campus' end BranchName,
	Convert(nvarchar(15), cast(P.AddDate as Date),106)PayementDate
	FROM  Emp_BasicInfo EI 
	INNER JOIN HR_SalaryHold H ON H.EmpId=EI.EmpBasicInfoID 
	LEFT JOIN HR_SalaryHoldPayment P ON P.EmpId=EI.EmpBasicInfoID 
	LEFT JOIN Emp_Designation D ON D.DesignationID=EI.DesignationID
	LEFT JOIN HR_SalaryPeriod SP ON SP.Id = P.SalaryPeriodId
	WHERE  H.EmpId in  (SELECT * FROM STRING_SPLIT(@EmpId,',')) 
	AND H.IsDeleted = 0 AND H.Status='A' 
	order by EI.FullName



END

