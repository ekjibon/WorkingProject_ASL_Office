/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Split]'))
BEGIN
DROP FUNCTION  [dbo].[Split]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Biplob>
-- Create date: <01-Jun-2017,>
-- Description:	<For Latter grade ad GP  Present>
-- =============================================
Create FUNCTION [dbo].[Split]
(
@String NVARCHAR(4000),
@Delimiter NCHAR(1)
)
RETURNS TABLE 
AS
RETURN 
(
WITH Split(stpos,endpos) 
AS(
SELECT 0 AS stpos, CHARINDEX(@Delimiter,@String) AS endpos
UNION ALL
SELECT endpos+1, CHARINDEX(@Delimiter,@String,endpos+1)
FROM Split
WHERE endpos > 0
)
SELECT 'Id' = ROW_NUMBER() OVER (ORDER BY (SELECT 1)),
'Data' = SUBSTRING(@String,stpos,COALESCE(NULLIF(endpos,0),LEN(@String)+1)-stpos)
FROM Split
)
GO


