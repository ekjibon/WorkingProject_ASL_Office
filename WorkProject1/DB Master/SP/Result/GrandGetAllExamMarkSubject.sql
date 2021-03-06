
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GrandGetAllExamMarkSubject]'))
BEGIN
DROP PROCEDURE  GrandGetAllExamMarkSubject
END
GO
Create proc [dbo].[GrandGetAllExamMarkSubject]
(
 @VersionId int,
 @SessionId int,
 @ClassId int,
 @GroupId int,
 @MainExamId int
 )
 AS
BEGIN
SELECT 
       S.SubjectName AS SubjectName
      ,ISNULL(M.[GrandExamMarkSetupId],0) AS GrandExamMarkSetupId
      ,S.[VersionId]
      ,S.[SessionId]
      ,S.[ClassId]
      ,S.[GroupId]
      ,@MainExamId AS GrandExamId
      ,ISNULL(S.SubID,0) AS ExamSubjectID
      ,ISNULL([ExamFullMarks],0) AS ExamFullMarks
      ,ISNULL([ExamIsPassDepend],0) AS ExamIsPassDepend
      ,ISNULL([ExamPassMark],0) AS ExamPassMark
      ,ISNULL([ExamPassMarkIsPercent],0) AS ExamPassMarkIsPercent
      --,ISNULL([MainExamDefaultPercent],0) AS MainExamDefaultPercent
      ,S.[IsDeleted]
      ,S.[AddBy]
      ,S.[AddDate]
      ,ISNULL(S.[UpdateBy],'') AS [UpdateBy]
      ,ISNULL(S.[UpdateDate],'') AS [UpdateDate]
      ,ISNULL(S.[Remarks],'') AS [Remarks]
      ,ISNULL(S.[Status],'') AS [Status]   
	  ,CASE WHEN M.GrandExamMarkSetupId IS NULL THEN 'Main Exam' ELSE 'Main Exam Has Been Configured' END AS MainExmConfigured 
	  ,CASE WHEN (SELECT ISNULL(SUM(SubExamFullMarks),0) FROM Res_GrandSubExamMarkSetup WHERE GrandExamMarkSetupId=M.GrandExamMarkSetupId AND Res_GrandSubExamMarkSetup.IsDeleted=0) = M.ExamFullMarks THEN 'SubExamConfigured' ELSE 'Sub Exam' END AS SubExmConfigured
	  ,CASE WHEN  (SELECT ISNULL(SUM(D.DividedExamFullMarks),0) FROM Res_GrandDividedExamMarkSetup AS D WHERE D.IsDeleted=0 AND D.SubExamMarkSetupId IN(SELECT SE.GrandSubExamMarkSetupId FROM Res_GrandSubExamMarkSetup AS SE WHERE SE.GrandExamMarkSetupId= M.GrandExamMarkSetupId AND SE.IsDeleted=0))
	  = ( SELECT SUM(SEE.SubExamExamMarks) FROM Res_GrandSubExamMarkSetup AS SEE WHERE SEE.GrandExamMarkSetupId= M.GrandExamMarkSetupId AND SEE.IsDeleted=0)
	  THEN 'DividedExamConfigured' ELSE 'Divided Exam' END AS DividedExmConfigured
  FROM [dbo].[Res_GrandExamMarkSetup] AS M
  RIGHT OUTER JOIN Res_SubjectSetup AS S ON M.ExamSubjectID=S.SubID AND M.GrandExamId=@MainExamId AND M.IsDeleted=0 
  LEFT OUTER JOIN Res_MainExam AS E ON E.MainExamId=M.GrandExamId AND E.MainExamId=@MainExamId AND E.IsDeleted=0
  WHERE S.VersionID=@VersionId AND S.SessionId=@SessionId AND S.ClassId=@ClassId AND S.GroupId=@GroupId AND S.IsDeleted=0 --AND M.IsDeleted=0 --S.IsDeleted=0 --AND M.IsDeleted=0-- AND S.SubjectCode !=0
  ORDER BY S.ReportSerialNo ASC

END


--select [MainExamMarkSetupId], Id from [dbo].[Res_GrandSubExamMarkSetup] where [MainExamMarkSetupId]=161

---  GrandGetAllExamMarkSubject 1,6,7,0,5826