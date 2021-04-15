
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetSubjectWiseCommentsList_33]'))
BEGIN
DROP PROCEDURE  GetSubjectWiseCommentsList_33
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetSubjectWiseCommentsList_33]  
	
	-- GetSubjectWiseCommentsList_33  8,11,3,20,83,17,1035,132

	@BranchID INT,
	@SessionId INT,
	@ShiftID INT,
	@ClassId INT,
	@SectionId INT = NULL,
	@TermId INT,
	@MainExamId INT,
	@SubjectId INT

AS
BEGIN
    SELECT distinct MED.[SubjectID], sb.StudentIID,sb.RollNo,sb.FullName, sb.StudentInsID,[ResultSubjectDetailsId]
      ,ME.[MainExamId] ,swc.Comments,swc.Id
      ,[SubjectObtMarks]
      ,[SubjectConvertedMarks]
      ,[SubjectConvertedMarksFraction]
      ,[SubjectGP]
      ,[SubjectGL]
      ,[SubjectHighestMark]
      ,[SubjectIsPass]
      ,[SubjectIsAbsent]
      ,[TotalExamNo]
      ,MED.[IsECA]
      ,[AutumnMarks]
      ,[MidYearSubObtMarks]
      ,[MidYearSubConvtMarks]
      ,[WinterMarks]
	  ,MainExamName
	  ,SessionName
	  ,ClassName
	  ,BranchName
	  ,ShiftName
	  ,RSS.BranchId
	  ,ME.SessionId
	  ,ME.ClassId
	  ,sh.ShiftId
	  ,ME.TermId
	  ,SEC.SectionId
	  ,SEC.SectionName
  FROM [dbo].[Res_MainExamResultSubjectDetails] MED
  INNER JOIN dbo.Student_BasicInfo SB ON SB.StudentIID=MED.StudentIID
  INNER JOIN [dbo].[Res_MainExam] ME ON ME.MainExamId=MED.MainExamId
  
  INNER JOIN [dbo].[Ins_Session] S ON S.SessionId=ME.SessionId
  INNER JOIN [dbo].[Ins_ClassInfo] C ON C.ClassId=ME.ClassId
  INNER JOIN [dbo].[Res_StudentSubject] RSS ON RSS.SubjectID=MED.SubjectID
  INNER JOIN [dbo].[Res_SubjectSetup] SS ON SS.SubID=MED.SubjectID
  LEFT OUTER JOIN dbo.Res_SubjectWiseComment swc on swc.StudentId = sb.StudentIID  and swc.IsDeleted=0 and ss.SubID= SWC.SubjectId and swc.TermId=@TermId 
  INNER JOIN [dbo].[Ins_Branch] B ON B.BranchId=RSS.BranchId
  INNER JOIN [dbo].[Ins_Shift] SH ON SH.BranchId=B.BranchId
  INNER JOIN [dbo].[Ins_Section] SEC ON SEC.ClassId=C.ClassId
  where ME.TermId=@TermId and MED.MainExamId=@MainExamId 
		and MED.SubjectID=@SubjectId and  ME.SessionId=@SessionId 
		and ME.ClassId=@ClassId and RSS.BranchId=@BranchID 
		and SH.ShiftId=@ShiftID AND (SEC.SectionId=@SectionId OR SEC.SectionId IS NULL) 
		and SB.SectionId =@SectionId
  --where ME.TermId=42 and MED.MainExamId=2034 and MED.SubjectID=134 and  ME.SessionId=10 and ME.ClassId=23 and RSS.BranchId=8 and SH.ShiftId=2 AND (SEC.SectionId=92 OR SEC.SectionId IS NULL)
    --ORDER BY 	MED.[SubjectID], sb.StudentIID,sb.RollNo
	-- SELECT * FROM [Res_StudentSubject]
END 
		
		