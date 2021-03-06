/****** Object:  StoredProcedure [dbo].[CheckStudentMark]    Script Date: 7/22/2017 2:43:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CheckStudentMark]'))
BEGIN
DROP PROCEDURE  CheckStudentMark
END
GO


 CREATE PROC [dbo].[CheckStudentMark]
  (
  	@VersionId INT,
	@SessionId INT,	
	@ShiftID INT ,
	@ClassId INT,
	@GroupId INT,
	@SectionId INT,
	@StudentIID INT,
	@SubjectID INT,
	@MainExamId INT,
	@SubExamId INT,
	@DividedExamId INT
  )
  AS
  BEGIN 
  IF EXISTS(
  SELECT * FROM [dbo].[Res_MainExamMarks] WHERE VersionID =  @VersionId AND 
  SessionId = @SessionId AND SectionId = @SectionId
  AND ShiftID = @ShiftID AND ClassId = @ClassId 
  AND GroupId = @GroupId  AND StudentIID = @StudentIID
  AND SubjectID = @SubjectID AND MainExamID = @MainExamId
  AND SubExamID = @SubExamId AND DividedExamID = @DividedExamId AND IsDeleted=0)
  BEGIN
  SELECT @@ROWCOUNT AS MARKEXIST
  END
  ELSE
  BEGIN
    SELECT @@ROWCOUNT AS MARKEXIST
  END
  END 