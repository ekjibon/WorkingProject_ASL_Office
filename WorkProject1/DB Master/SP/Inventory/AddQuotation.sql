/****** Object:  UserDefinedTableType [dbo].[udtPurchaseOrderDetails]   */
--IF type_id('[dbo].[udtPurchaseOrderDetails]') IS NOT NULL
--DROP TYPE [dbo].[udtQuotationDetails];
--GO

--CREATE TYPE [dbo].[udtQuotationDetails] AS TABLE(
--	[ProductId] INT NOT NULL,
--	[Quantity] [decimal](10, 2) NULL,
--	[Discount] [decimal](10, 2) NULL,
--	[UnitPrice] [decimal](10, 2) NULL

--)
--GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AddQuotation]'))
BEGIN
DROP PROCEDURE  [AddQuotation]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shahin
-- Create date: March 19, 2018
-- Description:	
-- =============================================


CREATE  PROCEDURE [dbo].[AddQuotation]
(
    @SupplierId INT,
	@DueDate SMALLDATETIME,	
	@Description VARCHAR(50)=null,
	@AddBy VARCHAR(50)=null,
	@QuotationDetails udtQuotationDetails READONLY
)	
AS
BEGIN
	

	DECLARE @IID  INT 
	DECLARE @CODE varchar(25)

	SELect @CODE = 'Q'+ Cast(year(getdate()) as varchar) +  Cast(month(getdate()) as varchar) +Cast(day(getdate()) as varchar) + CAST((Select  Count(*)+1 From Inv_Quotation) as varchar)
	
	print @CODE

	INSERT INTO Inv_Quotation([QuotationCode],[SupplierId],[Description],[IsDeleted],[AddBy],[Status],[AddDate],[DueDate])
	VALUES( @CODE, @SupplierId,@Description,0,@AddBy,'A',GetDate(),@DueDate)

	SELECT @IID = @@IDENTITY

	INSERT INTO Inv_QuotationDetails(QuotationId,[ProductId],[Quantity],[UnitPrice],[Discount],[IsDeleted],[AddBy],[Status],[AddDate])
	       SELECT @IID, ProductId,Quantity,[UnitPrice],[Discount],0,@AddBy,'A',GetDate() FROM @QuotationDetails 



		   --select * from dbo.Inv_Quotation
		   --Select * from Inv_QuotationDetails

		   --Select * from Inv_StockTransaction

END

