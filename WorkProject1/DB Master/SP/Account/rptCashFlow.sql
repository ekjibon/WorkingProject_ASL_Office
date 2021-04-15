IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptCashFlow]'))
BEGIN
DROP PROCEDURE  rptCashFlow
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
-- rptCashFlow 12
Create PROCEDURE [dbo].rptCashFlow 
@FiscalYearID int

AS
BEGIN  
 DECLARE @TotalBalanceOperation  decimal(10,2),@TotalBalanceInvesting  decimal(10,2),@TotalBalanceFinancing  decimal(10,2),@TotalIncreaseDecrease  decimal(10,2)
 SET @TotalBalanceOperation = (ISNULL((SELECT SUM(CurrentBalance) FROM dbo.ACC_Ledgers WHERE CashFlowType='Operation' AND IsDisplay = 1 AND Status = 'A' AND IsDeleted = 0 AND CurrentBalanceDc=2 ),0) - ISNULL((SELECT SUM(CurrentBalance) FROM dbo.ACC_Ledgers WHERE CashFlowType='Operation' AND IsDisplay = 1 AND Status = 'A' AND IsDeleted = 0 AND CurrentBalanceDc=1),0)) 
 SET @TotalBalanceInvesting = (ISNULL((SELECT SUM(CurrentBalance) FROM dbo.ACC_Ledgers WHERE CashFlowType='Investing' AND IsDisplay = 1 AND Status = 'A' AND IsDeleted = 0 AND CurrentBalanceDc=2 ),0) - ISNULL((SELECT SUM(CurrentBalance) FROM dbo.ACC_Ledgers WHERE CashFlowType='Investing' AND IsDisplay = 1 AND Status = 'A' AND IsDeleted = 0 AND CurrentBalanceDc=1),0)) 
 SET @TotalBalanceFinancing =(ISNULL((SELECT SUM(CurrentBalance) FROM dbo.ACC_Ledgers WHERE CashFlowType='Financing' AND IsDisplay = 1 AND Status = 'A' AND IsDeleted = 0 AND CurrentBalanceDc=2 ),0) - ISNULL((SELECT SUM(CurrentBalance) FROM dbo.ACC_Ledgers WHERE CashFlowType='Financing' AND IsDisplay = 1 AND Status = 'A' AND IsDeleted = 0 AND CurrentBalanceDc=1),0)) 
 SET @TotalIncreaseDecrease = (@TotalBalanceOperation + @TotalBalanceInvesting + @TotalBalanceFinancing)

 --Cash receipts from Operation
 SELECT  Name,LedgerId,ParentId,(CurrentBalance) AS CurrentBalanceROperation,SUM(CurrentBalance) AS TotalReciveOperation
 FROM dbo.ACC_Ledgers
 WHERE CashFlowType='Operation' AND IsDisplay = 1 AND Status = 'A' AND IsDeleted = 0 AND CurrentBalanceDc=2 AND LedgerId NOT IN(1757)
 GROUP BY Name,LedgerId,ParentId,CurrentBalance

-- Cash paid for Operation
SELECT 'Administrative Expense' Name,0 LedgerId,0 ParentId,CurrentBalancePOperation ,0 TotalPaymentOperation,@TotalBalanceOperation AS TotalBalanceOperation FROM
(SELECT SUM(CurrentBalance)CurrentBalancePOperation 
FROM ACC_Ledgers WHERE ParentId = 1714 AND LedgerId IN(
SELECT  led1.LedgerId  FROM dbo.ACC_Ledgers led1
		INNER JOIN dbo.ACC_TransactionDetail TD ON  TD.LedgerId = led1.LedgerId
		INNER JOIN dbo.ACC_Transaction T ON T.Id = TD.TransactionId
	    where led1.IsDisplay=1 and led1.RootGroupId=4
	    AND T.FiscalYearId = @FiscalYearID AND led1.Status = 'A' AND led1.CurrentBalance<>0 AND T.IsApproved =1 AND T.IsReject = 0 AND led1.ParentId=1714))T
 UNION ALL 
 SELECT Name,LedgerId,ParentId,(CurrentBalance)As CurrentBalancePOperation,SUM(CurrentBalance) AS TotalPaymentOperation,@TotalBalanceOperation AS TotalBalanceOperation
 FROM dbo.ACC_Ledgers
 WHERE CashFlowType='Operation' AND IsDisplay = 1 AND Status = 'A' AND IsDeleted = 0  AND CurrentBalanceDc=1 AND LedgerId NOT IN(1714)
 GROUP BY Name,LedgerId,ParentId,CurrentBalance
 UNION ALL  --Accounts Payable
 SELECT 'Cash paid to suppliers & others',LedgerId,ParentId,(CurrentBalance)As CurrentBalancePOperation,SUM(CurrentBalance) AS TotalPaymentOperation,@TotalBalanceOperation AS TotalBalanceOperation
 FROM dbo.ACC_Ledgers
 WHERE CashFlowType='Operation' AND IsDisplay = 1 AND Status = 'A' AND IsDeleted = 0  AND LedgerId  IN(1757)
 GROUP BY Name,LedgerId,ParentId,CurrentBalance

 --Cash receipts from Investing
 SELECT  Name,LedgerId,ParentId,(CurrentBalance) AS CurrentBalanceRInvesting,SUM(CurrentBalance) AS TotalReciveInvesting
 FROM dbo.ACC_Ledgers
 WHERE CashFlowType='Investing' AND IsDisplay = 1 AND Status = 'A' AND IsDeleted = 0 AND CurrentBalanceDc=2 
 GROUP BY Name,LedgerId,ParentId,CurrentBalance

-- Cash paid for Investing
 SELECT Name,LedgerId,ParentId,(CurrentBalance)As CurrentBalancePInvesting,SUM(CurrentBalance) AS TotalPaymentInvesting,@TotalBalanceInvesting AS TotalBalanceInvesting
 FROM dbo.ACC_Ledgers
 WHERE CashFlowType='Investing' AND IsDisplay = 1 AND Status = 'A' AND IsDeleted = 0  AND CurrentBalanceDc=1 
 GROUP BY Name,LedgerId,ParentId,CurrentBalance

 --Cash receipts from Financing
 SELECT  Name,LedgerId,ParentId,(CurrentBalance) AS CurrentBalanceRFinancing,SUM(CurrentBalance) AS TotalReciveFinancing
 FROM dbo.ACC_Ledgers
 WHERE CashFlowType='Financing' AND IsDisplay = 1 AND Status = 'A' AND IsDeleted = 0 AND CurrentBalanceDc=2 
 GROUP BY Name,LedgerId,ParentId,CurrentBalance

-- Cash paid for Financing
 SELECT Name,LedgerId,ParentId,(CurrentBalance)As CurrentBalancePFinancing,SUM(CurrentBalance) AS TotalPaymentFinancing,@TotalBalanceFinancing AS TotalBalanceFinancing
 FROM dbo.ACC_Ledgers
 WHERE CashFlowType='Financing' AND IsDisplay = 1 AND Status = 'A' AND IsDeleted = 0  AND CurrentBalanceDc=1 
 GROUP BY Name,LedgerId,ParentId,CurrentBalance

 --Total Increase Decrease 
 SELECT @TotalIncreaseDecrease AS TotalIncreaseDecrease,(SELECT OpenningBalance FROM ACC_Ledgers WHERE LedgerId = 1652 )OpenningBalanceCashBank,
 (SELECT CurrentBalance  FROM ACC_Ledgers WHERE LedgerId = 1652 )ClosingBalanceCashBank
 

END