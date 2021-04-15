IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetTrailBalanceForCC]'))
BEGIN
DROP PROCEDURE  rptGetTrailBalanceForCC
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].rptGetTrailBalanceForCC 
	--@FromDate VARCHAR(100),
	--@ToDate	VARCHAR(100)
	@FiscalYearID int
AS
BEGIN  
--  rptGetTrailBalanceForCC 6

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
	ClosingDC INT,
	CCName VARCHAR(100),
	CCAmt DECIMAL(18,2),
)

	INSERT INTO #TrialBalance(LedgerId,ParentName,LedgerName,OpenDebit,OpenCredit,TotalDebit,TotalCredit,ClosingAmt,ClosingDC,CCName,CCAmt)
	SELECT DISTINCT TD.LedgerId,(SELECT LG.Name FROM ACC_Ledgers LG WHERE LedgerId = L.ParentId),L.[Name],
	CASE WHEN L.CurrentBalanceDc = 1 THEN dbo.GetLedgerBalance(TD.LedgerId,@FiscalYearID,'Opening') ELSE 0 END,
	CASE WHEN L.CurrentBalanceDc = 2 THEN dbo.GetLedgerBalance(TD.LedgerId,@FiscalYearID,'Opening') ELSE 0 END,
	SUM(TD.DrAmount),
	SUM(TD.CrAmount),
	0,
   -- CASE WHEN L.CurrentBalanceDc= 1 THEN ((dbo.GetLedgerBalance(TD.LedgerId,@FiscalYearID,'Opening') + SUM(TD.DrAmount))-(dbo.GetLedgerBalance(TD.LedgerId,@FiscalYearID,'Opening') + SUM(TD.CrAmount))) ELSE 0 END,
	L.CurrentBalanceDc,'',0
	FROM ACC_Transaction T 
	INNER JOIN ACC_TransactionDetail TD ON T.Id = TD.TransactionId
	INNER JOIN ACC_Ledgers L ON L.LedgerId= TD.LedgerId
	WHERE T.FiscalYearId = @FiscalYearID AND T.IsApproved = 1 AND T.IsReject = 0
	GROUP BY TD.LedgerId , L.[Name],L.CurrentBalanceDc,L.ParentId

	    UNION ALL

	SELECT CCD.LedgerId,L1.Name,L.Name,
	0,
	0,
	0,
	0,
	0,
	0, CC.CostCenterName, SUM(CCD.Amount) AS CostCenterAmount
	FROM [dbo].[ACC_CostCenterDetails] CCD
	INNER JOIN [dbo].[ACC_CostCenter] CC ON CC.Id = CCD.CostCenterId
	INNER JOIN ACC_Ledgers L ON L.LedgerId= CCD.LedgerId
	JOIN ACC_Ledgers L1 ON L1.LedgerId = L.ParentId
	GROUP BY CCD.LedgerId,CC.CostCenterName,L.Name,L1.Name

	INSERT INTO #TrialBalance(LedgerId,ParentName,LedgerName,OpenDebit,OpenCredit,TotalDebit,TotalCredit,ClosingAmt,ClosingDC)
	SELECT DISTINCT LedgerId,(SELECT LG.Name FROM ACC_Ledgers LG WHERE LedgerId =(AL.ParentId)),[Name],
	CASE WHEN OpenningBalanceDc = 1 THEN dbo.GetLedgerBalance(LedgerId,@FiscalYearID,'Opening') ELSE 0 END,
	CASE WHEN OpenningBalanceDc = 2 THEN dbo.GetLedgerBalance(LedgerId,@FiscalYearID,'Opening') ELSE 0 END,
	0,0,0,CurrentBalanceDc
	 --FROM ACC_Ledgers AL WHERE LedgerId IN (597,45)
	 FROM ACC_Ledgers AL WHERE LedgerId IN (SELECT LedgerId FROM ACC_Ledgers WHERE OpenningBalance>0) AND OpenningBalance >0   

	UPDATE #TrialBalance SET ClosingAmt = (OpenDebit + TotalDebit) - (OpenCredit+TotalCredit)


	SELECT LedgerId,ParentName,LedgerName,OpenDebit,OpenCredit,TotalDebit,TotalCredit,ClosingDC, ABS( ClosingAmt) AS ClosingAmt,CCName,CCAmt FROM #TrialBalance


	DROP TABLE #TrialBalance
END