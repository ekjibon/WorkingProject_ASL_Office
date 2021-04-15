--USE [cgsd_new_2019_test_20200112]
GO
/****** Object:  StoredProcedure [dbo].[SP_RPTGetSalaryIncrement]    Script Date: 4/26/2020 10:25:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	--- EXEC SP_RPTGetSalaryIncrement 1,'20200401'
CREATE PROCEDURE [dbo].[SP_RPTGetSalaryIncrement] 
(
@EmpId INT,
@SalaryDate NVARCHAR(12)
)
AS
BEGIN
	SELECT   EI.FullName,EI.EmpId IDNumber,D.DesignationName,Convert(nvarchar(15), cast(@SalaryDate as Date),106)SalaryDate,
	Convert(nvarchar(15), cast(getdate() as Date),106)PrintDate--,ISNULL(H.AmountAfterIncrement,0)AmountAfterIncrement
	,CASE WHEN EI.Gender='Male' THEN 'Mr.' 
		  WHEN EI.Gender='Female' AND MaritalStatus='Married' THEN 'Mrs.' 
		  WHEN EI.Gender='Female' AND MaritalStatus='Single' THEN 'Miss.'
		  ELSE '' END Address 

	FROM  Emp_BasicInfo EI 
	LEFT JOIN HR_SalaryIncrement H ON H.EmpId=EI.EmpBasicInfoID 
	LEFT JOIN Emp_Designation D ON D.DesignationID=EI.DesignationID
	WHERE  EI.EmpBasicInfoID=@EmpId AND EI.IsDeleted = 0 AND EI.Status='A' 



END

