/****** Object:  StoredProcedure [dbo].[GetRootGroupCodeSetup]    Script Date: 3/05/2019 03:52:37 PM ******/

IF type_id('dbo.UTT_FeesAdvanceAmount') IS NOT NULL
BEGIN
 -- DROP PROCEDURE transactiondetailinsert 
	DROP TYPE dbo.UTT_FeesAdvanceAmount;
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TYPE dbo.UTT_FeesAdvanceAmount AS TABLE 
(
	ID INT NOT NULL,
	[HeadId] [int] NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[AdvanceAmount] [decimal](18, 2) NOT NULL

)
GO