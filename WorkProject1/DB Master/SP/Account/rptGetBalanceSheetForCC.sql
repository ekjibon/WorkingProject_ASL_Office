IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetBalanceSheetForCC]'))
BEGIN
DROP PROCEDURE  rptGetBalanceSheetForCC
END
GO
SET ANSI_NULLS ON 
SET QUOTED_IDENTIFIER ON
GO
--rptGetBalanceSheetForCC
Create PROCEDURE [dbo].rptGetBalanceSheetForCC 
AS
BEGIN  

	SELECT  led2.Name ParentName,led1.LedgerId,led1.Name,led1.CurrentBalance,led1.CurrentBalanceDc,led1.ParentId, led2.LedgerId PId,'' AS CostCenterName,0 AS CostCenterAmount FROM dbo.ACC_Ledgers led1
	JOIN dbo.ACC_Ledgers led2 on led2.LedgerId=led1.ParentId
	JOIN dbo.ACC_Ledgers led3 on led3.LedgerId=led2.ParentId
	  where led1.IsDisplay=1 and led2.IsDisplay=1 and led1.RootGroupId=2 AND led1.Status = 'A' AND led1.CurrentBalance<>0
	  
	     UNION ALL

	SELECT L1.Name,CCD.LedgerId,L.Name,0,0,0,0,CC.CostCenterName, SUM(CCD.Amount) AS CostCenterAmount
	FROM [dbo].[ACC_CostCenterDetails] CCD
	INNER JOIN [dbo].[ACC_CostCenter] CC ON CC.Id = CCD.CostCenterId
	INNER JOIN ACC_Ledgers L ON L.LedgerId= CCD.LedgerId
	JOIN ACC_Ledgers L1 ON L1.LedgerId = L.ParentId
	WHERE CCD.LedgerId = 1757
	GROUP BY CCD.LedgerId,CC.CostCenterName,L.Name,L1.Name
	  

	  union all
Select 'Profit & Loss  A/C' as ParentName,0,'Opening Balance Current Period' as Name, (select SUM(led1.CurrentBalance) FROM dbo.ACC_Ledgers led1 where led1.RootGroupId=3 and led1.IsDisplay=1 and led1.IsLedger=1) 
-(select SUM(led1.CurrentBalance) FROM dbo.ACC_Ledgers led1 where led1.RootGroupId=4 and led1.IsDisplay=1 and led1.IsLedger=1) as CurrentBalance ,0,0,0,'',0



	--  SELECT  led2.Name ParentName,led1.LedgerId,led1.Name,Sum( led1.CurrentBalance) CurrentBalance,led1.CurrentBalanceDc,led1.RootGroupId, led2.LedgerId PId FROM dbo.ACC_Ledgers led1
	--JOIN dbo.ACC_Ledgers led2 on led2.LedgerId=led1.ParentId
	--JOIN dbo.ACC_TransactionDetail td on td.LedgerId=led1.LedgerId
	--  where led1.IsDisplay=1 and led2.IsDisplay=1 and led1.RootGroupId=1 and led1.IsLedger=1
	--  group by led2.Name ,led1.LedgerId,led1.Name,led1.CurrentBalanceDc,led1.RootGroupId, led2.LedgerId 
		  SELECT  led2.Name ParentName,led1.LedgerId,led1.Name,(SELECT Sum(CurrentBalance) FROM dbo.ACC_Ledgers WHERE RootGroupId =1 AND LedgerId =led1.LedgerId ) CurrentBalance,led1.CurrentBalanceDc,led1.RootGroupId, led2.LedgerId PId,'' AS CostCenterName,0 AS CostCenterAmount FROM dbo.ACC_Ledgers led1
	JOIN dbo.ACC_Ledgers led2 on led2.LedgerId=led1.ParentId
	JOIN dbo.ACC_TransactionDetail td on td.LedgerId=led1.LedgerId
	JOIN [dbo].[ACC_Transaction] T ON T.Id = Td.TransactionId
	  where led1.IsDisplay=1 and led2.IsDisplay=1 and led1.RootGroupId=1 and led1.IsLedger=1 AND T.IsApproved =1 AND T.IsReject = 0 AND led1.Status = 'A' AND led1.CurrentBalance<>0
	  group by led2.Name ,led1.LedgerId,led1.Name,led1.CurrentBalanceDc,led1.RootGroupId, led2.LedgerId 


	  	     UNION ALL

	SELECT L1.Name,CCD.LedgerId,L.Name,0,0,0,0,CC.CostCenterName, SUM(CCD.Amount) AS CostCenterAmount
	FROM [dbo].[ACC_CostCenterDetails] CCD
	INNER JOIN [dbo].[ACC_CostCenter] CC ON CC.Id = CCD.CostCenterId
	INNER JOIN ACC_Ledgers L ON L.LedgerId= CCD.LedgerId
	JOIN ACC_Ledgers L1 ON L1.LedgerId = L.ParentId
	WHERE CCD.LedgerId = 1678
	GROUP BY CCD.LedgerId,CC.CostCenterName,L.Name,L1.Name


END