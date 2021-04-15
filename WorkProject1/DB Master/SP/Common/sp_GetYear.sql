CREATE PROCEDURE sp_GetYear
AS
BEGIN
	SELECT * FROM [dbo].[Common_DropDownConfig] WHERE TYPE like '%Year%'
END

