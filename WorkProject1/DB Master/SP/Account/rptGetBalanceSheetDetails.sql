IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetBalanceSheetDetails]'))
BEGIN
DROP PROCEDURE  rptGetBalanceSheetDetails
END
GO
SET ANSI_NULLS ON 
SET QUOTED_IDENTIFIER ON
GO
--rptGetBalanceSheetDetails
Create PROCEDURE [dbo].rptGetBalanceSheetDetails 
AS
BEGIN  
DECLARE @TotalAmountLiabilities AS decimal
DECLARE @TotalAmountAsset AS decimal
DECLARE @TotalProfitLoss AS decimal

SELECT @TotalAmountLiabilities =  SUM(CurrentBalance) FROM
	(SELECT  led2.Name ParentName,led1.LedgerId,led1.Name,led1.CurrentBalance,led1.CurrentBalanceDc,led1.ParentId, led2.LedgerId PId FROM dbo.ACC_Ledgers led1
	JOIN dbo.ACC_Ledgers led2 on led2.LedgerId=led1.ParentId
	JOIN dbo.ACC_Ledgers led3 on led3.LedgerId=led2.ParentId
	  where led1.IsDisplay=1 and led2.IsDisplay=1 and led1.RootGroupId=2 AND led1.Status = 'A' AND led1.CurrentBalance<>0
	  	  union all
  Select 'Profit & Loss  A/C' as ParentName,0,'Opening Balance Current Period' as Name, (select SUM(led1.CurrentBalance) FROM dbo.ACC_Ledgers led1 where led1.RootGroupId=3 and led1.IsDisplay=1 and led1.IsLedger=1) 
-(select SUM(led1.CurrentBalance) FROM dbo.ACC_Ledgers led1 where led1.RootGroupId=4 and led1.IsDisplay=1 and led1.IsLedger=1) as CurrentBalance ,0,0,0)t
	
	SELECT @TotalAmountAsset =  SUM(CurrentBalance) FROM
	(  SELECT  led2.Name ParentName,led1.LedgerId,led1.Name,  (SELECT Sum(CurrentBalance) FROM dbo.ACC_Ledgers WHERE RootGroupId =1 AND LedgerId =led1.LedgerId ) CurrentBalance,led1.CurrentBalanceDc,led1.RootGroupId, led2.LedgerId PId FROM dbo.ACC_Ledgers led1
	JOIN dbo.ACC_Ledgers led2 on led2.LedgerId=led1.ParentId
	  where led1.IsDisplay=1 and led2.IsDisplay=1 and led1.RootGroupId=1 and led1.IsLedger=1 
	  AND led1.Status = 'A' AND led1.CurrentBalance<>0
	  group by led2.Name ,led1.LedgerId,led1.Name,led1.CurrentBalanceDc,led1.RootGroupId, led2.LedgerId )s


	SELECT  led2.Name ParentName,led1.LedgerId,led1.Name,led1.OpenningBalance,led1.CurrentBalance,(SELECT SUM(CurrentBalance) FROM dbo.ACC_Ledgers WHERE ParentId = led1.ParentId) AS CurrentTotalwithperent,led1.CurrentBalanceDc,led1.ParentId, led2.LedgerId PId,0 AS totalP,0 AS BranchId,@TotalAmountLiabilities AS TotalAmountLiabilities FROM dbo.ACC_Ledgers led1
	JOIN dbo.ACC_Ledgers led2 on led2.LedgerId=led1.ParentId
	JOIN dbo.ACC_Ledgers led3 on led3.LedgerId=led2.ParentId
	  where led1.IsDisplay=1 and led2.IsDisplay=1 and led1.RootGroupId=2 AND led1.Status = 'A' AND led1.CurrentBalance<>0
	  union all
    SELECT led3.Name,AL.LedgerId, AL.Name,AL.OpenningBalance,Al.CurrentBalance,0,Al.CurrentBalanceDc,Al.ParentId,Led3.LedgerId PId, SUM(T.DrTotal),T.AccBranchId,0
	FROM ACC_Ledgers AL
	JOIN dbo.ACC_Ledgers led3 on led3.LedgerId=AL.ParentId
	LEFT JOIN ACC_TransactionDetail TD  ON  AL.LedgerId = TD.LedgerId
	LEFT JOIN ACC_Transaction T ON T.Id = TD.TransactionId
	WHERE  AL.RootGroupId = 2  AND AL.Status = 'A' AND AL.CurrentBalance<>0 AND AL.OpenningBalance <>0 AND Al.IsDisplay = 1 AND led3.IsDisplay = 1 AND T.IsApproved = 1 AND T.IsReject = 0 
	GROUP BY AL.LedgerId,Al.OpenningBalance,Al.ParentId,T.AccBranchId,AL.Name,led3.Name,Al.CurrentBalance,Al.CurrentBalanceDc,Led3.LedgerId
  union all
   Select 'Profit & Loss  A/C' as ParentName,0,'Opening Balance Current Period' as Name,0,0, (select SUM(led1.CurrentBalance) FROM dbo.ACC_Ledgers led1 where led1.RootGroupId=3 and led1.IsDisplay=1 and led1.IsLedger=1) 
