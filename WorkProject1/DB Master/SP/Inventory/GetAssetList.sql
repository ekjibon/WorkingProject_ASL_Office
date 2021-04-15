IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAssetList]'))
BEGIN
DROP PROCEDURE  [GetAssetList]
END
GO
/****** Object:  StoredProcedure [dbo].[GetAssetList]    Script Date: 5/21/2019 3:41:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure [dbo].[GetAssetList]

As
BEGIN
SELECT   A.AssetId
        
		,A.AssetName
		,A.AssetSubCatId
		,A.[Description]
		,A.UnitId
		,A.AccCode		
		,SC.SubCategoryName
		,AC.AssetCateId
		,AC.CategoryName
		,SC.CategoryId
		,A.AssetCode
		,AU.UnitName
		,A.DeprcAmount
		,AU.UnitSetupId,A.SellingPrice
	    ,A.AssetTypeId
		FROM dbo.FA_Asset A
		INNER join dbo.FA_AssetUnitSetup AU ON A.UnitId = AU.UnitSetupId		
		INNER join dbo.FA_AssetSubCategory SC ON SC.AssetSubCatId = A.AssetSubCatId
		INNER join dbo.FA_AssetCategory AC ON SC.CategoryId = AC.AssetCateId
		WHERE  A.IsDeleted = 0 and A.[Status] ='A' order by A.AssetId desc
	

END

--[GetAssetList] 