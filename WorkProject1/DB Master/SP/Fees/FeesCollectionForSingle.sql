/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FeesCollectionForSingle]'))
BEGIN
DROP PROCEDURE  [FeesCollectionForSingle]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		 ARIFUR 
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
-- execute FeesCollectionForSingle 9,2019,'admin','4720','3/1/2020 6:00:00 PM'
CREATE  PROCEDURE [dbo].[FeesCollectionForSingle] 	
	@MonthId INT ,
	@Year INT ,
	@AddBy VARCHAR(200),
	@StuId INT,
	@BankCollectionDate DATETIME
	--@ChequeNo VARCHAR(200)
AS
BEGIN
set transaction isolation level read uncommitted;
BEGIN TRANSACTION 

BEGIN TRY






	DECLARE @TotlaAmount DECIMAL(10,2),@TotalAmt DECIMAL(10,2),@InvoiceAmt DECIMAL(10,2),@ReciveAmt DECIMAL(10,2),@COUNTER INT,@MAXID INT , @StudentId INT,@MoneyReciptNo VARCHAR(MAX)='',@Count INT = 0,@AdvAmount DECIMAL(10,2);
	DECLARE @IID INT ,@BranchId INT,@AccBranchId INT,@AccRemarks NVARCHAR(200)='';
	DECLARE @TransactionDetail UTT_TRANSACTIONDETAIL ,@AccId1 INT ,@AccId2 INT,@AccId3 INT,@CurrDate DATETIME = GETDATE(),@AccId4 INT




	SELECT ROW_NUMBER() OVER(ORDER BY FeesStudentId ASC) AS ID,FeesStudentId,StudentIID  AS StudentId,HeadId,DueAmount,PaidAmount,InvoiceAmount,PartialAmount,AdvanceAmount,TotalAmount
															,ScholarshipAmount,DiscountAmount,MonthId,IsPaid,IsCompleted,Year
							INTO #StuId FROM dbo.Fees_Student WHERE StudentIID = @StuId 
							AND datefromparts(Year,MonthId, 1) <= EOMONTH(datefromparts(@Year, @MonthId, 1)) AND IsCompleted = 0 AND IsDeleted=0 AND IsEnrollment=0 --AND InvoiceAmount <> 0
		
		--SELECT * from #StuId
	
			SELECT @MAXID = @@ROWCOUNT
			SET @COUNTER = 1
		
		SELECT @Count = (COUNT(*) + 1) FROM [Fees_CollectionMaster] 
			SET @MoneyReciptNo = CAST(YEAR(GETDATE()) AS VARCHAR(28)) +  CAST(MONTH(GETDATE()) AS VARCHAR(28)) + CAST(DAY(GETDATE()) AS VARCHAR(28)) + CAST(@Count AS VARCHAR(MAX));
			PRINT @MoneyReciptNo

		SELECT  @TotalAmt = ISNULL(SUM(InvoiceAmount),0) ,@AdvAmount=ISNULL(SUM(AdvanceAmount),0) FROM #StuId WHERE InvoiceAmount <> 0
		PRINT @TotalAmt

		SET @BranchId=(select top 1 BranchID from [dbo].[Student_BasicInfo] where StudentIID=@StuId)
		IF(@BranchId=8)
		BEGIN
		SET @AccBranchId=1;
		END
		IF(@BranchId=9)
		BEGIN
		SET @AccBranchId=2;
		END
		
		IF(@TotalAmt>0)
		BEGIN

				

					IF(@AdvAmount>0)
					 SET @ReciveAmt = @TotalAmt - @AdvAmount;
					 ELSE
					 SET @ReciveAmt = @TotalAmt;

					 PRINT @TotalAmt 
					PRINT @ReciveAmt
					PRINT @AdvAmount
					 --RETURN
					SELECT @AccId1 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'Cash In Hand'
					SELECT @AccId2 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'Accounts Receivable'
					

					--SELECT @AccId4 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'Late Fine'


					INSERT INTO @TransactionDetail VALUES (1,@AccId1,@TotalAmt,0,0,0,1)
					INSERT INTO @TransactionDetail VALUES (2,@AccId2,0,@ReciveAmt,0,0,2)
					
					IF(@AdvAmount>0)
					BEGIN
					SELECT @AccId3 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'Advance Tuition Fee'
					INSERT INTO @TransactionDetail VALUES (3,@AccId3,0,@AdvAmount,0,0,2)
					END
				

					--SELECT * FROM @TransactionDetail
					SET @AccRemarks='Fees_Coll_SP_'+CAST(@StuId AS NVARCHAR(50));

					EXEC Transactiondetailinsert NULL,@AccBranchId,'',4,@CurrDate,@TotalAmt, @TotalAmt, 'admin',@AccRemarks,'IP','MAC', @TransactionDetail

		END




			INSERT INTO [dbo].[Fees_CollectionMaster]
           ([StudentIID],[PaymentDate],[TotalAmount],[ReceivedAmount],[TotalDiscountAmount],[PaymentMonth],[MoneyReceipt],[PaymentType],[ChequeNo],[BankName]
			,[IsPosted],[BoothID],[BankCollectionDate],[IsDeleted],[AddBy],[AddDate],[MonthId],[SessionId],[VAT],[PayModeNo])
			VALUES(@StuId,GETDATE(),@TotalAmt,@TotalAmt,0,@MonthId,[dbo].[MoneyReceiptGenerate](),1,'','',1,0,@BankCollectionDate,0,@AddBy,GETDATE(),@MonthId,1,0,1)

			SELECT @IID = @@IDENTITY

			
			INSERT INTO [dbo].[Fees_CollectionDetails]
			([MasterID],[Amount],[DueAmount],[AdvanceAmount],[ScholarshipAmount],[DiscountAmount],[ReceiveAmount],[IsLateFine],[IsDeleted],[AddBy],[AddDate],[HeadId],[MonthId],[Year])
			SELECT  @IID,TotalAmount,DueAmount,AdvanceAmount,ScholarshipAmount,DiscountAmount,InvoiceAmount,0,0,@AddBy,GETDATE(),HeadId,MonthId,@Year
			FROM #StuId WHERE InvoiceAmount <> 0
					

			WHILE (@COUNTER <= @MAXID)
			BEGIN
			DECLARE @HeadId INT= 0;
				SELECT @StudentId = FeesStudentId,@HeadId=HeadId,@InvoiceAmt= InvoiceAmount FROM #StuId WHERE ID = @COUNTER 
				

				BEGIN
							UPDATE Fees_Student 
							SET 
							DueAmount = (CASE  
											WHEN  PartialAmount > 0 OR PartialAmount IS NOT NULL THEN PartialAmount
											ELSE 0
											END
										),
							PaidAmount =PaidAmount + @InvoiceAmt,
							InvoiceAmount = (CASE  
												WHEN  PartialAmount > 0 OR PartialAmount IS NOT NULL  THEN PartialAmount
												ELSE 0
												END
											),

							IsPaid = (CASE  
											WHEN  PartialAmount > 0 OR PartialAmount IS NOT NULL THEN 0
											ELSE 1
											END
										), 
							IsCompleted = (CASE  
											WHEN  PartialAmount > 0 OR PartialAmount IS NOT NULL THEN 0
											ELSE 1
											END
										),
							PartialAmount = NULL
							WHERE FeesStudentId = @StudentId AND HeadId = @HeadId AND InvoiceAmount <> 0  --AND MonthId = @MonthId AND [Year] = @Year

							UPDATE dbo.Fees_Student 
							SET InvoiceAmount = DueAmount,PartialAmount = NULL
							WHERE  FeesStudentId = @StudentId AND HeadId = @HeadId AND InvoiceAmount  = 0

				END

			SET @COUNTER =@COUNTER + 1
			END

	DELETE FROM @TransactionDetail
	DROP TABLE #StuId

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



