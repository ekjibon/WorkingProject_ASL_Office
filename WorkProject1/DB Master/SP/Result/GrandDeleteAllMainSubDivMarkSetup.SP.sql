GO
/****** Object:  StoredProcedure [dbo].[GetAllExamMarkSubject]    Script Date: 7/22/2017 4:03:26 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GrandDeleteAllMainSubDivMarkSetup]'))
BEGIN
DROP PROCEDURE  GrandDeleteAllMainSubDivMarkSetup
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[GrandDeleteAllMainSubDivMarkSetup]
(
 @VersionId int,
 @SessionId int,
 @ClassId int,
 @GroupId int,
 @GrandExamId int
)
AS
BEGIN
	
	IF EXISTS(SELECT [MainExamId],[GrandExamId] FROM [Res_GrandConfig] WHERE [IsDeleted]=0 AND [GrandExamId]=@GrandExamId)
		BEGIN
			SELECT 'GRAND CONFIG EXISTS' AS FAIL_OR_SUCCESS
		END
	ELSE
		BEGIN
			UPDATE [dbo].Res_GrandDividedExamMarkSetup SET IsDeleted=1 WHERE SubExamMarkSetupId
			IN(SELECT GrandSubExamMarkSetupId FROM [dbo].[Res_GrandSubExamMarkSetup] WHERE GrandExamMarkSetupId 
			IN( SELECT GrandExamId FROM [Res_GrandExamMarkSetup] WHERE VersionID=@VersionId
			AND SessionId=@SessionId AND ClassId=@ClassId AND GroupId=@GroupId
			AND GrandExamId=@GrandExamId AND IsDeleted=0))

			UPDATE [dbo].[Res_GrandSubExamMarkSetup] SET IsDeleted=1  WHERE GrandExamMarkSetupId 
			IN( SELECT GrandExamMarkSetupId FROM [Res_GrandExamMarkSetup] WHERE VersionID=@VersionId
			AND SessionId=@SessionId AND ClassId=@ClassId AND GroupId=@GroupId
			AND GrandExamId=@GrandExamId AND IsDeleted=0)

			UPDATE [Res_GrandExamMarkSetup] SET IsDeleted=1  WHERE VersionID=@VersionId
			AND SessionId=@SessionId AND ClassId=@ClassId AND GroupId=@GroupId
			AND GrandExamId=@GrandExamId AND IsDeleted=0 
			SELECT @@ROWCOUNT AS FAIL_OR_SUCCESS
		END
END