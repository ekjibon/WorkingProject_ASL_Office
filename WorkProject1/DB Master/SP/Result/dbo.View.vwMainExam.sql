/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[vwMainExam]'))
BEGIN
DROP VIEW  vwMainExam
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwMainExam]
AS
SELECT        dbo.Res_MainExam.VersionId, 
dbo.Res_MainExam.SessionId, 
dbo.Res_MainExam.ClassId,
 dbo.Res_MainExam.GroupId, 
 dbo.Res_MainExam.MainExamName,
  dbo.Res_MainExam.MainExamIsGrand, 
                         dbo.Res_MainExam.MainExamGrandShowOrder, 
						 dbo.Res_SubExam.SubExamName, 
						 dbo.Res_SubExam.IsConvertLayer,
						  dbo.Res_SubExam.SubExamId,
						  dbo.Res_MainExam.MainExamId,
						 dbo.Res_MainExam.IsEnableForMakrsEntry
FROM            dbo.Res_MainExam INNER JOIN
                         dbo.Res_SubExam ON dbo.Res_MainExam.MainExamId = dbo.Res_SubExam.MainExamId 

GO