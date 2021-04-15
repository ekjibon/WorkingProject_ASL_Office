/****** Object:  StoredProcedure [dbo].[GetStudentInfoForResult]    Script Date: 7/22/2017 4:19:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptStudentListWithUniversalMarksEntry]'))
BEGIN
DROP PROCEDURE  rptStudentListWithUniversalMarksEntry
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec rptStudentListWithUniversalMarksEntry 8,10,4,23,92,16,1026,134

CREATE PROCEDURE [dbo].[rptStudentListWithUniversalMarksEntry]
	

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
	
				SELECT DISTINCT ISNULL(M.MarksId,0) AS MarksId, sb.StudentIID AS StudentIId, S.MainExamId, 
				sb.FullName,sb.RollNo,b.BranchName,sess.SessionName,sec.SectionName, rss.SubjectName, sh.ShiftName,t.Name as TermName,
	 c.ClassName + ' ( '+sec.SectionName+' )' as ClassName,sb.StudentInsID,
				S.SubExamId,(SELECT SubExamName FROM Res_SubExam WHERE SubExamId=S.SubExamId) AS SubExamName,
		S.SubExamExamMarks as FullMarks,ISNULL(M.ObtainMarks,0) AS Marks,CAST( ISNULL( M.IsAbsent,0) AS BIT) IsAbsent,
		(SELECT SubExamName FROM Res_SubExam WHERE SubExamId=S.SubExamId) AS SubExamName,
		ISNULL(M.ObtainMarks,0) AS Marks,CAST( ISNULL( M.IsAbsent,0) AS BIT) IsAbsent, @SubjectID	AS SubjectId
		FROM [Qry_MarkSetup] AS S 		 LEFT OUTER JOIN [dbo].[Res_MainExamMarks] AS M ON S.MainExamId=M.MainExamID AND S.SubExamId=M.SubExamID 
		AND M.SessionId=@SessionId AND M.ShiftId=@ShiftID
		AND M.ClassId=@ClassId AND M.SectionId=@SectionId 
		INNER JOIN dbo.Student_BasicInfo sb on sb.SessionId = @SessionId and sb.ClassId = @ClassId
		                and sb.ShiftID = @ShiftID and sb.SectionId = @SectionId and sb.BranchID = @BranchID
		  AND M.IsDeleted=0 AND M.StudentIID=sb.StudentIID AND (M.SubjectID=@SubjectID) 
	 -- OR @SubjectID=0) 
		INNER JOIN dbo.Res_StudentSubject ss on ss.StudentID=sb.StudentIID Inner JOIN
		dbo.Ins_Branch b on b.BranchId = sb.BranchID INNER JOin
		dbo.Ins_Session sess on sess.SessionId = sb.SessionId INNER JOin
		dbo.Ins_Section Sec on Sec.SectionId = sb.SectionId INNER JOin
		dbo.Ins_Shift sh on sh.ShiftId = sb.ShiftId INNER JOin
		dbo.Ins_ClassInfo c on c.ClassId = sb.ClassId Inner Join dbo.Res_SubjectSetup rss on rss.SubID =@SubjectId and rss.ClassId = sb.ClassId 
       Inner Join dbo.Res_Terms t on t.TermId =@TermId and t.ClassId = sb.ClassId
		
		WHERE   S.MainExamId=@MainExamId AND (S.MainExamSubjectID=@SubjectID)  and s.SubjectId=@SubjectId
		order by s.SubExamId

END

-- exec rptStudentListWithUniversalMarksEntry 1,12,1002,19,76,1,1002,14