IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_GetMonth]'))
BEGIN
DROP PROCEDURE  SP_GetMonth
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
	--- EXEC SP_GetMonth 

CREATE PROCEDURE [dbo].[SP_GetMonth]
AS
BEGIN
	SELECT * FROM [dbo].[Common_DropDownConfig] WHERE TYPE like '%Month%'
END