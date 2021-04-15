IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AddProduct]'))
BEGIN
DROP PROCEDURE  [AddProduct]
END
GO
/****** Object:  StoredProcedure [dbo].[AddProduct]    **/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC [dbo].[AddProduct] 0,PEN,P01,2,0,0,1,null,1,0,20,addmin,null
Create Procedure [dbo].[AddProduct]
(
@ProductId int =0,
@ProductName varchar(100),
@ProductCode varchar(100),
@ProductSubCateId int = 0,
@UnitId int = 0,
@ReOrderLevel int = 0,
@ProductTypeId INT ,
@Description varchar(Max),
@OpeningBalance decimal = 0,
@Amount  DECIMAL(10,2) =0,
@SellingPrice decimal = 0,
@AddBy varchar(100),
@AccCode VARCHAR(100)
)
As
BEGIN


BEGIN TRANSACTION ;
	BEGIN TRY
		DECLARE @TransactionDetail UTT_TRANSACTIONDETAIL ,@TotalAmount Decimal = 0 
		DECLare @IID INT =0 , @AccId1 INT , @AccId2 INT , @CurrDate SMALLDATETIME = GETDATE()
		INSERT INTO dbo.Inv_Product 
		(ProductName,ProductCode,ProductSubCateId,UnitId,ReOrderLevel,ProductTypeId,[Description],OpeningBalance
		,SellingPrice,AccCode, IsDeleted,AddBy,AddDate,[Status],[Amount])
		VALUES (@ProductName,@ProductCode,@ProductSubCateId,@UnitId,@ReOrderLevel,@ProductTypeId,@Description
				,@OpeningBalance,@SellingPrice,@AccCode,0,@AddBy,GETDATE(),'A',@Amount) 

		

		SELECT @IID = @@IDENTITY

		INSERT INTO Inv_StockTransaction([ProductId],[Quantity],[LastStockQty],[TransType],[TransCategory],[IsDeleted],[AddBy],[AddDate])
		VALUES(@IID,@OpeningBalance,0,'IN','OP',0,@AddBy,GETDATE())

		
		IF(@ProductTypeId=1) --  For Sale
		BEGIN
			SELECT	@TotalAmount  = (@OpeningBalance * @SellingPrice);  -- Added By Arif Suggest By Alvi Vai
			---- Accounts Hit Transcation NO# 1
			SELECT @AccId1=LedgerId FROM ACC_Ledgers WHERE [Name] = 'Merchandise inventory'
			SELECT @AccId2=LedgerId FROM ACC_Ledgers WHERE [Name] = 'Owners Equity'

			
			INSERT INTO @TransactionDetail VALUES (1,@AccId1,@TotalAmount,0,0,0,1) 
			INSERT INTO @TransactionDetail VALUES (2,@AccId2,0,@TotalAmount,0,0,2)  
			--SP Calling: 
			EXEC Transactiondetailinsert NULL,0,'',4,@CurrDate,@TotalAmount, @TotalAmount, @AddBy,'Add_Prod_Sale','IP','MAC', @TransactionDetail
		END
		IF(@ProductTypeId=2) -- For Distribute
		BEGIN
		SELECT	@TotalAmount  = (@OpeningBalance * @Amount);  -- Added By Arif Suggest By Alvi Vai
			---- Accounts Hit Transcation NO# 2
			SELECT @AccId1=LedgerId FROM ACC_Ledgers WHERE [Name] = 'Distributable Inventory'
			SELECT @AccId2=LedgerId FROM ACC_Ledgers WHERE [Name] = 'Owners Equity'
			
			INSERT INTO @TransactionDetail VALUES (1,@AccId1,@TotalAmount,0,0,0,1) 
			INSERT INTO @TransactionDetail VALUES (2,@AccId2,0,@TotalAmount,0,0,2)  
			--SP Calling: 
			EXEC Transactiondetailinsert NULL,0,'',4,@CurrDate,@TotalAmount, @TotalAmount, @AddBy,'Add_Prod_Dis','IP','MAC', @TransactionDetail
		END
		IF(@ProductTypeId=3) -- For Fixed Asset
		BEGIN
			SELECT	@TotalAmount  = (@OpeningBalance * @Amount);  -- Added By Arif Suggest By Alvi Vai
			---- Accounts Hit Transcation NO# 3
			SELECT @AccId1=LedgerId FROM ACC_Ledgers WHERE Code = @AccCode
			SELECT @AccId2=LedgerId FROM ACC_Ledgers WHERE [Name] = 'Owners Equity'
			
			INSERT INTO @TransactionDetail VALUES (1,@AccId1,@TotalAmount,0,0,0,1) 
			INSERT INTO @TransactionDetail VALUES (2,@AccId2,0,@TotalAmount,0,0,2)  
			--SP Calling: 
			EXEC Transactiondetailinsert NULL,0,'',4,@CurrDate,@TotalAmount, @TotalAmount, @AddBy,'Add_Prod_Dis','IP','MAC', @TransactionDetail
		END
		DELETE FROM @TransactionDetail

	COMMIT TRAN 
	Select SCOPE_IDENTITY()
	END TRY
	BEGIN CATCH		
		ROLLBACK TRAN 
		DECLARE @ErrorMessage NVARCHAR(4000); 
        DECLARE @ErrorSeverity INT; 
        DECLARE @ErrorState INT; 
        SELECT @ErrorMessage = Error_message(),  @ErrorSeverity = Error_severity(), @ErrorState = Error_state();          
        RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState); 
	END CATCH


END
