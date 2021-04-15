/****** Object:  StoredProcedure [dbo].[GetRootGroupCodeSetup]    Script Date: 3/05/2019 03:52:37 PM ******/

IF type_id('dbo.UTT_FeesStuCollection') IS NOT NULL
BEGIN
 -- DROP PROCEDURE transactiondetailinsert 
	DROP TYPE dbo.UTT_FeesStuCollection;
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TYPE dbo.UTT_FeesStuCollection AS TABLE 
(
	ID INT NOT NULL,
	ProcessId INT NOT NULL,
	[HeadId] [int] NOT NULL,
	[StudenIId] [int] NOT NULL,
	[MonthId] INT NOT NULL,
	[Year] INT NOT NULL,
	[FeesSessionYearId] INT NOT NULL

)
GO