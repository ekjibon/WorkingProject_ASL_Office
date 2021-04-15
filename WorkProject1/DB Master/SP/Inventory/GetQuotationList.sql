IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetQuotationList]'))
BEGIN
DROP PROCEDURE  [GetQuotationList]
END
GO
/****** Object:  StoredProcedure [dbo].[ClassWiseResultProcess]    Script Date: 5/21/2019 3:41:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC [GetQuotationList]
Create Procedure [dbo].[GetQuotationList]

As
BEGIN

	SELECT Q.*,S.SupplierName,S.AccountCode FROM dbo.Inv_Quotation  Q 
	INNER JOIN dbo.Inv_Supplier S ON S.SupplierId = Q.SupplierId
	WHERE Q.IsDeleted = 0 AND Q.[Status] = 'A'

	SELECT qd.*,P.ProductName,U.UnitCode AS Unit FROM dbo.Inv_QuotationDetails qd
	INNER JOIN dbo.Inv_Product P ON P.ProductId = qd.ProductId
	INNER JOIN dbo.Inv_UnitSetup U ON P.UnitId = U.UnitSetupId

END
-- SELECT * FROM dbo.Inv_QuotationDetails   
--[GetQuotationList]