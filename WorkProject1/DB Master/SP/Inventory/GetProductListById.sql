IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetProductListById]'))
BEGIN
DROP PROCEDURE  [GetProductListById]
END
GO
/****** Object:  StoredProcedure [dbo].[ClassWiseResultProcess]    Script Date: 5/21/2019 3:41:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC ClassWiseResultProcess 10,19,8,1011
Create Procedure [dbo].[GetProductListById]
(
@ProductId int 
)
As
BEGIN
Select p.ProductId
	,p.ProductName
	,p.OpeningBalance
	 ,p.ProductTypeId
	,ps.Quantity as StockQuantity
       ,p.ProductCode
	   ,u.UnitCode
	   ,u.UnitName
	   ,u.UnitSetupId,p.SellingPrice
        from dbo.Inv_Product p
     inner join dbo.Inv_UnitSetup u on p.UnitId = u.UnitSetupId
     inner join dbo.Inv_ProductStocks ps on ps.ProductId = p.ProductId
     --inner join dbo.Inv_StockTransaction st on st.ProductId = p.ProductId
	 where p.ProductId=@ProductId and p.IsDeleted = 0 and p.Status ='A'

END

--[GetProductList] 36