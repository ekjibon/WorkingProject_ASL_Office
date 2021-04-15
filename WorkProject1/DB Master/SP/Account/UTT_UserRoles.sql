/****** Object:  StoredProcedure [dbo].[GetRootGroupCodeSetup]    Script Date: 3/05/2019 03:52:37 PM ******/

IF type_id('dbo.UTT_UserRoles') IS NOT NULL
BEGIN
 -- DROP PROCEDURE transactiondetailinsert 
	DROP TYPE dbo.UTT_UserRoles;
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TYPE dbo.UTT_UserRoles AS TABLE 
(
	
	[UserId] VARCHAR(MAX) NOT NULL,	
	[RoleId] VARCHAR(MAX) NOT NULL

	
)
GO
