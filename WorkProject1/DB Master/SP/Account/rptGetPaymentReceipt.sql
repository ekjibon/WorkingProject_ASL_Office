IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetPaymentReceipt]'))
BEGIN
DROP PROCEDURE  rptGetPaymentReceipt
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].rptGetPaymentReceipt 
	@FromDate VARCHAR(100),
	@ToDate	VARCHAR(100)
AS
BEGIN  
	--  rptGetPaymentReceipt '01-01-019', '01-02-2019'
	
	SELECT TOP 5 (L.Name) AS [Text], CAST( L.LedgerId AS varchar) AS [Value]
	FROM ACC_Ledgers L 
	WHERE L.IsDeleted=0 and L.Status='A' and L.IsLedger=1

END