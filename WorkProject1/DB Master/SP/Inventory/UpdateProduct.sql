IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UpdateProduct]'))
BEGIN
DROP PROCEDURE  [UpdateProduct]
END
GO
/****** Object:  StoredProcedure [dbo].[ClassWiseResultProcess]    Script Date: 5/21/2019 3:41:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC ClassWiseResultProcess 10,19,8,1011
Create Procedure [dbo].[UpdateProduct]
(
@ProductId int =0,
@ProductName varchar(100),
@ProductCode varchar(100),
@ProductSubCateId int = 0,
@UnitId int = 0,
@ReOrderLevel int = 0,
@ProductTypeId INT ,
@Description varchar(Max),
@SellingPrice decimal = 0,
@UpdateBy varchar(100)
)
As
BEGIN

DECLare @IID INT =0;
BEGIN TRAN UpdateTran;
Update dbo.Inv_Product SET ProductName = @ProductName,ProductCode =@ProductCode,ProductSubCateId = @ProductSubCateId,UnitId =@UnitId,
                           ReOrderLevel = @ReOrderLevel,[Description]= @Description,SellingPrice=@SellingPrice
						  ,UpdateBy =@UpdateBy,UpdateDate = GETDATE()
						   WHERE ProductId = @ProductId 
  SELECT @IID = @@IDENTITY

 -- INSERT INTO Inv_StockTransaction([ProductId],[Quantity],[LastStockQty],[TransType],[TransCategory],[IsDeleted],[AddBy],[AddDate])
	--VALUES(@IID,@OpeningBalance,0,'IN','OP',0,@AddBy,GETDATE())

COMMIT TRAN

Select SCOPE_IDENTITY()

END
