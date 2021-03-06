IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_GetAllBillingHeadConfig]'))
BEGIN
DROP PROCEDURE  SP_GetAllBillingHeadConfig
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
	--- EXEC SP_GetAllBillingHeadConfig 0,0,0,'',0,2020,1,3
CREATE PROCEDURE [dbo].[SP_GetAllBillingHeadConfig]
(
	@ClientId INT = 0,
	@InvoiceServiceId INT = 0,
	@BillingHeadId INT = 0,
	@BillingHeadType VARCHAR(100) = '',
	@BillingMethodId INT = 0,
	@Year INT = 0,
	@Month INT = 0,
	@Block INT
)
AS
BEGIN
	IF(@Block =1)
	BEGIN
		SELECT CC.FullName ,CC.ClientId AS GenerateClientId ,ISV.ServiceName ,IBH.BillingHeadName ,IBM.BillingMethodName ,IBHC.ClientId ,IBHC.BillingHeadId ,IBHC.BillingMethodId ,IBHC.[Year] ,IBHC.MaskAmount
			  ,IBHC.InvoiceServiceId ,IBHC.Id ,IBHC.NoMaskAmount ,IBHC.BillingHeadType ,IBHC.Rate ,IBHC.MinAmount,ISNULL((SELECT  STUFF((SELECT ', ' + MonthName FROM Invoice_BillingHeadConfigDetails
				WHERE BillingHeadConfigId=IBHC.Id FOR XML PATH('')), 1, 1, '')),'') MonthNames

		FROM 
			Invoice_BillingHeadConfig IBHC
			INNER JOIN CRM_Client CC ON IBHC.ClientId = CC.Id AND CC.ActivityStatus ='A'
			INNER JOIN Invoice_Service ISV ON IBHC.InvoiceServiceId = ISV.Id
			INNER JOIN Invoice_BillingHead IBH ON IBHC.BillingHeadId = IBH.Id
			INNER JOIN Invoice_BillingMethod IBM ON IBHC.BillingMethodId = IBM.Id

		WHERE 
			IBHC.IsDeleted = 0 AND  IBHC.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE IBHC.ClientId END
			AND IBHC.InvoiceServiceId = CASE WHEN @InvoiceServiceId<>0 THEN @InvoiceServiceId ELSE IBHC.InvoiceServiceId END
			AND IBHC.BillingHeadId = CASE WHEN @BillingHeadId<>0 THEN @BillingHeadId ELSE IBHC.BillingHeadId END
			AND IBHC.BillingHeadType = CASE WHEN @BillingHeadType<>'' THEN @BillingHeadType ELSE IBHC.BillingHeadType END
			AND IBHC.BillingMethodId = CASE WHEN @BillingMethodId<>0 THEN @BillingMethodId ELSE IBHC.BillingMethodId END
	END
	IF(@Block =2) --- EXEC SP_GetAllBillingHeadConfig 0,0,0,'',0,2020,2,2
	BEGIN
		SELECT IBHC.ClientId , cc.FullName,CC.ShortName, ISNULL(cc.ClientId,'')+'-'+CC.ShortName AS GenerateClientId, IBHCD.Year, IBHCD.MonthId, (SELECT SUM(TotalAmount) FROM Invoice_BillingProcess IBP WHERE IBHC.ClientId=IBP.ClientId AND IBP.IsDeleted=0 AND IBHC.Year=IBP.Year AND IBP.MonthId=IBHCD.MonthId)ProcessAmount

		FROM 
			Invoice_BillingHeadConfig IBHC
			INNER JOIN CRM_Client CC ON IBHC.ClientId = CC.Id AND CC.ActivityStatus ='A'
			INNER JOIN Invoice_BillingHeadConfigDetails IBHCD ON IBHC.Id = IBHCD.BillingHeadConfigId 
			

		WHERE 
			IBHC.IsDeleted = 0  
			AND  IBHC.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE IBHC.ClientId END
			AND  IBHCD.Year = CASE WHEN @Year<>0 THEN @Year ELSE IBHCD.Year END
			AND  IBHCD.MonthId = CASE WHEN @Month<>0 THEN @Month ELSE IBHCD.MonthId END
			GROUP BY IBHC.ClientId , cc.FullName,CC.ShortName, cc.ClientId, IBHCD.Year, IBHCD.MonthId, IBHC.Year
	END
	IF(@Block =3) --- EXEC SP_GetAllBillingHeadConfig 0,0,0,'',0,2021,2,3
	BEGIN
		SELECT CC.FullName ,CC.ClientId AS GenerateClientId ,CC.ShortName ,ISV.ServiceName ,IBHC.Id BillingHeadConfigId,IBH.BillingHeadName ,IBM.BillingMethodName ,IBHC.ClientId ,IBHC.BillingHeadId ,IBHC.BillingMethodId ,IBHC.[Year] ,IBHC.MaskAmount
			  ,IBHC.InvoiceServiceId ,IBHC.Id ,IBHC.NoMaskAmount ,IBHC.BillingHeadType ,IBHC.Rate ,IBHC.MinAmount,IBHCD.MonthId,IBHCD.Year,IBP.Quantity,IBP.TotalAmount, IBHC.BillingMethodId, IBHC.BillingHeadType,IBHC.InvoiceServiceId
			  , CASE
					WHEN IBHC.ClientId IN(SELECT IIG.ClientId FROM Invoice_InvoiceGenerate IIG WHERE IIG.MonthId=IBHCD.MonthId and DueAmount>0 and IIG.BillingHeadId=IBHC.BillingHeadId AND ISNULL(IsPublish,0)=0) THEN 'ProcessOn'
					WHEN IBHC.ClientId IN(SELECT IIG.ClientId FROM Invoice_InvoiceGenerate IIG WHERE IIG.MonthId=IBHCD.MonthId and DueAmount>0 and IIG.BillingHeadId=IBHC.BillingHeadId AND ISNULL(IsPublish,0)=1) THEN 'Published'
					WHEN IBHC.ClientId IN(SELECT IIG.ClientId FROM Invoice_InvoiceGenerate IIG WHERE IIG.MonthId=IBHCD.MonthId and DueAmount=0 and IIG.BillingHeadId=IBHC.BillingHeadId) THEN 'PaymentDone' ELSE 'Pending' 
				END Status
			 , CASE
					WHEN IBHC.ClientId IN(SELECT IIG.ClientId FROM Invoice_InvoiceGenerate IIG WHERE IIG.MonthId=IBHCD.MonthId  and IIG.BillingHeadId=IBHC.BillingHeadId AND ISNULL(IIG.IsPublish,0)=1) THEN 1
					 ELSE 0
				END IsPublish
				
		FROM 
			Invoice_BillingHeadConfig IBHC
			INNER JOIN CRM_Client CC ON IBHC.ClientId = CC.Id
			INNER JOIN Invoice_Service ISV ON IBHC.InvoiceServiceId = ISV.Id
			INNER JOIN Invoice_BillingHead IBH ON IBHC.BillingHeadId = IBH.Id
			INNER JOIN Invoice_BillingMethod IBM ON IBHC.BillingMethodId = IBM.Id
			INNER JOIN Invoice_BillingHeadConfigDetails IBHCD ON IBHC.Id = IBHCD.BillingHeadConfigId 
			LEFT JOIN Invoice_BillingProcess IBP ON IBP.ClientId = IBHC.ClientId AND IBHCD.Year=IBP.Year  AND IBH.Id =IBP.BillingHeadId AND IBP.MonthId = IBHCD.MonthId

		WHERE 
			IBHC.IsDeleted = 0 AND  IBHC.ClientId = CASE WHEN @ClientId<>0 THEN @ClientId ELSE IBHC.ClientId END
			AND  IBHCD.Year = CASE WHEN @Year<>0 THEN @Year ELSE IBHCD.Year END
			AND  IBHCD.MonthId = CASE WHEN @Month<>0 THEN @Month ELSE IBHCD.MonthId END
			
			
	END
END


