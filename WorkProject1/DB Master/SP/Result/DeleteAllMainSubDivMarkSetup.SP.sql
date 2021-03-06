GO
/****** Object:  StoredProcedure [dbo].[GetAllExamMarkSubject]    Script Date: 7/22/2017 4:03:26 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DeleteAllMainSubDivMarkSetup]'))
BEGIN
DROP PROCEDURE  DeleteAllMainSubDivMarkSetup
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[DeleteAllMainSubDivMarkSetup]
(
 @SessionId int,
 @ClassId int,
 @TermId int,
 @MainExamId int
)
AS
BEGIN
	--IF EXISTS(SELECT MarksId FROM Res_MainExamMarks WHERE VersionID=@VersionId
	--AND SessionId=@SessionId AND ClassId=@ClassId AND GroupId=@GroupId
	--AND MainExamId=@MainExamId AND IsDeleted=0)
	--	BEGIN
	--		SELECT 'MARKS EXISTS' AS FAIL_OR_SUCCESS
	--	END
	--ELSE
	--	BEGIN
			

			UPDATE [dbo].[Res_SubExamMarkSetup] SET IsDeleted=1  WHERE [MainExamMarkSetupId] 
			IN( SELECT Id FROM Res_MainExamMarkSetup WHERE SessionId=@SessionId AND ClassId=@ClassId 
			AND TermId=@TermId
			AND MainExamId=@MainExamId AND IsDeleted=0)

			UPDATE Res_MainExamMarkSetup SET IsDeleted=1  WHERE 
			 SessionId=@SessionId AND ClassId=@ClassId AND TermId=@TermId
			AND MainExamId=@MainExamId AND IsDeleted=0 
			SELECT @@ROWCOUNT AS FAIL_OR_SUCCESS
    --  END
END