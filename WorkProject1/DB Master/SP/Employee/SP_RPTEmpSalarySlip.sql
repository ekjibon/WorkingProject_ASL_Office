
GO
/****** Object:  StoredProcedure [dbo].[SP_RPTEmpSalarySlip]    Script Date: 4/19/2020 12:07:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Azmal
-- Create date: 4/19/2020
-- Description:	
-- =============================================
	--- EXEC SP_RPTEmpSalarySlip 2,'11,3,13'
ALTER PROCEDURE [dbo].[SP_RPTEmpSalarySlip] 
@PeriodId INT,
@EmpId  VARCHAR(max) =null
AS
BEGIN

DECLARE @Dateoflate NVARCHAR(MAX)
DECLARE @DateofAbsent NVARCHAR(MAX)
DECLARE @StartDate as NVARCHAR(12)
DECLARE @EndDate as NVARCHAR(12)
DECLARE @CategoryID AS INT


	SELECT @StartDate= CONVERT(NVARCHAR(12),CAST(StartDate AS DATE), 112), @EndDate=  CONVERT(NVARCHAR(12),CAST(EndDate AS DATE), 112), @CategoryID =CategoryID
	FROM HR_SalaryPeriod WHERE ID=@PeriodID


	SELECT  EMP.FullName,EMP.EmpId IDNumber,D.DesignationName,Convert(nvarchar(15), cast(JoiningDate as Date),106)JoiningDate,
	Convert(nvarchar(15), cast(ConfirmationDate as Date),106)ConfirmationDate,SalaryACNo, EMP.MobileNo ,ES.GrossAmount,
	  ES.NetAmount NetSalary, SP.PeriodName,SP.DaysWorking,SP.MonthName,SP.Year,Convert(nvarchar(15), cast(SP.StartDate as Date),106) StartDate,
	  Convert(nvarchar(15), cast(SP.EndDate as Date),106) EndDate,HeadName DeductHeadName,isnull(Amount,0)DeductAmount
	,CASE WHEN HeadId=1005 THEN STUFF((SELECT ', ' + CONVERT(NVARCHAR(12),CAST(A.Intime AS DATE), 106) from [dbo].[Emp_Attendance] A
			INNER JOIN Emp_BasicInfo EI ON EI.EmpBasicInfoID =ES.EmpId
			WHERE CONVERT(NVARCHAR(12),CAST(A.Intime AS DATE), 112) between @StartDate and @EndDate AND A.Islate=1 
			AND A.EmpId=ES.EmpId
            FOR XML PATH('')), 1, 1, '')
		    WHEN HeadId=1008 THEN STUFF((SELECT ', ' + CONVERT(NVARCHAR(12),CAST(A.Intime AS DATE), 106) from [dbo].[Emp_Attendance] A
	INNER JOIN Emp_BasicInfo EI ON EI.EmpBasicInfoID =ES.EmpId
	WHERE CONVERT(NVARCHAR(12),CAST(A.Intime AS DATE), 112) between @StartDate and @EndDate  AND A.IsLeave=0 AND A.IsPresent=0 AND A.IsAbsetLongHoliday = 0
	AND A.EmpId=ES.EmpId
            FOR XML PATH('')), 1, 1, '')	 ELSE '' END DateofLateabsent
	 ,ISNULL((select Amount from HR_SalaryStructurePeriod WHERE  PeriodId=@PeriodID AND EmpId=ES.EmpId  AND HeadId =1027),0)Arrear 
	 ,HP.Remarks DeductRemarks
	FROM  HR_SalaryPayDetails ES  
	LEFT JOIN (SELECT H.HeadName ,P.Amount,P.EmpId,P.HeadId,P.Remarks FROM HR_SalaryHead H INNER JOIN HR_SalaryStructurePeriod P ON P.HeadId=H.ID WHERE H.Category=2 and P.PeriodId=@PeriodId) HP ON HP.EmpId=ES.EmpId 
	INNER JOIN Emp_BasicInfo EMP ON ES.EmpId = EMP.EmpBasicInfoID AND ES.SalaryPeriodId=@PeriodId
	INNER JOIN Emp_Designation D ON D.DesignationID=EMP.DesignationID
	INNER JOIN HR_SalaryPeriod SP ON SP.Id = ES.SalaryPeriodId
	WHERE ES.SalaryPeriodId = @PeriodId AND EMP.EmpBasicInfoID in  (SELECT * FROM STRING_SPLIT(@EmpId,','))
	ORDER BY EMP.FullName
	



END
