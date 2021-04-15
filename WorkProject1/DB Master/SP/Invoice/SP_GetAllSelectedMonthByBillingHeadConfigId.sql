IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_GetAllSelectedMonthByBillingHeadConfigId]'))
BEGIN
DROP PROCEDURE  SP_GetAllSelectedMonthByBillingHeadConfigId
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
	--- EXEC SP_GetAllSelectedMonthByBillingHeadConfigId 1

CREATE PROCEDURE SP_GetAllSelectedMonthByBillingHeadConfigId
(
	@BillingHeadConfigId int
)
AS
BEGIN
	SELECT IBHCD.[YEAR] As [Year],IBHCD.MonthId,IBHCD.[MonthName] ,
	CASE WHEN IBHC.ClientId IN(SELECT IIG.ClientId FROM Invoice_InvoiceGenerate IIG WHERE IIG.MonthId=IBHCD.MonthId and IIG.Year=IBHCD.Year  and IIG.BillingHeadId=IBHC.BillingHeadId) THEN '1'
	ELSE '0' END IsProcess
	FROM Invoice_BillingHeadConfig IBHC
	inner join Invoice_BillingHeadConfigDetails IBHCD ON IBHC.Id=IBHCD.BillingHeadConfigId
	WHERE IBHCD.BillingHeadConfigId=@BillingHeadConfigId
	
END