IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SubjectWiseResultProcessClear]'))
BEGIN
DROP PROCEDURE  SubjectWiseResultProcessClear
END
GO
/****** Object:  StoredProcedure [dbo].[SubjectWiseResultProcess]    Script Date: 5/21/2019 3:43:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC SubjectWiseResultProcessClear 11,27,9,1030,36,109
Create Procedure [dbo].[SubjectWiseResultProcessClear]
(
	 @SessionId INT=NULL, 
	 @ClassId    INT=NULL, 
	 @TermId   INT=NULL, 
	 @MainExamId   INT=NULL,
	 @SubjectId   INT=NULL,
	 @SectionId   INT=NULL
)
As
BEGIN

SELECT StudentID INTO #StuList 
FROM Res_StudentSubject S INNER JOIN dbo.Student_BasicInfo SB ON SB.StudentIID = S.StudentID
WHERE S.SessionId = @SessionId AND S.ClassId =  @ClassId AND S.SubjectID = @SubjectId AND SB.SectionId = @SectionId
	--SELECT * FROM #StuList
	IF(EXISTS( SELECT * FROM dbo.Res_MainExamResultSubjectDetails WHERE MainExamID = @MainExamId AND SubjectID = @SubjectId AND StudentIID IN (SELECT * FROM #StuList)))  
																												-- Single Class e Multiple Sub thakle 
	BEGIN
	 RAISERROR ('Class Wise Process Already ', -- Message text.
				   16, -- Severity.
				   1 -- State.
				   );
	END

	DELETE  FROM [dbo].[Res_MERSubExamResult] 
	WHERE SubjectID  = @SubjectId AND MainExamID = @MainExamId AND StudentIID IN (SELECT * FROM #StuList) 

	DROP TABLE #StuList
END
