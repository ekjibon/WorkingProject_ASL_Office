/****** Object:  StoredProcedure [dbo].[DividedExamForMarksEntry]    Script Date: 7/22/2017 3:24:43 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DividedExamForMarksEntry]'))
BEGIN
DROP PROCEDURE  DividedExamForMarksEntry
END
GO
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[DividedExamForMarksEntry]
(
	@SubExamId INT
)
AS
BEGIN
SELECT Distinct [DividedExamId]     
      ,[DividedExamName]
      
  FROM [dbo].[Res_DividedExam]

  Where IsDeleted=0 and [DividedExamId] In 
  (
  SELECT 
     [DividedExamId]
     
  FROM [dbo].[Res_DividedExamMarkSetup]  where [SubExamMarkSetupId] in(

    select Id from [dbo].[Res_SubExamMarkSetup]  where [SubExamId]=@SubExamId and IsDeleted=0
	)
  )

END