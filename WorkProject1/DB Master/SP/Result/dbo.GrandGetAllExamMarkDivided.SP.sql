/****** Objct:  StoredProcedure [dbo].[GetAllExamMarkDivided]    Script Date: 7/22/2017 4:02:46 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GrandGetAllExamMarkDivided]'))
BEGIN
DROP PROCEDURE  GrandGetAllExamMarkDivided
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GrandGetAllExamMarkDivided] --66
(
@SubExamId INT,
@SubExamMarkSetupId INT
)
AS
BEGIN
SELECT
	   D.DividedExamName
	  ,ISNULL(DividedExamMarkSetupId,0) AS DividedExamMarkSetupId
     ,@SubExamMarkSetupId as SubExamMarkSetupId
	  
      ,D.[GrandDividedExamId] as DividedExamId
      ,D.[DividedExamType]
      ,ISNULL([DividedExamFullMarks],0) AS [DividedExamFullMarks]
      ,ISNULL([DividedExamExamMarks],0) AS [DividedExamExamMarks]
      ,ISNULL([DividedExamIsPassDepend],0) AS [DividedExamIsPassDepend]
      ,ISNULL([DividedExamPassMarks],0) AS [DividedExamPassMarks]
      ,ISNULL([DividedExamPassMarkIsPercent],0) AS [DividedExamPassMarkIsPercent]
      --,ISNULL([DividedExamDefaultPercent],0) AS [DividedExamDefaultPercent]
      ,ISNULL(DM.[IsDeleted],0) AS [IsDeleted]
      ,ISNULL(DM.[AddBy],'') AS [AddBy]
      ,ISNULL(DM.[AddDate],'') AS [AddDate]
      ,ISNULL(DM.[UpdateBy],'') AS [UpdateBy]
      ,ISNULL(DM.[UpdateDate],'') AS [UpdateDate]
      ,ISNULL(DM.[Remarks],'') AS [Remarks]
      ,ISNULL(DM.[Status],'') AS [Status]
	  ,ISNULL(DM.DividedExamIsEnable,0) AS DividedExamIsEnable
	  ,CASE WHEN DM.DividedExamMarkSetupId IS NULL THEN 'Divided Exam' ELSE 'DividedExamConfigured' END AS DividedExmConfigured	  
  FROM Res_GrandDividedExam  AS D LEFT OUTER JOIN Res_GrandDividedExamMarkSetup AS DM
  ON DM.DividedExamId=D.GrandDividedExamId AND DM.SubExamMarkSetupId=@SubExamMarkSetupId
  AND DM.IsDeleted=0   WHERE D.GrandSubExamId=@SubExamId AND D.IsDeleted=0
  END




 --  [dbo].[GetAllExamMarkDivided] 98,38
