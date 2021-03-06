
GO
/****** Object:  StoredProcedure [dbo].[GetAllSubExammarkSetup]    Script Date: 03/08/2017 4:06:56 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GrandGetAllSubExammarkSetup]'))
BEGIN
DROP PROCEDURE  GrandGetAllSubExammarkSetup
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GrandGetAllSubExammarkSetup] 
(
@MainExamMarkSetupId INT,
@MainExamId INT
)
as
Begin
SELECT S.GrandSubExamId as SubExamId, @MainExamId AS MainExamId, S.GrandSubExamName as SubExamName,
ISNULL(SM.GrandSubExamMarkSetupId,0) as Id, @MainExamMarkSetupId as MainExamMarkSetupId, 
ISNULL(SM.SubExamFullMarks,0) as SubExamFullMarks, ISNULL(SM.SubExamExamMarks,0) as SubExamExamMarks,
ISNULL(SM.SubExamIsPassDepend,0) AS SubExamIsPassDepend, ISNULL(SM.SubExamPassMark,0) as SubExamPassMark, 
ISNULL(SM.SubExamPassMarkIsPercent,0) as SubExamPassMarkIsPercent,
--ISNULL(SM.SubExamDefaultPercent,0) as SubExamDefaultPercent,
ISNULL(SM.SubExamIsEnable,0) AS SubExamIsEnable,
ISNULL(SM.SubExamIsEnable,0) AS SubExamIsEnable
,CASE WHEN SM.GrandSubExamMarkSetupId IS NULL THEN 'Sub Exam' ELSE 'SubExamConfigured' END AS SubExmConfigured
,CASE WHEN  (SELECT ISNULL(SUM(D.DividedExamFullMarks),0) FROM Res_GrandDividedExamMarkSetup AS D WHERE D.IsDeleted=0 AND D.SubExamMarkSetupId = SM.GrandSubExamMarkSetupId)
= SM.SubExamExamMarks  THEN 'DividedExamConfigured' ELSE 'Divided Exam' END AS DividedExmConfigured
FROM  dbo.Res_GrandSubExam S LEFT OUTER JOIN 
dbo.Res_GrandSubExamMarkSetup SM ON S.GrandSubExamId=SM.SubExamId 
AND SM.GrandExamMarkSetupId=@MainExamMarkSetupId AND SM.IsDeleted=0
where S.GrandExamId=@MainExamId and S.IsDeleted=0
END


--GrandGetAllSubExammarkSetup 773,56