

	DECLARE @StudentId INT = 23846 , @MonthId INT = 1, @Year INT = 2019 ,  @TotlaAmount DECIMAL(10,2),@TotalAmt DECIMAL(10,2),@ReciveAmt DECIMAL(10,2);
	DECLARE @TransactionDetail UTT_TRANSACTIONDETAIL ,@AccId1 INT ,@AccId2 INT,@AccId3 INT,@CurrDate DATETIME = GETDATE()

	SELECT  @TotalAmt =SUM(InvoiceAmount) , @ReciveAmt= SUM(DueAmount) FROM Fees_Student WHERE MonthId = @MonthId AND IsPaid = 0 AND IsCompleted = 0 AND StudentIID = @StudentId

	SELECT  * FROM Fees_Student WHERE MonthId = @MonthId AND IsPaid = 0 AND IsCompleted = 0 AND StudentIID = @StudentId




PRINT @TotalAmt 
PRINT @ReciveAmt


	SELECT @AccId1 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'Cash In Hand'
	SELECT @AccId2 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'Accounts Receivable'
	SELECT @AccId3 = LedgerId FROM ACC_Ledgers WHERE [Name] = 'Advance Tuition Fee'


	INSERT INTO @TransactionDetail VALUES (1,@AccId1,@TotalAmt,0,0,0,1)
	INSERT INTO @TransactionDetail VALUES (2,@AccId2,0,@ReciveAmt,0,0,2)
	INSERT INTO @TransactionDetail VALUES (3,@AccId3,0,(@TotalAmt-@ReciveAmt),0,0,2)

	SELECT * FROM @TransactionDetail

	EXEC Transactiondetailinsert NULL,0,'',4,@CurrDate,@TotalAmt, @TotalAmt, 'admin','Fees_Coll_SP','IP','MAC', @TransactionDetail

	UPDATE Fees_Student 
	SET 
	DueAmount = 0 ,
	--AdvanceAmount = InvoiceAmount-DueAmount,
	InvoiceAmount = 0,
	IsPaid = 1 , 
	IsCompleted = 1 
	WHERE StudentIID = @StudentId




 
