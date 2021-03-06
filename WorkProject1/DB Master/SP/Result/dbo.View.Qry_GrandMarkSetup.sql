/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Qry_GrandMarkSetup]'))
BEGIN
DROP VIEW  Qry_GrandMarkSetup
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Qry_GrandMarkSetup]
AS
SELECT        dbo.Res_GrandExamMarkSetup.GrandExamMarkSetupId, dbo.Res_GrandExamMarkSetup.GrandExamId, dbo.Res_GrandExamMarkSetup.ExamSubjectID, dbo.Res_GrandExamMarkSetup.ExamFullMarks, 
                         dbo.Res_GrandExamMarkSetup.ExamIsPassDepend, dbo.Res_GrandExamMarkSetup.ExamPassMark, dbo.Res_GrandExamMarkSetup.ExamPassMarkIsPercent, 
                         dbo.Res_GrandSubExamMarkSetup.GrandSubExamMarkSetupId , dbo.Res_GrandSubExamMarkSetup.SubExamId, dbo.Res_GrandSubExamMarkSetup.SubExamFullMarks, dbo.Res_GrandSubExamMarkSetup.SubExamExamMarks, 
                         dbo.Res_GrandSubExamMarkSetup.SubExamIsPassDepend, dbo.Res_GrandSubExamMarkSetup.SubExamPassMark, dbo.Res_GrandSubExamMarkSetup.SubExamPassMarkIsPercent, 
                         dbo.Res_GrandDividedExamMarkSetup.DividedExamMarkSetupId, dbo.Res_GrandDividedExamMarkSetup.DividedExamId, dbo.Res_GrandDividedExamMarkSetup.DividedExamType, dbo.Res_GrandDividedExamMarkSetup.DividedExamFullMarks, 
                         dbo.Res_GrandDividedExamMarkSetup.DividedExamExamMarks, dbo.Res_GrandDividedExamMarkSetup.DividedExamIsPassDepend, dbo.Res_GrandDividedExamMarkSetup.DividedExamPassMarks, 
                         dbo.Res_GrandDividedExamMarkSetup.DividedExamPassMarkIsPercent, dbo.Res_GrandSubExamMarkSetup.SubExamIsEnable, dbo.Res_GrandDividedExamMarkSetup.DividedExamIsEnable, 
                         dbo.Res_GrandExamMarkSetup.IsDeleted AS MIsDeleted, dbo.Res_GrandSubExamMarkSetup.IsDeleted AS SIsDeleted, dbo.Res_GrandDividedExamMarkSetup.IsDeleted AS DIsDeleted
FROM            dbo.Res_GrandDividedExamMarkSetup INNER JOIN
                         dbo.Res_GrandSubExamMarkSetup INNER JOIN
                         dbo.Res_GrandExamMarkSetup ON dbo.Res_GrandSubExamMarkSetup.GrandExamMarkSetupId = dbo.Res_GrandExamMarkSetup.GrandExamMarkSetupId ON dbo.Res_GrandDividedExamMarkSetup.SubExamMarkSetupId = dbo.Res_GrandSubExamMarkSetup.GrandSubExamMarkSetupId


GO
