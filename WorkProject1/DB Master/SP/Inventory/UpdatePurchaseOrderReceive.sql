/****** Object:  UserDefinedTableType [dbo].[udtPurchaseOrderDetails]   */
/*IF type_id('[dbo].[udtUpdatePurchaseOrderDetails]') IS NOT NULL
DROP TYPE [dbo].[udtUpdatePurchaseOrderDetails];
GO

CREATE TYPE [dbo].[udtUpdatePurchaseOrderDetails] AS TABLE(
    ReceiveQuantity decimal(10,2) NULL, 
	PODetailsId INT NOT NULL,
	ProductId INT NOT NULL

)
GO*/
/*
DECLARE @UpdateOrderDetails udtUpdatePurchaseOrderDetails  
INSERT INTO @UpdateOrderDetails VALUES (5,95,68) 
--SP Calling: 
EXEC UpdatePurchaseOrderReceive 87,'dfgdf','dfgfdg', @UpdateOrderDetails



*/



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UpdatePurchaseOrderReceive]'))
BEGIN
DROP PROCEDURE  [UpdatePurchaseOrderReceive]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE [dbo].[UpdatePurchaseOrderReceive]
(
    @POId INT,
	@UpdateBy VARCHAR(50)=null,
	@ReceiverComments varchar(MAX) = null,
	@UpdateOrderDetails udtUpdatePurchaseOrderDetails READONLY
)	
AS
BEGIN

	BEGIN TRANSACTION ;
	BEGIN TRY
		DECLARE @TransactionDetail UTT_TRANSACTIONDETAIL  
		DECLARE @IID  INT,@TotalAmount Decimal = 0,@UnitPrice DECIMAL =0  
		DECLARE @CODE varchar(25)
		DECLARE @TPrice decimal(10,2) =0 , @SupAccCode VARCHAR(100),@ProAccCode VARCHAR(100), @AccountId INT , @AccRecId INT = 39 , @FISYear INT, @AccId1 INT , @AccId2 INT ,
		@CurrDate SMALLDATETIME = GETDATE() , @PType INT 
		SELECT TOP 1 @FISYear = Id FROM ACC_FiscalYear WHERE [Status] = 'A' 

		SELECT @SupAccCode = S.AccountCode , @TPrice = PD.TotalPrice FROM Inv_PurchaseOrder PD  INNER JOIN Inv_Supplier S ON S.SupplierId = PD.SupplierId
		WHERE	POId = @POId
		PRINT @SupAccCode

		

		DECLARE   @ReceiveQuantity decimal(10,2) ,@PODetailsId INT,@ProductId INT ,@ProductTypeId INT, @Amount DECIMAL(10,2),@OpeningAmount DECIMAL(10,2)
 
		DECLARE cursor_product CURSOR
		FOR SELECT ReceiveQuantity, PODetailsId,ProductId FROM @UpdateOrderDetails
		OPEN cursor_product
 
		FETCH NEXT FROM cursor_product INTO @ReceiveQuantity, @PODetailsId,@ProductId
		WHILE @@FETCH_STATUS = 0
		BEGIN
				Update Inv_PurchaseOrderDetails   SET ReceiveQuantity  = @ReceiveQuantity WHERE PODetailsId = @PODetailsId
				--SELECT @Amount = TotalPrice FROM Inv_PurchaseOrderDetails WHERE PODetailsId = @PODetailsId AND ProductId = @ProductId
				SELECT @ProductTypeId = ProductTypeId  FROM Inv_Product WHERE ProductId = @ProductId
				SELECT @UnitPrice = UnitPrice  FROM Inv_PurchaseOrderDetails WHERE ProductId = @ProductId AND POId= @POId
				SELECT	@TotalAmount  = (@ReceiveQuantity * @UnitPrice);  
				IF(@ProductTypeId=1) --  For Sale
				BEGIN
				PRINT 'For Sale' 
				
					---- Accounts Hit Transcation NO# 1
					SELECT @AccId1=LedgerId FROM ACC_Ledgers WHERE [Name] = 'Merchandise Inventory'
					SELECT @AccId2=LedgerId FROM ACC_Ledgers WHERE Code = @SupAccCode 
				PRINT @AccId1
			
					INSERT INTO @TransactionDetail VALUES (1,@AccId1,@TotalAmount,0,0,0,1) 
					INSERT INTO @TransactionDetail VALUES (2,@AccId2,0,@TotalAmount,0,0,2)  
					--SP Calling: 
					EXEC Transactiondetailinsert NULL,0,'',4,@CurrDate,@TotalAmount, @TotalAmount, @UpdateBy,'Add_Prod_Sale','IP','MAC', @TransactionDetail
				END
				IF(@ProductTypeId=2) -- For Distribute
				BEGIN
				--SELECT @OpeningAmount = Amount  FROM Inv_Product WHERE ProductId = @ProductId
				--SELECT	@TotalAmount  = (@ReceiveQuantity * @OpeningAmount);  -- Added By Arif Suggest By Alvi Vai
					---- Accounts Hit Transcation NO# 2
					SELECT @AccId1=LedgerId FROM ACC_Ledgers WHERE [Name] = 'Distributable Inventory'
					SELECT @AccId2=LedgerId FROM ACC_Ledgers WHERE Code = @SupAccCode 
			
					INSERT INTO @TransactionDetail VALUES (1,@AccId1,@TotalAmount,0,0,0,1) 
					INSERT INTO @TransactionDetail VALUES (2,@AccId2,0,@TotalAmount,0,0,2)  
					--SP Calling: 
					EXEC Transactiondetailinsert NULL,0,'',4,@CurrDate,@TotalAmount, @TotalAmount, @UpdateBy,'Add_Prod_Dis','IP','MAC', @TransactionDetail
				END
				IF(@ProductTypeId=3) -- For Fixed Asset
				BEGIN
					---- Accounts Hit Transcation NO# 3

					SELECT @ProAccCode = AccCode  FROM Inv_Product WHERE ProductId = @ProductId
					PRINT @ProAccCode PRINT @SupAccCode

					SELECT @AccId1=LedgerId FROM ACC_Ledgers WHERE Code =@ProAccCode
					SELECT @AccId2=LedgerId FROM ACC_Ledgers WHERE Code =  @SupAccCode
			
					INSERT INTO @TransactionDetail VALUES (1,@AccId1,@TotalAmount,0,0,0,1) 
					INSERT INTO @TransactionDetail VALUES (2,@AccId2,0,@TotalAmount,0,0,2)  
					--SP Calling: 
					EXEC Transactiondetailinsert NULL,0,'',4,@CurrDate,@TotalAmount, @TotalAmount, @UpdateBy,'Add_Prod_Dis','IP','MAC', @TransactionDetail
				END

				DELETE FROM @TransactionDetail

				FETCH NEXT FROM cursor_product INTO @ReceiveQuantity, @PODetailsId,@ProductId; 
		END
 
		CLOSE cursor_product;
 
		DEALLOCATE cursor_product;


		Update dbo.Inv_PurchaseOrder
		SET IsReceived = 1,ReceiverComments = @ReceiverComments,UpdateBy = @UpdateBy , UpdateDate =GETDATE(),ReceivedBy= @UpdateBy
		WHERE	POId = @POId

		INSERT INTO Inv_StockTransaction([ProductId],[Quantity],[LastStockQty],[TransType],[TransCategory],[IsDeleted],UpdateBy,UpdateDate)
		SELECT  OD.ProductId,OD.ReceiveQuantity,dbo.GetLastStock( OD.ProductId),'IN','P',0,@UpdateBy,GETDATE()
		FROM @UpdateOrderDetails OD


	  
	COMMIT TRAN 
	END TRY
	BEGIN CATCH		
		ROLLBACK TRAN 
		DECLARE @ErrorMessage NVARCHAR(4000); 
        DECLARE @ErrorSeverity INT; 
        DECLARE @ErrorState INT; 
        SELECT @ErrorMessage = Error_message(),  @ErrorSeverity = Error_severity(), @ErrorState = Error_state();          
        RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState); 
	END CATCH
		

	-- Select * from Inv_PurchaseOrder
	-- Select * from Inv_PurchaseOrderDetails 
	-- Select * from Inv_StockTransaction
	-- Select * from Inv_ProductStocks

END

		   
