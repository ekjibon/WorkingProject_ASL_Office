/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Grand_ResultView]'))
BEGIN
DROP VIEW  Grand_ResultView
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Grand_ResultView]
AS
SELECT        dbo.Res_GrandResult.GrandExamId, dbo.Res_GrandResult.StudentIID, dbo.Res_GrandResultSubjectDetails.SubjectID, dbo.Res_SubjectSetup.SubjectName, dbo.Res_GrandResult.TotalMarks, 
                         dbo.Res_GrandResult.GPA, dbo.Res_GrandResult.GPAWithOut4Sub, dbo.Res_GrandResult.GradeLetter, dbo.Res_GrandResult.IsPass, dbo.Res_GrandResult.OverAllMerit, 
                         dbo.Res_GrandResult.SectionWiseMerit, dbo.Res_GrandResult.ShiftWiseMerit, dbo.Res_GrandResult.ClassWiseMerit, dbo.Res_GrandResult.TotalConvertedMarks, 
                         dbo.Res_GrandResult.TotalConvertedMarksFraction, dbo.Res_GrandResult.FailStudentGPA, dbo.Res_GrandResult.TotalGP, dbo.Res_GrandResult.TotalGPWithOut4Sub, 
                         dbo.Res_GrandResultSubjectDetails.SubjectObtMarks, dbo.Res_GrandResultSubjectDetails.SubjectConvertedMarks, dbo.Res_GrandResultSubjectDetails.SubjectConvertedMarksFraction, 
                         dbo.Res_GrandResultSubjectDetails.SubjectGP, dbo.Res_GrandResultSubjectDetails.SubjectGL, dbo.Res_GrandResultSubjectDetails.SubjectHighestMark, dbo.Res_GrandResultSubjectDetails.SubjectIsPass, 
                         dbo.Res_GrandResultSubjectDetails.SubjectIsAbsent, dbo.Res_GrandResultSubjectDetails.VirtualConvertedMarks1, dbo.Res_GrandResultSubjectDetails.VirtualConvertedMarks2, 
                         dbo.Res_GrandResultMarksDetails.SubExamTotalObt, dbo.Res_GrandResultMarksDetails.SubExamTotalConv, dbo.Res_GrandResultMarksDetails.SubExamTotalFrac, dbo.Res_GrandResultMarksDetails.WrittenObt1, dbo.Res_GrandResultMarksDetails.WrittenConv1, 
                         dbo.Res_GrandResultMarksDetails.WrittenFrac1, dbo.Res_GrandResultMarksDetails.SubExamIsPass, dbo.Res_GrandResultMarksDetails.SubExamIsAbsent, dbo.Res_GrandResultMarksDetails.WrittenIsPass1, dbo.Res_GrandResultMarksDetails.WrittenIsAbsent1, 
                         dbo.Res_GrandResultMarksDetails.WrittenObt2, dbo.Res_GrandResultMarksDetails.WrittenConv2, dbo.Res_GrandResultMarksDetails.WrittenFrac2, dbo.Res_GrandResultMarksDetails.WrittenIsPass2, dbo.Res_GrandResultMarksDetails.WrittenIsAbsent2, 
                         dbo.Res_GrandResultMarksDetails.WrittenObt3, dbo.Res_GrandResultMarksDetails.WrittenConv3, dbo.Res_GrandResultMarksDetails.WrittenFrac3, dbo.Res_GrandResultMarksDetails.WrittenIsPass3, dbo.Res_GrandResultMarksDetails.WrittenIsAbsent3, 
                         dbo.Res_GrandResultMarksDetails.SubjectiveObt, dbo.Res_GrandResultMarksDetails.SubjectiveConv, dbo.Res_GrandResultMarksDetails.SubjectiveFrac, dbo.Res_GrandResultMarksDetails.SubjectiveIsPass, dbo.Res_GrandResultMarksDetails.SubjectiveIsAbsent, 
                         dbo.Res_GrandResultMarksDetails.ObjectiveObt, dbo.Res_GrandResultMarksDetails.ObjectiveConv, dbo.Res_GrandResultMarksDetails.ObjectiveFrac, dbo.Res_GrandResultMarksDetails.ObjectiveIsPass, dbo.Res_GrandResultMarksDetails.ObjectiveIsAbsent, 
                         dbo.Res_GrandResultMarksDetails.PracticalObt, dbo.Res_GrandResultMarksDetails.PracticalConv, dbo.Res_GrandResultMarksDetails.PracticalFrac, dbo.Res_GrandResultMarksDetails.PracticalIsPass, dbo.Res_GrandResultMarksDetails.PracticalIsAbsent, 
                         dbo.Res_SubjectSetup.ReportSerialNo, dbo.Res_GrandResultMarksDetails.GrandSubExamId
FROM            dbo.Res_GrandResult INNER JOIN
                         dbo.Res_GrandResultSubjectDetails ON dbo.Res_GrandResult.StudentIID = dbo.Res_GrandResultSubjectDetails.StudentIID AND 
                         dbo.Res_GrandResult.GrandExamId = dbo.Res_GrandResultSubjectDetails.GrandExamId INNER JOIN
                         dbo.Res_SubjectSetup ON dbo.Res_GrandResultSubjectDetails.SubjectID = dbo.Res_SubjectSetup.SubID INNER JOIN
                         dbo.Res_GrandResultMarksDetails ON dbo.Res_GrandResultMarksDetails.GrandExamId = dbo.Res_GrandResultSubjectDetails.GrandExamId AND 
                         dbo.Res_GrandResultMarksDetails.StudentIID = dbo.Res_GrandResultSubjectDetails.StudentIID AND dbo.Res_GrandResultMarksDetails.SubjectID = dbo.Res_GrandResultSubjectDetails.SubjectID
GO