IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetTrailBalance]'))
BEGIN
DROP PROCEDURE  rptGetTrailBalance
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].rptGetTrailBalance 
	--@FromDate VARCHAR(100),
	--@ToDate	VARCHAR(100)
	@FiscalYearID int
AS
BEGIN  
--  rptGetTrailBalance 12

CREATE TABLE #TrialBalance
(
	LedgerId INT,
	ParentName VARCHAR(100),
	LedgerName VARCHAR(100),
	OpenDebit DECIMAL(18,2),
	OpenCredit DECIMAL(18,2),	
	TotalDebit DECIMAL(18,2),
	TotalCredit DECIMAL(18,2),
	ClosingAmt DECIMAL(18,2),
	ClosingDC INT


)

	INSERT INTO #TrialBalance(LedgerId,ParentName,LedgerName,OpenDebit,OpenCredit,TotalDebit,TotalCredit,ClosingAmt,ClosingDC)
	SELECT DISTINCT TD.LedgerId,(SELECT LG.Name FROM ACC_Ledgers LG WHERE LedgerId = L.ParentId),L.[Name],
	CASE WHEN L.CurrentBalanceDc = 1 THEN dbo.GetLedgerBalance(TD.LedgerId,@FiscalYearID,'Opening') ELSE 0 END,
	CASE WHEN L.CurrentBalanceDc = 2 THEN dbo.GetLedgerBalance(TD.LedgerId,@FiscalYearID,'Opening') ELSE 0 END,
	SUM(TD.DrAmount),
	SUM(TD.CrAmount),
	L.CurrentBalance,
   -- CASE WHEN L.CurrentBalanceDc= 1 THEN ((dbo.GetLedgerBalance(TD.LedgerId,@FiscalYearID,'Opening') + SUM(TD.DrAmount))-(dbo.GetLedgerBalance(TD.LedgerId,@FiscalYearID,'Opening') + SUM(TD.CrAmount))) ELSE 0 END,
	L.CurrentBalanceDc
	FROM ACC_Transaction T 
	INNER JOIN ACC_TransactionDetail TD ON T.Id = TD.TransactionId
	INNER JOIN ACC_Ledgers L ON L.LedgerId= TD.LedgerId
	WHERE T.FiscalYearId = @FiscalYearID AND T.IsApproved = 1 AND T.IsReject = 0
	GROUP BY TD.LedgerId , L.[Name],L.CurrentBalanceDc,L.ParentId,L.CurrentBalance

	INSERT INTO #TrialBalance(LedgerId,ParentName,LedgerName,OpenDebit,OpenCredit,TotalDebit,TotalCredit,ClosingAmt,ClosingDC)
	SELECT DISTINCT LedgerId,(SELECT LG.Name FROM ACC_Ledgers LG WHERE LedgerId =(AL.ParentId)),[Name],
	CASE WHEN OpenningBalanceDc = 1 THEN dbo.GetLedgerBalance(LedgerId,@FiscalYearID,'Opening') ELSE 0 END,
	CASE WHEN OpenningBalanceDc = 2 THEN dbo.GetLedgerBalance(LedgerId,@FiscalYearID,'Opening') ELSE 0 END,
	0,0,CurrentBalance,CurrentBalanceDc
	 --FROM ACC_Ledgers AL WHERE LedgerId IN (597,45)
	FROM ACC_Ledgers AL WHERE LedgerId IN (SELECT LedgerId FROM ACC_Ledgers WHERE OpenningBalance > 0 ) AND OpenningBalance > 0 
	AND LedgerId NOT IN (SELECT LedgerId FROM ACC_TransactionDetail  ) 

	--UPDATE #TrialBalance SET ClosingAmt = (OpenDebit + TotalDebit) - (OpenCredit+TotalCredit)


	SELECT LedgerId,ParentName,LedgerName,OpenDebit,OpenCredit,TotalDebit,TotalCredit,ClosingDC, ABS( ClosingAmt) AS ClosingAmt FROM #TrialBalance


	DROP TABLE #TrialBalance

--SELECT * FROM ACC_Ledgers WHERE  CurrentBalance <> 0.00 AND OpenningBalance <> 0.00

--SELECT  led2.[Name] ParentName,
--		led1.[Name],		
--		led1.OpenningBalance,
--		led1.CurrentBalance,
--		led1.CurrentBalanceDc,  
--		led2.LedgerId PId FROM dbo.ACC_Ledgers led1
--		JOIN dbo.ACC_Ledgers led2 on led2.LedgerId=led1.ParentId
--		INNER JOIN dbo.ACC_TransactionDetail TD ON TD.LedgerId = led2.LedgerId OR TD.LedgerId = led1.LedgerId
--		INNER JOIN dbo.ACC_Transaction T ON T.Id = TD.TransactionId
--	  where led1.IsDisplay=1 and led2.IsDisplay=1 and led1.IsLedger=1 
--	        AND T.FiscalYearId = @FiscalYearID
--			AND T.IsApproved = 1

--union ALL
--	SELECT  ' ','Total',0,Sum(led1.CurrentBalance),1,'' FROM dbo.ACC_Ledgers led1
--	JOIN dbo.ACC_Ledgers led2 on led2.LedgerId=led1.ParentId
--	  where led1.IsDisplay=1 and led2.IsDisplay=1 and led1.CurrentBalanceDc=1
--	  group by led1.CurrentBalanceDc
--	  union ALL
--	SELECT  ' ','Total',0,Sum(led1.CurrentBalance),2,'' FROM dbo.ACC_Ledgers led1
--	JOIN dbo.ACC_Ledgers led2 on led2.LedgerId=led1.ParentId
--	  where led1.IsDisplay=1 and led2.IsDisplay=1 and led1.CurrentBalanceDc=2
--	  group by led1.CurrentBalanceDc


---	Select * from ACC_Transaction


END
