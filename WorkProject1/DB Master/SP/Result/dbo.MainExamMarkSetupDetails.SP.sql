/****** Object:  StoredProcedure [dbo].[ProccessMainExam]    Script Date: 7/22/2017 4:28:51 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MainExamMarkSetupDetails]'))
BEGIN
DROP PROCEDURE  MainExamMarkSetupDetails
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
Create PROC [dbo].[MainExamMarkSetupDetails] 
(
@MainExamID int,
@SubExamID int,
@DivdidedExamID int,
@GrandExamID int,
@GSubExamID int,
@GDivdidedExamID int
)
AS
BEGIN
--MainExam
SELECT DISTINCT	  
	   S.SubID
	  ,M.MainExamId
      ,M.MainExamName
      ,CT.VersionName
      ,CT.SessionName     
	  ,CT.ClassName
      ,CT.GroupName
      ,S.SubjectName
	  ,Me.Id As MEMSID	  
	  ,ME.MainExamFullMarks AS FullMarks
	  ,ME.MainExamIsPassDepend AS PassDepend
	  ,ME.MainExamPassMark AS PassMark
	  ,ME.MainExamPassMarkIsPercent AS IsPercent          
 INTO #MAINEXAMMARK  FROM [Res_MainExam] AS M INNER JOIN [view_CommonTableNames] AS CT
 ON M.VersionId=CT.VersionId AND M.SessionId=CT.SessionId AND M.ClassId=CT.ClassId AND M.GroupId=CT.GroupId
 INNER JOIN [Res_MainExamMarkSetup] AS ME ON M.MainExamId=ME.MainExamId AND ME.IsDeleted=0 
 INNER JOIN [dbo].[Res_SubjectSetup] AS S ON ME.MainExamSubjectID=S.SubID AND S.IsDeleted=0
 WHERE M.MainExamId=@MainExamID AND M.IsDeleted=0 

  SELECT DISTINCT ME.MainExamSubjectID, S.SubExamName,S.SubExamId, SEM.Id AS SEMID, SEM.SubExamFullMarks, SEM.SubExamExamMarks,
  SEM.SubExamPassMark, SEM.SubExamIsPassDepend,SEM.SubExamPassMarkIsPercent, SEM.SubExamIsEnable, D.DividedExamName,D.DividedExamId,
  DE.Id AS DEMID, DE.DividedExamType, DE.DividedExamFullMarks, DE.DividedExamExamMarks,
  DE.DividedExamPassMarks, DE.DividedExamIsPassDepend,DE.DividedExamIsEnable,DE.DividedExamPassMarkIsPercent
  INTO #DIVEXAMMARK FROM [Res_SubExamMarkSetup] AS SEM INNER JOIN [Res_MainExamMarkSetup] AS ME
  ON SEM.MainExamMarkSetupId=ME.Id AND ME.IsDeleted=0
  INNER JOIN Res_DividedExamMarkSetup AS DE 
  ON SEM.[Id]=DE.SubExamMarkSetupId INNER JOIN [Res_SubExam] AS S ON SEM.SubExamId=S.SubExamId AND S.IsDeleted=0
  INNER JOIN [dbo].[Res_DividedExam] AS D ON DE.DividedExamId=D.DividedExamId AND D.IsDeleted=0 AND DE.IsDeleted=0
  WHERE SEM.IsDeleted=0 AND ME.MainExamId=@MainExamID
  
  
  SELECT DISTINCT T.SubjectName,T.SubID, T.MainExamId, T.MainExamName, T.MEMSID,
  T.FullMarks, D.SubExamName,D.SubExamId, D.SEMID, D.SubExamFullMarks, D.SubExamExamMarks,
  D.DividedExamName,D.DividedExamId, D.DEMID, D.DividedExamType, D.DividedExamFullMarks, D.DividedExamExamMarks 
  into #MD FROM #MAINEXAMMARK AS T INNER JOIN #DIVEXAMMARK AS D ON T.SubID=D.MainExamSubjectID 
  select * from #MD where MainExamId=@MainExamID and subExamId=@SubExamID and DividedExamId=@DivdidedExamID order by SubID
 
 --End Main Exam

	

 --Grand Exam
 SELECT DISTINCT	  
	   S.SubID
	  ,M.GrandExamId
      ,M.GrandExamName
      ,CT.VersionName
      ,CT.SessionName     
	  ,CT.ClassName
      ,CT.GroupName
      ,S.SubjectName
	  ,ME.GrandExamMarkSetupId	  
	  ,ME.ExamFullMarks
	  ,ME.ExamIsPassDepend AS PassDepend
	  ,ME.ExamPassMark AS PassMark
	  ,ME.ExamPassMarkIsPercent AS IsPercent          
INTO #GMAINEXAMMARK  FROM [Res_GrandExam] AS M INNER JOIN [view_CommonTableNames] AS CT
 ON M.VersionId=CT.VersionId AND M.SessionId=CT.SessionId AND M.ClassId=CT.ClassId AND M.GroupId=CT.GroupId
 INNER JOIN [Res_GrandExamMarkSetup] AS ME ON M.GrandExamId=ME.GrandExamId AND ME.IsDeleted=0 
 INNER JOIN [dbo].[Res_SubjectSetup] AS S ON ME.ExamSubjectID=S.SubID AND S.IsDeleted=0
 WHERE M.GrandExamId=@GrandExamID AND M.IsDeleted=0 

  SELECT DISTINCT ME.ExamSubjectID, S.GrandSubExamName,S.GrandSubExamId, SEM.GrandSubExamMarkSetupId, SEM.SubExamFullMarks, SEM.SubExamExamMarks,
  D.DividedExamName,D.GrandDividedExamId,
  DE.DividedExamMarkSetupId, DE.DividedExamType, DE.DividedExamFullMarks, DE.DividedExamExamMarks  
  INTO #GDIVEXAMMARK FROM [Res_GrandSubExamMarkSetup] AS SEM INNER JOIN [Res_GrandExamMarkSetup] AS ME
  ON  SEM.GrandExamMarkSetupId=ME.GrandExamMarkSetupId AND ME.IsDeleted=0
  INNER JOIN Res_GrandDividedExamMarkSetup AS DE 
  ON SEM.[GrandSubExamMarkSetupId]=DE.SubExamMarkSetupId INNER JOIN [Res_GrandSubExam] AS S ON SEM.SubExamId=S.GrandSubExamId AND S.IsDeleted=0
  INNER JOIN [dbo].[Res_GrandDividedExam] AS D ON DE.DividedExamId=D.GrandDividedExamId AND D.IsDeleted=0 AND DE.IsDeleted=0
  WHERE SEM.IsDeleted=0 AND ME.GrandExamId=@GrandExamID
  
  
  SELECT DISTINCT T.SubjectName,T.SubID, T.GrandExamId, T.GrandExamName, T.GrandExamMarkSetupId,
  T.ExamFullMarks, D.GrandSubExamName,D.GrandSubExamId, D.GrandSubExamMarkSetupId, D.SubExamFullMarks, D.SubExamExamMarks,
  D.DividedExamName,D.GrandDividedExamId, D.DividedExamMarkSetupId, D.DividedExamType, D.DividedExamFullMarks, D.DividedExamExamMarks 
  into #GD FROM #GMAINEXAMMARK AS T INNER JOIN #GDIVEXAMMARK AS D ON T.SubID=D.ExamSubjectID 
  Select * from  #GD where GrandExamId=@GrandExamID and GrandSubExamId= @GSubExamID and GrandDividedExamId=@GDivdidedExamID order by SubID
 --End Grand Exam


  DROP TABLE #MAINEXAMMARK,#DIVEXAMMARK ,#GMAINEXAMMARK, #GDIVEXAMMARK, #GD, #MD


  --  MainExamMarkSetupDetails 10,35,27, 3,4,6
END