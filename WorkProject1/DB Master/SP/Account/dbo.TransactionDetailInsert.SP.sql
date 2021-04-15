/****** Object:  StoredProcedure [dbo].[GetRootGroupCodeSetup]    Script Date: 3/05/2019 03:52:37 PM ******/ 
IF EXISTS (SELECT *  FROM   sys.objects WHERE  object_id = Object_id(N'[TransactionDetailInsert]')) 
  BEGIN 
      DROP PROCEDURE Transactiondetailinsert 
  END 
go 
SET ansi_nulls ON 
go 
SET quoted_identifier ON 
go 
/*
DECLARE @TransactionDetail UTT_TRANSACTIONDETAIL  
INSERT INTO @TransactionDetail VALUES (1,1020,500,0,500.00,0,1) 
INSERT INTO @TransactionDetail VALUES (2,1034,0,500,500.00,0,2)  
--SP Calling: 
EXEC Transactiondetailinsert 1002,0,'1908270001',2,'2019-12-30',500, 500, 'Admin','Remaks','IP','MAC', @TransactionDetail

UPDATE L
SET L.ParentId = (SELECT   LedgerId FROM ACC_Ledgers A WHERE A.ParentId  = T.ParentId AND A.Name = T.Name) 

FROM ACC_Ledgers L 
INNER JOIN ACC_COATemp T ON T.[Name] = L.[Name]

*/	

-- execute [dbo].[GetRootGroupCodeSetup] 
CREATE PROCEDURE Transactiondetailinsert 
@FiscalYear        INT = NULL, 
@BranchId          INT , 
@Number            VARCHAR(20) ='', 
@Type              INT , -- 1 = Recive ,2 = Payment , 3 = Contra , 4 = Journal
@Date              DATETIME , 
@DrTotal           DECIMAL(18,2) = 0 , 
@CrTotal           DECIMAL(18,2) = 0 , 
@AddBy             VARCHAR(128), 
@Remarks           VARCHAR(100), 
@IP                VARCHAR(20), 
@MAC               VARCHAR(50), 
@InvoiceTransType     INT=0 ,
@TransactionDetail UTT_TRANSACTIONDETAIL readonly 
AS 
  BEGIN 
    BEGIN try 
        BEGIN TRAN 
        DECLARE @LedgerCurrAmt DECIMAL(18,2) = 0,@LedgerCurrent DECIMAL(18,2) = 0,@LedgerName VARCHAR(max)=NULL,@mgs VARCHAR(max)=NULL,@LedgerDrAmount DECIMAL(18,2) = 0,@LedgerCrAmount DECIMAL(18,2) = 0,@CurrentAmount DECIMAL(18,2) = 0, 
