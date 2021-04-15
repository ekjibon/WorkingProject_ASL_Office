/****** Object:  UserDefinedTableType [dbo].[udtPurchaseOrderDetails]   */
 /*IF type_id('[dbo].[udtSalesDetails]') IS NOT NULL
DROP TYPE [dbo].[udtSalesDetails];
GO

CREATE TYPE [dbo].[udtSalesDetails] AS TABLE(
	[ProductId] INT NOT NULL, 
	[Quantity] [decimal](10, 2) NULL,
	[SubTotal] [decimal](10, 2) NULL,
	[UnitPrice] [decimal](10, 2) NULL
	
)
GO
*/

/*
DECLARE @SalesDetails udtSalesDetails  
INSERT INTO @SalesDetails VALUES (68,2,240,120) 
--SP Calling: 
EXEC AddSales 'sdfsd','016',0,240,240,'sfdfsdf', @SalesDetails
*/

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AddSales]'))
BEGIN
DROP PROCEDURE  [AddSales]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[AddSales]
(
    @CustomerName Varchar(Max),
	@MobileNo Varchar(Max),	
	@Vat decimal (10,2) =0,
	@SubTotal decimal (10,2) =0,
	@NetPayable  decimal (10,2) =0,
	@Addby VARCHAR(50)=null,
	@SalesDetails udtSalesDetails READONLY
)	
AS
BEGIN
	BEGIN TRANSACTION;

	BEGIN TRY
	DECLARE @TransactionDetail UTT_TRANSACTIONDETAIL  
	DECLARE @IID  INT 
    DECLARE @TotalAmount Decimal = 0
	DECLARE @CurrDate SMALLDATETIME=GETDATE() ,@AccId1 INT , @AccId2 INT ,@AccId3 INT ,@AccId4 INT 

	INSERT INTO Inv_Sales([CustomerName],[MobileNo],[Vat],[SubTotal],[NetPayable],[IsDeleted],[AddBy],[Status],[AddDate],[Discount])
	                VALUES(@CustomerName,@MobileNo,@Vat,@SubTotal,@NetPayable,0,@Addby,'A',GETDATE(),0)

	SELECT @IID = @@IDENTITY

	

 
	  INSERT INTO Inv_StockTransaction([ProductId],[Quantity],[LastStockQty],[TransType],[TransCategory],[IsDeleted],[AddBy],[AddDate])
	      SELECT  SD.ProductId,SD.Quantity,[dbo].[GetLastStock](SD.ProductId),'OUT','S',0,
		  @Addby,GETDATE()
		   FROM @SalesDetails SD

		   DECLARE   @Quantity decimal(10,2) ,@Prod_SubTotal DECIMAL(10,2),@ProductId INT ,@UnitPrice DECIMAL(10,2), @RevenueAmt DECIMAL(10,2)=0,@PurchasePrice DECIMAL(10,2)
 
		DECLARE cursor_product CURSOR
		FOR SELECT ProductId, Quantity,SubTotal,UnitPrice FROM @SalesDetails
		OPEN cursor_product
 
		FETCH NEXT FROM cursor_product INTO @ProductId,@Quantity, @Prod_SubTotal,@UnitPrice
		WHILE @@FETCH_STATUS = 0
		BEGIN
				-- Insert Product Sales Details 
				INSERT INTO Inv_SalesDetails([SalesId],[ProductId],[Quantity],[SubTotal],IsDeleted,[AddBy],[Status],[AddDate],[UnitPrice],[Discount],[Vat],[NetPayable])
				SELECT @IID, @ProductId,@Quantity,@Prod_SubTotal,0,@Addby,'A',GETDATE(),@UnitPrice,0,0,0 
				
				PRINT @ProductId

				SELECT TOP 1 @PurchasePrice = UnitPrice  FROM Inv_PurchaseOrderDetails WHERE ProductId = @ProductId ORDER BY POId DESC -- Get Product Latest Purchase Price
				SET @RevenueAmt = @RevenueAmt + ((@UnitPrice-@PurchasePrice)*@Quantity) -- GET The orginal profit on this product
				PRINT @PurchasePrice
				

				DELETE FROM @TransactionDetail

				FETCH NEXT FROM cursor_product INTO @ProductId,@Quantity, @Prod_SubTotal ,@UnitPrice;
		END
 
		CLOSE cursor_product;
 
		DEALLOCATE cursor_product;

				--PRINT @RevenueAmt
				IF(@Vat=0) --  Excluding VAT
				BEGIN
				PRINT 'Excluding VAT' 
				
					---- Accounts Hit Transcation NO# 7
					SELECT @AccId1=LedgerId FROM ACC_Ledgers WHERE [Name] = 'Cash in hand'
					SELECT @AccId2=LedgerId FROM ACC_Ledgers WHERE [Name] = 'Revenue' 
					SELECT @AccId3=LedgerId FROM ACC_Ledgers WHERE [Name] = 'Merchandise Inventory' 
				
			
					INSERT INTO @TransactionDetail VALUES (1,@AccId1,@NetPayable,0,0,0,1) 
					INSERT INTO @TransactionDetail VALUES (2,@AccId2,0,@RevenueAmt,0,0,2)  
					INSERT INTO @TransactionDetail VALUES (3,@AccId3,0,(@NetPayable-@RevenueAmt),0,0,2)  
					--SP Calling: 
					EXEC Transactiondetailinsert NULL,0,'',4,@CurrDate,@NetPayable, @NetPayable, @Addby,'SALE_EX_VAT','IP','MAC', @TransactionDetail
				END
				ELSE -- Including VAT
				BEGIN				
					---- Accounts Hit Transcation NO# 8
					SELECT @AccId1=LedgerId FROM ACC_Ledgers WHERE [Name] = 'Cash in hand'
					SELECT @AccId2=LedgerId FROM ACC_Ledgers WHERE [Name] = 'Revenue' 
					SELECT @AccId3=LedgerId FROM ACC_Ledgers WHERE [Name] = 'Merchandise Inventory' 
					SELECT @AccId4=LedgerId FROM ACC_Ledgers WHERE [Name] = 'Sales tax liability (VAT)' 
			
					INSERT INTO @TransactionDetail VALUES (1,@AccId1,@NetPayable,0,0,0,1) 
					INSERT INTO @TransactionDetail VALUES (2,@AccId2,0,@RevenueAmt,0,0,2)  
					INSERT INTO @TransactionDetail VALUES (3,@AccId3,0,(@NetPayable-@RevenueAmt),0,0,2)  
					INSERT INTO @TransactionDetail VALUES (3,@AccId4,0,@Vat,0,0,2)  
					--SP Calling: 
					EXEC Transactiondetailinsert NULL,0,'',4,@CurrDate,@TotalAmount, @TotalAmount, @Addby,'Add_Prod_Dis','IP','MAC', @TransactionDetail
				END


		   COMMIT TRAN;
	END TRY

	BEGIN CATCH
	ROLLBACK TRAN 
		DECLARE @ErrorMessage NVARCHAR(4000); 
        DECLARE @ErrorSeverity INT; 
        DECLARE @ErrorState INT; 
        SELECT @ErrorMessage = Error_message(),  @ErrorSeverity = Error_severity(), @ErrorState = Error_state();          
        RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState); 
	END CATCH

	  

	-- Select * from Inv_Sales
	-- Select * from Inv_SalesDetails 
	-- Select * from Inv_StockTransaction
	-- Select * from Inv_ProductStocks
END

		   
