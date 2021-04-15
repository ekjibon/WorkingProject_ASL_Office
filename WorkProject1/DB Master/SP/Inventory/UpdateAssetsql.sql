IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UpdateAsset]'))
BEGIN
DROP PROCEDURE  [UpdateAsset]
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateAsset]    Script Date: 24/2/2020 5:29:21 PM******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure [dbo].[UpdateAsset]
(
@AssetId int =0,
@AssetName varchar(100),
@AssetCode varchar(100),
@AssetSubCatId int = 0,
@UnitId int = 0,
@DeprcAmount int = 0,
@ProductTypeId INT ,
@Description varchar(Max),
@SellingPrice decimal = 0,
@UpdateBy varchar(100)
)
As
BEGIN


Update dbo.FA_Asset SET AssetName = @AssetName,AssetCode =@AssetCode,AssetSubCatId = @AssetSubCatId,UnitId =@UnitId,
                           [Description]= @Description,DeprcAmount=@DeprcAmount,SellingPrice=@SellingPrice
						  ,UpdateBy =@UpdateBy,UpdateDate = GETDATE()
						   WHERE AssetId = @AssetId 
 




END
