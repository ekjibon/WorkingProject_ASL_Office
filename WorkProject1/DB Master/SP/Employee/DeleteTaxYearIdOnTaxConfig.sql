/****** Object:  StoredProcedure [dbo].[DeleteTaxYearIdOnTaxConfig]    Script Date: 06/05/2020 11:33:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DeleteTaxYearIdOnTaxConfig]'))
BEGIN
DROP PROCEDURE  DeleteTaxYearIdOnTaxConfig
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Author: Khaled
---[dbo].[DeleteTaxYearIdOnTaxConfig] 2
CREATE PROCEDURE [dbo].[DeleteTaxYearIdOnTaxConfig] 
(
@CalendarId INT        
)
AS
BEGIN
   DELETE FROM [dbo].[HR_EmployeeTaxSetup] WHERE TaxYearId = @CalendarId
END