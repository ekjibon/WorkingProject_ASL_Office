IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetProfitLossDetails]'))
BEGIN
DROP PROCEDURE  rptGetProfitLossDetails
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].rptGetProfitLossDetails -- rptGetProfitLossDetails 12
@FiscalYearID int
AS
BEGIN  
DECLARE @TotalAmountIncome AS decimal
DECLARE @TotalAmountExpence AS decimal
DECLARE @TotalProfitLoss AS decimal

SELECT @TotalAmountIncome = SUM(CurrentBalance) FROM
	   (SELECT DISTINCT  led2.Name ParentName,led1.LedgerId,led1.Name,led1.CurrentBalance,led1.CurrentBalanceDc,led1.OpenningBalance,SUM(led1.CurrentBalance) AS CurrentAmountTotal, led2.LedgerId PId FROM dbo.ACC_Ledgers led1
	JOIN dbo.ACC_Ledgers led2 on led2.LedgerId=led1.ParentId
		INNER JOIN dbo.ACC_TransactionDetail TD ON TD.LedgerId = led2.LedgerId OR TD.LedgerId = led1.LedgerId
		INNER JOIN dbo.ACC_Transaction T ON T.Id = TD.TransactionId
	  where led1.IsDisplay=1 and led2.IsDisplay=1 and led1.RootGroupId=3 AND led1.Status = 'A' AND led1.CurrentBalance<>0 AND T.IsApproved =1 AND T.IsReject = 0
	   AND T.FiscalYearId = @FiscalYearID
   GROUP BY led2.Name,led1.LedgerId,led1.OpenningBalance,led1.CurrentBalance,led1.CurrentBalanceDc,led1.ParentId, led2.LedgerId,T.AccBranchId,led1.Name) t
SELECT @TotalAmountExpence =   SUM(CurrentBalance) FROM
   	(SELECT DISTINCT  led2.Name ParentName,led1.*,(SELECT SUM(CurrentBalance) FROM ACC_Ledgers WHERE RootGroupId = 4) AS CurrentAmountTotal,  led2.LedgerId PId FROM dbo.ACC_Ledgers led1
	JOIN dbo.ACC_Ledgers led2 on led2.LedgerId=led1.ParentId
		INNER JOIN dbo.ACC_TransactionDetail TD ON TD.LedgerId = led2.LedgerId OR TD.LedgerId = led1.LedgerId
		INNER JOIN dbo.ACC_Transaction T ON T.Id = TD.TransactionId
	  where led1.IsDisplay=1 and led2.IsDisplay=1 and led1.RootGroupId=4
	   AND T.FiscalYearId = @FiscalYearID AND led1.Status = 'A' AND led1.CurrentBalance<>0 AND T.IsApproved =1 AND T.IsReject = 0)S

SET @TotalProfitLoss = @TotalAmountIncome - @TotalAmountExpence

SELECT DISTINCT  led2.Name ParentName,led1.LedgerId,led1.Name,led1.CurrentBalance,led1.CurrentBalanceDc,led1.OpenningBalance,SUM(led1.CurrentBalance) AS CurrentAmountTotal,@TotalAmountIncome AS TotalIncomeAmount,  led2.LedgerId PId,  SUM(T.DrTotal) AS totalP,T.AccBranchId FROM dbo.ACC_Ledgers led1
	JOIN dbo.ACC_Ledgers led2 on led2.LedgerId=led1.ParentId
		INNER JOIN dbo.ACC_TransactionDetail TD ON TD.LedgerId = led2.LedgerId OR TD.LedgerId = led1.LedgerId
		INNER JOIN dbo.ACC_Transaction T ON T.Id = TD.TransactionId
	  where led1.IsDisplay=1 and led2.IsDisplay=1 and led1.RootGroupId=3 AND led1.Status = 'A' AND led1.CurrentBalance<>0 AND T.IsApproved =1 AND T.IsReject = 0
	   AND T.FiscalYearId = @FiscalYearID
   GROUP BY led2.Name,led1.LedgerId,led1.OpenningBalance,led1.CurrentBalance,led1.CurrentBalanceDc,led1.ParentId, led2.LedgerId,T.AccBranchId,led1.Name

	SELECT DISTINCT  led2.Name ParentName,led1.LedgerId,led1.Name,led1.CurrentBalance,led1.CurrentBalanceDc,led1.OpenningBalance,SUM(led1.CurrentBalance) AS CurrentAmountTotal,@TotalAmountExpence AS TotalExpenceAmount,SUM(T.DrTotal) AS totalP,@TotalProfitLoss AS TotalProfitLoss,T.AccBranchId FROM dbo.ACC_Ledgers led1
	JOIN dbo.ACC_Ledgers led2 on led2.LedgerId=led1.ParentId
		INNER JOIN dbo.ACC_TransactionDetail TD ON TD.LedgerId = led2.LedgerId OR TD.LedgerId = led1.LedgerId
		INNER JOIN dbo.ACC_Transaction T ON T.Id = TD.TransactionId
	  where led1.IsDisplay=1 and led2.IsDisplay=1 and led1.RootGroupId=4
	   AND T.FiscalYearId = @FiscalYearID AND led1.Status = 'A' AND led1.CurrentBalance<>0 AND T.IsApproved =1 AND T.IsReject = 0
   GROUP BY led2.Name,led1.LedgerId,led1.OpenningBalance,led1.CurrentBalance,led1.CurrentBalanceDc,led1.ParentId, led2.LedgerId,T.AccBranchId,led1.Name

END