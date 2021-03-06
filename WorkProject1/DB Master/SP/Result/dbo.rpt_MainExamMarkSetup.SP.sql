/****** Object:  StoredProcedure [dbo].[ProccessMarks]    Script Date: 7/22/2017 4:28:51 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rpt_MainExamMarkSetup]'))
BEGIN
DROP PROCEDURE  rpt_MainExamMarkSetup
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO --- rpt_MainExamMarkSetup 4
CREATE PROC [dbo].[rpt_MainExamMarkSetup] 
(
@MainExamID int 
)
AS
BEGIN
SELECT DISTINCT	  
	   S.SubID,S.ReportSerialNo
	  ,M.MainExamId
      ,M.MainExamName
      ,CT.VersionName
      ,CT.SessionName     
	  ,CT.ClassName
      ,CT.GroupName
      ,S.SubjectName
	  ,ME.MainExamFullMarks AS FullMarks
	  ,ME.MainExamIsPassDepend AS PassDepend
	  ,ME.MainExamPassMark AS PassMark
	  ,ME.MainExamPassMarkIsPercent AS IsPercent          
INTO #MAINEXAMMARK  FROM [Res_MainExam] AS M INNER JOIN [view_CommonTableNames] AS CT
 ON M.VersionId=CT.VersionId AND M.SessionId=CT.SessionId AND M.ClassId=CT.ClassId AND M.GroupId=CT.GroupId
 INNER JOIN [Res_MainExamMarkSetup] AS ME ON M.MainExamId=ME.MainExamId AND ME.IsDeleted=0 
 INNER JOIN [dbo].[Res_SubjectSetup] AS S ON ME.MainExamSubjectID=S.SubID AND S.IsDeleted=0
 WHERE M.MainExamId=@MainExamID AND M.IsDeleted=0 ORDER BY S.ReportSerialNo

  SELECT DISTINCT ME.MainExamSubjectID, S.SubExamName, SEM.Id AS SEMID, SEM.SubExamFullMarks, SEM.SubExamExamMarks,
  SEM.SubExamPassMark, SEM.SubExamIsPassDepend,SEM.SubExamPassMarkIsPercent, SEM.SubExamIsEnable  , D.DividedExamName,
  DE.Id AS DEMID, DE.DividedExamType, DE.DividedExamFullMarks, DE.DividedExamExamMarks,
  DE.DividedExamPassMarks, DE.DividedExamIsPassDepend,DE.DividedExamIsEnable,DE.DividedExamPassMarkIsPercent
  INTO #DIVEXAMMARK FROM [Res_SubExamMarkSetup] AS SEM INNER JOIN [Res_MainExamMarkSetup] AS ME
  ON SEM.MainExamMarkSetupId=ME.Id AND ME.IsDeleted=0
  INNER JOIN Res_DividedExamMarkSetup AS DE 
  ON SEM.[Id]=DE.SubExamMarkSetupId INNER JOIN [Res_SubExam] AS S ON SEM.SubExamId=S.SubExamId AND S.IsDeleted=0
  INNER JOIN [dbo].[Res_DividedExam] AS D ON DE.DividedExamId=D.DividedExamId AND D.IsDeleted=0 AND DE.IsDeleted=0
  WHERE SEM.IsDeleted=0 AND ME.MainExamId=@MainExamID
  
  
  SELECT DISTINCT T.ReportSerialNo, T.MainExamId, T.MainExamName,
  T.VersionName, T.SessionName, T.ClassName, T.GroupName, T.FullMarks,
  T.PassDepend, T.PassMark, T.IsPercent, T.SubjectName,
  D.SubExamName, D.SEMID, D.SubExamFullMarks, D.SubExamExamMarks,
  D.SubExamPassMark, D.SubExamPassMarkIsPercent, D.SubExamIsPassDepend,
  D.DividedExamName, D.DEMID, D.DividedExamType, D.DividedExamFullMarks, D.DividedExamExamMarks,
  D.DividedExamPassMarks, D.DividedExamIsPassDepend,D.DividedExamPassMarkIsPercent, D.DividedExamIsEnable
  FROM #MAINEXAMMARK AS T INNER JOIN #DIVEXAMMARK AS D ON T.SubID=D.MainExamSubjectID
  ORDER BY T.ReportSerialNo
  DROP TABLE #MAINEXAMMARK,#DIVEXAMMARK


  -- rpt_MainExamMarkSetup 127
END