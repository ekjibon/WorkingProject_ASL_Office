
IF type_id('dbo.UTT_FeesHead') IS NOT NULL
BEGIN
 -- DROP PROCEDURE transactiondetailinsert 
	DROP TYPE dbo.UTT_FeesHead;
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TYPE dbo.UTT_FeesHead AS TABLE 
(
	
	[FeesHeadId] INT,	
	[Advance] DECIMAL(10,2) ,
	[PaidAmount] DECIMAL(10,2) ,
	[TotalAmount] DECIMAL(10,2) ,
	[Narration] VARCHAR(MAX)
)
GO