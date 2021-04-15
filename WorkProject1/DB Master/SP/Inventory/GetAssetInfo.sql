IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAssetInfo]'))
BEGIN
DROP PROCEDURE  [GetAssetInfo]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE GetAssetInfo
(
	@AssetIdNo int
)
AS
BEGIN

	SELECT 	*			
				
	FROM dbo.FA_Asset A
	
		

   WHERE A.AssetId=8
   END