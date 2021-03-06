
GO
/****** Object:  StoredProcedure [dbo].[GetAllExamMarkSubject]    Script Date: 7/22/2017 4:03:26 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DeleteAllSubExamMark]'))
BEGIN
DROP PROCEDURE  DeleteAllSubExamMark
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[DeleteAllSubExamMark]
(
 @MainExamMarkSetupId INT,
 @MainExamId INT,
 @SubexamID INT,
 @SubjectID INT
 )
 AS
BEGIN
	IF EXISTS(SELECT MarksId FROM Res_MainExamMarks WHERE MainExamId=@MainExamId AND SubExamID=@SubexamID AND SubjectID=@SubjectID  AND IsDeleted=0)
		BEGIN
			SELECT 'MARKS EXISTS' AS FAIL_OR_SUCCESS
		END
	ELSE
		BEGIN
		     IF EXISTS(SELECT [SubExamMarkSetupId]  FROM [Res_DividedExamMarkSetup] WHERE [SubExamMarkSetupId] IN 
			 (SELECT Id FROM Res_SubExamMarkSetup WHERE MainExamMarkSetupId = @MainExamMarkSetupId))
				BEGIN
					SELECT 'DIVIDED EXAM MARK SETUP EXISTS' AS FAIL_OR_SUCCESS
				END
			 ELSE
				BEGIN
					UPDATE Res_SubExamMarkSetup SET IsDeleted=1  WHERE MainExamMarkSetupId = @MainExamMarkSetupId AND IsDeleted=0 
				    SELECT @@ROWCOUNT AS FAIL_OR_SUCCESS		
				END				
		END
END


--select [MainExamMarkSetupId], Id from [dbo].[Res_SubExamMarkSetup] where [MainExamMarkSetupId]=161

---  GetAllExamMarkSubject 1,5,15,1,129