
GO
/****** Object:  StoredProcedure [dbo].[SP_RPTGetSalarySheetByPaymentMode]    Script Date: 5/14/2020 12:22:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Azmal
-- Create date: 2020-05-20
-- Description:	
-- =============================================
	--- EXEC SP_RPTGetSalarySheetByPaymentMode 0,'BankAccount',0,'2020-01-01 12:00:00.000',0,0
ALTER PROCEDURE [dbo].[SP_RPTGetSalarySheetByPaymentMode] 
(
@PeriodId INT,
@SalaryPaymentMode NVARCHAR(100),
@BranchID INT = 0,
@PrintDate datetime=null,
@MonthId INT = 0,
@SalaryYearId INT = 0

)
AS
BEGIN

	SELECT Sl,FullName,IDNumber,DesignationName,JoiningDate,ConfirmationDate,SalaryACNo,MobileNo,PeriodName,DaysWorking,MonthName,Year,
	StartDate,EndDate,GrossAmount,Deduction,IncomeTax,(GrossAmount+Arrear-Deduction-IncomeTax)NetSalary,isnull(ConfirmationSalary,'')ConfirmationSalary,Arrear,
	BranchName,PrintDate,Remarks,YearName,[dbo].[fnIntegerToWords](cast(TotalNetAmount as int))NetAmountInword FROM
	(SELECT CONVERT(VARCHAR,ROW_NUMBER() Over (Order by EMP.FullName)) As Sl, EMP.FullName,EMP.EmpId IDNumber,D.DesignationName,Convert(nvarchar(15), cast(JoiningDate as Date),106)JoiningDate,
	Convert(nvarchar(15), cast(ConfirmationDate as Date),106)ConfirmationDate,SalaryACNo, EMP.MobileNo ,ES.GrossAmount,
	  ES.NetAmount , SP.PeriodName,SP.DaysWorking,SP.MonthName,SP.Year,Convert(nvarchar(15), cast(SP.StartDate as Date),106) StartDate,
	  Convert(nvarchar(15), cast(SP.EndDate as Date),106) EndDate,
	  ISNULL((SELECT SUM(Amount) FROM HR_SalaryStructurePeriod S INNER JOIN HR_SalaryHead H ON H.Id=S.HeadId WHERE PeriodId=@PeriodID AND S.EmpId=ES.EmpId AND H.Category=2 AND S.HeadId NOT IN(1015) group by S.EmpId,PeriodId),0)Deduction,
	  Isnull((select Amount from HR_SalaryStructurePeriod WHERE  PeriodId=@PeriodID AND EmpId=ES.EmpId  AND HeadId =1015),0)IncomeTax,
	 ISNULL((select Amount from HR_SalaryStructurePeriod WHERE  PeriodId=@PeriodID AND EmpId=ES.EmpId  AND HeadId =1027),0)Arrear,
	  case when @BranchID=8 then 'Primary Campus' when @BranchID=9 then 'Secondary Campus' else 'Primary & Secondary Campus' end BranchName,Convert(nvarchar(15), cast(@PrintDate as Date),104)PrintDate,
	  (SELECT  STUFF((SELECT ' and ' + Remarks FROM HR_SalaryStructurePeriod WHERE PeriodId=ES.SalaryPeriodId AND EmpId=ES.EmpId FOR XML PATH('')), 1, 4, '')) Remarks,
	  SY.YearName,(SELECT isnull(ConfirmationSalary,0)ConfirmationSalary FROM Emp_BasicInfo WHERE EmpBasicInfoID=ES.EmpId AND ConfirmationDate BETWEEN SY.FromDate and ToDate)ConfirmationSalary,
	  (SELECT sum(NetAmount) FROM HR_SalaryPayDetails ES 
	INNER JOIN Emp_BasicInfo EMP ON ES.EmpId = EMP.EmpBasicInfoID --AND ES.SalaryPeriodId=CASE WHEN @PeriodId<>0 THEN @PeriodId ELSE ES.SalaryPeriodId END
	INNER JOIN HR_SalaryPeriod SP ON SP.Id = ES.SalaryPeriodId
	WHERE ES.SalaryPeriodId = CASE WHEN @PeriodId<>0 THEN @PeriodId ELSE ES.SalaryPeriodId END and SalaryPaymentMode=@SalaryPaymentMode
	and EMP.BranchID=CASE WHEN @BranchID<>0 THEN @BranchID ELSE EMP.BranchID END)TotalNetAmount
	FROM HR_SalaryPayDetails ES 
	INNER JOIN Emp_BasicInfo EMP ON ES.EmpId = EMP.EmpBasicInfoID -- AND ES.SalaryPeriodId=@PeriodId
	INNER JOIN Emp_Designation D ON D.DesignationID=EMP.DesignationID
	INNER JOIN HR_SalaryPeriod SP ON SP.Id = ES.SalaryPeriodId
	INNER JOIN HR_SalaryYear SY ON SY.Id = SP.SalaryYearId
	WHERE ES.SalaryPeriodId = CASE WHEN @PeriodId<>0 THEN @PeriodId ELSE ES.SalaryPeriodId END and SalaryPaymentMode=@SalaryPaymentMode
	and EMP.BranchID=CASE WHEN @BranchID<>0 THEN @BranchID ELSE EMP.BranchID END
    and SP.Month=CASE WHEN @MonthId<>0 THEN @MonthId ELSE SP.Month END
	and SP.SalaryYearId=CASE WHEN @SalaryYearId<>0 THEN @SalaryYearId ELSE SP.SalaryYearId END
	)T ORDER BY FullName



END


