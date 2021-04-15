IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetProductList]'))
BEGIN
DROP PROCEDURE  [GetProductList]
END
GO
/****** Object:  StoredProcedure [dbo].[ClassWiseResultProcess]    Script Date: 5/21/2019 3:41:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [dbo].[GetProductList]
Create Procedure [dbo].[GetProductList]

As
BEGIN
SELECT   P.Id
		,P.ProductName
		,P.ProductSubCateId
		,P.[Description]
		,P.UnitId
		,P.OpeningBalance
		,PSC.SubCategoryName
		,PC.CategoryName
		,PSC.CategoryId
		,P.ProductCode
		,U.UnitCode
		,U.UnitName
		,P.ReOrderLevel
		,U.Id
		,P.OpeningUnit
		FROM dbo.Inv_Product P
		inner join dbo.Inv_UnitSetup U ON P.UnitId = U.Id	
		inner join dbo.Inv_ProductSubCategory PSC ON PSC.Id = P.ProductSubCateId
		inner join dbo.Inv_ProductCategory PC ON psc.CategoryId = PC.Id
		WHERE  P.IsDeleted = 0 and P.[Status] ='A' order by P.Id desc
		-- SELECT * FROM Inv_ProductCategory
		-- SELECT * FROM Inv_ProductSubCategory
		-- SELECT * FROM Inv_Product

END

--[GetProductList] 