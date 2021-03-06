/****** Object:  StoredProcedure [dbo].[GetStudentInfoForResult]    Script Date: 7/22/2017 4:19:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetStudentListWithAssesmentSubjectWise]'))
BEGIN
DROP PROCEDURE  GetStudentListWithAssesmentSubjectWise
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON

GO
	--Section: "96,"97,98,99
-- exec GetStudentListWithAssesmentSubjectWise 8,11,2,32,127,41,1047,142

CREATE PROCEDURE [dbo].[GetStudentListWithAssesmentSubjectWise]
	

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
	
	SELECT   mrsd.SubjectConvertedMarks,sb.FullName,sb.StudentIID,sb.RollNo, sb.StudentInsID,ASS.Id as AssesmentId,ASS.Name as AssesmentName,ASS.Code AS Code, ASTU.Comments AS Comment ,
	 1 as IsTaken,
	mrsd.SubjectGL,mrsd.SubjectGP,ROUND( mrsd.SubjectConvertedMarks,0) as TotalMark
	FROM               
        dbo.Student_BasicInfo sb   
		left OUTER JOIN [dbo].[Res_AssessmentSubSetup] ASS on  ass.MainExamId=@MainExamId AND ass.SubjectId = @SubjectId
		LEFT JOIN Res_AssessmentStudent  ASTU ON ASTU.StudentId = SB.StudentIID AND ASTU.SubjectId = @SubjectId AND ASTU.AssessmentId = ASS.Id
		left OUTER JOIN [dbo].Res_MainExamResultSubjectDetails mrsd  on mrsd.SubjectID=ass.SubjectId and mrsd.StudentIID=sb.StudentIID and mrsd.MainExamId=@MainExamId AND mrsd.SubjectId=@SubjectId
		
		
		WHERE 			
			sb.SessionId = COALESCE(@SessionId,sb.SessionId) 
			AND sb.BranchID = COALESCE(@BranchID,sb.BranchID)
			AND sb.ShiftID = COALESCE(@ShiftID,sb.ShiftID)
			AND sb.ClassId = COALESCE(@ClassId,sb.ClassId)
			AND sb.SectionId = COALESCE(@SectionId,sb.SectionId) 			
		   -- AND mrsd.SubjectId=@SubjectId
			AND sb.IsDeleted=0 AND ASS.IsDeleted =0 AND sb.[Status] = 'A'
		ORDER BY Ass.[Order], CAST(sb.RollNo AS INT)  ASC

END
--SELECT * FROM Common_DropDownConfig WHERE Type = 'AssesmentComment'
--SELECT * FROM [Res_AssessmentSubSetup]

-- exec GetStudentListWithAssesmentSubjectWise 1,12,1002,19,76,1,1002,14