IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetSubLedger]'))
BEGIN
DROP PROCEDURE  rptGetSubLedger
END
GO
SET ANSI_NULLS ON 
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		 Khaled
-- Create date: 13/11/2019
-- Description:	
-- =============================================
-- exec rptGetSubLedger 3356,'2018/09/01','2020/09/30',1
Create PROCEDURE [dbo].rptGetSubLedger 
(
@LedgerId INT NULL,
@FromDate VARCHAR(MAX) NULL,
@ToDate VARCHAR(MAX) NULL,
@BranchId INT NULL
)
AS
BEGIN  
 DECLARE @CrAmount DECIMAL(18,2),@DrAmount DECIMAL(18,2),@OpeningtAmount DECIMAL(18,2),@TransOpeningtAmount DECIMAL(18,2),@CurrAmount DECIMAL(18,2),@MaxID INT,@COUNTER INT,@TotalAmnt DECIMAL(18,2)
       ,@RootGroup INT,@CurrentAmount DECIMAL(18,2),@transNo VARCHAR(MAX),@OpeningBalaceIn DECIMAL(18,2)

 CREATE TABLE #tempTranDetail
 (
       [Id] [int] IDENTITY (1, 1) NOT NULL,
	   DrAmount DECIMAL(18,2),
	   CrAmount DECIMAL(18,2),
	   TransNo VARCHAR(MAX)
 )
 CREATE TABLE #tempTotalAmount
 (
       [Id] [int] IDENTITY (1, 1) NOT NULL,
	   TransNo VARCHAR(MAX),
	   DrAmount DECIMAL(18,2),
	   CrAmount DECIMAL(18,2),
       TotalAmount DECIMAL(18,2),
       ClosingAmount DECIMAL(18,2),
	   LegId INT 
	 
 )



	SELECT @OpeningtAmount= ISNULL(OpenningBalance,0),@RootGroup=RootGroupId,@CurrentAmount = CurrentBalance FROM ACC_Ledgers ACL WHERE LedgerId = @LedgerId
	set @OpeningBalaceIn=@OpeningtAmount;
	IF(@RootGroup=1 OR @RootGroup=4)
				BEGIN
					SELECT  @TransOpeningtAmount=(@OpeningtAmount+SUM(DrAmount))-SUM(CrAmount)
					FROM ACC_TransactionDetail AcT
					INNER JOIN dbo.ACC_Transaction T ON  T.Id = AcT.TransactionId
					WHERE LedgerId = @LedgerId  AND CAST(T.Date AS DATE) < CAST(@FromDate AS DATE)
					AND T.IsApproved = 1
					AND T.IsReject= 0
					AND AccBranchId =  CASE WHEN @BranchId<>0 THEN @BranchID ELSE AccBranchId END
					GROUP BY LedgerId
					
				END
			IF(@RootGroup=2 OR @RootGroup=3)
				BEGIN
				    SELECT  @TransOpeningtAmount=(@OpeningtAmount-SUM(DrAmount))+SUM(CrAmount)
					FROM ACC_TransactionDetail AcT
					INNER JOIN dbo.ACC_Transaction T ON  T.Id = AcT.TransactionId
					WHERE LedgerId = @LedgerId  AND CAST(T.Date AS DATE) < CAST(@FromDate AS DATE)
					AND T.IsApproved = 1
					AND T.IsReject= 0
					AND AccBranchId = CASE WHEN @BranchId<>0 THEN @BranchID ELSE AccBranchId END
					GROUP BY LedgerId
				END
	SET @OpeningtAmount=ISNULL(@TransOpeningtAmount,@OpeningBalaceIn);
	PRINT @OpeningtAmount
	PRINT @OpeningBalaceIn
	
	INSERT INTO #tempTranDetail 
	SELECT DrAmount,CrAmount,TransNo 
	FROM ACC_TransactionDetail AcT
	INNER JOIN dbo.ACC_Transaction T ON  T.Id = AcT.TransactionId
	WHERE LedgerId = @LedgerId  AND CAST(T.Date AS DATE) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE)
	AND T.IsApproved = 1
	AND T.IsReject= 0
	AND AccBranchId = CASE WHEN @BranchId<>0 THEN @BranchID ELSE AccBranchId END
	ORDER BY T.Date,TransNo asc 

	  --SELECT * FROM #tempTranDetail


	SET @MaxID = @@ROWCOUNT
	PRINT CAST(@MaxID AS VARCHAR(50))
	SET @COUNTER = 1;
