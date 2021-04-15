IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAllLedgersForInvoice]'))
BEGIN
DROP PROCEDURE  GetAllLedgersForInvoice
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
--  EXEC [dbo].GetAllLedgersForInvoice 2
Create PROCEDURE [dbo].GetAllLedgersForInvoice 
@Block  INT =0
AS
BEGIN  
	IF(@Block=1)
	BEGIN
	SELECT LedgerId,Name, Code, Code + ' ' + '('+ Name +')' AS CodeWithName FROM dbo.ACC_Ledgers  
	WHERE IsDeleted = 0 AND IsLedger = 1
	ORDER BY Code ASC
	END
	IF(@Block=2)
	BEGIN
	SELECT LedgerId,Name, Code, Code + ' ' + '('+ Name +')' AS CodeWithName FROM dbo.ACC_Ledgers  
	WHERE IsDeleted = 0 AND IsLedger = 1
	AND ParentId IN(SELECT LedgerId FROM [dbo].[ACC_Ledgers] where Name IN('Cash In Bank','Cash In Hand'))
	ORDER BY Code ASC
	END

END

--  EXEC GetAllLedgersForInvoice 
