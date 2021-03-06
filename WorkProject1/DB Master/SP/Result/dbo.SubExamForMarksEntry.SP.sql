/****** Object:  StoredProcedure [dbo].[SubExamForMarksEntry]    Script Date: 7/22/2017 5:09:00 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SubExamForMarksEntry]'))
BEGIN
DROP PROCEDURE  SubExamForMarksEntry
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[SubExamForMarksEntry]
(
    @VersionId INT,
	@SessionId INT,
	@ClassId INT,
	@GroupId INT,	
	@SubjectID INT,
	@MainExamId INT
)
AS
BEGIN
SELECT Distinct [SubExamId]      
      ,[SubExamName]
      
  FROM [dbo].[Res_SubExam]

  Where IsDeleted=0 and SubExamId In 
  (
  SELECT 
     [SubExamId]
     
  FROM [Res_SubExamMarkSetup] where [Res_SubExamMarkSetup].IsDeleted=0 and [MainExamMarkSetupId] in(

    select Id from [Res_MainExamMarkSetup] where MainExamSubjectID=@SubjectID and 
	MainExamId=@MainExamId and [VersionId]=@VersionId and [SessionId]=@SessionId 
	and [ClassId]=@ClassId and [GroupId]=@GroupId and IsDeleted=0
	)
  )

END