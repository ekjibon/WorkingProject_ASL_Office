/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FeesCollection]'))
BEGIN
DROP PROCEDURE  [FeesCollection]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		 Biplob 
-- Create date: 
-- Description:	
-- =============================================
/*
CREATE TYPE dbo.UTT_FeesStuCollection AS TABLE 
(
	ID INT NOT NULL,
	
	[HeadId] [int] NOT NULL,
	[StudenIId] [int] NOT NULL,
	

)
*/
-- execute FeesCollection 3,2020,'admin','5119','3/1/2020 6:00:00 PM'
CREATE  PROCEDURE [dbo].[FeesCollection] 	
	@MonthId INT ,
	@Year INT ,
	@AddBy VARCHAR(200),
	@StuIds VARCHAR(1000),
	@BankCollectionDate VARCHAR(1000)
	--@ChequeNo VARCHAR(200)
AS
BEGIN
set transaction isolation level read uncommitted;
BEGIN TRANSACTION 

BEGIN TRY






	DECLARE @TotlaAmount DECIMAL(10,2),@TotalAmt DECIMAL(10,2),@ReciveAmt DECIMAL(10,2),@COUNTER INT,@MAXID INT , @StudentId INT,@MoneyReciptNo VARCHAR(MAX)='',@Count INT = 0;
	DECLARE @IID INT ;
	DECLARE @TransactionDetail UTT_TRANSACTIONDETAIL ,@AccId1 INT ,@AccId2 INT,@AccId3 INT,@CurrDate DATETIME = GETDATE(),@AccId4 INT




	SELECT ROW_NUMBER() OVER(ORDER BY value ASC) AS ID, value  AS StudentId INTO #StuId FROM STRING_SPLIT(@StuIds, ',')  
	SELECT @MAXID = @@ROWCOUNT
	SET @COUNTER = 1

	WHILE (@COUNTER <= @MAXID)
	BEGIN
		SELECT @Count = (COUNT(*) + 1) FROM [Fees_CollectionMaster] 
	SET @MoneyReciptNo = CAST(YEAR(GETDATE()) AS VARCHAR(28)) +  CAST(MONTH(GETDATE()) AS VARCHAR(28)) + CAST(DAY(GETDATE()) AS VARCHAR(28)) + CAST(@Count AS VARCHAR(MAX));
	PRINT @MoneyReciptNo

	SELECT @StudentId = StudentId FROM #StuId WHERE ID = @COUNTER 
	PRINT @StudentId

	SELECT  @TotalAmt = ISNULL(SUM(InvoiceAmount),0) , @ReciveAmt= SUM(DueAmount) FROM Fees_Student 
	WHERE MonthId <= @MonthId AND IsPaid = 0 AND IsCompleted = 0 AND StudentIID = @StudentId
	--SELECT  * FROM Fees_Student WHERE MonthId = @MonthId AND IsPaid = 0 AND IsCompleted = 0 AND StudentIID = @StudentId

		IF(@TotalAmt>0)
		BEGIN

			PRINT @TotalAmt 
			PRINT @ReciveAmt


			SELECT @AccId1 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'Cash In Hand'
			SELECT @AccId2 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'Accounts Receivable'
			SELECT @AccId3 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'Advance Tuition Fee'

			--SELECT @AccId4 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'Late Fine'


			INSERT INTO @TransactionDetail VALUES (1,@AccId1,@TotalAmt,0,0,0,1)
			INSERT INTO @TransactionDetail VALUES (2,@AccId2,0,@ReciveAmt,0,0,2)
			INSERT INTO @TransactionDetail VALUES (3,@AccId3,0,(@TotalAmt-@ReciveAmt),0,0,2)

			--SELECT * FROM @TransactionDetail

			EXEC Transactiondetailinsert NULL,0,'',4,@CurrDate,@TotalAmt, @TotalAmt, 'admin','Fees_Coll_SP','IP','MAC', @TransactionDetail






			INSERT INTO [dbo].[Fees_CollectionMaster]
           ([StudentIID],[PaymentDate],[TotalAmount],[ReceivedAmount],[TotalDiscountAmount],[PaymentMonth],[MoneyReceipt],[PaymentType],[ChequeNo],[BankName]
			,[IsPosted],[BoothID],[BankCollectionDate],[IsDeleted],[AddBy],[AddDate],[MonthId],[SessionId],[VAT],[PayModeNo])
			VALUES(@StudentId,GETDATE(),@TotalAmt,@TotalAmt,0,@MonthId,@MoneyReciptNo,2,'','',1,0,CAST(@BankCollectionDate AS DATETIME),0,@AddBy,GETDATE(),@MonthId,1,0,1)

			SELECT @IID = @@IDENTITY

			
			INSERT INTO [dbo].[Fees_CollectionDetails]
			([MasterID],[Amount],[DueAmount],[AdvanceAmount],[ScholarshipAmount],[DiscountAmount],[ReceiveAmount],[IsLateFine],[IsDeleted],[AddBy],[AddDate],[HeadId],[MonthId],[Year])
			SELECT  @IID,TotalAmount, DueAmount,AdvanceAmount,ScholarshipAmount,DiscountAmount,DueAmount,0,0,@AddBy,GETDATE(),HeadId,MonthId,@Year
			FROM Fees_Student
			WHERE StudentIID = @StudentId AND MonthId <= @MonthId AND [Year] <= @Year AND IsPaid = 0


			UPDATE Fees_Student 
			SET 
			DueAmount = 0 ,
			--AdvanceAmount = InvoiceAmount-DueAmount,
			InvoiceAmount = 0,
			IsPaid = 1 , 
			IsCompleted = 1 
			WHERE StudentIID = @StudentId AND MonthId = @MonthId AND [Year] = @Year

			DELETE FROM @TransactionDetail

		END

	SET @COUNTER =@COUNTER + 1
	END

	SELECT @MoneyReciptNo As MoneyReciptNo


	




COMMIT TRANSACTION ;
END TRY
BEGIN CATCH;
	ROLLBACK TRANSACTION ;
	DECLARE @ErrorMessage NVARCHAR(4000);  
    DECLARE @ErrorSeverity INT;  
    DECLARE @ErrorState INT;  
    SELECT   
        @ErrorMessage = ERROR_MESSAGE(),  
        @ErrorSeverity = ERROR_SEVERITY(),  
        @ErrorState = ERROR_STATE();  
    RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);  

END CATCH  

END
go



