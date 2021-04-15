IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAllTransaction]'))
BEGIN
DROP PROCEDURE  GetAllTransaction
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].GetAllTransaction
AS
BEGIN  
	--  GetAllTransaction
	
	SELECT 
	T.*, 
	F.Name, 
	F.Id as FisId ,
		CASE T.TransType 
	WHEN 1 THEN 'Receive'
	WHEN 2 THEN 'Payment'
	WHEN 3 THEN 'Contra'
	WHEN 4 THEN 'Journal'
	END AS TypeName
	FROM dbo.ACC_Transaction T
	LEFT JOIN dbo.ACC_FiscalYear F ON T.FiscalYearID = f.Id
	WHERE  isnull(T.InvoiceTransType,0) NOT IN(1,2)
	ORDER BY T.Id DESC
	

END