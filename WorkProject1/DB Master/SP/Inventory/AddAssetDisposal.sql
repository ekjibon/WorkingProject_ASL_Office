
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AddAssetDisposal]'))
BEGIN
DROP PROCEDURE  [AddAssetDisposal]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[AddAssetDisposal]
(
    @ProductId INT =0,
    @DisposalType varchar(50) Null,
    @SellingPrice decimal(10,2) =0,
    @Quantity decimal(10,2) =0,
    @AccountCode varchar(50) Null,
	@Addby VARCHAR(50)=null
	
)	

AS
BEGIN
	

	INSERT INTO		Inv_AssetDisposal([ProductId],[DisposalType],SellingPrice,[Quantity],[AccountCode],[AddBy],IsDeleted,[AddDate],[Status]) 
	          VALUES(@ProductId,@DisposalType,@SellingPrice,@Quantity,@AccountCode,@Addby,0,GETDATE(),'A')
	         
 
	  INSERT INTO Inv_StockTransaction([ProductId],[Quantity],[LastStockQty],[TransType],[TransCategory],[IsDeleted],[AddBy],[AddDate])
	      SELECT  @ProductId,@Quantity,[dbo].[GetLastStock](@ProductId),'OUT','DIS',0,@Addby,GETDATE()
		 
		 -- Nedd Account Hits Acc Ledger


	-- Select * from Inv_AssetDisposal
	-- Select * from Inv_SalesDetails 
	-- Select * from Inv_StockTransaction where ProductId = 32
	-- Select * from Inv_ProductStocks where ProductId = 32

	-- Select [dbo].[GetLastStock](32)
END

		   
