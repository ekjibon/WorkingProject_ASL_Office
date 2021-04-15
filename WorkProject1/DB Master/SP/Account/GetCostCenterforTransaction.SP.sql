GO
/****** Object:  StoredProcedure [dbo].[GetCostCenterforTransaction]    Script Date: 12-Aug-20 1:21:24 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetCostCenterforTransaction]'))
BEGIN
DROP PROCEDURE  GetCostCenterforTransaction
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<AZMAL>
-- Create date: <12/08/2020>
-- Description:	<Description,,>
-- =============================================
-- EXEC GetCostCenterforTransaction 'so',3114
CREATE Procedure [dbo].[GetCostCenterforTransaction]
@SrchText VARCHAR(50),
@LedgerId int=0
As
BEGIN
 SELECT  (ACC.CostCenterName) AS [Text], CAST( ACC.Id AS varchar) AS [Value] FROM [dbo].[ACC_CostCenter] ACC
 WHERE ACC.IsDeleted = 0 AND ACC.LedgerId=@LedgerId AND  ACC.CostCenterName like '%'+@SrchText+'%' 

END