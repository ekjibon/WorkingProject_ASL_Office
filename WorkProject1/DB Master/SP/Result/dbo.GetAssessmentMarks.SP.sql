/****** Object:  StoredProcedure [dbo].[ProccessMarks]    Script Date: 7/22/2017 4:26:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAssessmentMarks]'))
BEGIN
DROP PROCEDURE  GetAssessmentMarks
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --@EmpBasicInfoID int, @MainExamID int=3, @SubExamID int=4, 
--execute AssignSubjectToTeacher 14,10,35

CREATE PROCEDURE GetAssessmentMarks
(
@GrandExamId int,
@SubjectId int,
@version int,
@session int,
@branch int,
@shift int,
@classid int,
@groupid int,
@section int
)
AS
BEGIN
	DECLARE @SUBNAME VARCHAR(150) 
	SELECT @SUBNAME=ISNULL([SubjectName],'') FROM [dbo].[Res_AssessmentSubject] WHERE AId=@SubjectId
		               SELECT
	       					  ISNULL(A.ID,0) AS  ID,
                              B.VersionID,
                              B.SessionID,
                              B.BranchID,
                              B.ShiftID,
                              B.ClassID,
                              B.GroupID,
                              B.SectionID,
                              @GrandExamId AS GrandExamId,
                              B.StudentIID AS StudentID,
                              B.StudentInsID,
                              B.RollNo,
                              B.FullName,
                              @SubjectId AS SubjectId,
                              @SUBNAME AS SubjectName,
                              ISNULL(A.HandWriting,0) AS HandWriting,
                              ISNULL(A.PicReading,0) AS PicReading,
                              ISNULL(A.Recitation,0) AS Recitation,
                              ISNULL(A.[Conversation],0) AS [Conversation],
                              ISNULL(A.ColourSense,0) AS ColourSense,
                              ISNULL(A.Art,0) AS Art,
                              ISNULL(A.Music,0) AS Music,
                              ISNULL(A.ParticipationInGames,0) AS ParticipationInGames,
                              ISNULL(A.Obedience,0) AS Obedience,
                              ISNULL(A.Tolerance,0) AS Tolerance,
                              ISNULL(A.SelfReliance,0) AS SelfReliance,
                              ISNULL(A.Leadership,0) AS Leadership,
                              ISNULL(A.Interaction_with_Teachers_and_Peers,0) AS Interaction_with_Teachers_and_Peers,
                              ISNULL(A.IsDeleted,0) AS IsDeleted                         
							  FROM  [Student_BasicInfo] AS B LEFT JOIN [Res_GrandStudentAssessment] AS A ON B.StudentIID=A.StudentID 
							  AND A.GrandExamId = @GrandExamId AND A.SubjectId = @SubjectId
							  AND A.VersionID = @version AND A.SessionID = @session AND
							  A.BranchID = @branch AND A.ShiftID = @shift AND  A.ClassID = @classid
                              AND A.GroupID = @groupid AND  A.SectionID = @section AND A.IsDeleted = 0 
							  WHERE B.VersionID = @version AND B.SessionID = @session AND
							  B.BranchID = @branch AND B.ShiftID = @shift AND  B.ClassID = @classid
                              AND B.GroupID = @groupid AND  B.SectionID = @section AND B.IsDeleted = 0
							  ORDER BY  B.RollNo
							

END
   --  GetAssessmentMarks 92,1,1,6,1,1,7,0,23
	