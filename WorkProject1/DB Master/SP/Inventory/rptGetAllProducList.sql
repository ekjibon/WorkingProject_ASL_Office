IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetAllProducList]'))
BEGIN
DROP PROCEDURE  [rptGetAllProducList]
END
GO
/****** Object:  StoredProcedure [dbo].[ClassWiseResultProcess]    Script Date: 5/21/2019 3:41:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC ClassWiseResultProcess 10,19,8,1011
Create Procedure [dbo].[rptGetAllProducList]
(
@FromDate datetime,
@ToDate datetime,
@TypeId INT =0
--@ProductTypeId INT =0
)
As
BEGIN
IF(@TypeId=1)   --- Selling Product List p.ProductTypeId = 1
BEGIN
Select p.ProductId
	,p.ProductName
	,p.ProductTypeId
	,p.OpeningBalance
	,p.Status
	,p.IsDeleted
	,ps.Quantity as StockQuantity
       ,p.ProductCode
	   ,u.UnitCode
	   ,u.UnitName
	   ,u.UnitSetupId,p.SellingPrice,p.AddDate
        from dbo.Inv_Product p
     inner join dbo.Inv_UnitSetup u on p.UnitId = u.UnitSetupId
     inner join dbo.Inv_ProductStocks ps on ps.ProductId = p.ProductId
	 where (Cast(p.AddDate as date) between Cast(@FromDate as date) and Cast(@ToDate as date)) and  p.IsDeleted=0 and p.ProductTypeId = 1
END
	 IF(@TypeId=2)       --- Fixed Asset List p.ProductTypeId = 3
	 BEGIN
	Select p.ProductId
	,p.ProductName
	,p.ProductTypeId
	,p.OpeningBalance
	,p.Status
	,p.IsDeleted
	,ps.Quantity as StockQuantity
    ,p.ProductCode
	,u.UnitCode
	,u.UnitName
	,u.UnitSetupId,p.SellingPrice
     from dbo.Inv_Product p
     inner join dbo.Inv_UnitSetup u on p.UnitId = u.UnitSetupId
     inner join dbo.Inv_ProductStocks ps on ps.ProductId = p.ProductId
	 where  (p.AddDate between Cast(@FromDate as date) and Cast(@ToDate as date))  and p.IsDeleted=0 and p.ProductTypeId = 3
	 END
	 IF(@TypeId=3)    -- Distributed Product List p.ProductTypeId = 2
	 BEGIN
	Select p.ProductId
	,p.ProductName
	,p.ProductTypeId 
	,p.OpeningBalance
	,p.Status
	,p.IsDeleted
	,ps.Quantity as StockQuantity
       ,p.ProductCode
	   ,u.UnitCode
	   ,u.UnitName
	   ,u.UnitSetupId,p.SellingPrice
        from dbo.Inv_Product p
     inner join dbo.Inv_UnitSetup u on p.UnitId = u.UnitSetupId
     inner join dbo.Inv_ProductStocks ps on ps.ProductId = p.ProductId
	 where p.AddDate between Cast(@FromDate as date) and Cast(@ToDate as date)  and p.ProductTypeId = 2 and p.IsDeleted=0
	 END

	 IF(@TypeId=4)    -- Stock Status Report All Product List
	BEGIN
	Select p.ProductId
	,p.ProductName
	,p.OpeningBalance
	,p.ProductTypeId
	,p.Status
	,p.IsDeleted
	,ps.Quantity as StockQuantity
	,p.ProductCode
	,u.UnitCode
	,u.UnitName
	,u.UnitSetupId,p.SellingPrice
	from dbo.Inv_ProductStocks ps
	inner join  dbo.Inv_Product p  on ps.ProductId = p.ProductId
	inner join dbo.Inv_UnitSetup u on p.UnitId = u.UnitSetupId
	where CAST(p.AddDate as date) between Cast(@FromDate as date) and Cast(@ToDate as date)  and p.IsDeleted=0
	END

END

-- select * from Inv_Product Where ProductId = 

--[rptGetAllProducList] '2019-09-04 18:45:06.030','2019-09-09 12:14:00.643',4