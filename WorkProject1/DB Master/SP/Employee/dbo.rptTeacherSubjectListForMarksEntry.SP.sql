/****** Object:  StoredProcedure [dbo].[ProccessMainExam]    Script Date: 7/22/2017 4:28:51 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptTeacherSubjectListForMarksEntry]'))
BEGIN
DROP PROCEDURE  rptTeacherSubjectListForMarksEntry
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
CREATE PROCEDURE [dbo].[rptTeacherSubjectListForMarksEntry] 
(
	@VersionID int,
	@SessionID int,
	@BranchID int,
	@ShiftID int
	--@ClassID int,
	--@GroupID int,
	--@SectionID int
)
AS
BEGIN
	
SELECT V.[VersionName], V.[BranchName], V.[ClassName], V.[SessionName], V.[ShiftName], V.[GroupName], V.[SectionName],
	   E.EmpID, E.[FullName],S.[SubjectName],
	   VE.[MainExamName], VE.[SubExamName], VE.[DividedExamName]        
  FROM [dbo].[Res_AssignSubjectsToTeacher] AS A 
	   INNER JOIN [view_CommonTableNames] AS V ON A.VersionID=V.VersionId AND A.BranchID=V.BranchId AND A.ClassID=V.ClassId
	   AND A.SessionID=V.SessionId AND A.ShiftID=V.ShiftId AND A.GroupID=V.GroupId AND A.SectionID=V.SectionId
	   INNER JOIN Emp_BasicInfo AS E ON A.TeacherID=E.EmpBasicInfoID AND E.IsDeleted=0
	   INNER JOIN [vwMainExam] AS VE ON A.MainExamID=VE.MainExamId AND A.SubExamID=VE.SubExamId AND A.DivideExamID=VE.DividedExamId
	   INNER JOIN Res_SubjectSetup AS S ON A.SubjectID=S.SubID
	   WHERE A.VersionID=@VersionID AND A.SessionID=@SessionID AND A.BranchID=@BranchID
	   AND A.ShiftID=@ShiftID --AND A.ClassID=@ClassID AND A.GroupID=@GroupID AND A.SectionID=@SectionID
	   AND A.IsDeleted=0 ORDER BY A.[MainExamID], A.SubExamID, A.DivideExamID, A.[SubjectID]
END

---   GetTeacherSubjectForMarksEntry 3