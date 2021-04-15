IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetTransactionLedger]'))
BEGIN
DROP PROCEDURE  GetTransactionLedger
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].GetTransactionLedger 
AS
BEGIN  
	select 

END
select * from dbo.ACC_Ledgers where IsDeleted=0 and IsDisplay=1