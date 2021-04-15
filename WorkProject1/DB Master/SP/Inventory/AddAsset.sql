IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AddAsset]'))
BEGIN
DROP PROCEDURE  [AddAsset]
END
GO
/****** Object:  StoredProcedure [dbo].[AddAsset]    **/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC [dbo].[AddAsset] 0,PEN,P01,2,0,0,1,null,1,0,20,addmin,null
Create Procedure [dbo].[AddAsset]
(
@AssetId int =0,
@AssetName varchar(100),
@AssetCode varchar(100),
@AssetSubCatId int = 0,
@UnitId int = 0,
@AssetTypeId INT ,
@Description varchar(Max),
@DeprcAmount int = 0,
@Amount  DECIMAL(10,2) =0,
@SellingPrice decimal = 0,
@AccCode VARCHAR(100),
@AddBy varchar(100)

)
As
BEGIN

		
		INSERT INTO dbo.FA_Asset
		(AssetName,AssetCode,AssetSubCatId,UnitId,AssetTypeId,[Description],Amount
		,SellingPrice,AccCode,DeprcAmount,IsPercentage,IsDeleted,AddBy,AddDate,[Status])
		VALUES (@AssetName,@AssetCode,@AssetSubCatId,@UnitId,@AssetTypeId,@Description,@Amount
				,@SellingPrice,@AccCode,@DeprcAmount,1,0,@AddBy,GETDATE(),'A') 
END