@CurrentLedgerAmount DECIMAL(18,2) = 0,@TransactionId INT,@COUNT INT,@Row INT,@LId INT,@DC INT,@LedgDC INT,@CurrentBalanceDc INT,@ParentId1 INT, 
@ParentId2           INT, 
@ParentId3           INT, 
@LastCount           INT 

        -- Generate uniqne number serial on today 
        SELECT @LastCount = Max(id)  FROM   Acc_transaction WHERE  Cast(adddate AS DATE) = Cast(Getdate() AS DATE) 
        SET @LastCount = @LastCount + 1 

        SELECT @Number = 'T-' + Cast( Day(Getdate()) AS VARCHAR) + Cast( Month(Getdate()) AS VARCHAR) + RIGHT('0000'+Isnull(Cast(@LastCount AS VARCHAR(max)), ''),4) 

		SELECT TOP 1 @FiscalYear = Id FROM ACC_FiscalYear WHERE [Status]= 'A' AND [IsDeleted] = 0

		-- Update [Acc_transaction] SET  [FiscalYearId] = 1
        INSERT INTO [dbo].[Acc_transaction] ([FiscalYearId], [AccBranchId],[TransNo],[TransType],[date],[drtotal],[crtotal],[isdeleted],[addby],[adddate],[remarks],[status],[ip],[macaddress],IsApproved,InvoiceTransType)         
		VALUES     ( @FiscalYear,@BranchId, @Number, @Type, @Date, @DrTotal,@CrTotal,0,@AddBy,Getdate(),@Remarks,'Approved',@IP,@MAC,1,@InvoiceTransType ) 

        IF( @@ROWCOUNT = 0 ) 
		RAISERROR ('Transaction Not Insert',16,1); 
        SELECT @TransactionId = @@IDENTITY 

        INSERT INTO [dbo].[Acc_transactiondetail] 
                    ([TransactionId],[LedgerId],[DrAmount],[CrAmount],[currentamount],[openingamount],DC) 
        SELECT @TransactionId,DT.ledgerid,DT.dramount,DT.cramount,DT.currentamount,DT.openingamount,DT.dc
		        FROM   @TransactionDetail DT 

        IF( @@ROWCOUNT = 0 ) 
		RAISERROR ('Transaction detail Not Insert',16,1);  
		
		CREATE TABLE #TransactionDetail(
		[RowNo] [int] IDENTITY(1,1) NOT NULL,
		[LedgerId] [int] NOT NULL,	
		[DrAmount] [decimal](18, 2) NOT NULL,
		[CrAmount] [decimal](18, 2) NOT NULL,
		[CurrentAmount] [decimal](18, 2) NOT NULL,
		[OpeningAmount] [decimal](18, 2) NOT NULL,
		[DC] INT NOT NULL
		)

		 INSERT INTO #TransactionDetail([LedgerId],[DrAmount],[CrAmount],[currentamount],[openingamount],DC) 
         SELECT DT.ledgerid,DT.dramount,DT.cramount,DT.currentamount,DT.openingamount,DT.dc FROM   @TransactionDetail DT

        SELECT @COUNT = Count(*)  FROM   @TransactionDetail 
        PRINT Cast( @COUNT AS VARCHAR(max) ) + ' Rows' 
        SET @Row=1; 
        WHILE ( @Row <= @COUNT ) 
          BEGIN 
		    PRINT CAST(@Row AS VARCHAR (MAX))
              ---------------------------------------insert transaction Layer 1 
              PRINT 'Level 1' 

              SELECT @LId = ledgerid,  @LedgerCrAmount = cramount,  @LedgerDrAmount = dramount, @DC = dc  FROM   #TransactionDetail  WHERE  RowNo = @Row 

              PRINT 'LedgerId: ' +Cast( @LId AS VARCHAR(max) ) + ' , DC: '+Cast( @DC AS VARCHAR(max) )  +' , Cr: '+ Cast( @LedgerCrAmount AS VARCHAR(max) ) +' , Dr: '+ Cast( @LedgerDrAmount AS VARCHAR(max) )

              SELECT @LedgerCurrAmt = CurrentBalance, @LedgDC = CurrentBalanceDc,@ParentId1 = ParentId, @LedgerName = [Name] 
              FROM   Acc_ledgers WHERE  LedgerId = @LId 
              PRINT 'Curr Ledger Amt 1:  ' + Cast( @LedgerCurrAmt AS VARCHAR(max) ) + ' , DC: '+ Cast( @LedgDC AS VARCHAR(max) ) 

              IF( @DC = 1 ) 
                BEGIN 
                    IF( @LedgDC = 1 ) 
                      BEGIN 
                          SET @CurrentAmount=(@LedgerCurrAmt + @LedgerDrAmount) 
                      END 
                    ELSE 
                      BEGIN 
                          SET @CurrentAmount=(@LedgerCurrAmt - @LedgerDrAmount) 
                      END 
                END 
              ELSE 
                BEGIN 
                    IF( @LedgDC = 2 ) 
                      BEGIN 
                          SET @CurrentAmount=(@LedgerCurrAmt + @LedgerCrAmount) 
                      END 
                    ELSE 
                      BEGIN 
                          SET @CurrentAmount=(@LedgerCurrAmt - @LedgerCrAmount) 
                      END 
                END 

              PRINT 'New Amount 1: ' + Cast( @CurrentAmount AS VARCHAR(max) ) 

              UPDATE ACC_Ledgers SET    CurrentBalance = @CurrentAmount WHERE  LedgerId = @LId 

              IF( @@ROWCOUNT = 0 ) 
			  RAISERROR ('Ledger 1 Not Insert',16,1); 
			             

              ---------------------------------------insert transaction Layer 2 
              IF ( @ParentId1 != 0 ) 
                BEGIN 
                    PRINT 'P1>> ' + Cast( @ParentId1 AS VARCHAR ) 

                    SELECT @LedgerCurrAmt = currentbalance, 
                           @LedgDC = currentbalancedc, 
                           @ParentId2 = parentid, 
                           @LedgerName = [name] 
                    FROM   Acc_ledgers 
                    WHERE  ledgerid = @ParentId1 

                    PRINT '@LedgerName 2  ' + @LedgerName + ' ' 
                          + Cast( @ParentId1 AS VARCHAR(max) ) 

                    PRINT '@@LedgerCurrAmt 2  ' 
                          + Cast( @LedgerCurrAmt AS VARCHAR(max) ) + ' ' 
                          + Cast( @ParentId1 AS VARCHAR(max) ) 

                    PRINT '@@DC 2  ' + Cast( @DC AS VARCHAR(max) ) 

                    PRINT '@@LedgDC 2  ' + Cast( @DC AS VARCHAR(max) ) 

                    IF( @DC = 1 ) 
                      BEGIN 
                          IF( @LedgDC = 1 ) 
                            BEGIN 
                                SET @CurrentAmount=( 
                                @LedgerCurrAmt + @LedgerDrAmount ) 
                            END 
                          ELSE 
                            BEGIN 
                                SET @CurrentAmount=( 
                                @LedgerCurrAmt - @LedgerDrAmount ) 
                            END 
                      END 
                    ELSE 
                      BEGIN 
                          IF( @LedgDC = 2 ) 
                            BEGIN 
                                SET @CurrentAmount=( 
                                @LedgerCurrAmt + @LedgerCrAmount ) 
                            END 
                          ELSE 
                            BEGIN 
                                SET @CurrentAmount=( 
                                @LedgerCurrAmt - @LedgerCrAmount ) 
                            END 
                      END 

                    PRINT '@@CurrentAmount 2: ' 
                          + Cast( @CurrentAmount AS VARCHAR(max) ) 

                    UPDATE Acc_ledgers 
                    SET    currentbalance = @CurrentAmount 
                    WHERE  ledgerid = @ParentId1 

                    IF( @@ROWCOUNT = 0 ) 
                      BEGIN 
                          RAISERROR ('Ledger 2 Not Insert',16,1); 
                      END 

                    SET @LedgerName =NULL; 
                END 

              ---------------------------------------insert transaction Layer 2 
              IF ( @ParentId2 != 0 ) 
                BEGIN 
                    SELECT @LedgerCurrAmt = currentbalance, 
                           @LedgDC = currentbalancedc, 
                           @ParentId3 = parentid, 
                           @LedgerName = NAME 
                    FROM   dbo.Acc_ledgers 
                    WHERE  ledgerid = @ParentId2 

                    PRINT '@LedgerName 3  ' + @LedgerName + ' ' 
                          + Cast( @ParentId2 AS VARCHAR(max) ) 

                    PRINT '@@LedgerCurrAmt 3  ' 
                          + Cast( @LedgerCurrAmt AS VARCHAR(max) ) + ' ' 
                          + Cast( @ParentId2 AS VARCHAR(max) ) 

                    PRINT '@@DC 3  ' + Cast( @DC AS VARCHAR(max) ) 

                    PRINT '@@LedgDC 3  ' + Cast( @DC AS VARCHAR(max) ) 

                    IF( @DC = 1 ) 
                      BEGIN 
                          IF( @LedgDC = 1 ) 
                            BEGIN 
                                SET @CurrentAmount=( 
                                @LedgerCurrAmt + @LedgerDrAmount ) 
                            END 
                          ELSE 
                            BEGIN 
                                SET @CurrentAmount=( 
                                @LedgerCurrAmt - @LedgerDrAmount ) 
                            END 
                      END 
                    ELSE 
                      BEGIN 
                          IF( @LedgDC = 2 ) 
                            BEGIN 
                                SET @CurrentAmount=( 
                                @LedgerCurrAmt + @LedgerCrAmount ) 
                            END 
                          ELSE 
                            BEGIN 
                                SET @CurrentAmount=( 
                                @LedgerCurrAmt - @LedgerCrAmount ) 
                            END 
                      END 

                    PRINT '@@CurrentAmount 3 ' 
                          + Cast( @CurrentAmount AS VARCHAR(max) ) 

                    UPDATE Acc_ledgers 
                    SET    currentbalance = @CurrentAmount 
                    WHERE  ledgerid = @ParentId2 

                    IF( @@ROWCOUNT = 0 ) 
                      BEGIN 
                          RAISERROR ('Ledger 3 Not Insert',16,1); 
                      END 

                    SET @LedgerName =NULL; 
                END 

              SET @Row=@Row + 1; 
          END 
		  DROP TABLE #TransactionDetail
		  SELECT @Number AS VoucharNo
        COMMIT TRAN 
    END try 

    BEGIN catch 
        ROLLBACK TRAN 

        DECLARE @ErrorMessage NVARCHAR(4000); 
        DECLARE @ErrorSeverity INT; 
        DECLARE @ErrorState INT; 

        SELECT @ErrorMessage = Error_message(), 
               @ErrorSeverity = Error_severity(), 
               @ErrorState = Error_state(); 

        -- Use RAISERROR inside the CATCH block to return error  
        -- information about the original error that caused  
        -- execution to jump to the CATCH block.  
        RAISERROR (@ErrorMessage,-- Message text.  
                   @ErrorSeverity,-- Severity.  
                   @ErrorState -- State.  
        ); 
    END catch 
END 

go 
