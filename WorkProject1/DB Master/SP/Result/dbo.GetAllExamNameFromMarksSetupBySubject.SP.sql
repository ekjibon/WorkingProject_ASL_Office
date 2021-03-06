/****** Object:  StoredProcedure [dbo].[SP_GetEmpAllInfo]    Script Date: 11/18/2017 6:37:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAllExamNameFromMarksSetupBySubject]'))
BEGIN
DROP PROCEDURE  [GetAllExamNameFromMarksSetupBySubject]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[GetAllExamNameFromMarksSetupBySubject] -- EXEC GetAllExamNameFromMarksSetupBySubject 1005, 1002
(
@MainExamId int ,
@SubjectId int
)
As
Begin
SELECT M.MainExamName,S.SubExamName,D.DividedExamName,D.DividedExamId,Q.DividedExamFullMarks,Q.DividedExamExamMarks,Q.DividedExamPassMarks FROM [dbo].[Qry_MarkSetup] Q
	INNER JOIN Res_MainExam M ON M.MainExamId = Q.MainExamId
	INNER JOIN Res_SubExam S ON S.SubExamId =  Q.SubExamId
	INNER JOIN Res_DividedExam D ON D.DividedExamId =  Q.DividedExamId
 WHERE Q.MainExamId = @MainExamId AND Q.MainExamSubjectID = @SubjectId AND Q.DIsDeleted = 0 
End

