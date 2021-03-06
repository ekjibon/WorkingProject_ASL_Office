/****** Object:  StoredProcedure [dbo].[MainExamForMarksEntry]    Script Date: 7/22/2017 4:27:33 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[MainExamForMarksEntry]'))
BEGIN
DROP PROCEDURE  MainExamForMarksEntry
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/
-- exec MainExamForMarksEntry 12,19,14,1
CREATE Proc [dbo].[MainExamForMarksEntry]
(
	@SessionId INT,
	@ClassId INT,
	@SubjectID INT,
	@TermId INT
)
AS
BEGIN

SELECT distinct  [MainExamId]
      ,[MainExamName]
      
  FROM [dbo].[Res_MainExam] 
  where [MainExamId] in (
   select MainExamId from [Res_MainExamMarkSetup] 
   where MainExamSubjectID=@SubjectID and 
    [SessionId]=@SessionId and [ClassId]=@ClassId and  IsDeleted=0
  ) AND IsDeleted=0 AND TermId=@TermId
 END