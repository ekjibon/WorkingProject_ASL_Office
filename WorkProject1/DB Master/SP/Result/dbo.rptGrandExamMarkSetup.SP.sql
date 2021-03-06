IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGrandExamMarkSetup]'))
BEGIN
DROP PROCEDURE  rptGrandExamMarkSetup
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO --- rptGrandExamMarkSetup 4
CREATE PROC [dbo].[rptGrandExamMarkSetup] 
(
@GrandExamID int 
)
AS
BEGIN
SELECT DISTINCT	  
	   S.SubID
	  ,S.ReportSerialNo
	  ,M.GrandExamId
      ,M.GrandExamName
      ,CT.VersionName
      ,CT.SessionName     
	  ,CT.ClassName
      ,CT.GroupName
      ,S.SubjectName
	  ,GR.ExamFullMarks AS FullMarks
	  ,GR.ExamIsPassDepend AS PassDepend
	  ,GR.ExamPassMark AS PassMark
	  ,GR.ExamPassMarkIsPercent AS IsPercent          
INTO #GrandEXAMMARK  FROM [Res_GrandExam] AS M INNER JOIN [view_CommonTableNames] AS CT
 ON M.VersionId=CT.VersionId AND M.SessionId=CT.SessionId AND M.ClassId=CT.ClassId AND M.GroupId=CT.GroupId
 INNER JOIN [Res_GrandExamMarkSetup] AS GR ON M.GrandExamId=GR.GrandExamId AND GR.IsDeleted=0 
 INNER JOIN [dbo].[Res_SubjectSetup] AS S ON GR.ExamSubjectID=S.SubID AND S.IsDeleted=0
 WHERE M.GrandExamId=@GrandExamID AND M.IsDeleted=0 ORDER BY S.ReportSerialNo
 --select * from #GrandEXAMMARK

  SELECT DISTINCT GR.ExamSubjectID, S.GrandSubExamName, SEM.SubExamId AS SEMID, SEM.SubExamFullMarks, SEM.SubExamExamMarks,
  SEM.SubExamPassMark, SEM.SubExamIsPassDepend,SEM.SubExamPassMarkIsPercent, SEM.SubExamIsEnable  , D.DividedExamName,
  DE.DividedExamId AS DEMID, DE.DividedExamType, DE.DividedExamFullMarks, DE.DividedExamExamMarks,
  DE.DividedExamPassMarks, DE.DividedExamIsPassDepend,DE.DividedExamIsEnable,DE.DividedExamPassMarkIsPercent
  INTO #DIVEXAMMARK 
  FROM [Res_GrandSubExamMarkSetup] AS SEM 
  INNER JOIN [Res_GrandExamMarkSetup] AS GR  ON SEM.GrandExamMarkSetupId=GR.GrandExamMarkSetupId AND GR.IsDeleted=0
  INNER JOIN Res_GrandDividedExamMarkSetup AS DE   ON SEM.GrandSubExamMarkSetupId=DE.SubExamMarkSetupId 
  INNER JOIN [Res_GrandSubExam] AS S ON SEM.SubExamId=S.GrandSubExamId AND S.IsDeleted=0
  INNER JOIN [dbo].[Res_GrandDividedExam] AS D ON DE.DividedExamId=D.GrandDividedExamId AND D.IsDeleted=0 AND DE.IsDeleted=0
  WHERE SEM.IsDeleted=0 AND GR.GrandExamId=@GrandExamID
  
  
  SELECT DISTINCT T.ReportSerialNo, T.GrandExamId, T.GrandExamName,
  T.VersionName, T.SessionName, T.ClassName, T.GroupName, T.FullMarks,
  T.PassDepend, T.PassMark, T.IsPercent, T.SubjectName,
  D.GrandSubExamName, D.SEMID, D.SubExamFullMarks, D.SubExamExamMarks,
  D.SubExamPassMark, D.SubExamPassMarkIsPercent, D.SubExamIsPassDepend,
  D.DividedExamName, D.DEMID, D.DividedExamType, D.DividedExamFullMarks, D.DividedExamExamMarks,
  D.DividedExamPassMarks, D.DividedExamIsPassDepend,D.DividedExamPassMarkIsPercent, D.DividedExamIsEnable
  FROM #GrandEXAMMARK AS T 
  INNER JOIN #DIVEXAMMARK AS D ON T.SubID=D.ExamSubjectID
  ORDER BY T.ReportSerialNo
  DROP TABLE #GrandEXAMMARK,#DIVEXAMMARK
  -- rptGrandExamMarkSetup 82
END