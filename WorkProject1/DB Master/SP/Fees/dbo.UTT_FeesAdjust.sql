
IF type_id('dbo.UTT_FeesAdjust') IS NOT NULL
BEGIN
 -- DROP PROCEDURE transactiondetailinsert 
	DROP TYPE dbo.UTT_FeesAdjust;
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TYPE dbo.UTT_FeesAdjust AS TABLE 
(
	
	[HeadId] INT NOT NULL,	
	[DueAmount] DECIMAL(10,2) ,

	[MonthId] INT NOT NULL,
		[FeesSessionYearId] INT NOT NULL
)
GO