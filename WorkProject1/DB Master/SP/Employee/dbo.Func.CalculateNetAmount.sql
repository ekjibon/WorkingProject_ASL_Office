/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CalculateNetAmount]'))
BEGIN
DROP FUNCTION  CalculateNetAmount
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Biplob>
-- Create date: <01-Jun-2017,>
-- Description:	<For Latter grade ad GP  Calculation>
-- =============================================

 -- EXEC dbo.CalculateNetAmount( 10,2)
CREATE FUNCTION [dbo].[CalculateNetAmount]
(
 @EmpId INT ,
 @PeriodId INT
)
RETURNS  decimal(10,2)
AS
BEGIN

DECLARE   @GrossAmt DECIMAL(10,2) , @DeductAmt DECIMAL(10,2)

 SELECT @GrossAmt = ISNULL(SUM(AMOUNT),0) FROM HR_EmployeeSalary E 
 INNER JOIN HR_SalaryHead H ON H.Id = E.HeadId
 WHERE E.PeriodId = @PeriodId AND EmpId= @EmpId AND H.Category=1

 SELECT @DeductAmt = ISNULL(SUM(AMOUNT),0) FROM HR_EmployeeSalary E 
 INNER JOIN HR_SalaryHead H ON H.Id = E.HeadId
 WHERE E.PeriodId = @PeriodId AND EmpId= @EmpId AND H.Category=2
 

RETURN  @GrossAmt- @DeductAmt
END

GO


