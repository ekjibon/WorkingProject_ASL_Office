/****** Object:  StoredProcedure [dbo].[ProcessHighestMark_Grand]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ProcessHighestMark_Grand]'))
BEGIN
DROP PROCEDURE  ProcessHighestMark_Grand
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ProcessHighestMark_Grand] 
	@VersionId int = 0, 
	@SessionId int = 0,
	@ShiftID int =  0,
	@ClassId int = 0,
	@GroupId int = 0,
	@GrandExamId INT
AS
BEGIN
	DECLARE @VersionWise [bit] = NULL,	@ClassWise [bit] =NULL,	@ShiftWise [bit] =NULL ,	@SectionWise [bit] = NULL
	,@IsFrac [bit] = NULL

	SELECT @VersionWise = VersionWise , @ClassWise= ClassWise, @ShiftWise = ShiftWise , @SectionWise = SectionWise ,@IsFrac= IsFrac  FROM Res_HighestMarkConfig 
					 WHERE Versionid  = @VersionId AND SessionId =  @SessionId 
						AND ClassId = @ClassId AND GroupId = @GroupId
PRINT @VersionWise 
PRINT @ClassWise
PRINT @ShiftWise 
PRINT @SectionWise

		
IF(@VersionWise=1)
BEGIN
		UPDATE [Res_GrandResultSubjectDetails] SET [SubjectHighestMark] = q.[SubjectConvertedMarks]
		FROM (
			SELECT [SubjectID],  MAX( 
									CASE WHEN @IsFrac = 1 THEN SubjectConvertedMarksFraction
										ELSE [SubjectConvertedMarks]
										END
			) AS [SubjectConvertedMarks] FROM [dbo].[Res_GrandResultSubjectDetails]
				WHERE [GrandExamId] =@GrandExamId AND StudentIID IN (
										SELECT StudentIID FROM Student_BasicInfo S 
										WHERE S.VersionId  = @VersionId
										 AND S.SessionId =   @SessionId
										 AND  S.Status = 'A'	 )	GROUP BY [SubjectID] 
			) AS q
			WHERE q.[SubjectID] = [Res_GrandResultSubjectDetails].[SubjectID] AND [GrandExamId] =@GrandExamId 
			AND [Res_GrandResultSubjectDetails].StudentIID IN (
										SELECT StudentIID FROM Student_BasicInfo S 
										WHERE S.VersionId  = @VersionId
										 AND S.SessionId =   @SessionId
										 AND  S.Status = 'A'	 )

		
END	

IF(@ClassWise=1)
BEGIN
		UPDATE [Res_GrandResultSubjectDetails] SET [SubjectHighestMark] = q.[SubjectConvertedMarks]
		FROM (
			SELECT [SubjectID],  MAX(
									CASE WHEN @IsFrac = 1 THEN SubjectConvertedMarksFraction
										ELSE [SubjectConvertedMarks]
										END
			) AS [SubjectConvertedMarks] FROM [dbo].[Res_GrandResultSubjectDetails]
				WHERE [GrandExamId] =@GrandExamId AND StudentIID IN (
										SELECT StudentIID FROM Student_BasicInfo S 
										WHERE  S.SessionId =   @SessionId
										  AND S.ClassId = @ClassId  AND  S.Status = 'A'	 )	GROUP BY [SubjectID]
			) AS q
			WHERE q.[SubjectID] = [Res_GrandResultSubjectDetails].[SubjectID] AND [GrandExamId] =@GrandExamId 
			AND [Res_GrandResultSubjectDetails].StudentIID IN (
										SELECT StudentIID FROM Student_BasicInfo S 
										WHERE  S.SessionId =   @SessionId
										  AND S.ClassId = @ClassId  AND  S.Status = 'A'	 )

		
END	
	
	

IF(@ShiftWise=1)
BEGIN
		UPDATE [Res_GrandResultSubjectDetails] SET [SubjectHighestMark] = q.[SubjectConvertedMarks]
		FROM (
			SELECT [SubjectID],  MAX( 
									CASE WHEN @IsFrac = 1 THEN SubjectConvertedMarksFraction
										ELSE [SubjectConvertedMarks]
										END
			) AS [SubjectConvertedMarks] FROM [dbo].[Res_GrandResultSubjectDetails]
				WHERE [GrandExamId] =@GrandExamId AND StudentIID IN (
										SELECT StudentIID FROM Student_BasicInfo S 
										WHERE  S.SessionId =   @SessionId
										  AND S.ShiftID = @ShiftID  AND  S.Status = 'A'	 )	GROUP BY [SubjectID]
			) AS q
			WHERE q.[SubjectID] = [Res_GrandResultSubjectDetails].[SubjectID] AND [GrandExamId] =@GrandExamId 
			AND [Res_GrandResultSubjectDetails].StudentIID IN (
										SELECT StudentIID FROM Student_BasicInfo S 
										WHERE  S.SessionId =   @SessionId
										  AND S.ShiftID = @ShiftID  AND  S.Status = 'A'	 )

		
END	
IF(@SectionWise=1)
BEGIN

CREATE TABLE #tmpSections(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SectionID] [int] NOT NULL
	)
INSERT INTO #tmpSections
([SectionID])  
SELECT SectionId FROM Ins_Section WHERE ClassId =@ClassId AND GroupId = @GroupId AND IsDeleted = 0
		
DECLARE @COUNTER INT, @MAXID INT 
SET @COUNTER = 1
SELECT @MAXID = COUNT(*) FROM #tmpSections
WHILE (@COUNTER <= @MAXID)
	BEGIN
	DECLARE @SectionId INT 
	SELECT @SectionId = SectionID FROM #tmpSections WHERE id=@COUNTER
	PRINT @SectionId

		UPDATE [Res_GrandResultSubjectDetails] SET [SubjectHighestMark] = q.[SubjectConvertedMarks]
		FROM (
			SELECT [SubjectID],  MAX( 
									CASE WHEN @IsFrac = 1 THEN SubjectConvertedMarksFraction
										ELSE [SubjectConvertedMarks]
										END
			) AS [SubjectConvertedMarks] FROM [dbo].[Res_GrandResultSubjectDetails]
				WHERE [GrandExamId] =@GrandExamId AND StudentIID IN (
										SELECT StudentIID FROM Student_BasicInfo S 
										WHERE  S.SessionId =   @SessionId
										   AND  S.Status = 'A'	 )	GROUP BY [SubjectID]
			) AS q
			WHERE q.[SubjectID] = [Res_GrandResultSubjectDetails].[SubjectID] AND [GrandExamId] =@GrandExamId 
			AND [Res_GrandResultSubjectDetails].StudentIID IN (
										SELECT StudentIID FROM Student_BasicInfo S 
										WHERE  S.SessionId =   @SessionId
										  AND S.SectionId = @SectionId  AND  S.Status = 'A'	 )
		SET @COUNTER = @COUNTER +1
	END

		
END		
																
END


-- EXEC ProcessHighestMark_Grand 1,6,1,6,0,82

