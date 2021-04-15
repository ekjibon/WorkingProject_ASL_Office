IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetProfitLossForCC]'))
BEGIN
DROP PROCEDURE  rptGetProfitLossForCC
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].rptGetProfitLossForCC -- rptGetProfitLossForCC 12
@FiscalYearID int
AS
BEGIN  
SELECT DISTINCT  led2.Name ParentName,led1.*,(SELECT SUM(CurrentBalance) FROM ACC_Ledgers WHERE RootGroupId = 3 AND IsDisplay=1) AS CurrentAmountTotal,  led2.LedgerId PId FROM dbo.ACC_Ledgers led1
	JOIN dbo.ACC_Ledgers led2 on led2.LedgerId=led1.ParentId
		INNER JOIN dbo.ACC_TransactionDetail TD ON TD.LedgerId = led2.LedgerId OR TD.LedgerId = led1.LedgerId
		INNER JOIN dbo.ACC_Transaction T ON T.Id = TD.TransactionId
	  where led1.IsDisplay=1 and led2.IsDisplay=1 and led1.RootGroupId=3 AND led1.Status = 'A' AND led1.CurrentBalance<>0 AND T.IsApproved =1 AND T.IsReject = 0
	   AND T.FiscalYearId = @FiscalYearID
order by led1.[DisplayOrder]

	SELECT DISTINCT  led2.Name ParentName,led1.Name,led1.[LedgerId],led1.[CurrentBalance],led1.[ParentId],(SELECT SUM(CurrentBalance) FROM ACC_Ledgers WHERE RootGroupId = 4) AS CurrentAmountTotal,  led2.LedgerId PId,''AS CostcenterName,0 AS CostCenterAmount FROM dbo.ACC_Ledgers led1
	JOIN dbo.ACC_Ledgers led2 on led2.LedgerId=led1.ParentId
		INNER JOIN dbo.ACC_TransactionDetail TD ON TD.LedgerId = led2.LedgerId OR TD.LedgerId = led1.LedgerId
		INNER JOIN dbo.ACC_Transaction T ON T.Id = TD.TransactionId
	  where led1.IsDisplay=1 and led2.IsDisplay=1 and led1.RootGroupId=4 AND led1.Status = 'A' AND led1.CurrentBalance<>0 AND T.IsApproved =1 AND T.IsReject = 0
	   AND T.FiscalYearId = @FiscalYearID
      --order by led1.[DisplayOrder]
	  GROUP BY led1.[LedgerId],led1.[CurrentBalance],led1.[ParentId],led1.Name,led2.Name, led2.LedgerId,led2.ParentId

  UNION ALL
	SELECT L1.Name,L.Name,CCD.LedgerId,0,L1.LedgerId,0,L1.LedgerId,CC.CostCenterName AS CostcenterName, SUM(CCD.Amount) AS CostCenterAmount
	FROM [dbo].[ACC_CostCenterDetails] CCD
	INNER JOIN [dbo].[ACC_CostCenter] CC ON CC.Id = CCD.CostCenterId
	INNER JOIN ACC_Ledgers L ON L.LedgerId= CCD.LedgerId
	JOIN ACC_Ledgers L1 ON L1.LedgerId = L.ParentId
	GROUP BY CCD.LedgerId,CC.CostCenterName,L.Name,L1.Name,L1.LedgerId
END