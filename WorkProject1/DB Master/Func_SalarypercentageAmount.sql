
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SalarypercentageAmount]'))
BEGIN
DROP FUNCTION  SalarypercentageAmount
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Khaled
-- =============================================
--select dbo.SalarypercentageAmount(40000,80) 
CREATE FUNCTION [dbo].[SalarypercentageAmount]
(
 @CurrentSalary decimal(10,2) ,
 @Amount decimal(10,2)
 --,@TotalExamCount int
)
RETURNS  decimal(10,2)
AS
BEGIN
	DECLARE @TotalConv DECIMAL(10,2)
	SET @TotalConv =(@CurrentSalary)*(@Amount/100)
	RETURN @TotalConv
END 
GO