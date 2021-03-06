/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Qry_MarkSetup]'))
BEGIN
DROP VIEW  Qry_MarkSetup
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Qry_MarkSetup]
AS

SELECT 
M.MainExamSubjectID,M.MainExamId,S.SubExamId,m.MainExamFullMarks,Se.SectionId,Se.IsMidYear,
S.SubExamExamMarks , S.SubExamFullMarks,se.SubjectId,m.TermId
FROM Res_MainExamMarkSetup M 

INNER JOIN Res_SubExamMarkSetup S ON M.Id = S.MainExamMarkSetupId
INNER JOIN dbo.Res_SubExam Se ON se.SubExamId = S.SubExamId and se.MainExamId=m.MainExamId
where se.IsDeleted=0 and s.IsDeleted=0 and m.IsDeleted=0


GO

