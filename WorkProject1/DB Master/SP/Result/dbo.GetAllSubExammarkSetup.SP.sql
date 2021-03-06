GO
/****** Object:  StoredProcedure [dbo].[GetAllSubExammarkSetup]    Script Date: 03/08/2017 4:06:56 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAllSubExammarkSetup]'))
BEGIN
DROP PROCEDURE  GetAllSubExammarkSetup
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--- [dbo].[GetAllSubExammarkSetup] 385,1044,117
CREATE PROC [dbo].[GetAllSubExammarkSetup] 
(
@MainExamMarkSetupId INT,
@MainExamId INT,
@SectionId INT

)
AS
BEGIN
	DECLARE @SubjectId INT
	SELECT @SubjectId=MainExamSubjectID FROM Res_MainExamMarkSetup WHERE Id=@MainExamMarkSetupId
SELECT s.*, S.SubExamId, s.MainExamId, S.SubExamName,
	ISNULL(SM.Id,0) as Id, @MainExamMarkSetupId as MainExamMarkSetupId, 
	ISNULL(SM.SubExamFullMarks,0) as SubExamFullMarks, ISNULL(SM.SubExamExamMarks,0) as SubExamExamMarks,
	ISNULL(SM.SubExamIsPassDepend,0) AS SubExamIsPassDepend, ISNULL(SM.SubExamPassMark,0) as SubExamPassMark, 
	ISNULL(SM.SubExamPassMarkIsPercent,0) as SubExamPassMarkIsPercent,
	ISNULL(SM.SubExamDefaultPercent,0) as SubExamDefaultPercent,
	ISNULL(SM.SubExamIsEnable,0) AS SubExamIsEnable,
	ISNULL(SM.SubExamIsEnable,0) AS SubExamIsEnable
	--,CASE WHEN SM.Id IS NULL THEN 'Sub Exam' ELSE 'SubExamConfigured' END AS SubExmConfigured
	--,CASE WHEN  (SELECT ISNULL(SUM(D.DividedExamFullMarks),0) FROM Res_DividedExamMarkSetup AS D WHERE D.IsDeleted=0 AND D.SubExamMarkSetupId = SM.Id)
	--= SM.SubExamExamMarks  THEN 'DividedExamConfigured' ELSE 'Divided Exam' END AS DividedExmConfigured
	,ISNULL((SELECT TOP 1 MarksId FROM Res_MainExamMarks WHERE MainExamID=S.MainExamId 
	AND SubExamID=SM.SubExamId AND SubjectID=@SubjectId AND IsDeleted=0),0) AS SubExamMarksEntry
	,SM.AddBy
	,SM.AddDate
	 FROM  dbo.Res_SubExam S LEFT OUTER JOIN 
	dbo.Res_SubExamMarkSetup SM ON S.SubExamId=SM.SubExamId  and sm.IsDeleted=0 and sm.MainExamMarkSetupId=@MainExamMarkSetupId
	where s.SubjectId=@SubjectId  and s.IsDeleted=0 and s.MainExamId=@MainExamId AND S.SectionId = @SectionId
END
