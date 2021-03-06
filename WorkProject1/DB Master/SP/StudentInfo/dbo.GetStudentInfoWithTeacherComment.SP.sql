/****** Object:  StoredProcedure [dbo].[GetStudentInfoForResult]    Script Date: 7/22/2017 4:19:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetStudentInfoWithTeacherComment]'))
BEGIN
DROP PROCEDURE  GetStudentInfoWithTeacherComment
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec GetStudentInfoWithTeacherComment 11,9,5,29,117,1044,26

CREATE PROCEDURE [dbo].[GetStudentInfoWithTeacherComment] -- Total 7 param
	
	@SessionId INT = NULL,
	@BranchID INT = NULL,
	@ShiftID INT = NULL,
	@ClassId INT = NULL,
	@SectionId INT = NULL,
	@MainExamId INT = NULL,
	@TermId INT = NULL
	
	
AS
BEGIN

		IF @SessionId = 0 SET @SessionId  = NULL
		IF @BranchID = 0 SET @BranchID  = NULL
		IF @ShiftID = 0 SET @ShiftID  = NULL
		IF @ClassId = 0 SET @ClassId  = NULL
		IF @MainExamId = 0 SET @MainExamId  = NULL
		IF @SectionId = 0 SET @SectionId  = NULL
		IF @TermId = 0 SET @TermId  = NULL
IF(@ClassId=19 OR @ClassId=20)
	BEGIN
			SELECT  sb.StudentIID,sb.StudentInsID,  sb.FullName,sb.RollNo,me.FailSubComments, me.TeacherComments,me.HeadTeacherComments,me.COComments,me.MainExamId,
			me.ReportGLComments,me.Id,
			'' GPA,'' GradeLetter,'' TotalMark
			FROM               
        
			dbo.Student_BasicInfo sb
			LEFT join dbo.Res_ClassResultComments me on me.StudentId = sb.StudentIID and me.MainExamId=@MainExamId and me.TermId=@TermId
			WHERE 			

			sb.SessionId = COALESCE(@SessionId,sb.SessionId)  
			AND sb.BranchID = COALESCE(@BranchID,sb.BranchID)
			AND sb.ShiftID = COALESCE(@ShiftID,sb.ShiftID)
			--AND ac.MainExamId=COALESCE(@MainExamId,ac.MainExamId) 
			
			--me.MainExamId=@MainExamId AND
			AND sb.SectionId = COALESCE(@SectionId,sb.SectionId) 

			AND sb.IsDeleted=0 AND sb.[Status] = 'A'
			ORDER BY  sb.FullName  ASC
			--ORDER BY  CAST(sb.RollNo AS INT)  ASC
	END
	ELSE
	BEGIN
			SELECT  sb.StudentIID,sb.StudentInsID,  sb.FullName,sb.RollNo,me.FailSubComments, me.TeacherComments,me.HeadTeacherComments,me.COComments,me.MainExamId,
			me.ReportGLComments,me.Id,
			ac.GPA,ac.GradeLetter,(select ROUND(TotalWithECAPercent,0) from dbo.Res_MainExamResult WHERE StudentIID = sb.StudentIID AND MainExamId = @MainExamId)
			as TotalMark
			FROM               
        
			dbo.Student_BasicInfo sb 
			INNER join dbo.Res_MainExamResult ac on ac.StudentIID=sb.StudentIID  
			LEFT join dbo.Res_ClassResultComments me on me.StudentId = ac.StudentIID and me.MainExamId=@MainExamId and me.TermId=@TermId
			WHERE 			

			sb.SessionId = COALESCE(@SessionId,sb.SessionId)  
			AND sb.BranchID = COALESCE(@BranchID,sb.BranchID)
			AND sb.ShiftID = COALESCE(@ShiftID,sb.ShiftID)
			AND ac.MainExamId=COALESCE(@MainExamId,ac.MainExamId) 
			
			--me.MainExamId=@MainExamId AND
			AND sb.SectionId = COALESCE(@SectionId,sb.SectionId) 

			AND sb.IsDeleted=0 AND sb.[Status] = 'A'
			ORDER BY  sb.FullName  ASC
	END
	


END


--EXEC GetStudentInfoForResult
