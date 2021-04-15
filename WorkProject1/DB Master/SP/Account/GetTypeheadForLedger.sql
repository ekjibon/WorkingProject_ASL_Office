IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetTypeheadForLedger]'))
BEGIN
DROP PROCEDURE  GetTypeheadForLedger
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO --- EXEC GetTypeheadForLedger 'Cash',2,'CR',1
Create PROCEDURE [dbo].GetTypeheadForLedger 
	@SrchText VARCHAR(50),
	@Type INT,
	@AccType VARCHAR(20),  -- CR=Credit , DR = Debit
	@PayMode INT
AS
BEGIN  

	IF(@Type=1) -- FOR Recive 
	BEGIN
		IF(@AccType='DR')
				BEGIN
				IF(@PayMode=1)  -- Cash EXEC GetTypeheadForLedger 'cash',1,'DR',1
					BEGIN
						SELECT TOP 7 (L.Name) AS [Text], CAST( L.LedgerId AS varchar) AS [Value]
						FROM ACC_Ledgers L 
						WHERE (L.RootGroupId = 1 OR L.RootGroupId=2)
						AND (L.ParentId IN (SELECT LedgerId FROM ACC_Ledgers WHERE [Name]='Cash In Hand' OR [Name]='Cash In Bank' ))
						AND L.IsDeleted=0 and L.[Status]='A' and L.IsLedger=1 AND IsGroup = 0 and L.IsDisplay=1  
						AND  ( L.Name like '%'+@SrchText+'%' OR L.Code like '%'+@SrchText+'%' OR L.[Name]='Tuition Fees Receivable' OR L.[Name]='Late Fees Receivable') 
					END
					IF(@PayMode=2) -- Cheque EXEC GetTypeheadForLedger 'pr',1,'DR',2
					BEGIN
						SELECT TOP 7 (L.Name) AS [Text], CAST( L.LedgerId AS varchar) AS [Value]
						FROM ACC_Ledgers L 
						WHERE (L.RootGroupId = 1 OR L.RootGroupId=2)
						AND (L.ParentId IN (SELECT LedgerId FROM ACC_Ledgers WHERE  [Name]='Cash In Bank'))
						AND L.IsDeleted=0 and L.[Status]='A' and L.IsLedger=1 AND IsGroup = 0 and L.IsDisplay=1  
						AND  ( L.Name like '%'+@SrchText+'%' OR L.Code like '%'+@SrchText+'%' OR L.[Name]='Tuition Fees Receivable' OR L.[Name]='Late Fees Receivable') 
					END
					IF(@PayMode=3) -- Receivables EXEC GetTypeheadForLedger 'pr',1,'DR',3
					BEGIN
						SELECT TOP 7 (L.Name) AS [Text], CAST( L.LedgerId AS varchar) AS [Value]
						FROM ACC_Ledgers L 
						WHERE (L.RootGroupId = 1 OR L.RootGroupId=2)
						AND (L.ParentId IN (SELECT LedgerId FROM ACC_Ledgers WHERE [Name]='Account Receivable'))
						AND L.IsDeleted=0 and L.[Status]='A' and L.IsLedger=1 AND IsGroup = 0 and L.IsDisplay=1  
						AND  ( L.Name like '%'+@SrchText+'%' OR L.Code like '%'+@SrchText+'%' OR L.[Name]='Tuition Fees Receivable' OR L.[Name]='Late Fees Receivable') 
					END		
				END
		ELSE IF(@AccType='CR')
		BEGIN
			SELECT  (L.Name) AS [Text], CAST( L.LedgerId AS varchar) AS [Value]
			FROM ACC_Ledgers L 
			WHERE L.RootGroupId =  3 AND  L.IsDeleted=0 and L.[Status]='A' and L.IsLedger=1 AND IsGroup = 0 and L.IsDisplay=1 
			AND  ( L.Name like '%'+@SrchText+'%' OR L.Code like '%'+@SrchText+'%')
		END
	END
	IF(@Type=2) -- FOR Payment
	BEGIN
		IF(@AccType='DR')
		BEGIN
			SELECT TOP 7 (L.Name) AS [Text], CAST( L.LedgerId AS varchar) AS [Value]
			FROM ACC_Ledgers L 
			WHERE L.RootGroupId =  4 AND  L.IsDeleted=0 and L.[Status]='A' and L.IsLedger=1 AND IsGroup = 0 and L.IsDisplay=1 
			AND  ( L.Name like '%'+@SrchText+'%' OR L.Code like '%'+@SrchText+'%')
		END		
		ELSE IF(@AccType='CR')
		BEGIN

		IF(@PayMode=1) -- Cash EXEC GetTypeheadForLedger 'cash',2,'CR',1
		BEGIN
		SELECT TOP 7 (L.Name) AS [Text], CAST( L.LedgerId AS varchar) AS [Value]
			FROM ACC_Ledgers L 
			WHERE (L.RootGroupId = 1 OR L.RootGroupId=2)
			AND L.ParentId IN (SELECT LedgerId FROM ACC_Ledgers WHERE [Name]='Cash In Hand')
			AND L.IsDeleted=0 and L.[Status]='A' and L.IsLedger=1 AND IsGroup = 0 and L.IsDisplay=1  
			AND  ( L.Name like '%'+@SrchText+'%' OR L.Code like '%'+@SrchText+'%')
		END
		IF(@PayMode=2) -- Cheque --- EXEC GetTypeheadForLedger 'pr',2,'CR',2
			BEGIN
			SELECT TOP 7 (L.Name) AS [Text], CAST( L.LedgerId AS varchar) AS [Value]
				FROM ACC_Ledgers L 
				WHERE (L.RootGroupId = 1 OR L.RootGroupId=2)
				AND L.ParentId IN (SELECT LedgerId FROM ACC_Ledgers WHERE  [Name]='Cash In Bank')
				AND L.IsDeleted=0 and L.[Status]='A' and L.IsLedger=1 AND IsGroup = 0 and L.IsDisplay=1  
				AND  ( L.Name like '%'+@SrchText+'%' OR L.Code like '%'+@SrchText+'%')
			END

		IF(@PayMode=3) -- On Credit EXEC GetTypeheadForLedger '',2,'CR',1
			BEGIN
				SELECT TOP 7 (L.Name) AS [Text], CAST( L.LedgerId AS varchar) AS [Value]
					FROM ACC_Ledgers L 
					WHERE (L.RootGroupId = 1 OR L.RootGroupId=2)
					AND L.ParentId IN (SELECT LedgerId FROM ACC_Ledgers WHERE  [Name]='Current Libilities')
					AND L.IsDeleted=0 and L.[Status]='A' and L.IsLedger=1 AND IsGroup = 0 and L.IsDisplay=1  
					AND  ( L.Name like '%'+@SrchText+'%' OR L.Code like '%'+@SrchText+'%')
			END

		IF(@PayMode=4) -- Bank --- EXEC GetTypeheadForLedger 'bank',2,'CR',4
			BEGIN
			SELECT TOP 7 (L.Name) AS [Text], CAST( L.LedgerId AS varchar) AS [Value]
				FROM ACC_Ledgers L 
				WHERE (L.RootGroupId = 1 OR L.RootGroupId=2)
				AND L.ParentId IN (SELECT LedgerId FROM ACC_Ledgers WHERE  [Name]='Cash In Bank')
				AND L.IsDeleted=0 and L.[Status]='A' and L.IsLedger=1 AND IsGroup = 0 and L.IsDisplay=1  
				AND  ( L.Name like '%'+@SrchText+'%' OR L.Code like '%'+@SrchText+'%')
			END
			
		END
	END
	IF(@Type=3) -- FOR Contra  EXEC GetTypeheadForLedger 'Cash',3,'CR',0
	BEGIN
		IF(@AccType='DR')
		BEGIN
			SELECT TOP 7 (L.Name) AS [Text], CAST( L.LedgerId AS varchar) AS [Value]
			FROM ACC_Ledgers L 
			WHERE (L.RootGroupId = 1 OR L.RootGroupId=2)
			AND L.ParentId IN (SELECT LedgerId FROM ACC_Ledgers WHERE  [Name]='Cash In Bank' OR [Name]='Tuition Fees Receivable' OR [Name]='Cash In Hand' OR [Name]='Late Fees Receivable' OR [Name]='Accounts Payable')
			AND L.IsDeleted=0 and L.[Status]='A' and L.IsLedger=1 AND IsGroup = 0 and L.IsDisplay=1  
			AND  ( L.Name like '%'+@SrchText+'%' OR L.Code like '%'+@SrchText+'%' ) 
			
		END		
		ELSE IF(@AccType='CR')
		BEGIN
			SELECT  (L.Name) AS [Text], CAST( L.LedgerId AS varchar) AS [Value]
			FROM ACC_Ledgers L 
			WHERE (L.RootGroupId = 1 OR L.RootGroupId=2)
			AND L.ParentId IN (SELECT LedgerId FROM ACC_Ledgers WHERE   [Name]='Cash In Hand' OR [Name]='Tuition Fees Receivable' OR [Name]='Late Fees Receivable'  OR [Name]='Cash In Bank' ) 
			AND  L.IsDeleted=0 and L.[Status]='A' and L.IsLedger=1 AND IsGroup = 0 and L.IsDisplay=1 
			AND  ( L.Name like '%'+@SrchText+'%' OR L.Code like '%'+@SrchText+'%' )
		END
	END
	IF(@Type=4) -- FOR Journal
	BEGIN
		IF(@AccType='CR')
		BEGIN
			SELECT TOP 7 (L.Name) AS [Text], CAST( L.LedgerId AS varchar) AS [Value]
			FROM ACC_Ledgers L 
			WHERE L.IsDeleted=0 and L.[Status]='A' and L.IsLedger=1 AND IsGroup = 0 and L.IsDisplay=1 AND  ( L.Name like '%'+@SrchText+'%' OR L.Code like '%'+@SrchText+'%')
		END
		ELSE IF(@AccType='DR')
		BEGIN
			SELECT TOP 7 (L.Name) AS [Text], CAST( L.LedgerId AS varchar) AS [Value]
			FROM ACC_Ledgers L 
			WHERE L.IsDeleted=0 and L.[Status]='A'  and L.IsDisplay=1 and L.IsLedger=1 AND IsGroup = 0 AND  ( L.Name like '%'+@SrchText+'%' OR L.Code like '%'+@SrchText+'%')
		END
	END
	
END


-- SELECT  * FROM ACC_Ledgers
-- GetTypeheadForLedger 'ad'