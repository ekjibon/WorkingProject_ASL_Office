IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetPortalResultDetails]'))
BEGIN
DROP PROCEDURE  GetPortalResultDetails
END
GO
/****** Object:  StoredProcedure [dbo].[GetPortalResultDetails]    Script Date: 4/16/2019 1:14:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[GetPortalResultDetails]
(
@StudentId Int,
@ExamId Int
)
AS
Begin
Select RD.MainExamId,
       M.MainExamName,
       RS.SubjectName,
       RD.SubjectGP,
	    RD.SubjectConvertedMarks AS TotalMarks,
	   RD.SubjectHighestMark,
	  RD.SubjectGL,
	  MR.GPA,MR.GradeLetter
 From Res_MainExamResultSubjectDetails  RD 
Join [dbo].[Res_SubjectSetup] RS On RD.SubjectID = RS.SubID
 Join Res_MainExamResult MR On MR.MainExamId = RD.MainExamId and RD.StudentIID =MR.StudentIID
 INNER JOIN Res_MainExam M ON M.MainExamId = RD.MainExamId
  Where RD.StudentIID = @StudentId and RD.MainExamId = @ExamId 

    --Select GPA,GradeLetter From Res_MainExamResult Where StudentIID=@StudentId and MainExamId = @ExamId
End
--GetPortalResultDetails 77,29