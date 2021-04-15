/****** Object:  UserDefinedTableType [dbo].[udtPurchaseOrderDetails]   */
--IF type_id('[dbo].[udtRequisitionDetails]') IS NOT NULL
--DROP TYPE [dbo].udtRequisitionDetails;
--GO

--CREATE TYPE [dbo].[udtRequisitionDetails] AS TABLE(
--	[ProductId] INT NOT NULL,
--	[Quantity] [decimal](10, 2) NULL

--)
--GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AddRequisition]'))
BEGIN
DROP PROCEDURE  [AddRequisition]
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


CREATE  PROCEDURE [dbo].[AddRequisition]
(
    
	@DueDate SMALLDATETIME,	
	@Description VARCHAR(50)=null,
	@AddBy VARCHAR(50)=null,
	@RequisitionDetails udtRequisitionDetails READONLY
)	
AS
BEGIN
	

	DECLARE @IID  INT 
	DECLARE @CODE varchar(25)

	SELect @CODE = 'R'+ Cast(year(getdate()) as varchar) +  Cast(month(getdate()) as varchar) +Cast(day(getdate()) as varchar) + CAST((Select  Count(*)+ 1 From Inv_Requisition) as varchar)
	
	print @CODE

	INSERT INTO dbo.Inv_Requisition([ReqCode],[DueDate],[Description],[IsDeleted],[AddBy],[Status],[AddDate],IsApproved)
	VALUES( @CODE, @DueDate,@Description,0,@AddBy,'A',GetDate(),0)

	SELECT @IID = @@IDENTITY

	INSERT INTO Inv_RequisitionDetails([ReqId],[ProductId],[Quantity])
	       SELECT @IID, ProductId,Quantity FROM @RequisitionDetails 

		   --select * from dbo.Inv_Requisition
		   --Select * from Inv_RequisitionDetails

END

