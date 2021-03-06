/****** Object:  StoredProcedure [dbo].[GetSelectiveSubject]    Script Date: 7/22/2017 4:13:29 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetSelectiveSubject]'))
BEGIN
DROP PROCEDURE  GetSelectiveSubject
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[GetSelectiveSubject]       
(
@StudentInsID Varchar(100)
)
As
Begin
SELECT
	  ISNULL(SS.ID,0) AS ID,
	  CAST(CASE WHEN ISNULL(SS.ID,0)=0 THEN 0 ELSE 1 END AS BIT ) Assigned
	  ,B.StudentIID AS StudentIID
      ,S.[SubID]
	  ,B.FullName AS Name
	  ,B.BranchID
	  ,C.ClassName
	  ,G.GroupName
      ,S.[VersionID]
      ,S.[SessionId]
      ,S.[ClassId]
      ,S.[GroupId]
      ,S.[SubjectName]
      ,ISNULL(S.[ShortName],'') AS [ShortName]
      ,ISNULL(S.[SubjectCode],0) AS [SubjectCode]
      ,ISNULL(S.[ReportSerialNo],0) AS [ReportSerialNo]
      ,ISNULL(S.[NoEffectOnExam],0) AS [NoEffectOnExam]
      ,ISNULL(S.[SpecialSubject],0) AS [SpecialSubject]
      ,ISNULL(S.[ImpactOnMeritPosition],0) AS [ImpactOnMeritPosition]
      ,ISNULL(S.[IsCompulsory],0) AS [IsCompulsory]
      ,ISNULL(S.[IsSelective],0) AS [IsSelective]
      ,ISNULL(S.[IsThird],0) AS [IsThird]
      ,ISNULL(S.[IsFourth],0) AS [IsFourth]
      ,ISNULL(S.[IsReligious],0) AS [IsReligious]
      ,ISNULL(S.[IsPair],0) AS [IsPair]
      ,ISNULL(S.[FirstPairSubID],0) AS [FirstPairSubID]
      ,ISNULL(S.[SecondPairSubID],0) AS [SecondPairSubID]
      ,ISNULL(SS.[IsDeleted],0) AS [IsDeleted]
      ,ISNULL(SS.[AddBy],'') AS [AddBy]
      ,ISNULL(SS.[AddDate],'') AS [AddDate]
      ,ISNULL(SS.[UpdateBy],'') AS [UpdateBy]
      ,ISNULL(SS.[UpdateDate],'') AS [UpdateDate]      
	  ,ISNULL(SS.[Remarks],'') AS [Remarks]      
	  ,ISNULL((SELECT TOP(1) CONVERT(VARCHAR(100), SubjectID) FROM Res_MainExamMarks 
	   WHERE SubjectID=[SubID] AND VersionId=B.VersionID AND 
	   SessionId=B.SessionId AND ClassId=B.ClassId AND GroupId=B.GroupId AND StudentIID=B.StudentIID AND [IsDeleted]=0),'M') AS [Status]

  FROM [dbo].[Res_SubjectSetup] AS S INNER JOIN Student_BasicInfo AS B
  On S.VersionID=B.VersionID AND S.SessionId=B.SessionId AND S.ClassId=B.ClassId AND S.GroupId=B.GroupId
   LEFT OUTER JOIN Res_StudentSubject AS SS ON SS.SubjectID=S.SubID AND SS.SessionId=S.SessionId AND SS.StudentID=B.StudentIID AND SS.IsDeleted=0
  --LEFT OUTER JOIN Res_SelectiveSubjectSetup AS SS ON SS.SubjectID=S.SubID AND SS.SessionID=S.SessionId AND SS.StudentID=B.StudentIID AND SS.IsDeleted=0
  INNER JOIN Ins_ClassInfo C ON S.ClassId=C.ClassId INNER JOIN Ins_Group AS G ON S.GroupId=G.GroupId
  WHERE B.StudentInsID=@StudentInsID AND S.[IsSelective]=1 AND S.[IsDeleted]=0 AND B.[IsDeleted]=0
  ORDER BY [ReportSerialNo] ASC
  --AND S.ShortName !=''
End

    

  
  -- [dbo].[GetSelectiveSubject] '1707021274'