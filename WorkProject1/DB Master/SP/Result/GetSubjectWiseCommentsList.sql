/****** Object:  StoredProcedure [dbo].[GetStudentInfoForResult]    Script Date: 7/22/2017 4:19:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetSubjectWiseCommentsList]'))
BEGIN
DROP PROCEDURE  GetSubjectWiseCommentsList
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec GetSubjectWiseCommentsList 8,10,2,19,76,8,1011,24

CREATE PROCEDURE [dbo].[GetSubjectWiseCommentsList]
	

	@BranchID INT = NULL,
	@SessionId INT = NULL,
	@ShiftID INT = NULL,
	@ClassId INT = NULL,
	@SectionId INT = NULL,
	@TermId INT = NULL,
	@MainExamId INT =NULL,
	@SubjectId INT=NULL

AS
BEGIN
		IF @SessionId = 0 SET @SessionId  = NULL
		IF @BranchID = 0 SET @BranchID  = NULL
		IF @ShiftID = 0 SET @ShiftID  = NULL
		IF @ClassId = 0 SET @ClassId  = NULL
		IF @SectionId = 0 SET @SectionId  = NULL
		IF @TermId = 0 SET @TermId  = NULL
		IF @MainExamId = 0 SET @MainExamId  = NULL
		IF @SubjectId = 0 SET @SubjectId  = NULL
	
	SELECT distinct  sb.FullName,sb.StudentIID,sb.RollNo, sb.StudentInsID,mesd.SubjectGL,swc.Comments,swc.Id
	FROM               
        dbo.Student_BasicInfo sb 
		left outer join dbo.Res_MainExamResultSubjectDetails mesd on mesd.StudentIID = sb.StudentIID and mesd.MainExamId = @MainExamId and mesd.SubjectID = @SubjectId
		left outer join dbo.Res_SubjectWiseComment swc on swc.StudentId = sb.StudentIID and swc.MainExamId = @MainExamId and swc.SubjectID = @SubjectId and swc.IsDeleted=0
		
		 
		WHERE 			
			sb.SessionId = COALESCE(@SessionId,sb.SessionId) AND 
			sb.BranchID = COALESCE(@BranchID,sb.BranchID)AND
			sb.ShiftID = COALESCE(@ShiftID,sb.ShiftID)AND
			sb.ClassId = COALESCE(@ClassId,sb.ClassId)AND
			sb.SectionId = COALESCE(@SectionId,sb.SectionId) --AND
			--ASS.SubjectId=@SubjectId
			 AND sb.IsDeleted=0

	


END

-- exec GetSubjectWiseCommentsList 1,12,1002,19,76,1,1002,14