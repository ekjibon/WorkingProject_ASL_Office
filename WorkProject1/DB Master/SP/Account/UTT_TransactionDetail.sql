/****** Object:  StoredProcedure [dbo].[GetRootGroupCodeSetup]    Script Date: 3/05/2019 03:52:37 PM ******/

IF type_id('dbo.UTT_TransactionDetail') IS NOT NULL
BEGIN
 -- DROP PROCEDURE transactiondetailinsert 
	DROP TYPE dbo.UTT_TransactionDetail;
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TYPE dbo.UTT_TransactionDetail AS TABLE 
(
	[RowNo] [int] NOT NULL,
	[LedgerId] [int] NOT NULL,	
	[DrAmount] [decimal](18, 2) NOT NULL,
	[CrAmount] [decimal](18, 2) NOT NULL,
	[CurrentAmount] [decimal](18, 2) NOT NULL,
	[OpeningAmount] [decimal](18, 2) NOT NULL,
	[DC] INT NOT NULL
	
)
GO
