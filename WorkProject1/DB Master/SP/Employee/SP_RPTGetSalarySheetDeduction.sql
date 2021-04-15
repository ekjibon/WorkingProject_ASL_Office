--USE [cgsd_new_2019_test_20200112]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPTGetSalarySheetDeduction]    Script Date: 4/22/2020 11:03:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Azmal
-- Create date: 2020-05-14
-- Description:	
-- =============================================
	--- EXEC SP_RPTGetSalarySheetDeduction 1,8
CREATE PROCEDURE [dbo].[SP_RPTGetSalarySheetDeduction] 
(
@PeriodId INT,
@BranchID INT = 0
)
AS
BEGIN
	SELECT Sl,FullName,IDNumber,DesignationName,JoiningDate,ConfirmationDate,SalaryACNo,MobileNo,PeriodName,DaysWorking,MonthName,Year,
	StartDate,EndDate,GrossAmount,Deduction,IncomeTax,(GrossAmount+Arrear-Deduction-IncomeTax)NetSalary,isnull(ConfirmationSalary,'')ConfirmationSalary,Arrear,
	BranchName,PrintDate,Remarks,YearName FROM
	(SELECT CONVERT(VARCHAR,ROW_NUMBER() Over (Order by EMP.FullName)) As Sl, EMP.FullName,EMP.EmpId IDNumber,D.DesignationName,Convert(nvarchar(15), cast(JoiningDate as Date),106)JoiningDate,
	Convert(nvarchar(15), cast(ConfirmationDate as Date),106)ConfirmationDate,SalaryACNo, EMP.MobileNo ,ES.GrossAmount,
	  ES.NetAmount , SP.PeriodName,SP.DaysWorking,SP.MonthName,SP.Year,Convert(nvarchar(15), cast(SP.StartDate as Date),106) StartDate,
	  Convert(nvarchar(15), cast(SP.EndDate as Date),106) EndDate,
	  ISNULL((SELECT SUM(Amount) FROM HR_SalaryStructurePeriod S INNER JOIN HR_SalaryHead H ON H.Id=S.HeadId WHERE PeriodId=@PeriodID AND S.EmpId=ES.EmpId AND H.Category=2 AND S.HeadId NOT IN(1015) group by S.EmpId,PeriodId),0)Deduction,
	  Isnull((select Amount from HR_SalaryStructurePeriod WHERE  PeriodId=@PeriodID AND EmpId=ES.EmpId  AND HeadId =1015),0)IncomeTax,
	  ISNULL((select Amount from HR_SalaryStructurePeriod WHERE  PeriodId=@PeriodID AND EmpId=ES.EmpId  AND HeadId =1027),0)Arrear,
	  case when EMP.BranchName='CGSD Primary' then 'Primary Campus' else 'Secondary Campus' end BranchName,Convert(nvarchar(15), cast(getdate() as Date),106)PrintDate,
	  (SELECT  STUFF((SELECT ' and ' + Remarks FROM HR_SalaryStructurePeriod WHERE PeriodId=ES.SalaryPeriodId AND EmpId=ES.EmpId FOR XML PATH('')), 1, 4, '')) Remarks,
	  SY.YearName,(SELECT isnull(ConfirmationSalary,0)ConfirmationSalary FROM Emp_BasicInfo WHERE EmpBasicInfoID=ES.EmpId AND ConfirmationDate BETWEEN SY.FromDate and ToDate)ConfirmationSalary
	FROM HR_SalaryPayDetails ES 
	INNER JOIN (SELECT P.EmpId FROM HR_SalaryHead H INNER JOIN HR_SalaryStructurePeriod P ON P.HeadId=H.ID WHERE H.Category=2 GROUP BY P.EmpId) HP ON HP.EmpId=ES.EmpId 
	INNER JOIN Emp_BasicInfo EMP ON ES.EmpId = EMP.EmpBasicInfoID AND ES.SalaryPeriodId=@PeriodId
	INNER JOIN Emp_Designation D ON D.DesignationID=EMP.DesignationID
	INNER JOIN HR_SalaryPeriod SP ON SP.Id = ES.SalaryPeriodId
	INNER JOIN HR_SalaryYear SY ON SY.Id = SP.SalaryYearId  
	WHERE ES.SalaryPeriodId = @PeriodId 
	and EMP.BranchID=CASE WHEN @BranchID<>0 THEN @BranchID ELSE EMP.BranchID END
	)T ORDER BY FullName



END

