/****** Object:  StoredProcedure [dbo].[GetRootGroupCodeSetup]    Script Date: 3/05/2019 03:52:37 PM ******/ 
IF EXISTS (SELECT *  FROM   sys.objects WHERE  object_id = Object_id(N'[TransactionInsert]')) 
  BEGIN 
      DROP PROCEDURE TransactionInsert
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
CREATE PROCEDURE TransactionInsert 
@FiscalYearId        INT = NULL, 
@AccBranchId       INT , 
@TransType              INT , -- 1 = Recive ,2 = Payment , 3 = Contra , 4 = Journal
@Date              DATETIME , 
@DrTotal           DECIMAL , 
@CrTotal           DECIMAL , 
@AddBy             VARCHAR(128), 
@IP                VARCHAR(20), 
@MAC               VARCHAR(50), 
@PayMode			INT = NULL,
@ChequeNo			VARCHAR(MAX) = NULL,
@Description		Varchar(MAX) = NULL, 
@ChequeDate		DATETIME = NULL,
@PayTo		Varchar(MAX) = NULL,
@RecivedBy  Varchar(MAX) = NULL,
@IsReject  bit = NULL,
@TransactionDetail UTT_TRANSACTIONDETAIL readonly 
AS 
  BEGIN 
    BEGIN try 
        BEGIN TRAN 
        DECLARE @LedgerCurrAmt DECIMAL,@TrancNo VARCHAR(12) ,@LedgerCurrent DECIMAL,@LedgerName VARCHAR(max)=NULL,@mgs VARCHAR(max)=NULL,@LedgerDrAmount DECIMAL,@LedgerCrAmount DECIMAL,@CurrentAmount DECIMAL, 
@CurrentLedgerAmount DECIMAL=0,@TransactionId INT,@COUNT INT,@Row INT,@LId INT,@DC INT,@LedgDC INT,@CurrentBalanceDc INT,@ParentId1 INT, 
@ParentId2           INT, 
@ParentId3           INT, 
@LastCount           INT 

        -- Generate uniqne number serial on today 
        SELECT @LastCount = Max(id)  FROM   Acc_transaction WHERE  Cast(AddDate AS DATE) = Cast(Getdate() AS DATE) 
        SET @LastCount = @LastCount + 1  

        SELECT @TrancNo = 'T-' + Cast( Day(Getdate()) AS VARCHAR) + Cast( Month(Getdate()) AS VARCHAR) + RIGHT('0000'+Isnull(Cast(@LastCount AS VARCHAR(max)), ''),4) 
		PRINT @TrancNo
		SELECT TOP 1 @FiscalYearId = Id FROM ACC_FiscalYear WHERE [Status]= 'A' AND Id = @FiscalYearId

        INSERT INTO [dbo].[ACC_Transaction] ([FiscalYearId], [AccBranchId],[TransNo],[TransType],[Date],[DrTotal],[CrTotal],[IsDeleted],[AddBy],[AddDate],[Description],[Status],[IP],[MacAddress],IsApproved,[ApproveBy],PayTo,RecivedBy,IsReject,ApproveDate,[PayMode],ChequeNo,ChequeDate)         
		VALUES     ( @FiscalYearId,@AccBranchId, @TrancNo, @TransType, @Date, @DrTotal,@CrTotal,0,@AddBy,Getdate(),@Description,'Pending',@IP,@MAC,0,'',@PayTo,@RecivedBy,@IsReject,GETDATE(),@PayMode,@ChequeNo,@ChequeDate) 

        IF( @@ROWCOUNT = 0 ) 
		RAISERROR ('Transaction Not Insert',16,1); 
        SELECT @TransactionId = @@IDENTITY 

        INSERT INTO [dbo].[Acc_transactiondetail] 
                    ([transactionid],[ledgerid],[dramount],[cramount],[currentamount],[openingamount],DC) 
        SELECT @TransactionId,DT.LedgerId,DT.dramount,DT.cramount,DT.currentamount,DT.openingamount,DT.DC FROM   @TransactionDetail DT 

				
        IF( @@ROWCOUNT = 0 ) 
		RAISERROR ('Transaction detail Not Insert',16,1);         


		  SELECT @TrancNo AS VoucharNo,@TransactionId AS TransactionId
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
