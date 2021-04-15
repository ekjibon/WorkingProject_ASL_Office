
CREATE PROCEDURE sp_GetMonth
AS
BEGIN
	SELECT * FROM [dbo].[Common_DropDownConfig] WHERE TYPE like '%Month%'
END
