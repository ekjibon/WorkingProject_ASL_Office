/****** Object:  StoredProcedure [dbo].[GetCostCenterList]    Script Date: 27/01/2021 11:12:12 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetCostCenterList]'))
BEGIN
DROP PROCEDURE  GetCostCenterList
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<AZMAL>
-- Create date: <27/01/2021>
-- Description:	<Description,,>
-- =============================================

-- EXEC GetCostCenterList 
CREATE Procedure [dbo].[GetCostCenterList]

As
BEGIN
 SELECT ACC.*,ACT.CostCategoryName,l.Name LedgerName FROM [dbo].[ACC_CostCenter] ACC
 INNER JOIN [dbo].[ACC_CostCategory] ACT ON ACT.Id = ACC.CostCategoryId
 LEFT JOIN [dbo].[ACC_Ledgers] L ON L.LedgerId = ACC.LedgerId
 WHERE ACC.IsDeleted = 0 AND ACT.IsDeleted =0

END