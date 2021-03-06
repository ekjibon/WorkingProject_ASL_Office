/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UpdateLedgerAmount]'))
BEGIN
DROP PROCEDURE  UpdateLedgerAmount
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- EXEC  dbo.UpdateLedgerAmount 1678,00.00,22000.00,1

CREATE PROCEDURE [dbo].[UpdateLedgerAmount]
(	
	@LId INT,
	@LedgerCrAmount DECIMAL(10,2),
	@LedgerDrAmount DECIMAL(10,2) ,	
	@DC INT
)
AS
BEGIN
	
	DECLARE @ParentId INT = 0 ,@CurrentAmount DECIMAL(18,2),@LedgerName VARCHAR(150),@LedgerCurrAmt DECIMAL(18,2) ,@LedgDC  DECIMAL(10,2)

	 

	  
             
              SELECT @LedgerCurrAmt = CAST(CurrentBalance AS DECIMAL(18,2)), @LedgDC = CurrentBalanceDc,@ParentId = ParentId, @LedgerName = [Name] 
              FROM   Acc_ledgers WHERE  LedgerId = @LId 
            PRINT @ParentId

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

			

              UPDATE ACC_Ledgers SET    CurrentBalance = @CurrentAmount WHERE  LedgerId = @LId 

             
			   IF(@ParentId!=0)
			   BEGIN
					EXEC UpdateLedgerAmount @ParentId,@LedgerCrAmount,@LedgerDrAmount,@DC
			   END
			             
				

	

END


GO
