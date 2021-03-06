/****** Object:  StoredProcedure [dbo].[DeleteMainExamStudentMark]    Script Date: 7/22/2017 3:00:43 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DeleteMainExamStudentMark]'))
BEGIN
DROP PROCEDURE  DeleteMainExamStudentMark
END
GO
CREATE PROCEDURE [dbo].[DeleteMainExamStudentMark] 
(
   	@VersionId INT,
	@SessionId INT,	
	@ShiftID INT ,
	@ClassId INT,
	@GroupId INT,
	@SectionId INT,
	@SubjectID INT,
	@MainExamId INT,
	@SubExamId INT,
	@DividedExamId INT,
	@MarksId INT = 0
)
AS
SET NOCOUNT OFF;
BEGIN
	IF(@MarksId >0)
	BEGIN
		DELETE FROM [dbo].[Res_MainExamMarks] WHERE MarksId = @MarksId
		SELECT @@ROWCOUNT AS NO_ROW_DELETED
	END
	ELSE
	BEGIN
		DELETE FROM [dbo].[Res_MainExamMarks] 
									WHERE   VersionId = @VersionId AND 
											SessionId = @SessionId AND
											ShiftId = @ShiftID AND
											ClassId =  @ClassId AND
											GroupId = @GroupId AND
											SectionId = @SectionId AND
											SubjectID = @SubjectID AND
											MainExamID = @MainExamId AND
											SubExamID = @SubExamId AND
											DividedExamID =@DividedExamId

		SELECT CAST( @@ROWCOUNT AS VARCHAR) + ' Data Deleted Successfully!!'  AS NO_ROW_DELETED

	END
END
