/****** Object:  UserDefinedTableType [dbo].[udtPurchaseOrderDetails]   */
--IF type_id('[dbo].[udtPurchaseOrderDetails]') IS NOT NULL
--DROP TYPE [dbo].[udtPurchaseOrderDetails];
--GO

--CREATE TYPE [dbo].[udtPurchaseOrderDetails] AS TABLE(
--	[ProductId] INT NOT NULL, 
--	[Quantity] [decimal](10, 2) NULL,
--	[UnitPrice] [decimal](10, 2) NULL,
--	[TotalPrice] [decimal](10, 2) NULL,
--	[Discount] [decimal](10, 2) NULL
--)
--GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AddPurchaseOrder]'))
BEGIN
DROP PROCEDURE  [AddPurchaseOrder]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE [dbo].[AddPurchaseOrder]
(
    @SupplierId INT,
	@DueDate SMALLDATETIME,	
	@Description VARCHAR(50)=null,
	@Addby VARCHAR(50)=null,
	@OrderDetails udtPurchaseOrderDetails READONLY
)	
AS
BEGIN
	

	DECLARE @IID  INT 
    DECLARE @CODE varchar(25)
	DECLARE @TPrice decimal(10,2) =0


	SELECT @TPrice = Sum(TotalPrice) FROM @OrderDetails 

	SELect @CODE = 'P'+ Cast(year(getdate()) as varchar) +  Cast(month(getdate()) as varchar) +Cast(day(getdate()) as varchar) + CAST((Select  Count(*)+1 From dbo.Inv_PurchaseOrder) as varchar)
	
	print @CODE

	INSERT INTO Inv_PurchaseOrder([POCode],[SupplierId],[DueDate],[Description],[TotalPrice],[IsReceived],[IsDeleted],[AddBy],[Status],[AddDate])
	VALUES( @CODE, @SupplierId,@DueDate,@Description,@TPrice,0,0,@Addby,'A',GETDATE())

	SELECT @IID = @@IDENTITY

	INSERT INTO Inv_PurchaseOrderDetails([POId],[ProductId],[Quantity],[UnitPrice],[TotalPrice],[Discount],[ReceiveQuantity])
	SELECT @IID, ProductId,Quantity,UnitPrice,TotalPrice,Discount,0 FROM @OrderDetails 

	-- Select * from Inv_PurchaseOrder
	-- Select * from Inv_PurchaseOrderDetails 
	-- Select * from Inv_StockTransaction
	-- Select * from Inv_ProductStocks
END

		   
