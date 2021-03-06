GO
/****** Object:  StoredProcedure [dbo].[GetAllExamMarkSubject]    Script Date: 7/22/2017 4:03:26 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DeleteAllExamMarkSubject]'))
BEGIN
DROP PROCEDURE  DeleteAllExamMarkSubject
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[DeleteAllExamMarkSubject]
(
 @SessionId int,
 @ClassId int,
 @TermId int,
 @MainExamId int
)
AS
BEGIN
	IF EXISTS(SELECT MarksId FROM Res_MainExamMarks WHERE 
	 SessionId=@SessionId AND ClassId=@ClassId 
	AND MainExamId=@MainExamId AND IsDeleted=0)
		BEGIN
			SELECT 'MARKS EXISTS' AS FAIL_OR_SUCCESS
		END
	ELSE
		BEGIN
			IF EXISTS(SELECT Id FROM [dbo].[Res_SubExamMarkSetup] WHERE [MainExamMarkSetupId] 
			IN( SELECT Id FROM Res_MainExamMarkSetup WHERE  SessionId=@SessionId AND ClassId=@ClassId 
			AND MainExamId=@MainExamId AND IsDeleted=0))
				BEGIN
					SELECT 'SUB EXAM MARK SETUP EXISTS' AS FAIL_OR_SUCCESS
				END
			ELSE
				BEGIN
					UPDATE Res_MainExamMarkSetup SET IsDeleted=1  WHERE 
					 SessionId=@SessionId AND ClassId=@ClassId 
					AND MainExamId=@MainExamId AND IsDeleted=0 
					SELECT @@ROWCOUNT AS FAIL_OR_SUCCESS
				END
		END
END