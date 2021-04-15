
IF type_id('dbo.UTT_InvoicePayment') IS NOT NULL
BEGIN
 
	DROP TYPE dbo.UTT_InvoicePayment;
END

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TYPE dbo.UTT_InvoicePayment AS TABLE 
(
	[Id] INT,
	[Year] INT,	
	[MonthId] INT,
	[BillingHeadId] INT,
	[Quantity] INT,
	[Rate] DECIMAL(18,2) ,
	[TotalAmount] DECIMAL(18,2) ,
	[DueAmount] DECIMAL(18,2) ,
	[CollectionAmount] DECIMAL(18,2) ,
	[PaymentMethod] VARCHAR(100),
	[ChequeNo] VARCHAR(100),
	[AdjustmentAmount] DECIMAL(18,2) ,
	[CollectionNarration] VARCHAR(max),
	[DiscountAmount] DECIMAL(18,2),
	[ExtraCollectionAmount] DECIMAL(18,2)
)
GO