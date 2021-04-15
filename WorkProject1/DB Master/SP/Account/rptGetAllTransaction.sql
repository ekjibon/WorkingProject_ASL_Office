IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetAllTransaction]'))
BEGIN
DROP PROCEDURE  rptGetAllTransaction
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].rptGetAllTransaction
(
@TransactionId INT 
)
AS
BEGIN  
	--  rptGetAllTransaction 117
	
	SELECT 
		TD.*,
		[dbo].[fnIntegerToWords](TD.CrAmount) AS CrAmountWords,
		[dbo].[fnIntegerToWords](TD.DrAmount) AS DrAmountWords,
		[dbo].[fnIntegerToWords](T.CrTotal) AS CrTotalWords,
		[dbo].[fnIntegerToWords](T.DrTotal) AS DrTotalWords,
	CASE T.PayMode 
	WHEN 1 THEN 'Cash'
	WHEN 2 THEN 'Cheque'
	WHEN 3 THEN 'OnCredit'
	END AS PayModeName,
	F.[Name] AS FiscalYear,
	AL.[Name],
	AL.[OpenningBalanceDc],
	CASE T.TransType 
	WHEN 1 THEN 'Recive'
	WHEN 2 THEN 'Payment'
	WHEN 3 THEN 'Contra'
	WHEN 4 THEN 'Journal'
	END AS TransTypeName,
	AB.[Name] AS ACCBranchName,
	AN.[FullName],

	T.*
	FROM dbo.ACC_Transaction T
	INNER JOIN dbo.ACC_FiscalYear F ON T.FiscalYearId = F.Id
	INNER JOIN dbo.ACC_Branchs AB ON AB.BranchId = T.AccBranchId
	INNER JOIN dbo.ACC_TransactionDetail TD ON TD.TransactionId = T.Id
	INNER JOIN dbo.ACC_Ledgers AL ON AL.LedgerId = TD.LedgerId
	INNER JOIN dbo.AspNetUsers AN ON AL.AddBy = AN.FullName
	WHERE T.IsApproved = 1 AND T.Id = @TransactionId

END