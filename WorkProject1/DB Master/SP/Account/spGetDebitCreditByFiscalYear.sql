IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[spGetDebitCreditByFiscalYear]'))
BEGIN
DROP PROCEDURE  spGetDebitCreditByFiscalYear
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO


Create PROCEDURE spGetDebitCreditByFiscalYear @Id int
AS
IF @Id IS NOT NULL
BEGIN  
	--  GetDebitCreditByFiscalYear ACC_TransactionDetail
	
	SELECT td.*, F.Name, F.Id as FisId ,t.Id
	FROM dbo.ACC_Transaction T
	LEFT JOIN dbo.ACC_FiscalYear F ON T.FiscalYear = f.Id
	LEFT JOIN ACC_TransactionDetail td ON t.Id=td.TransactionId
	WHERE t.Id=@Id
	 

END


