/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetLastStock]'))
BEGIN
DROP FUNCTION  GetLastStock
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================

CREATE FUNCTION [dbo].[GetLastStock]
(	
	@ProductId INT	
)
RETURNS  real
AS
BEGIN
	DECLARE @LastStock DECIMAL(10,2)
	
	Select top(1) @LastStock= Quantity FROM  Inv_ProductStocks WHERE ProductId = @ProductId
	RETURN @LastStock

END


GO