-(select SUM(led1.CurrentBalance) FROM dbo.ACC_Ledgers led1 where led1.RootGroupId=4 and led1.IsDisplay=1 and led1.IsLedger=1) as CurrentTotalwithperent,0,0,0,0,0,0

	  SELECT  led2.Name ParentName,led1.LedgerId,led1.Name,led1.OpenningBalance,  (SELECT Sum(CurrentBalance) FROM dbo.ACC_Ledgers WHERE RootGroupId =1 AND LedgerId =led1.LedgerId ) CurrentBalance,(SELECT SUM(CurrentBalance) FROM dbo.ACC_Ledgers WHERE ParentId = led1.ParentId) AS CurrentTotalwithperent,led1.CurrentBalanceDc,led1.RootGroupId, led2.LedgerId PId,0 AS totalP,0 AS BranchId,@TotalAmountAsset AS TotalAmountAsset FROM dbo.ACC_Ledgers led1
	JOIN dbo.ACC_Ledgers led2 on led2.LedgerId=led1.ParentId
	  where led1.IsDisplay=1 and led2.IsDisplay=1 and led1.RootGroupId=1 and led1.IsLedger=1 
	  AND led1.Status = 'A' AND led1.CurrentBalance<>0
	  group by led2.Name ,led1.LedgerId,led1.Name,led1.CurrentBalanceDc,led1.RootGroupId, led2.LedgerId,led1.OpenningBalance,led1.ParentId 
	  union all
	  SELECT led3.Name,AL.LedgerId, AL.Name,AL.OpenningBalance,Al.CurrentBalance,0,Al.CurrentBalanceDc,Al.ParentId,Led3.LedgerId PId, SUM(T.DrTotal),T.AccBranchId,0
	FROM ACC_Ledgers AL
	JOIN dbo.ACC_Ledgers led3 on led3.LedgerId=AL.ParentId
	LEFT JOIN ACC_TransactionDetail TD  ON  AL.LedgerId = TD.LedgerId
	LEFT JOIN ACC_Transaction T ON T.Id = TD.TransactionId
	WHERE  AL.RootGroupId = 1 AND AL.Status = 'A' AND AL.CurrentBalance<>0 AND AL.OpenningBalance <>0 AND Al.IsDisplay = 1 AND led3.IsDisplay = 1 AND T.IsApproved = 1 AND T.IsReject = 0 
	GROUP BY AL.LedgerId,Al.OpenningBalance,Al.ParentId,T.AccBranchId,AL.Name,led3.Name,Al.CurrentBalance,Al.CurrentBalanceDc,Led3.LedgerId
	
	


END









--SELECT  led2.Name ParentName,led1.LedgerId,  led1.Name,led1.OpenningBalance,led1.CurrentBalance,led1.CurrentBalanceDc,led1.ParentId, led2.LedgerId PId , 0 AS totalP, 0 AS totalS FROM dbo.ACC_Ledgers led1
--	JOIN dbo.ACC_Ledgers led2 on led2.LedgerId=led1.ParentId
--	JOIN dbo.ACC_Ledgers led3 on led3.LedgerId=led2.ParentId
--	LEFT JOIN ACC_TransactionDetail TD  ON  led1.LedgerId = TD.LedgerId
--	LEFT JOIN ACC_Transaction T ON T.Id = TD.TransactionId
--	  where led1.IsDisplay=1 and led2.IsDisplay=1 and led1.RootGroupId=2 AND led1.Status = 'A' AND led1.CurrentBalance<>0
--	 GROUP BY led2.Name,led1.LedgerId,led1.OpenningBalance,led1.CurrentBalance,led1.CurrentBalanceDc,led1.ParentId, led2.LedgerId,T.AccBranchId,led1.Name
--	 union all
	 
