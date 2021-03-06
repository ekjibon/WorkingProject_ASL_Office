
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAllSubjectForVirtualExam]'))
BEGIN
DROP PROCEDURE  GetAllSubjectForVirtualExam
END
GO
Create Proc [dbo].[GetAllSubjectForVirtualExam] -- EXEC GetAllSubjectForVirtualExam 1, 15,5,1
(
@VersionID int ,
@ClassID int,
@SessionID int,
@GroupID int
)
As
Begin
SELECT [SubID]
      ,[VersionID]
      ,[SessionId]
      ,[ClassId]
      ,[GroupId]
      ,[SubjectName]
      ,ISNULL([ShortName],'') AS [ShortName]
      ,ISNULL([SubjectCode],0) AS [SubjectCode]
      ,ISNULL([ReportSerialNo],0) AS [ReportSerialNo]
      ,ISNULL([NoEffectOnExam],0) AS [NoEffectOnExam]
      ,ISNULL([SpecialSubject],0) AS [SpecialSubject]
      ,ISNULL([ImpactOnMeritPosition],0) AS [ImpactOnMeritPosition]
      ,ISNULL([IsCompulsory],0) AS [IsCompulsory]
      ,ISNULL([IsSelective],0) AS [IsSelective]
      ,ISNULL([IsThird],0) AS [IsThird]
      ,ISNULL([IsFourth],0) AS [IsFourth]
      ,ISNULL([IsReligious],0) AS [IsReligious]
      ,ISNULL([IsPair],0) AS [IsPair]
      ,ISNULL([FirstPairSubID],0) AS [FirstPairSubID]
      ,ISNULL([SecondPairSubID],0) AS [SecondPairSubID]
      ,ISNULL([IsDeleted],0) AS [IsDeleted]
      ,ISNULL([AddBy],'') AS [AddBy]
      ,ISNULL([AddDate],'') AS [AddDate]
      ,ISNULL([UpdateBy],'') AS [UpdateBy]
      ,ISNULL([UpdateDate],'') AS [UpdateDate]
      ,CASE WHEN S.[SubjectType] !='T' and S.IsPair=1 THEN (ISNULL((SELECT Top(1) t.SubjectName FROM [Res_SubjectSetup] as t WHERE t.SubID=S.[FirstPairSubID] OR t.SubID=S.[SecondPairSubID]),'')) Else
	  (ISNULL((SELECT SubjectName FROM [Res_SubjectSetup] WHERE [SubID]=S.[FirstPairSubID]),'') +' '+
	   ISNULL((SELECT SubjectName FROM [Res_SubjectSetup] WHERE [SubID]=S.[SecondPairSubID]),'') )
	   End AS [Remarks]
      ,ISNULL([Status],'') AS [Status]
  FROM [dbo].[Res_SubjectSetup] AS S
  WHERE VersionID = @VersionID AND SessionId = @SessionID AND ClassId = @ClassID AND GroupId = @GroupID AND S.IsDeleted=0
  ORDER BY [ReportSerialNo] ASC
  --AND S.SubjectCode!=0
End

   --,CASE WHEN [SubjectCode] !=0 THEN ISNULL((SELECT SubjectName FROM [Res_SubjectSetup] WHERE [FirstPairSubID]=S.SubID OR [FirstPairSubID]=S.SubID),'') Else
	  --ISNULL((SELECT SubjectName FROM [Res_SubjectSetup] WHERE [SubID]=S.[FirstPairSubID]),'') +' '+
	  -- ISNULL((SELECT SubjectName FROM [Res_SubjectSetup] WHERE [SubID]=S.[SecondPairSubID]),'') End
	  -- AS [Remarks]

--	GetAllSubject  2002,2011,2012,1

--select S.[SubjectName], S.IsPair,  CASE WHEN S.[SubjectCode] !=0 and S.IsPair=1
-- THEN (ISNULL((SELECT Top(1) t.SubjectName FROM [Res_SubjectSetup] as t WHERE 
-- t.SubID=S.[FirstPairSubID] OR t.SubID=S.[SecondPairSubID]),''))
--  Else 
--   (ISNULL((SELECT SubjectName FROM [Res_SubjectSetup] WHERE [SubID]=S.[FirstPairSubID]),'') +' '+
--	   ISNULL((SELECT SubjectName FROM [Res_SubjectSetup] WHERE [SubID]=S.[SecondPairSubID]),'') ) end s from Res_SubjectSetup as S