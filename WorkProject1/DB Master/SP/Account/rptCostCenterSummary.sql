IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptCostCenterSummary]'))
BEGIN
DROP PROCEDURE  rptCostCenterSummary 
END
GO
SET ANSI_NULLS ON 
SET QUOTED_IDENTIFIER ON
GO
--exec rptCostCenterSummary '2020/08/01','2020/08/31',1
Create PROCEDURE [dbo].rptCostCenterSummary 
(
@FromDate VARCHAR(MAX) NULL,
@ToDate VARCHAR(MAX) NULL,
@BranchId INT NULL
)
AS
BEGIN  
	SELECT CCA.Id AS CategoryId,CCA.CostCategoryName,CC.CostCenterName,ACCB.Name,
    CAST(@FromDate AS datetime) AS FromDate,
	CAST(@ToDate AS datetime) AS ToDate,
	CCD.* FROM [dbo].[ACC_CostCenterDetails] CCD
	INNER JOIN [dbo].[ACC_CostCenter] CC ON CC.Id = CCD.CostCenterId
	INNER JOIN [dbo].[ACC_CostCategory] CCA ON CCA.Id = CC.CostCategoryId
	INNER JOIN [dbo].[ACC_Transaction] T ON T.Id = CCD.TransactionId
	INNER JOIN [dbo].[ACC_Branchs] ACCB ON ACCB.BranchId = T.AccBranchId

	WHERE CAST(T.[Date] AS DATE) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE)
	AND T.AccBranchId = ISNULL(@BranchId,T.AccBranchId) AND LedgerId <>0

END