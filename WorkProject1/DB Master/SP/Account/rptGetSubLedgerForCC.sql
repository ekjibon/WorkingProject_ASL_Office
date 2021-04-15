IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetSubLedgerForCC]'))
BEGIN
DROP PROCEDURE  rptGetSubLedgerForCC
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
-- exec rptGetSubLedgerForCC 2733,'2020/08/01','2020/08/31',1
Create PROCEDURE [dbo].rptGetSubLedgerForCC 
(
@LedgerId INT NULL,
@FromDate VARCHAR(MAX) NULL,
@ToDate VARCHAR(MAX) NULL,
@BranchId INT NULL
)
AS
BEGIN  
 DECLARE @CrAmount DECIMAL(18,2),@DrAmount DECIMAL(18,2),@OpeningtAmount DECIMAL(18,2),@TransOpeningtAmount DECIMAL(18,2),@CurrAmount DECIMAL(18,2),@MaxID INT,@COUNTER INT,@TotalAmnt DECIMAL(18,2)
       ,@RootGroup INT,@CurrentAmount DECIMAL(18,2),@transNo VARCHAR(MAX)

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

	IF(@RootGroup=1 OR @RootGroup=4)
				BEGIN
					SELECT  @TransOpeningtAmount=(@OpeningtAmount+SUM(DrAmount))-SUM(CrAmount)
					FROM ACC_TransactionDetail AcT
					INNER JOIN dbo.ACC_Transaction T ON  T.Id = AcT.TransactionId
					WHERE LedgerId = @LedgerId  AND CAST(T.Date AS DATE) < CAST(@FromDate AS DATE)
					AND T.IsApproved = 1
					AND T.IsReject= 0
					AND AccBranchId = @BranchId
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
					AND AccBranchId = @BranchId
					GROUP BY LedgerId
				END
	SET @OpeningtAmount=ISNULL(@TransOpeningtAmount,0);
	PRINT @OpeningtAmount
	
	INSERT INTO #tempTranDetail 
	SELECT DrAmount,CrAmount,TransNo 
	FROM ACC_TransactionDetail AcT
	INNER JOIN dbo.ACC_Transaction T ON  T.Id = AcT.TransactionId
	WHERE LedgerId = @LedgerId  AND CAST(T.Date AS DATE) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE)
	AND T.IsApproved = 1
	AND T.IsReject= 0
	AND AccBranchId = @BranchId
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

	
	SELECT   T.Date,T.DrTotal,T.CrTotal,T.TransNo,T.TransType--,TTA.ClosingAmount
	        ,TD.CrAmount
			,TD.DrAmount
			,TTA.TotalAmount
			,(SELECT [Name] FROM dbo.ACC_Ledgers WHERE LedgerId = L.ParentId)  AS GroupName
			,L.[Name] AS LedgerName,B.[Name],ISNULL(@TransOpeningtAmount,0) OpenningBalance,L.OpenningBalanceDc,L.RootGroupId 
			
			,CAST(@FromDate AS datetime) AS FromDate
			,CAST(@ToDate AS datetime) AS ToDate
			,'' AS CostCenterName,0 AS CostCenterAmount
			FROM dbo.ACC_Transaction T
			INNER JOIN dbo.ACC_TransactionDetail TD ON TD.TransactionId = T.Id
			INNER JOIN dbo.ACC_Ledgers L ON TD.LedgerId = L.LedgerId
			INNER JOIN dbo.ACC_Branchs B ON T.AccBranchId = B.BranchId
			INNER JOIN #tempTotalAmount TTA ON TTA.TransNo=T.TransNo
		
			WHERE T.AccBranchId = ISNULL(@BranchId,T.AccBranchId) 
					AND  CAST(T.Date AS DATE) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE)
				    AND L.LedgerId = @LedgerId
					AND T.IsApproved = 1
			        AND T.IsReject= 0
                   -- ORDER BY T.Date,T.TransNo asc	
				   GROUP BY T.Date,T.DrTotal,T.CrTotal,T.TransNo,T.TransType,TD.CrAmount,TD.DrAmount,TTA.TotalAmount,L.[Name],B.[Name],L.OpenningBalanceDc,L.RootGroupId,L.ParentId
		  UNION ALL
	SELECT T.Date,0,0,T.TransNo,0,0,0,0,L1.Name,L.Name,'',0,0,0,CAST(@FromDate AS datetime) AS FromDate,CAST(@ToDate AS datetime) AS ToDate,CC.CostCenterName AS CostCenterName, SUM(CCD.Amount) AS CostCenterAmount
	FROM [dbo].[ACC_CostCenterDetails] CCD
	INNER JOIN [dbo].[ACC_CostCenter] CC ON CC.Id = CCD.CostCenterId
	INNER JOIN ACC_Ledgers L ON L.LedgerId= CCD.LedgerId
	INNER JOIN[dbo].[ACC_Transaction] T ON T.Id = CCD.TransactionId
	JOIN ACC_Ledgers L1 ON L1.LedgerId = L.ParentId
	WHERE CCD.LedgerId = @LedgerId
	GROUP BY CCD.LedgerId,CC.CostCenterName,L.Name,L1.Name,T.Date,T.TransNo,L.ParentId

			DROP TABLE #tempTotalAmount
			DROP TABLE #tempTranDetail

END