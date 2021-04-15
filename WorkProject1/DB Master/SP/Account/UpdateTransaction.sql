IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UpdateTransaction]'))
BEGIN
DROP PROCEDURE  UpdateTransaction
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO --- EXEC UpdateTransaction 7551,'admin',''
Create PROCEDURE [dbo].UpdateTransaction
(
@TransactionId INT =0,
@ApproveBy VARCHAR(MAX),
@UpdateUserId VARCHAR(MAX)
)
AS
BEGIN  
	--  UpdateTransaction
	
	BEGIN try 
        BEGIN TRAN 
			
			DECLARE @Row INT =1, @Max INT 

	UPDATE dbo.ACC_Transaction
			SET ApproveBy = @ApproveBy
				,UpdateBy = @UpdateUserId
				,UpdateDate = GETDATE()
				,IsApproved = 1
				,ApproveDate = GETDATE()
				,[Status] = 'Approved'
	WHERE Id = @TransactionId;

	SELECT ROW_NUMBER() OVER(ORDER BY id ASC) AS IId,* INTO #TransDetails
	FROM ACC_TransactionDetail WHERE TransactionId= @TransactionId

	SET @Max = @@ROWCOUNT
	PRINT @Max

	WHILE(@Row<=@Max)
	BEGIN
		DECLARE @LId INT , @LedgerCrAmount DECIMAL(10,2),@LedgerDrAmount  DECIMAL(10,2),@DC INT

		SELECT @LId= LedgerId,@LedgerCrAmount =  CrAmount , @LedgerDrAmount = DrAmount, @DC = DC FROM  #TransDetails WHERE IId = @Row
		  PRINT 'TRAN:' +CAST(@Row AS VARCHAR)+ ' LedgerId: ' +Cast( @LId AS VARCHAR(max) ) + ' , DC: '+Cast( @DC AS VARCHAR(max) )  +' , Cr: '+ Cast( @LedgerCrAmount AS VARCHAR(max) ) +' , Dr: '+ Cast( @LedgerDrAmount AS VARCHAR(max) )
		 EXEC UpdateLedgerAmount @LId,@LedgerCrAmount,@LedgerDrAmount,@DC
		 SET @Row = @Row +1
	END


	

	SELECT @@ROWCOUNT 
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





	
	---SELECT * FROM dbo.ACC_Transaction WHERE TransactionId = @TransactionId
	
END