WHILE(@COUNTER<= @MaxID)
BEGIN
		SELECT @CrAmount = CrAmount,@DrAmount = DrAmount,@transNo=TransNo  FROM #tempTranDetail WHERE Id = @COUNTER
     

	 			IF(@RootGroup=1 OR @RootGroup=4)
				BEGIN
				PRINT CAST(@DrAmount AS VARCHAR)
					 --SET @TotalAmnt = (2000 + 500) - 3000;
					 SET @TotalAmnt = (@OpeningtAmount + @DrAmount) - @CrAmount;
					 SET @OpeningtAmount = @TotalAmnt;		
					 INSERT INTO #tempTotalAmount VALUES(@transNo,@DrAmount,@CrAmount,@OpeningtAmount,0,@LedgerId)
					-- PRINT CAST(@OpeningtAmount AS VARCHAR)
					--PRINT CAST(@TotalAmnt AS VARCHAR)
				END
			IF(@RootGroup=2 OR @RootGroup=3)
				BEGIN
					 SET @TotalAmnt = (@OpeningtAmount - @DrAmount) + @CrAmount;
					 SET @OpeningtAmount = @TotalAmnt;
					 INSERT INTO #tempTotalAmount VALUES(@transNo,@DrAmount,@CrAmount,@OpeningtAmount,0,@LedgerId)

					-- PRINT CAST(@OpeningtAmount AS VARCHAR)
				END
	
		SET @COUNTER = @COUNTER + 1;
	
END
--PRINT CAST(@OpeningtAmount AS VARCHAR)

		--SELECT * FROM #TEMPTRANDETAIL
		--SELECT * FROM #TEMPTOTALAMOUNT

		
	UPDATE #tempTotalAmount SET ClosingAmount = (SELECT TotalAmount FROM #tempTotalAmount WHERE Id = @COUNTER - 1)

	
	SELECT   T.*--,TTA.ClosingAmount
	        ,TD.CrAmount
			,TD.DrAmount
			,TTA.TotalAmount
			,(SELECT [Name] FROM dbo.ACC_Ledgers WHERE LedgerId = L.ParentId)  AS GroupName
			,L.[Name] AS LedgerName,B.[Name],ISNULL(@TransOpeningtAmount,@OpeningBalaceIn) OpenningBalance,L.OpenningBalanceDc,L.RootGroupId 
			
			,CAST(@FromDate AS datetime) AS FromDate
			,CAST(@ToDate AS datetime) AS ToDate
			FROM dbo.ACC_Transaction T
			INNER JOIN dbo.ACC_TransactionDetail TD ON TD.TransactionId = T.Id
			INNER JOIN dbo.ACC_Ledgers L ON TD.LedgerId = L.LedgerId
			INNER JOIN dbo.ACC_Branchs B ON T.AccBranchId = B.BranchId
			INNER JOIN #tempTotalAmount TTA ON TTA.TransNo=T.TransNo
		
			WHERE T.AccBranchId = CASE WHEN @BranchId<>0 THEN @BranchID ELSE T.AccBranchId END 
					AND  CAST(T.Date AS DATE) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE)
				    AND L.LedgerId = @LedgerId
					AND T.IsApproved = 1
			        AND T.IsReject= 0
                    ORDER BY T.Date,T.TransNo asc	
		

			DROP TABLE #tempTotalAmount
			DROP TABLE #tempTranDetail

END

-- rptGetSubLedger 1679,'2019-12-01 00:00:00.000','2019-12-31 00:00:00.000',1


/*
		SELECT * FROM dbo.ACC_Ledgers
		SELECT * FROM dbo.ACC_TransactionDetail WHERE  TransactionId = 421
		SELECT * FROM #TEMPTRANDETAIL
		SELECT * FROM #TEMPTOTALAMOUNT
*/