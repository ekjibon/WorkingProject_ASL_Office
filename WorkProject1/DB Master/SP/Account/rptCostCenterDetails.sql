IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptCostCenterDetails]'))
BEGIN
DROP PROCEDURE  rptCostCenterDetails 
END
GO
SET ANSI_NULLS ON 
SET QUOTED_IDENTIFIER ON
GO
--exec rptCostCenterDetails '2020/08/01','2020/08/31',1
Create PROCEDURE [dbo].rptCostCenterDetails
(
@FromDate VARCHAR(MAX) NULL,
@ToDate VARCHAR(MAX) NULL,
@BranchId INT NULL
)
AS
BEGIN  
	SELECT CC.CostCenterName,CCA.Id AS CategoryId,CCA.CostCategoryName,ACCB.Name,L.Name AS Ledger,L2.Name AS GroupName,T.Description,
    CAST(@FromDate AS datetime) AS FromDate,
	CAST(@ToDate AS datetime) AS ToDate,
	CCD.* FROM [dbo].[ACC_CostCenterDetails] CCD
	INNER JOIN [dbo].[ACC_CostCenter] CC ON CC.Id = CCD.CostCenterId
	INNER JOIN [dbo].[ACC_CostCategory] CCA ON CCA.Id = CC.CostCategoryId
	INNER JOIN [dbo].[ACC_Transaction] T ON T.Id = CCD.TransactionId
	INNER JOIN [dbo].[ACC_Branchs] ACCB ON ACCB.BranchId = T.AccBranchId
	INNER JOIN [dbo].[ACC_Ledgers] L ON L.LedgerId = CCD . LedgerId
	JOIN dbo.ACC_Ledgers L2 on L2.LedgerId=L.ParentId
	WHERE CAST(T.[Date] AS DATE) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE)
	AND T.AccBranchId = ISNULL(@BranchId,T.AccBranchId) 

END