IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ClassWiseResultProcessClear]'))
BEGIN
DROP PROCEDURE  dbo.ClassWiseResultProcessClear
END
GO
/****** Object:  StoredProcedure [dbo].[ClassWiseResultProcess]    Script Date: 5/21/2019 3:41:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC ClassWiseResultProcessClear 11,27,9,1030,109
Create Procedure [dbo].[ClassWiseResultProcessClear]
(
 @SessionId INT=NULL, 
 @ClassId    INT=NULL, 
 @TermId   INT=NULL, 
 @MainExamId   INT=NULL,
 @SectionId   INT=NULL
)
As
BEGIN
DECLARE @Count INT = 0

	SELECT SS.StudentID INTO #StuList 
	FROM Res_StudentSubject SS INNER JOIN dbo.Student_BasicInfo SB ON SB.StudentIID = SS.StudentID
	WHERE SB.SessionId = @SessionId AND SB.ClassId =  @ClassId AND SB.SectionId = @SectionId 

SELECT @Count = @@ROWCOUNT

PRINT @Count

 DELETE  FROM Res_MainExamResult 
    WHERE  MainExamID = @MainExamId AND StudentIID IN(SELECT * FROM #StuList)
	DROP TABLE #StuList
END

-- EXEC ClassWiseResultProcessClear 10,19,8,3039,200