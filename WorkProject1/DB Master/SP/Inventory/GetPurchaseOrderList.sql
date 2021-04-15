IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetPurchaseOrderList]'))
BEGIN
DROP PROCEDURE  [GetPurchaseOrderList]
END
GO
/****** Object:  StoredProcedure [dbo].[ClassWiseResultProcess]    Script Date: 5/21/2019 3:41:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC ClassWiseResultProcess 10,19,8,1011
Create Procedure [dbo].[GetPurchaseOrderList]

As
BEGIN

	SELECT PO.*,S.SupplierName,S.AccountCode FROM dbo.Inv_PurchaseOrder po 
	INNER JOIN dbo.Inv_Supplier s  on s.SupplierId = po.SupplierId
	WHERE po.IsDeleted = 0

	SELECT pd.*,P.ProductName,U.UnitCode AS Unit FROM dbo.Inv_PurchaseOrderDetails pd
	INNER JOIN dbo.Inv_Product P ON P.ProductId = pd.ProductId
	INNER JOIN dbo.Inv_UnitSetup U ON P.UnitId = U.UnitSetupId

END


--[GetPurchaseOrderList]

