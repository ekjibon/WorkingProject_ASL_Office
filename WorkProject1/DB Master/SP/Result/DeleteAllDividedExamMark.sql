
GO
/****** Object:  StoredProcedure [dbo].[GetAllExamMarkSubject]    Script Date: 7/22/2017 4:03:26 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DeleteAllDividedExamMark]'))
BEGIN
DROP PROCEDURE  DeleteAllDividedExamMark
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[DeleteAllDividedExamMark]
(
 @SubExamMarkSetupId int,
 @SubExamId int,
 @MainExamId int,
 @SubjectId int
 )
 AS
BEGIN
IF EXISTS(SELECT MarksId FROM Res_MainExamMarks WHERE SubExamID=@SubExamId AND MainExamID=@MainExamId AND SubjectID=@SubjectId AND IsDeleted=0)
BEGIN
SELECT @@ROWCOUNT,'MARKS EXISTS' AS FAIL_OR_SUCCESS
END
ELSE
BEGIN
UPDATE Res_DividedExamMarkSetup SET IsDeleted=1  WHERE SubExamMarkSetupId = @SubExamMarkSetupId AND IsDeleted=0 
SELECT @@ROWCOUNT AS FAIL_OR_SUCCESS
END
END
