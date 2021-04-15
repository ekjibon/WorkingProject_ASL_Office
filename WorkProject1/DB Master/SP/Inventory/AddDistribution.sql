
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AddDistribution]'))
BEGIN
DROP PROCEDURE  [AddDistribution]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[AddDistribution]
(
    @ProductId INT =0,
    @Qty INT =0,
    @EmployeeId INT =0,
	@Addby VARCHAR(50)=null
	
)	
AS
BEGIN
	

	INSERT INTO		Inv_Distribution ([ProductId],[Qty],[EmployeeId],[AddBy],IsDeleted,[AddDate],[Status]) 
	          VALUES(@ProductId,@Qty,@EmployeeId,@Addby,0,GETDATE(),'A')
	         
 
	  INSERT INTO Inv_StockTransaction([ProductId],[Quantity],[LastStockQty],[TransType],[TransCategory],[IsDeleted],[AddBy],[AddDate])
	      SELECT  @ProductId,@Qty,[dbo].[GetLastStock](@ProductId),'OUT','DIS',0,@Addby,GETDATE()
		 

	select  Scope_Identity();
	-- Select * from Inv_Distribution
	-- Select * from Inv_SalesDetails 
	-- Select * from Inv_StockTransaction where ProductId = 32
	-- Select * from Inv_ProductStocks where ProductId = 32

	-- Select [dbo].[GetLastStock](32)
END

		   
