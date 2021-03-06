/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ResultView]'))
BEGIN
DROP VIEW  ResultView
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ResultView]
AS
SELECT        dbo.Res_MainExamResult.MainExamId, dbo.Res_MainExamResult.StudentIID, dbo.Res_MainExamResultSubjectDetails.SubjectID, dbo.Res_SubjectSetup.SubjectName, dbo.Res_MainExamResult.TotalMarks, 
                         dbo.Res_MainExamResult.GPA, dbo.Res_MainExamResult.GPAWithOut4Sub, dbo.Res_MainExamResult.GradeLetter, dbo.Res_MainExamResult.IsPass, dbo.Res_MainExamResult.OverAllMerit, 
                         dbo.Res_MainExamResult.SectionWiseMerit, dbo.Res_MainExamResult.ShiftWiseMerit, dbo.Res_MainExamResult.ClassWiseMerit, dbo.Res_MainExamResult.TotalConvertedMarks, 
                         dbo.Res_MainExamResult.TotalConvertedMarksFraction, dbo.Res_MainExamResult.FailStudentGPA, dbo.Res_MainExamResult.TotalGP, dbo.Res_MainExamResult.TotalGPWithOut4Sub, 
                         dbo.Res_MainExamResultSubjectDetails.SubjectObtMarks, dbo.Res_MainExamResultSubjectDetails.SubjectConvertedMarks, dbo.Res_MainExamResultSubjectDetails.SubjectConvertedMarksFraction, 
                         dbo.Res_MainExamResultSubjectDetails.SubjectGP, dbo.Res_MainExamResultSubjectDetails.SubjectGL, dbo.Res_MainExamResultSubjectDetails.SubjectHighestMark, dbo.Res_MainExamResultSubjectDetails.SubjectIsPass, 
                         dbo.Res_MainExamResultSubjectDetails.SubjectIsAbsent, dbo.Res_MainExamResultSubjectDetails.VirtualConvertedMarks1, dbo.Res_MainExamResultSubjectDetails.VirtualConvertedMarks2, 
                         dbo.Res_MEResultDetails.SubExamTotalObt, dbo.Res_MEResultDetails.SubExamTotalConv, dbo.Res_MEResultDetails.SubExamTotalFrac, dbo.Res_MEResultDetails.WrittenObt1, dbo.Res_MEResultDetails.WrittenConv1, 
                         dbo.Res_MEResultDetails.WrittenFrac1, dbo.Res_MEResultDetails.SubExamIsPass, dbo.Res_MEResultDetails.SubExamIsAbsent, dbo.Res_MEResultDetails.WrittenIsPass1, dbo.Res_MEResultDetails.WrittenIsAbsent1, 
                         dbo.Res_MEResultDetails.WrittenObt2, dbo.Res_MEResultDetails.WrittenConv2, dbo.Res_MEResultDetails.WrittenFrac2, dbo.Res_MEResultDetails.WrittenIsPass2, dbo.Res_MEResultDetails.WrittenIsAbsent2, 
                         dbo.Res_MEResultDetails.WrittenObt3, dbo.Res_MEResultDetails.WrittenConv3, dbo.Res_MEResultDetails.WrittenFrac3, dbo.Res_MEResultDetails.WrittenIsPass3, dbo.Res_MEResultDetails.WrittenIsAbsent3, 
                         dbo.Res_MEResultDetails.SubjectiveObt, dbo.Res_MEResultDetails.SubjectiveConv, dbo.Res_MEResultDetails.SubjectiveFrac, dbo.Res_MEResultDetails.SubjectiveIsPass, dbo.Res_MEResultDetails.SubjectiveIsAbsent, 
                         dbo.Res_MEResultDetails.ObjectiveObt, dbo.Res_MEResultDetails.ObjectiveConv, dbo.Res_MEResultDetails.ObjectiveFrac, dbo.Res_MEResultDetails.ObjectiveIsPass, dbo.Res_MEResultDetails.ObjectiveIsAbsent, 
                         dbo.Res_MEResultDetails.PracticalObt, dbo.Res_MEResultDetails.PracticalConv, dbo.Res_MEResultDetails.PracticalFrac, dbo.Res_MEResultDetails.PracticalIsPass, dbo.Res_MEResultDetails.PracticalIsAbsent, 
                         dbo.Res_SubjectSetup.ReportSerialNo, dbo.Res_MEResultDetails.SubExamId
						 ,dbo.Res_MEResultDetails.SOPTotalObt , dbo.Res_MEResultDetails.SOPTotalConv,dbo.Res_MEResultDetails.SOPTotalFrac
FROM            dbo.Res_MainExamResult INNER JOIN
                         dbo.Res_MainExamResultSubjectDetails ON dbo.Res_MainExamResult.StudentIID = dbo.Res_MainExamResultSubjectDetails.StudentIID AND 
                         dbo.Res_MainExamResult.MainExamId = dbo.Res_MainExamResultSubjectDetails.MainExamId INNER JOIN
                         dbo.Res_SubjectSetup ON dbo.Res_MainExamResultSubjectDetails.SubjectID = dbo.Res_SubjectSetup.SubID INNER JOIN
                         dbo.Res_MEResultDetails ON dbo.Res_MEResultDetails.MainExamId = dbo.Res_MainExamResultSubjectDetails.MainExamId AND 
                         dbo.Res_MEResultDetails.StudentIID = dbo.Res_MainExamResultSubjectDetails.StudentIID AND dbo.Res_MEResultDetails.SubjectID = dbo.Res_MainExamResultSubjectDetails.SubjectID
GO