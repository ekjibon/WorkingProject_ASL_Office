IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetTypeHeadForInventoryLedger]'))
BEGIN
DROP PROCEDURE  GetTypeHeadForInventoryLedger
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO --- EXEC GetTypeHeadForInventoryLedger 'Oth',1
Create PROCEDURE [dbo].GetTypeHeadForInventoryLedger 
	@SrchText VARCHAR(50),
	@Type INT
AS
BEGIN  
IF(@Type =1)
BEGIN
SELECT TOP 5 (L.[Code]) AS [Text], CAST( L.LedgerId AS varchar) AS [Value]
	FROM ACC_Ledgers L 
	WHERE L.IsDeleted=0 and L.Status='A' and L.IsLedger=1 and L.IsDisplay=1 AND ( L.[Name] like '%'+@SrchText+'%' OR L.Code like '%'+@SrchText+'%')
END
END

-- GetTypeheadForLedger 'Oth',1