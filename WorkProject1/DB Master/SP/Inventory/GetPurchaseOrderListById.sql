IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetPurchaseOrderListById]'))
BEGIN
DROP PROCEDURE  [GetPurchaseOrderListById]
END
GO
/****** Object:  StoredProcedure [dbo].[ClassWiseResultProcess]    Script Date: 5/21/2019 3:41:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC ClassWiseResultProcess 10,19,8,1011
Create Procedure [dbo].[GetPurchaseOrderListById]
(
@POId INT
)

As
BEGIN

Select 
      po.POCode
	 ,po.POId
	 ,po.DueDate
	 ,po.[Description]
	 ,pod.Quantity as PurchaseOrderQuantity
	 ,pod.ProductId
	 ,pod.UnitPrice
	 ,pod.Discount
	 ,pod.TotalPrice
	 ,pod.PODetailsId
	 ,s.SupplierName
	 ,s.SupplierCode
	 ,p.ProductName
	 ,u.UnitCode
	    from dbo.Inv_PurchaseOrder po 
    inner join dbo.Inv_PurchaseOrderDetails pod  on pod.POId = po.POId
   inner join dbo.Inv_Supplier s  on s.SupplierId = po.SupplierId
     inner join dbo.Inv_Product p  on p.ProductId = pod.ProductId
   inner join dbo.Inv_UnitSetup u  on p.UnitId = u.UnitSetupId
   where po.POId =@POId and po.IsDeleted = 0 and po.[Status] = 'A' order by po.POId 

END

-- GetPurchaseOrderListById 19 