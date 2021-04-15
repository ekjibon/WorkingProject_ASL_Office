/****** Object:  StoredProcedure [dbo].[sp_CommonItem]    Script Date: 7/22/2017 4:41:46 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[sp_CommonItem]'))
BEGIN
DROP PROCEDURE  sp_CommonItem
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE proc [dbo].[sp_CommonItem] --exec sp_CommonItem
as
begin

SELECT [BranchId], [BranchName], [Code], [BranchNameBangla], [Address], [AddressBangla],[Branch_ContactNumber], [Email] FROM [dbo].[Ins_Branch] where IsDeleted=0
SELECT ClubId,ClubName,[Description] FROM Ins_ECAClub

end
