/****** Object:  StoredProcedure [dbo].[GetAllSubject]    Script Date: 7/22/2017 4:07:49 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAllSubject]'))
BEGIN
DROP PROCEDURE  GetAllSubject
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Proc [dbo].[GetAllSubject] 
(
@ClassID int,
@SessionID int,
@IsSuper bit,
@TermId int
)
As
Begin
DECLARE @Process VARCHAR(10);
--If Result Process the No Effect and Impact Merit DisAable


SELECT [SubID]
    
      ,[SessionId]
      ,[ClassId]
      ,[SubjectName]
      ,ISNULL([ShortName],'') AS [ShortName]
      ,ISNULL([SubjectCode],'') AS [SubjectCode]
      ,ISNULL([ReportSerialNo],0) AS [ReportSerialNo]
      ,TermId
      ,ISNULL([SpecialSubject],0) AS [SpecialSubject]

      ,ISNULL([IsCompulsory],0) AS [IsCompulsory]
      ,ISNULL([IsECA],0) AS [IsECA]
      ,ISNULL([IsICT],0) AS [IsICT]
      ,ISNULL([IsCompulsory],0) AS [IsCompulsory]

      ,ISNULL([IsPair],0) AS [IsPair]
      ,ISNULL([FirstPairSubID],0) AS [FirstPairSubID]
      ,ISNULL([SecondPairSubID],0) AS [SecondPairSubID]
      ,ISNULL([IsDeleted],0) AS [IsDeleted]
      ,ISNULL([AddBy],'') AS [AddBy]
      ,ISNULL([AddDate],'') AS [AddDate]
      ,ISNULL([UpdateBy],'') AS [UpdateBy]
      ,ISNULL([UpdateDate],'') AS [UpdateDate]
     ---No Empect in New RequiredMent
	
	  ,(case when EXISTS( select* from  Res_MERSubExamResult WHERE SubjectID =s.SubID) then  '0' else '0' END ) as [Processed] 
	 
	   --ISNULL((SELECT TOP(1) CONVERT(VARCHAR(100), SubjectID) FROM Res_MEResultDetails 
	   --WHERE SubjectID = ( CASE WHEN ([FirstPairSubID]!=0 and [SecondPairSubID]!=0) THEN  [FirstPairSubID] ELSE [SubID] END ) OR 
				--					   SubjectID =( CASE WHEN ([FirstPairSubID]!=0 and [SecondPairSubID]!=0) THEN [SecondPairSubID] ELSE [SubID] END )),'0')  AS [Processed]

  FROM [dbo].[Res_SubjectSetup] AS S
  WHERE SessionId = @SessionID AND ClassId = @ClassID AND S.IsDeleted=0  --AND s.TermId=@TermId
  ORDER BY [ReportSerialNo] ASC
  --AND S.SubjectCode!=0
End

---GetAllSubject 19,10,0,8

--select * FROM Res_MainExamMarks  where SubjectID =( case when (39!=0 and 40!=0) then  (39) else 38 end ) or 
--									   SubjectID =( case when (40!=0 and 39!=0) then  (40) else 38 end )