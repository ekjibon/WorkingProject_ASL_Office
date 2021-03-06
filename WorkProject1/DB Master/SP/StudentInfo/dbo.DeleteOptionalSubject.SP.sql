/****** Object:  StoredProcedure [dbo].[DeleteOptionalSubject]    Script Date: 7/22/2017 3:23:34 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DeleteOptionalSubject]'))
BEGIN
DROP PROCEDURE  DeleteOptionalSubject
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteOptionalSubject] 
	@VersionId INT,
	@SessionId INT,
	@BranchID INT,	
	@ClassId INT,
	@GroupId INT,	
	@SubjectID INT,
	@StudentID INT,
	@UserType VARCHAR(1)
	
AS
BEGIN  
DECLARE @ROWCOUNT INT = 0;
IF(@UserType='A')
BEGIN
	IF EXISTS(SELECT  MarksId,SubjectID FROM Res_MainExamMarks WHERE
	VersionID=@VersionId AND SessionId=@SessionId
	AND ClassId=@ClassId AND GroupId = @GroupId AND SubjectID = @SubjectID AND StudentIID=@StudentID )
	BEGIN 
		SELECT @ROWCOUNT AS SUCCESS_FAIL
	END
	ELSE
	BEGIN
		DELETE [dbo].[Res_StudentSubject]  WHERE VersionID=@VersionId AND SessionId=@SessionId
		AND BranchID=@BranchID AND ClassId=@ClassId AND GroupId = @GroupId AND SubjectID = @SubjectID AND StudentID=@StudentID
		--UPDATE [dbo].[Res_StudentSubject] SET IsDeleted=1 WHERE VersionID=@VersionId AND SessionId=@SessionId
		--AND BranchID=@BranchID AND ClassId=@ClassId AND GroupId = @GroupId AND SubjectID = @SubjectID AND StudentID=@StudentID
		SET @ROWCOUNT=@@ROWCOUNT
		SELECT @ROWCOUNT AS SUCCESS_FAIL
	END
	END
	ELSE
	BEGIN
		DELETE [dbo].[Res_StudentSubject]  WHERE VersionID=@VersionId AND SessionId=@SessionId
		AND BranchID=@BranchID AND ClassId=@ClassId AND GroupId = @GroupId AND SubjectID = @SubjectID AND StudentID=@StudentID
		--UPDATE [dbo].[Res_StudentSubject] SET IsDeleted=1 WHERE VersionID=@VersionId AND SessionId=@SessionId
		--AND BranchID=@BranchID AND ClassId=@ClassId AND GroupId = @GroupId AND SubjectID = @SubjectID AND StudentID=@StudentID
		SET @ROWCOUNT=@@ROWCOUNT
		SELECT @ROWCOUNT AS SUCCESS_FAIL
END

END