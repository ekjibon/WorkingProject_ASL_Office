/****** Object:  StoredProcedure [dbo].[GetStudentInfoForResult]    Script Date: 7/22/2017 4:19:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptStudentListWithAssesmentSubjectWise]'))
BEGIN
DROP PROCEDURE  rptStudentListWithAssesmentSubjectWise
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec rptStudentListWithAssesmentSubjectWise 8,10,4,23,92,16,1026,134

CREATE PROCEDURE [dbo].[rptStudentListWithAssesmentSubjectWise]
	

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
	
	SELECT   sb.FullName,sb.StudentIID,sb.RollNo,b.BranchName,s.SessionName,sec.SectionName, rss.SubjectName, sh.ShiftName,t.Name as TermName,
	 c.ClassName + ' ( '+sec.SectionName+' )' as ClassName,sb.StudentInsID,ASS.Id as AssesmentId,ASS.Name as AssesmentName,AM.Comments,1 as IsTaken
	FROM               
        dbo.Student_BasicInfo sb   left OUTER JOIN
		[dbo].Res_AssessmentStudent AM on AM.StudentId=sb.StudentIID and AM.SubjectId=@SubjectId left OUTER JOIN
		[dbo].[Res_AssessmentSubSetup] ASS on ASS.Id=AM.AssessmentId Inner  join 
		dbo.Ins_Branch b on b.BranchId = sb.BranchID INNER JOin
		dbo.Ins_Session s on S.SessionId = sb.SessionId INNER JOin
		dbo.Ins_Section Sec on Sec.SectionId = sb.SectionId INNER JOin
		dbo.Ins_Shift sh on sh.ShiftId = sb.ShiftId INNER JOin
		dbo.Ins_ClassInfo c on c.ClassId = sb.ClassId Inner Join dbo.Res_SubjectSetup rss on rss.SubID =AM.SubjectId and rss.ClassId = sb.ClassId 
       Inner Join dbo.Res_Terms t on t.TermId =@TermId and t.ClassId = sb.ClassId
		WHERE 			
			sb.SessionId = COALESCE(@SessionId,sb.SessionId) AND 
			sb.BranchID = COALESCE(@BranchID,sb.BranchID)AND
			sb.ShiftID = COALESCE(@ShiftID,sb.ShiftID)AND
			sb.ClassId = COALESCE(@ClassId,sb.ClassId)AND
			sb.SectionId = COALESCE(@SectionId,sb.SectionId) --AND
			--ASS.SubjectId=@SubjectId
			 AND sb.IsDeleted=0
		ORDER BY CAST(sb.RollNo AS INT)  ASC

END

-- exec rptStudentListWithAssesmentSubjectWise 1,12,1002,19,76,1,1002,14