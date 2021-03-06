USE [cgsd_new_2019_test_20200112]
GO
/****** Object:  StoredProcedure [dbo].[Transactiondetailinsert_SalaryPayment]    Script Date: 5/6/2020 11:22:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 1 = Recive ,2 = Payment , 3 = Contra , 4 = Journal
-- execute [dbo].[Transactiondetailinsert_SalaryPayment] 1,9,'Admin' 
ALTER PROCEDURE [dbo].[Transactiondetailinsert_SalaryPayment]
( 
@SalaryPeriodId        INT = NULL,
@BranchId INT = NULL,    
@AddBy NVARCHAR(150)
)
AS 
  BEGIN 
 --   BEGIN try 
 --       BEGIN TRAN 
        DECLARE @LedgerCurrAmt DECIMAL,@LedgerCurrent DECIMAL,@LedgerName VARCHAR(max)=NULL,@mgs VARCHAR(max)=NULL,@LedgerDrAmount DECIMAL,@LedgerCrAmount DECIMAL,@CurrentAmount DECIMAL, 
@CurrentLedgerAmount DECIMAL=0,@TransactionId INT,@COUNT INT,@Row INT,@LId INT,@DC INT,@LedgDC INT,@CurrentBalanceDc INT,@ParentId1 INT, 
@ParentId2           INT, 
@ParentId3           INT, 
@LastCount           INT, 
@FiscalYear          INT,
@Number				 NVARCHAR(100),
@TotalSalaryAmount   DECIMAL(18,2)

        -- Generate uniqne number serial on today 
        SELECT @LastCount = Max(id)  FROM   Acc_transaction WHERE  Cast(adddate AS DATE) = Cast(Getdate() AS DATE) 
        SET @LastCount = @LastCount + 1 

        SELECT @Number = 'T-' + Cast( Day(Getdate()) AS VARCHAR) + Cast( Month(Getdate()) AS VARCHAR) + RIGHT('00'+Isnull(Cast(@LastCount AS VARCHAR(max)), ''),2) 

		SELECT TOP 1 @FiscalYear = Id FROM ACC_FiscalYear WHERE [Status]= 'A' AND [IsDeleted] = 0
		select @TotalSalaryAmount=SUM(NetAmount) from HR_SalaryPayDetails PD
		INNER JOIN Emp_BasicInfo B ON B.EmpBasicInfoID=PD.EmpId
		where SalaryPeriodId=@SalaryPeriodId AND B.BranchID= @BranchId group by SalaryPeriodId

		UPDATE HR_SalaryPayDetails SET IsConfirmed=1 where SalaryPeriodId=@SalaryPeriodId 

		---- Update [Acc_transaction] SET  [FiscalYearId] = 1
  --      INSERT INTO [dbo].[Acc_transaction] ([FiscalYearId], [AccBranchId],[TransNo],[TransType],[date],[drtotal],[crtotal],[isdeleted],[addby],[adddate],[remarks],[status],[ip],[macaddress])         
		--VALUES     ( @FiscalYear,0, @Number, 2, Getdate(), @TotalSalaryAmount,@TotalSalaryAmount,0,@AddBy,Getdate(),'Salary Payment','A','IP','MAC' ) 

  --      IF( @@ROWCOUNT = 0 ) 
		--RAISERROR ('Transaction Not Insert',16,1); 
  --      SELECT @TransactionId = @@IDENTITY 

  --      INSERT INTO [dbo].[Acc_transactiondetail] 
  --                  ([TransactionId],[LedgerId],[DrAmount],[CrAmount],[currentamount],[openingamount],DC) 
  --      SELECT @TransactionId,1733,@TotalSalaryAmount,0,0,0,1
		-- INSERT INTO [dbo].[Acc_transactiondetail] 
  --                  ([TransactionId],[LedgerId],[DrAmount],[CrAmount],[currentamount],[openingamount],DC) 
  --      SELECT @TransactionId,1677,0,@TotalSalaryAmount,0,0,2
		       

  --      IF( @@ROWCOUNT = 0 ) 
		--RAISERROR ('Transaction detail Not Insert',16,1);         

  --      SELECT @COUNT = Count(*)  FROM   [dbo].[acc_transactiondetail] WHERE [transactionid]=@TransactionId 
  --      PRINT Cast( @COUNT AS VARCHAR(max) ) + ' Rows' 
  --      SET @Row=1; 
  --      WHILE ( @Row <= @COUNT ) 
  --        BEGIN 
		--    PRINT CAST(@Row AS VARCHAR (MAX))
  --            ---------------------------------------insert transaction Layer 1 
  --            PRINT 'Level 1' 

  --            SELECT @LId = ledgerid,  @LedgerCrAmount = cramount,  @LedgerDrAmount = dramount, @DC = dc  FROM   [dbo].[acc_transactiondetail]  WHERE  [transactionid]=@TransactionId AND DC = @Row 

  --            PRINT 'LedgerId: ' +Cast( @LId AS VARCHAR(max) ) + ' , DC: '+Cast( @DC AS VARCHAR(max) )  +' , Cr: '+ Cast( @LedgerCrAmount AS VARCHAR(max) ) +' , Dr: '+ Cast( @LedgerDrAmount AS VARCHAR(max) )

  --            SELECT @LedgerCurrAmt = CurrentBalance, @LedgDC = CurrentBalanceDc,@ParentId1 = ParentId, @LedgerName = [Name] 
  --            FROM   Acc_ledgers WHERE  LedgerId = @LId 
  --            PRINT 'Curr Ledger Amt 1:  ' + Cast( @LedgerCurrAmt AS VARCHAR(max) ) + ' , DC: '+ Cast( @LedgDC AS VARCHAR(max) ) 

  --            IF( @DC = 1 ) 
  --              BEGIN 
  --                  IF( @LedgDC = 1 ) 
  --                    BEGIN 
  --                        SET @CurrentAmount=(@LedgerCurrAmt + @LedgerDrAmount) 
  --                    END 
  --                  ELSE 
  --                    BEGIN 
  --                        SET @CurrentAmount=(@LedgerCurrAmt - @LedgerDrAmount) 
  --                    END 
  --              END 
  --            ELSE 
  --              BEGIN 
  --                  IF( @LedgDC = 2 ) 
  --                    BEGIN 
  --                        SET @CurrentAmount=(@LedgerCurrAmt + @LedgerCrAmount) 
  --                    END 
  --                  ELSE 
  --                    BEGIN 
  --                        SET @CurrentAmount=(@LedgerCurrAmt - @LedgerCrAmount) 
  --                    END 
  --              END 

  --            PRINT 'New Amount 1: ' + Cast( @CurrentAmount AS VARCHAR(max) ) 

  --            UPDATE ACC_Ledgers SET    CurrentBalance = @CurrentAmount WHERE  LedgerId = @LId 

  --            IF( @@ROWCOUNT = 0 ) 
		--	  RAISERROR ('Ledger 1 Not Insert',16,1); 
			             

  --            ---------------------------------------insert transaction Layer 2 
  --            IF ( @ParentId1 != 0 ) 
  --              BEGIN 
  --                  PRINT 'P1>> ' + Cast( @ParentId1 AS VARCHAR ) 

  --                  SELECT @LedgerCurrAmt = currentbalance, 
  --                         @LedgDC = currentbalancedc, 
  --                         @ParentId2 = parentid, 
  --                         @LedgerName = [name] 
  --                  FROM   Acc_ledgers 
  --                  WHERE  ledgerid = @ParentId1 

  --                  PRINT '@LedgerName 2  ' + @LedgerName + ' ' 
  --                        + Cast( @ParentId1 AS VARCHAR(max) ) 

  --                  PRINT '@@LedgerCurrAmt 2  ' 
  --                        + Cast( @LedgerCurrAmt AS VARCHAR(max) ) + ' ' 
  --                        + Cast( @ParentId1 AS VARCHAR(max) ) 

  --                  PRINT '@@DC 2  ' + Cast( @DC AS VARCHAR(max) ) 

  --                  PRINT '@@LedgDC 2  ' + Cast( @DC AS VARCHAR(max) ) 

  --                  IF( @DC = 1 ) 
  --                    BEGIN 
  --                        IF( @LedgDC = 1 ) 
  --                          BEGIN 
  --                              SET @CurrentAmount=( 
  --                              @LedgerCurrAmt + @LedgerDrAmount ) 
  --                          END 
  --                        ELSE 
  --                          BEGIN 
  --                              SET @CurrentAmount=( 
  --                              @LedgerCurrAmt - @LedgerDrAmount ) 
  --                          END 
  --                    END 
  --                  ELSE 
  --                    BEGIN 
  --                        IF( @LedgDC = 2 ) 
  --                          BEGIN 
  --                              SET @CurrentAmount=( 
  --                              @LedgerCurrAmt + @LedgerCrAmount ) 
  --                          END 
  --                        ELSE 
  --                          BEGIN 
  --                              SET @CurrentAmount=( 
  --                              @LedgerCurrAmt - @LedgerCrAmount ) 
  --                          END 
  --                    END 

  --                  PRINT '@@CurrentAmount 2: ' 
  --                        + Cast( @CurrentAmount AS VARCHAR(max) ) 

  --                  UPDATE Acc_ledgers 
  --                  SET    currentbalance = @CurrentAmount 
  --                  WHERE  ledgerid = @ParentId1 

  --                  IF( @@ROWCOUNT = 0 ) 
  --                    BEGIN 
  --                        RAISERROR ('Ledger 2 Not Insert',16,1); 
  --                    END 

  --                  SET @LedgerName =NULL; 
  --              END 

  --            ---------------------------------------insert transaction Layer 2 
  --            IF ( @ParentId2 != 0 ) 
  --              BEGIN 
  --                  SELECT @LedgerCurrAmt = currentbalance, 
  --                         @LedgDC = currentbalancedc, 
  --                         @ParentId3 = parentid, 
  --                         @LedgerName = NAME 
  --                  FROM   dbo.Acc_ledgers 
  --                  WHERE  ledgerid = @ParentId2 

  --                  PRINT '@LedgerName 3  ' + @LedgerName + ' ' 
  --                        + Cast( @ParentId2 AS VARCHAR(max) ) 

  --                  PRINT '@@LedgerCurrAmt 3  ' 
  --                        + Cast( @LedgerCurrAmt AS VARCHAR(max) ) + ' ' 
  --                        + Cast( @ParentId2 AS VARCHAR(max) ) 

  --                  PRINT '@@DC 3  ' + Cast( @DC AS VARCHAR(max) ) 

  --                  PRINT '@@LedgDC 3  ' + Cast( @DC AS VARCHAR(max) ) 

  --                  IF( @DC = 1 ) 
  --                    BEGIN 
  --                        IF( @LedgDC = 1 ) 
  --                          BEGIN 
  --                              SET @CurrentAmount=( 
  --                              @LedgerCurrAmt + @LedgerDrAmount ) 
  --                          END 
  --                        ELSE 
  --                          BEGIN 
  --                              SET @CurrentAmount=( 
  --                              @LedgerCurrAmt - @LedgerDrAmount ) 
  --                          END 
  --                    END 
  --                  ELSE 
  --                    BEGIN 
  --                        IF( @LedgDC = 2 ) 
  --                          BEGIN 
  --                              SET @CurrentAmount=( 
  --                              @LedgerCurrAmt + @LedgerCrAmount ) 
  --                          END 
  --                        ELSE 
  --                          BEGIN 
  --                              SET @CurrentAmount=( 
  --                              @LedgerCurrAmt - @LedgerCrAmount ) 
  --                          END 
  --                    END 

  --                  PRINT '@@CurrentAmount 3 ' 
  --                        + Cast( @CurrentAmount AS VARCHAR(max) ) 

  --                  UPDATE Acc_ledgers 
  --                  SET    currentbalance = @CurrentAmount 
  --                  WHERE  ledgerid = @ParentId2 

  --                  IF( @@ROWCOUNT = 0 ) 
  --                    BEGIN 
  --                        RAISERROR ('Ledger 3 Not Insert',16,1); 
  --                    END 

  --                  SET @LedgerName =NULL; 
  --              END 

  --            SET @Row=@Row + 1; 
  --        END 
		--  SELECT @Number AS VoucharNo
  --      COMMIT TRAN 
  --  END try 

  --  BEGIN catch 
  --      ROLLBACK TRAN 

  --      DECLARE @ErrorMessage NVARCHAR(4000); 
  --      DECLARE @ErrorSeverity INT; 
  --      DECLARE @ErrorState INT; 

  --      SELECT @ErrorMessage = Error_message(), 
  --             @ErrorSeverity = Error_severity(), 
  --             @ErrorState = Error_state(); 

  --      -- Use RAISERROR inside the CATCH block to return error  
  --      -- information about the original error that caused  
  --      -- execution to jump to the CATCH block.  
  --      RAISERROR (@ErrorMessage,-- Message text.  
  --                 @ErrorSeverity,-- Severity.  
  --                 @ErrorState -- State.  
  --      ); 
  -- END catch 
END 
