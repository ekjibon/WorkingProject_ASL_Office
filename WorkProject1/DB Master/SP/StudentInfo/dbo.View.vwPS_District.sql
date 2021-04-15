/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[vwPS_District]'))
BEGIN
DROP VIEW  vwPS_District
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwPS_District]
AS

SELECT PsId,	D.DistrictId,	PsName	,	DistrictName
 FROM Common_PoliceStation P INNER JOIN Common_District D ON D.DistrictId = P.DistrictId

GO