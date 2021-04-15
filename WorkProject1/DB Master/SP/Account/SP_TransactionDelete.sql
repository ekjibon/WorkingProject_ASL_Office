
/****** Object:  StoredProcedure [dbo].[SP_TransactionDelete]    Script Date: 25/03/2021 3:01:21 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_TransactionDelete]'))
BEGIN
DROP PROCEDURE  SP_TransactionDelete
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- execute [dbo].[SP_TransactionDelete] 394
CREATE PROCEDURE [dbo].[SP_TransactionDelete] 
(
@TransactionId        INT = NULL
)
                                         
AS 
  BEGIN 
      BEGIN try 
          BEGIN TRAN 
          DECLARE @LedgerAmount DECIMAL ,@LedgerCurrent Decimal,@LedgerName varchar(max)=null,@mgs varchar(max)=null
          DECLARE @LedgerDrAmount DECIMAL 
          DECLARE @LedgerCrAmount DECIMAL 
          DECLARE @CurrentAmount DECIMAL ,@CurrentLedgerAmount DECIMAL=0
         
          DECLARE @COUNT INT 
          DECLARE @Row INT 
          DECLARE @LId INT 
          DECLARE @DC INT ,@LedgDC INT,@CurrentBalanceDc int, @ParentId1 int,@ParentId2 int,@ParentId3 int

         


   --      UPDATE [dbo].[acc_transactiondetail] SET  [isdeleted]=1,Status='Deleted' WHERE [transactionid]=@TransactionId
		 --UPDATE [dbo].[ACC_Transaction] SET  [isdeleted]=1,Status='Deleted' WHERE Id=@TransactionId
         

          --IF( @@ROWCOUNT = 0 ) 
          --  BEGIN 
          --      RAISERROR ('Transaction detail Not Delete',16,1); 
          --  END 

          SET @COUNT=(SELECT Count(*) 
                      FROM   [dbo].[acc_transactiondetail] WHERE [transactionid]=@TransactionId); 
		   print '@@COUNT ' +cast( @COUNT  as varchar(max) )

		   DECLARE Structure_Cursor CURSOR FOR 
	
	(SELECT ledgerid,  cramount,  dramount , DC
                FROM   [dbo].[acc_transactiondetail] WHERE [transactionid]=@TransactionId ) 
	
	OPEN Structure_Cursor;

	FETCH NEXT FROM Structure_Cursor 
	INTO @LId , @LedgerCrAmount, @LedgerDrAmount, @DC

	WHILE @@FETCH_STATUS = 0
		BEGIN
			
			BEGIN

---------------------------------------insert transaction Layer 1 
			 
			  print '@Row'+cast( @Row  as varchar(max) )
			  print 'Lavel 1'
             

			print '@@LedgerCrAmount '+cast( @LedgerCrAmount  as varchar(max) )
			print '@@LedgerDrAmount '+cast( @LedgerDrAmount  as varchar(max) )
			print '@Ledger 1 '+cast( @LId  as varchar(max) )

            SELECT @LedgerAmount = currentbalance ,@LedgDC= CurrentBalanceDc,@ParentId1=ParentId,@LedgerName=Name
                                   FROM   dbo.acc_ledgers 
                                   WHERE  ledgerid = @LId 
			print '@LedgerName 1  '+@LedgerName+' Id '+cast( @LId  as varchar(max) )
			print '@@LedgerAmount 1  '+ cast( @LedgerAmount  as varchar(max) )+' '+cast( @LId  as varchar(max) )
			print '@@DC 1  '+cast( @DC  as varchar(max) )
			print '@@LedgDC 1  '+cast( @DC  as varchar(max) )

			    if(@DC = 1) 
				BEGIN 
				  IF(@LedgDC =1)
						BEGIN
						SET @CurrentAmount=( @LedgerAmount - @LedgerDrAmount )
						END
				  ELSE
						BEGIN
						SET @CurrentAmount=( @LedgerAmount + @LedgerDrAmount )
						END
				END
				else
				BEGIN
				IF(@LedgDC =2)
					BEGIN
					 SET @CurrentAmount=( @LedgerAmount - @LedgerCrAmount )
					END
					ELSE
					BEGIN
					 SET @CurrentAmount=( @LedgerAmount + @LedgerCrAmount )
				END
				END

				print '@@CurrentAmount 1 '+cast( @CurrentAmount  as varchar(max) )
				update ACC_Ledgers set CurrentBalance= @CurrentAmount  WHERE  ledgerid = @LId  
				IF( @@ROWCOUNT = 0 ) 
            BEGIN 
                RAISERROR ('Ledger 1 Not Insert',16,1); 
            END 
			SET @LedgerName =null;
			
---------------------------------------insert transaction Layer 2
			  if (@ParentId1 != 0)
			  BEGIN
			
            SELECT @LedgerAmount = currentbalance ,@LedgDC= CurrentBalanceDc,@ParentId2=ParentId,@LedgerName=Name
                                   FROM   dbo.acc_ledgers 
                                   WHERE  ledgerid = @ParentId1 
			print '@LedgerName 2  '+@LedgerName+' '+cast( @ParentId1  as varchar(max) )
			print '@@LedgerAmount 2  '+ cast( @LedgerAmount  as varchar(max) )+' '+cast( @ParentId1  as varchar(max) )
			print '@@DC 2  '+cast( @DC  as varchar(max) )
			print '@@LedgDC 2  '+cast( @DC  as varchar(max) )

			    if(@DC = 1) 
				BEGIN 
				IF(@LedgDC =1)
					BEGIN
					 SET @CurrentAmount=( @LedgerAmount - @LedgerDrAmount )
					END
					ELSE
					BEGIN
					 SET @CurrentAmount=( @LedgerAmount + @LedgerDrAmount )
				END
				END
				else
				BEGIN
				IF(@LedgDC =2)
					BEGIN
					 SET @CurrentAmount=( @LedgerAmount - @LedgerCrAmount )
					END
					ELSE
					BEGIN
					 SET @CurrentAmount=( @LedgerAmount + @LedgerCrAmount )
				END
				END

				print '@@CurrentAmount 2 '+cast( @CurrentAmount  as varchar(max) )
				update ACC_Ledgers set CurrentBalance= @CurrentAmount  WHERE  ledgerid = @ParentId1  
				IF( @@ROWCOUNT = 0 ) 
            BEGIN 
                RAISERROR ('Ledger 2 Not Insert',16,1); 
            END 
			SET @LedgerName =null;
			END
---------------------------------------insert transaction Layer 2

			  if (@ParentId2 != 0)
			  BEGIN
			
            SELECT @LedgerAmount = currentbalance ,@LedgDC= CurrentBalanceDc,@ParentId3=ParentId,@LedgerName=Name
                                   FROM   dbo.acc_ledgers 
                                   WHERE  ledgerid = @ParentId2 
			print '@LedgerName 3  '+@LedgerName+' '+cast( @ParentId2  as varchar(max) )
			print '@@LedgerAmount 3  '+ cast( @LedgerAmount  as varchar(max) )+' '+cast( @ParentId2  as varchar(max) )
			print '@@DC 3  '+cast( @DC  as varchar(max) )
			print '@@LedgDC 3  '+cast( @DC  as varchar(max) )

			    if(@DC = 1) 
				BEGIN 
				IF(@LedgDC =1)
					BEGIN
					 SET @CurrentAmount=( @LedgerAmount - @LedgerDrAmount )
					END
					ELSE
					BEGIN
					 SET @CurrentAmount=( @LedgerAmount + @LedgerDrAmount )
				END
				END
				else
				BEGIN
				IF(@LedgDC =2)
					BEGIN
					 SET @CurrentAmount=( @LedgerAmount - @LedgerCrAmount )
					END
					ELSE
					BEGIN
					 SET @CurrentAmount=( @LedgerAmount + @LedgerCrAmount )
				END
				END

				print '@@CurrentAmount 3 '+cast( @CurrentAmount  as varchar(max) )
				update ACC_Ledgers set CurrentBalance= @CurrentAmount  WHERE  ledgerid = @ParentId2
				  
				IF( @@ROWCOUNT = 0 ) 
            BEGIN 
                RAISERROR ('Ledger 3 Not Insert',16,1); 
            END 
			SET @LedgerName =null;
			END
                --SET @Row=@Row + 1; 
            END
			
		FETCH NEXT FROM Structure_Cursor 
		
		INTO  @LId , @LedgerCrAmount, @LedgerDrAmount, @DC
		END
		DEALLOCATE Structure_Cursor;

		delete FROM [dbo].[ACC_Transaction] where Id=@TransactionId
		delete FROM [dbo].[ACC_TransactionDetail] where TransactionId=@TransactionId
	

            --BEGIN  
          COMMIT TRAN 
      END try 
      BEGIN catch 

	  rollback TRAN 
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

