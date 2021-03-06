
GO
/****** Object:  StoredProcedure [dbo].[GetAllExamMarkSubject]    Script Date: 7/22/2017 4:03:26 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAllExamMarkSubject]'))
BEGIN
DROP PROCEDURE  GetAllExamMarkSubject
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- [dbo].[GetAllExamMarkSubject] 11,29,38,1056,1,null
--[dbo].[GetAllExamMarkSubject] 11,null, null,1044,2,'53c2fedf-a2dd-4cb8-b5d9-34b9342528ae'
CREATE proc [dbo].[GetAllExamMarkSubject]
(
 @SessionId int=null,
 @ClassId int=null,
 @TermId int=null,
 @MainExamId int=null,
 @Block int=null ,
 @TeacherId varchar(150)=null  --add by ayesha
 )
 AS
BEGIN
if(@Block=1)
BEGIN
SELECT 
       S.SubjectName AS SubjectName
      ,ISNULL(M.[Id],0) AS Id
      ,S.[SessionId]
      ,S.[ClassId]
      ,@MainExamId AS MainExamId
      ,ISNULL(S.SubID,0) AS MainExamSubjectID
      ,ISNULL([MainExamFullMarks],0) AS MainExamFullMarks
      ,ISNULL([MainExamPassMark],0) AS MainExamPassMark
      ,ISNULL([MainExamDefaultPercent],0) AS MainExamDefaultPercent
      ,S.[IsDeleted]
      ,S.[AddBy],
	  s.TermId
      ,S.[AddDate]
      ,ISNULL(S.[UpdateBy],'') AS [UpdateBy]
      ,ISNULL(S.[UpdateDate],'') AS [UpdateDate]
      ,ISNULL(S.[Remarks],'') AS [Remarks]
      ,ISNULL(S.[Status],'') AS [Status]   
	  ,CASE WHEN M.Id IS NULL THEN 'Main Exam' ELSE 'Main Exam Has Been Configured' END AS MainExmConfigured 
	  ,CASE WHEN (SELECT ISNULL(SUM(SubExamFullMarks),0) FROM Res_SubExamMarkSetup WHERE MainExamMarkSetupId=M.Id AND Res_SubExamMarkSetup.IsDeleted=0) = M.MainExamFullMarks THEN 'SubExamConfigured' ELSE 'Sub Exam' END AS SubExmConfigured
	  ,S.SubjectType
	  ,ISNULL((SELECT TOP 1 MarksId FROM Res_MainExamMarks WHERE SubjectID=S.SubID AND MainExamID=M.MainExamId AND IsDeleted=0),0) AS MarksEntry
  --FROM [dbo].[Res_MainExamMarkSetup] AS M
  --RIGHT OUTER JOIN Res_SubjectSetup AS S ON M.MainExamSubjectID=S.SubID AND M.MainExamId=@MainExamId AND M.IsDeleted=0 
  FROM Res_SubjectSetup AS S
  LEFT JOIN [dbo].[Res_MainExamMarkSetup] AS M ON M.MainExamSubjectID=S.SubID AND M.MainExamId=@MainExamId AND M.IsDeleted=0 AND M.TermId=@TermId
  LEFT JOIN Res_MainExam AS E ON E.MainExamId=M.MainExamId AND E.MainExamId=@MainExamId AND E.IsDeleted=0
  WHERE 
   S.SessionId=@SessionId AND S.ClassId=@ClassId  AND S.IsDeleted=0 --AND M.MainExamId = @MainExamId AND M.IsDeleted=0 --S.IsDeleted=0 --AND M.IsDeleted=0-- AND S.SubjectCode !=0
  ORDER BY S.ReportSerialNo ASC
END
if(@Block=2)
BEGIN
select top 1 @SessionId=SessionId,@ClassId=ClassId,@TermId=TermId from dbo.Res_MainExam where MainExamId=@MainExamId
SELECT DISTINCT S.[SessionId],
       S.SubjectName AS SubjectName
      ,ISNULL(M.[Id],0) AS Id
      
      ,S.[ClassId]
	  ,A.SectionID 
	  ,ISNULL((SELECT SectionName FROM [dbo].[Ins_Section] WHERE SectionId = (A.SectionID)),0) AS SectionName --Add by Khaled
      ,@MainExamId AS MainExamId
      ,ISNULL(S.SubID,0) AS MainExamSubjectID
      ,ISNULL([MainExamFullMarks],0) AS MainExamFullMarks
      ,ISNULL([MainExamPassMark],0) AS MainExamPassMark
      ,ISNULL([MainExamDefaultPercent],0) AS MainExamDefaultPercent
      ,S.[IsDeleted]
      ,S.[AddBy],
	  s.TermId
      ,S.[AddDate]
      ,ISNULL(S.[UpdateBy],'') AS [UpdateBy]
      ,ISNULL(S.[UpdateDate],'') AS [UpdateDate]
      ,ISNULL(S.[Remarks],'') AS [Remarks]
      ,ISNULL(S.[Status],'') AS [Status]   
	  ,CASE WHEN M.Id IS NULL THEN 'Main Exam' ELSE 'Main Exam Has Been Configured' END AS MainExmConfigured 
	  ,CASE WHEN (SELECT ISNULL(SUM(SubExamFullMarks),0) FROM Res_SubExamMarkSetup WHERE MainExamMarkSetupId=M.Id AND Res_SubExamMarkSetup.IsDeleted=0) = M.MainExamFullMarks THEN 'SubExamConfigured' ELSE 'Sub Exam' END AS SubExmConfigured
	  ,S.SubjectType
	  ,ISNULL((SELECT TOP 1 MarksId FROM Res_MainExamMarks WHERE SubjectID=S.SubID AND MainExamID=M.MainExamId AND IsDeleted=0),0) AS MarksEntry 
  FROM [dbo].[Res_MainExamMarkSetup] AS M
  INNER JOIN Res_SubjectSetup AS S ON M.MainExamSubjectID=S.SubID AND M.MainExamId=@MainExamId AND M.IsDeleted=0 
 -- LEFT OUTER JOIN Res_MainExam AS E ON E.MainExamId=M.MainExamId AND E.MainExamId=@MainExamId AND E.IsDeleted=0
  -------------------------Add by Ayesha
  INNER JOIN Res_AssignSubjectsToTeacher A ON A.SubjectID=S.SubID AND A.IsDeleted=0 
  INNER JOIN AspNetUsers U ON U.EmpId=A.TeacherID
  WHERE 
   S.SessionId=@SessionId AND S.ClassId=@ClassId   AND S.IsDeleted=0 and U.Id=@TeacherId --AND M.IsDeleted=0 --S.IsDeleted=0 --AND M.IsDeleted=0-- AND S.SubjectCode !=0
 -- ORDER BY S.ReportSerialNo ASC
END
END

--select [MainExamMarkSetupId], Id from [dbo].[Res_SubExamMarkSetup] where [MainExamMarkSetupId]=161

---  GetAllExamMarkSubject 1,5,15,1,129