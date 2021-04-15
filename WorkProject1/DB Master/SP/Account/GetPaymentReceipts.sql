IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetPaymentReceipts]'))
BEGIN
DROP PROCEDURE  GetPaymentReceipts
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].GetPaymentReceipts 
AS
BEGIN  
SELECT  led2.Name ParentName,  led2.LedgerId PId ,led1.* FROM dbo.ACC_Ledgers led1
	JOIN dbo.ACC_Ledgers led2 on led2.LedgerId=led1.ParentId
	  where led1.RootGroupId in (1,4)   and led1.IsDisplay=1 and led2.IsDisplay=1
	  order by led2.DisplayOrder
	  SELECT led2.Name ParentName,  led2.LedgerId PId ,led2.RootGroupId,  led1.* FROM dbo.ACC_Ledgers led1
	JOIN dbo.ACC_Ledgers led2 on led2.LedgerId=led1.ParentId 
	  where led2.RootGroupId in (2,3) and
 led1.IsDisplay=1 and led2.IsDisplay=1
order by led2.DisplayOrder
END
