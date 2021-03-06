/****** Objct:  StoredProcedure [dbo].[GetAllExamMarkDivided]    Script Date: 7/22/2017 4:02:46 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAllExamMarkDivided]'))
BEGIN
DROP PROCEDURE  GetAllExamMarkDivided
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GetAllExamMarkDivided] --66
(
@SubExamId INT,
@SubExamMarkSetupId INT
)
AS
BEGIN
	DECLARE @SubjectId INT, @MainExamId INT
	SELECT @SubjectId=MainExamSubjectID, @MainExamId=MainExamId FROM Res_MainExamMarkSetup WHERE Id=(SELECT MainExamMarkSetupId FROM Res_SubExamMarkSetup WHERE Id=@SubExamMarkSetupId AND IsDeleted=0)

	  SELECT D.DividedExamName
	  ,ISNULL([Id],0) AS Id
      ,@SubExamMarkSetupId as SubExamMarkSetupId	  
      ,D.[DividedExamId]
      ,D.[DividedExamType]
      ,ISNULL([DividedExamFullMarks],0) AS [DividedExamFullMarks]
      ,ISNULL([DividedExamExamMarks],0) AS [DividedExamExamMarks]
      ,ISNULL([DividedExamIsPassDepend],0) AS [DividedExamIsPassDepend]
      ,ISNULL([DividedExamPassMarks],0) AS [DividedExamPassMarks]
      ,ISNULL([DividedExamPassMarkIsPercent],0) AS [DividedExamPassMarkIsPercent]
      ,ISNULL([DividedExamDefaultPercent],0) AS [DividedExamDefaultPercent]
      ,ISNULL(DM.[IsDeleted],0) AS [IsDeleted]
      ,ISNULL(DM.[AddBy],'') AS [AddBy]
      ,ISNULL(DM.[AddDate],'') AS [AddDate]
      ,ISNULL(DM.[UpdateBy],'') AS [UpdateBy]
      ,ISNULL(DM.[UpdateDate],'') AS [UpdateDate]
      ,ISNULL(DM.[Remarks],'') AS [Remarks]
      ,ISNULL(DM.[Status],'') AS [Status]
	  ,ISNULL(DM.DividedExamIsEnable,0) AS DividedExamIsEnable
	  ,CASE WHEN DM.Id IS NULL THEN 'Divided Exam' ELSE 'DividedExamConfigured' END AS DividedExmConfigured	  
	  ,ISNULL((SELECT TOP 1 MarksId FROM Res_MainExamMarks WHERE MainExamID=@MainExamId AND SubExamID=@SubExamId AND DividedExamID=DM.DividedExamId AND SubjectID=@SubjectId AND IsDeleted=0),0) AS DividedExamMarksEntry
  FROM Res_DividedExam  AS D LEFT OUTER JOIN [dbo].[Res_DividedExamMarkSetup] AS DM
  ON DM.DividedExamId=D.DividedExamId AND DM.SubExamMarkSetupId=@SubExamMarkSetupId
  AND DM.IsDeleted=0   WHERE D.SubExamId=@SubExamId AND D.IsDeleted=0
  END




 --  [dbo].[GetAllExamMarkDivided] 18,140
