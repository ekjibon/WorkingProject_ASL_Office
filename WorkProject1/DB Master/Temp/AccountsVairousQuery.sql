--Truncate table ACC_Transaction truncate table ACC_TransactionDetail UPDATE ACC_Ledgers SET CurrentBalance = 0
--

DECLARE @TId INT = 1
--UPDATE ACC_Transaction SET IsApproved = 0 WHERE Id = 1

SELECT * FROM ACC_Transaction WHERE id = @TId
SELECT * FROM ACC_TransactionDetail WHERE TransactionId = @TId

SELECT LedgerId, [Name], CurrentBalance , ParentId   FROM ACC_Ledgers 
WHERE LedgerId IN (
	SELECT LedgerId FROM ACC_TransactionDetail WHERE TransactionId = @TId
	)


SELECT LedgerId, [Name], CurrentBalance ,ParentId , CurrentBalanceDc FROM ACC_Ledgers WHERE LedgerId IN (60,6,1)
SELECT LedgerId, [Name], CurrentBalance ,ParentId ,CurrentBalanceDc FROM ACC_Ledgers WHERE LedgerId IN (14,3)




/*
with name_tree as (
		SELECT LedgerId,ParentID, Name,Code , IsDisplay , IsLedger , CurrentBalance
		FROM  [dbo].[ACC_Ledgers]
		WHERE IsDeleted = 0 
		union all
		SELECT P.LedgerId,P.ParentID,P.Name,P.Code,P.IsDisplay, P.IsLedger , P.CurrentBalance
		FROM  [dbo].[ACC_Ledgers] P
			join name_tree T on T.LedgerId = P.ParentId 
			WHERE IsDeleted = 0 
		) 
		select Distinct *
		from name_tree  WHERE LedgerId IN (61,184)

*/

--SELECT LedgerId, [Name], CurrentBalance ,ParentId FROM ACC_Ledgers WHERE LedgerId =4

--EXEC  dbo.UpdateLedgerAmount 185,00.00,500.00,1

--