
/****** Object:  StoredProcedure [dbo].[GetRootGroupCodeSetup]    Script Date: 3/05/2019 03:52:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetRootGroupCodeSetup]'))
BEGIN
DROP PROCEDURE  GetRootGroupCodeSetup
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- execute [dbo].[GetRootGroupCodeSetup]
CREATE PROCEDURE [dbo].[GetRootGroupCodeSetup]
AS
BEGIN
	select  r.*,ISNULL((select top 1 LedgerId from dbo.ACC_Ledgers where RootGroupId=Id),0) as LedgerId from dbo.ACC_RootGroup r
END
