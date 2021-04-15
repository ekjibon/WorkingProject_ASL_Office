IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetRequisitionList]'))
BEGIN
DROP PROCEDURE  [GetRequisitionList]
END
GO
/****** Object:  StoredProcedure [dbo].[ClassWiseResultProcess]    Script Date: 5/21/2019 3:41:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC ClassWiseResultProcess 10,19,8,1011
Create Procedure [dbo].[GetRequisitionList]

As
BEGIN

SELECT * FROM dbo.Inv_Requisition   where IsDeleted = 0 and [Status] = 'A'

SELECT rd.*,P.ProductName,U.UnitCode AS Unit FROM dbo.Inv_RequisitionDetails   rd
   INNER JOIN dbo.Inv_Product P ON P.ProductId = rd.ProductId
   INNER JOIN dbo.Inv_UnitSetup U ON P.UnitId = U.UnitSetupId

END

--[GetRequisitionList]