/****** Object:  StoredProcedure [dbo].[InsertSalaryTaxYearIdOnEmpTaxSetup]    Script Date: 06/05/2020 11:33:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[InsertSalaryTaxYearIdOnEmpTaxSetup]'))
BEGIN
DROP PROCEDURE  InsertSalaryTaxYearIdOnEmpTaxSetup
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Author: Khaled
---[dbo].[InsertSalaryTaxYearIdOnEmpTaxSetup] 2
CREATE PROCEDURE [dbo].[InsertSalaryTaxYearIdOnEmpTaxSetup] 
AS
BEGIN
DECLARE @ID INT
SET @ID =(SELECT TOP(1) Id FROM [dbo].[HR_SalaryTaxYear] WHERE IsDeleted = 0 ORDER BY Id DESC)  
 print @ID

INSERT INTO [dbo].[HR_EmployeeTaxSetup]   ([CurrentSalary], [TaxAmount], [IsDeleted], [AddBy], [AddDate], [UpdateBy], [UpdateDate], [Remarks], 
[Status], [IP], [MacAddress], [EmpId], [TaxYearId], [CategoryID] )
	SELECT CurrentSalary,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,EmpBasicInfoID,@ID,CategoryID FROM Emp_BasicInfo	   
END