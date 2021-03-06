/****** Object:  StoredProcedure [dbo].[GetStudentInfoForResult]    Script Date: 7/22/2017 4:19:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetStudentInfoWithClassWiseAssesment]'))
BEGIN
DROP PROCEDURE  GetStudentInfoWithClassWiseAssesment
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec GetStudentInfoWithClassWiseAssesment 9,27,11,5,108,1059,51

CREATE PROCEDURE [dbo].[GetStudentInfoWithClassWiseAssesment] -- Total 7 param
	@BranchId INT=null,
	@ClassId INT = NULL,
	@SessionId INT =NULL,
	@ShiftId INT =NULL,
	@SectionId INT = NULL,
	@MainExamId INT = NULL,
	@TermId INT =NULL
	
   AS
BEGIN
		IF @BranchId = 0 SET @BranchId  = NULL
		IF @ClassId = 0 SET @ClassId  = NULL
		IF @SessionId = 0 SET @SessionId  = NULL
		IF @ShiftId = 0 SET @ShiftId  = NULL
		IF @SectionId = 0 SET @SectionId  = NULL
		IF @MainExamId = 0 SET @MainExamId  = NULL
		

	--
	SELECT        
		sb.StudentIID, sb.StudentInsID,sb.FullName,mr.GPA,mr.GradeLetter,ACS.[Order] AS AssOrder --,(SELECT FROM )
		,
		(select ROUND(TotalWithECAPercent,0) from dbo.Res_MainExamResult WHERE StudentIID = sb.StudentIID AND MainExamId = @MainExamId)
		 as TotalMark, AC.MainExamId,
		AC.AssesmentClassId,Ac.Comments,AC.Grade,AC.Academic,
		AC.Behaviroul,AC.Id as AssesmentClassWiseId
	FROM                    
        dbo.Student_BasicInfo sb LEFT JOIN 
		dbo.Res_MainExamResult mr on mr.StudentIID=sb.StudentIID AND mr.MainExamId=@MainExamId
		LEFT JOIN  [dbo].[Res_AssessmentClassStudent] AC on sb.StudentIID=AC.StudentId and AC.MainExamId=@MainExamId 
		LEFT JOIN Res_AssessmentClassSetUp ACS on mr.MainExamId=ACS.MainExamId and ACS.TermId=@TermId and AC.AssesmentClassId=ACS.ClassId

		WHERE 			
			sb.SessionId = COALESCE(@SessionId,sb.SessionId) AND 
			sb.BranchID = COALESCE(@BranchID,sb.BranchID)AND
			sb.ShiftID = COALESCE(@ShiftId,sb.ShiftID)AND
			sb.ClassId = COALESCE(@ClassId,sb.ClassId)AND
			sb.SectionId = COALESCE(@SectionId,sb.SectionId) 

			 AND sb.IsDeleted=0 AND sb.[Status] = 'A' 
			 
		ORDER BY  ACS.[Order], CAST(sb.RollNo AS INT)  ASC

END


--EXEC GetStudentInfoForResult
