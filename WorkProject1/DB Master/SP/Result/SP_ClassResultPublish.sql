/****** Object:  StoredProcedure [dbo].[SP_ClassResultPublish]    Script Date: 7/16/2020 12:26:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_ClassResultPublish]'))
BEGIN
DROP PROCEDURE  SP_ClassResultPublish
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- execute SP_ClassResultPublish 19,4414,1061
CREATE PROCEDURE [dbo].[SP_ClassResultPublish]  
	(
	@ClassId INT ,
	@StudentIID INT,
	@MainExamId INT = 0
	)
AS
BEGIN
DECLARE  @Count INT = 0;

	IF(@ClassId=19 OR @ClassId=20)
	BEGIN
	SET @Count = ISNULL((SELECT COUNT(StudentIID) FROM  dbo.Res_MainExamResult  WHERE MainExamId = @MainExamId AND StudentIID = @StudentIID),0)
		IF(@Count>0)
		BEGIN
		UPDATE dbo.Res_MainExamResult SET [IsPublished] = 1 WHERE MainExamId = @MainExamId AND StudentIID = @StudentIID
		END
		ELSE
		BEGIN
		INSERT INTO dbo.Res_MainExamResult(MainExamId,StudentIID,IsPublished,TotalWithECA,TotalWithOutECA,GPA,TotalWithECAPercent,TotalWithOutECAPercent)
		VALUES(@MainExamId,@StudentIID,1,0,0,0,0,0)
		END
	
	END
	ELSE
	BEGIN
	UPDATE dbo.Res_MainExamResult SET [IsPublished] = 1 WHERE MainExamId = @MainExamId AND StudentIID = @StudentIID
	END

END