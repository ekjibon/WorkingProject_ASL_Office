IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptCashBook]'))
BEGIN
DROP PROCEDURE  rptCashBook
END
GO

SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO -- EXEC rptCashBook 2018 , 9
create PROCEDURE rptCashBook
@Year INT,
@Month INT
AS
BEGIN  

	SELECT LedgerId INTO #CashBankLedgers  FROM ACC_Ledgers WHERE  ParentId = (SELECT LedgerId FROM ACC_Ledgers WHERE [Name] = 'Cash  in hand') AND LedgerId NOT IN (3352,3353)
	
	--SELECT * FROM ACC_Ledgers INTO #DebitCashBank  
	--FROM ACC_TransactionDetail WHERE DC = 2 AND LedgerId IN (SELECT * FROM #CashBankLedgers)
	--GROUP BY TransactionId

	CREATE TABLE #DebitCashBank
	(
		TransNo VARCHAR(50),
		TransType VARCHAR(50),
		[Date] SMALLDATETIME,
		DrAmount DECIMAL(10,2),
		CrAmount DECIMAL(10,2),
		DrTotal DECIMAL(10,2),
		CrTotal DECIMAL(10,2),
		Side VARCHAR(20)
	)


	INSERT INTO #DebitCashBank
	SELECT DISTINCT
		T.TransNo,
		T.TransType,
		T.[Date],
		TD.DrAmount,
		TD.CrAmount,
		T.DrTotal,
		T.CrTotal,
	'Debit' AS Side 
	FROM dbo.ACC_Transaction T
	INNER JOIN dbo.ACC_FiscalYear F ON T.FiscalYearId = F.Id
	--INNER JOIN dbo.ACC_Branchs AB ON AB.BranchId = T.AccBranchId
	INNER JOIN dbo.ACC_TransactionDetail TD ON TD.TransactionId = T.Id 
	INNER JOIN dbo.ACC_Ledgers AL ON AL.LedgerId = TD.LedgerId
	WHERE  	 MONTH(T.[Date])=@Month AND YEAR(T.[Date])=@Year	--AND TD.LedgerId NOT IN (SELECT * FROM #CashBankLedgers)
				AND	T.IsDeleted = 0 AND T.id IN (SELECT TransactionId  
	FROM ACC_TransactionDetail WHERE DrAmount>0  AND LedgerId IN (SELECT * FROM #CashBankLedgers)
	GROUP BY TransactionId )
	AND T.IsApproved = 1 AND T.IsReject = 0
	
	
	--SELECT * FROM #DebitCashBank
	
		INSERT INTO #DebitCashBank
	SELECT DISTINCT
		T.TransNo,
		T.TransType,
		T.[Date],
		TD.DrAmount,
		TD.CrAmount,
		T.DrTotal,
		T.CrTotal,
	'Credit' AS Side 
	FROM dbo.ACC_Transaction T
	INNER JOIN dbo.ACC_FiscalYear F ON T.FiscalYearId = F.Id
	--INNER JOIN dbo.ACC_Branchs AB ON AB.BranchId = T.AccBranchId
	INNER JOIN dbo.ACC_TransactionDetail TD ON TD.TransactionId = T.Id 
	INNER JOIN dbo.ACC_Ledgers AL ON AL.LedgerId = TD.LedgerId
	WHERE    YEAR(T.[Date])=@Year
	AND MONTH(T.[Date])=@Month
	--AND TD.LedgerId NOT IN (SELECT * FROM #CashBankLedgers)
	AND
	 T.id IN (SELECT TransactionId  
	FROM ACC_TransactionDetail WHERE CrAmount>0 AND LedgerId IN (SELECT * FROM #CashBankLedgers)
	GROUP BY TransactionId)
	AND T.IsApproved = 1 AND T.IsReject = 0
	
	SELECT * FROM #DebitCashBank
	




	DROP TABLE #DebitCashBank
	DROP TABLE #CashBankLedgers


END