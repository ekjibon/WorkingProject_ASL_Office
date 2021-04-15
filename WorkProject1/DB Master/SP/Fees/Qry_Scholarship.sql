IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Qry_Scholarship]'))
BEGIN
DROP VIEW  [dbo].[Qry_Scholarship]
END
GO
/****** Object:  View [dbo].[Qry_Scholarship]    Script Date: 10/28/2019 2:21:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[Qry_Scholarship]
AS
SELECT        dbo.Fees_ScholarshipType.ScholarshipTypeId, dbo.Fees_ScholarshipType.ScholarshipType, dbo.Fees_ScholarshipMaster.Amount, dbo.Fees_ScholarshipMaster.IsPercentage, dbo.Fees_ScholarshipMaster.IsDeleted, 
                         dbo.Fees_ScholarshipMaster.FeesHeadId, dbo.Fees_ScholarshipMaster.Command, dbo.Fees_ScholarshipMaster.StudentId, dbo.Fees_ScholarshipDetails.ScholarshipDetailsId, dbo.Fees_FeesSessionYear.FeesSessionYearId, 
                         dbo.Fees_FeesSessionYear.FeesFiscalSessionId, dbo.Fees_FeesSessionYear.Year, dbo.Fees_FeesSessionYear.MonthId
FROM            dbo.Fees_ScholarshipMaster INNER JOIN
                         dbo.Fees_ScholarshipType ON dbo.Fees_ScholarshipMaster.ScholarshipTypeId = dbo.Fees_ScholarshipType.ScholarshipTypeId INNER JOIN
                         dbo.Fees_ScholarshipDetails ON dbo.Fees_ScholarshipMaster.ScholarshipConfigId = dbo.Fees_ScholarshipDetails.ScholarshipMasterId INNER JOIN
                         dbo.Fees_FeesSessionYear ON dbo.Fees_ScholarshipDetails.SessionYearId = dbo.Fees_FeesSessionYear.FeesSessionYearId
						 WHERE dbo.Fees_ScholarshipMaster.IsDeleted=0

GO


