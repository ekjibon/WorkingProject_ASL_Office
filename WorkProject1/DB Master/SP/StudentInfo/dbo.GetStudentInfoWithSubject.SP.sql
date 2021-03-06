/****** Object:  StoredProcedure [dbo].[GetStudentInfoForResult]    Script Date: 7/22/2017 4:19:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetStudentInfoWithSubject]'))
BEGIN
DROP PROCEDURE  GetStudentInfoWithSubject
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec GetStudentInfoWithSubject 10,9,5,31,123

CREATE PROCEDURE [dbo].[GetStudentInfoWithSubject] -- Total 7 param
	
	@SessionId INT = NULL,
	@BranchID INT = NULL,
	@ShiftID INT = NULL,
	@ClassId INT = NULL,
	@SectionId INT = NULL,
	@TermId int
	
AS
BEGIN
PRINT 'dfgdfg>>>>>>>>>>>>>'

		IF @SessionId = 0 SET @SessionId  = NULL
		IF @BranchID = 0 SET @BranchID  = NULL
		IF @ShiftID = 0 SET @ShiftID  = NULL
		IF @ClassId = 0 SET @ClassId  = NULL
	
		IF @SectionId = 0 SET @SectionId  = NULL
		
	
	SELECT        
		sb.StudentIID, sb.StudentInsID, sb.FullName,sb.RollNo,ss.SubjectID,SubSet.SubjectName
	FROM               
        
        dbo.Student_BasicInfo sb LEft join
[dbo].[Res_StudentSubject] SS on sb.StudentIID=ss.StudentID and SS.TermId=@TermId
left join [dbo].[Res_SubjectSetup] SubSet on ss.SubjectID=SubSet.SubID

       
		WHERE 			

			sb.SessionId = COALESCE(@SessionId,sb.SessionId) AND 
			sb.BranchID = COALESCE(@BranchID,sb.BranchID)AND
			sb.ShiftID = COALESCE(@ShiftID,sb.ShiftID)AND
			sb.ClassId = COALESCE(@ClassId,sb.ClassId)AND

			sb.SectionId = COALESCE(@SectionId,sb.SectionId) 
			 AND sb.IsDeleted=0
			 ORDER BY sb.FullName
END


--EXEC GetStudentInfoForResult