--	SELECT led3.Name,AL.LedgerId,CASE WHEN T.AccBranchId = 1 THEN AL.Name + '(Primary)' WHEN T.AccBranchId = 2 THEN AL.Name + '(Secondary)' ELSE  AL.Name END Name,0,0,Al.CurrentBalanceDc,Al.ParentId,Led3.LedgerId PId,CASE WHEN T.AccBranchId = 1 THEN SUM(T.DrTotal) ELSE 0 END,CASE WHEN T.AccBranchId = 2 THEN SUM(T.DrTotal) ELSE 0 END
--	FROM ACC_Ledgers AL
--	JOIN dbo.ACC_Ledgers led3 on led3.LedgerId=AL.ParentId
--	LEFT JOIN ACC_TransactionDetail TD  ON  AL.LedgerId = TD.LedgerId
--	LEFT JOIN ACC_Transaction T ON T.Id = TD.TransactionId
--	WHERE  AL.RootGroupId = 2  AND AL.Status = 'A' AND AL.CurrentBalance<>0 AND AL.OpenningBalance <>0 AND Al.IsDisplay = 1 AND led3.IsDisplay = 1 AND T.IsApproved = 1 AND T.IsReject = 0 
--	GROUP BY AL.LedgerId,Al.OpenningBalance,Al.ParentId,T.AccBranchId,AL.Name,led3.Name,Al.CurrentBalance,Al.CurrentBalanceDc,Led3.LedgerId

-- union all
--Select 'Profit & Loss  A/C' as ParentName,0,'Opening Balance Current Period' as Name,0, (select SUM(led1.CurrentBalance) FROM dbo.ACC_Ledgers led1 where led1.RootGroupId=3 and led1.IsDisplay=1 and led1.IsLedger=1) 
---(select SUM(led1.CurrentBalance) FROM dbo.ACC_Ledgers led1 where led1.RootGroupId=4 and led1.IsDisplay=1 and led1.IsLedger=1) as CurrentBalance ,0,0,0,0,0


--     SELECT  led2.Name ParentName,led1.LedgerId, led1.Name, led1.OpenningBalance, (SELECT Sum(CurrentBalance) FROM dbo.ACC_Ledgers WHERE RootGroupId =1 AND LedgerId =led1.LedgerId ) CurrentBalance,led1.CurrentBalanceDc,led1.RootGroupId, led2.LedgerId PId, 0 AS totalP,t.AccBranchId FROM dbo.ACC_Ledgers led1
--	   JOIN dbo.ACC_Ledgers led2 on led2.LedgerId=led1.ParentId
--	   	LEFT JOIN ACC_TransactionDetail TD  ON  led1.LedgerId = TD.LedgerId
--	    LEFT JOIN ACC_Transaction T ON T.Id = TD.TransactionId
--	   where led1.IsDisplay=1 and led2.IsDisplay=1 and led1.RootGroupId=1 and led1.IsLedger=1 
--	   AND led1.Status = 'A' AND led1.CurrentBalance<>0 
--	   group by led2.Name ,led1.LedgerId,led1.Name,led1.CurrentBalanceDc,led1.RootGroupId, led2.LedgerId,led1.OpenningBalance,T.AccBranchId,led1.Name

--	    union all
--	SELECT led3.Name,AL.LedgerId, AL.Name,0,0,Al.CurrentBalanceDc,Al.ParentId,Led3.LedgerId PId,T.DrTotal,T.AccBranchId
--	FROM ACC_Ledgers AL
--	JOIN dbo.ACC_Ledgers led3 on led3.LedgerId=AL.ParentId
--	LEFT JOIN ACC_TransactionDetail TD  ON  AL.LedgerId = TD.LedgerId
--	LEFT JOIN ACC_Transaction T ON T.Id = TD.TransactionId
--	WHERE  AL.RootGroupId = 1  AND AL.Status = 'A' AND AL.CurrentBalance<>0 AND AL.OpenningBalance <>0 AND Al.IsDisplay = 1 AND led3.IsDisplay = 1 AND T.IsApproved = 1 AND T.IsReject = 0 
--	GROUP BY AL.LedgerId,Al.OpenningBalance,Al.ParentId,T.AccBranchId,AL.Name,led3.Name,Al.CurrentBalance,Al.CurrentBalanceDc,Led3.LedgerId

