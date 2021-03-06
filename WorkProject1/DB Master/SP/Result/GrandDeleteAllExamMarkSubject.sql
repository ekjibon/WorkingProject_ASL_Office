
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'GrandDeleteAllExamMarkSubject'))
BEGIN
DROP PROCEDURE  GrandDeleteAllExamMarkSubject
END
GO
CREATE PROCEDURE [dbo].[GrandDeleteAllExamMarkSubject]
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
			SELECT 'MARKS EXISTS' AS FAIL_OR_SUCCESS
		END
	ELSE
		BEGIN
			IF EXISTS(SELECT GrandSubExamMarkSetupId FROM [dbo].Res_GrandSubExamMarkSetup WHERE [GrandExamMarkSetupId] 
			IN( SELECT GrandExamMarkSetupId FROM Res_GrandExamMarkSetup WHERE VersionID=@VersionId
			AND SessionId=@SessionId AND ClassId=@ClassId AND GroupId=@GroupId
			AND GrandExamId=@GrandExamId AND IsDeleted=0))
				BEGIN
					SELECT 'SUB EXAM MARK SETUP EXISTS' AS FAIL_OR_SUCCESS
				END
			ELSE
				BEGIN
					UPDATE Res_GrandExamMarkSetup SET IsDeleted=1  WHERE VersionID=@VersionId
					AND SessionId=@SessionId AND ClassId=@ClassId AND GroupId=@GroupId
					AND GrandExamId=@GrandExamId AND IsDeleted=0 
					UPDATE dbo.Res_GrandSubExamMarkSetup SET IsDeleted=1  WHERE GrandExamMarkSetupId in (select GrandExamMarkSetupId from  Res_GrandExamMarkSetup WHERE VersionID=@VersionId
					AND SessionId=@SessionId AND ClassId=@ClassId AND GroupId=@GroupId
					AND GrandExamId=@GrandExamId AND IsDeleted=0 )

					UPDATE dbo.Res_GrandDividedExamMarkSetup SET IsDeleted=1  
					WHERE SubExamMarkSetupId in ( select * from dbo.Res_GrandSubExamMarkSetup where GrandSubExamMarkSetupId in 
					 (select GrandExamMarkSetupId from  Res_GrandExamMarkSetup WHERE VersionID=@VersionId
					AND SessionId=@SessionId AND ClassId=@ClassId AND GroupId=@GroupId
					AND GrandExamId=@GrandExamId AND IsDeleted=0 ))

					SELECT @@ROWCOUNT AS FAIL_OR_SUCCESS
				END
		END
END
