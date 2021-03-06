/****** Object:  StoredProcedure [dbo].[ProcessHighestMark]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ProcessHighestMark]'))
BEGIN
DROP PROCEDURE  ProcessHighestMark
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ProcessHighestMark] 
	@VersionId int = 0, 
	@SessionId int = 0,
	@ShiftID INT = 0,
	@ClassId int = 0,
	@GroupId int = 0,
	@MainExamId INT
AS
BEGIN
	DECLARE @BranchWise BIT = NULL, @VersionWise [bit] = NULL,	@ClassWise [bit] =NULL,	@ShiftWise [bit] =NULL ,@SectionWise [bit] = NULL,@Overall [bit] = NULL
	, @MAXID INT = 0

	SELECT @BranchWise = BranchWise, @VersionWise = VersionWise , @ClassWise= ClassWise, @ShiftWise = ShiftWise , @SectionWise = SectionWise,@Overall=IsOverall  FROM Res_HighestMarkConfig 
					 WHERE Versionid  = @VersionId AND SessionId =  @SessionId 
						AND ClassId = @ClassId AND GroupId = @GroupId
PRINT @BranchWise
PRINT @VersionWise 
PRINT @ClassWise
PRINT @ShiftWise 
PRINT @SectionWise
PRINT @Overall

IF(@VersionWise=1)
BEGIN
		UPDATE [Res_MainExamResultSubjectDetails] SET [SubjectHighestMark] = q.[SubjectConvertedMarks]
		FROM (
			SELECT [SubjectID],  MAX( [SubjectConvertedMarks]) AS [SubjectConvertedMarks] FROM [dbo].[Res_MainExamResultSubjectDetails]
				WHERE [MainExamId] =@MainExamId AND StudentIID IN (
										SELECT StudentIID FROM Student_BasicInfo S 
										WHERE S.VersionId  = @VersionId
										 AND S.SessionId =   @SessionId
										 AND  S.Status = 'A'	 )	GROUP BY [SubjectID] 
			) AS q
			WHERE q.[SubjectID] = [Res_MainExamResultSubjectDetails].[SubjectID] AND [MainExamId] =@MainExamId
			AND [Res_MainExamResultSubjectDetails].StudentIID IN (
										SELECT StudentIID FROM Student_BasicInfo S 
										WHERE S.VersionId  = @VersionId
										 AND S.SessionId =   @SessionId
										 AND  S.Status = 'A'	 )


	--	IF( (DB_Name()='scpsc_new_2018' AND @GroupId<> 3) OR DB_Name()='ccpc_new_2018')
	
		
END	
IF(@ClassWise=1)
BEGIN
		UPDATE [Res_MainExamResultSubjectDetails] SET [SubjectHighestMark] = q.[SubjectConvertedMarks] 
		FROM (
			SELECT [SubjectID],  MAX( [SubjectConvertedMarks]) AS [SubjectConvertedMarks] FROM [dbo].[Res_MainExamResultSubjectDetails]
				WHERE [MainExamId] =@MainExamId AND StudentIID IN (
										SELECT StudentIID FROM Student_BasicInfo S 
										WHERE  S.SessionId =   @SessionId
										  AND S.ClassId = @ClassId  AND  S.Status = 'A'	 )	GROUP BY [SubjectID]
			) AS q
			WHERE q.[SubjectID] = [Res_MainExamResultSubjectDetails].[SubjectID] AND [MainExamId] =@MainExamId
			AND [Res_MainExamResultSubjectDetails].StudentIID IN (
										SELECT StudentIID FROM Student_BasicInfo S 
										WHERE  S.SessionId =   @SessionId
										  AND S.ClassId = @ClassId  AND  S.Status = 'A'	 )

		
END	
IF(@ShiftWise=1)
BEGIN
		UPDATE [Res_MainExamResultSubjectDetails] SET [SubjectHighestMark] = q.[SubjectConvertedMarks]
		FROM (
			SELECT [SubjectID],  MAX( [SubjectConvertedMarks]) AS [SubjectConvertedMarks] FROM [dbo].[Res_MainExamResultSubjectDetails]
				WHERE [MainExamId] =@MainExamId AND StudentIID IN (
										SELECT StudentIID FROM Student_BasicInfo S 
										WHERE  S.SessionId =   @SessionId
										  AND S.ShiftID = @ShiftID  AND  S.Status = 'A'	 )	GROUP BY [SubjectID]
			) AS q
			WHERE q.[SubjectID] = [Res_MainExamResultSubjectDetails].[SubjectID] AND [MainExamId] =@MainExamId
			AND [Res_MainExamResultSubjectDetails].StudentIID IN (
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
		
DECLARE @COUNTER INT
SET @COUNTER = 1
SELECT @MAXID = COUNT(*) FROM #tmpSections
WHILE (@COUNTER <= @MAXID)
	BEGIN
	DECLARE @SectionId INT 
	SELECT @SectionId = SectionID FROM #tmpSections WHERE id=@COUNTER
	PRINT @SectionId

		UPDATE [Res_MainExamResultSubjectDetails] SET [SubjectHighestMark] = q.[SubjectConvertedMarks]
		FROM (
			SELECT [SubjectID],  MAX( [SubjectConvertedMarks]) AS [SubjectConvertedMarks] FROM [dbo].[Res_MainExamResultSubjectDetails]
				WHERE [MainExamId] =@MainExamId AND StudentIID IN (
										SELECT StudentIID FROM Student_BasicInfo S 
										WHERE  S.SessionId =   @SessionId AND  S.Status = 'A'	 )	GROUP BY [SubjectID]
			) AS q
			WHERE q.[SubjectID] = [Res_MainExamResultSubjectDetails].[SubjectID] AND [MainExamId] =@MainExamId
			AND [Res_MainExamResultSubjectDetails].StudentIID IN (
										SELECT StudentIID FROM Student_BasicInfo S 
										WHERE  S.SessionId =   @SessionId
										  AND S.SectionId = @SectionId  AND  S.Status = 'A'	 )
		SET @COUNTER = @COUNTER +1
	END

		
END		
IF(@Overall=1)
BEGIN
		DECLARE @C1 INT , @C2 INT , @Classname VARCHAR(50), @Count INT =1  , @HighMark Decimal(18,2)

		SELECT @C1 = @ClassId , @Classname = ClassName FROM Ins_ClassInfo WHERE ClassId =  @ClassId 
		SELECT @C2 = ClassId FROM  Ins_ClassInfo
		WHERE ClassName = @Classname AND ClassId <> @ClassId

		DECLARE  @S1 INT , @S2 INT

		PRINT @c1 PRINT @C2

		CREATE TABLE #temp 
		(
			Id int IDENTITY(1,1),
			StuId INT ,
			SubId INT

		)
		INSERT INTO #temp
		SELECT StudentIID,SubjectID  FROM Res_MainExamResultSubjectDetails
		WHERE MainExamId  IN (SELECT MainExamId FROM Res_MainExam WHERE ClassId IN (@C1,@C2) )
			AND [Res_MainExamResultSubjectDetails].StudentIID IN (
										SELECT StudentIID FROM Student_BasicInfo S 
										WHERE S.ClassId  in  (@C1,@C2) AND GroupId = @GroupId AND S.SessionId =   @SessionId AND  S.Status = 'A'	)
		
		 SELECT @MAXID = @@ROWCOUNT

		SELECT SubjectName,  MAX( [SubjectConvertedMarks]) AS [SubjectConvertedMarks] INTO #tempSub
		 FROM [dbo].[Res_MainExamResultSubjectDetails]
			INNER JOIN Res_SubjectSetup On SubID = SubjectID
				WHERE [MainExamId] IN ((SELECT MainExamId FROM Res_MainExam WHERE ClassId IN (@C1,@C2))) AND StudentIID IN (
										SELECT StudentIID FROM Student_BasicInfo S 
										WHERE  S.SessionId =   @SessionId
										  AND S.ClassId in (@C1,@C2)  AND  S.Status = 'A'	 )	GROUP BY SubjectName

		--SELECT COUNT(*) FROM #temp GRoup by StuId
		
		WHILE (@Count <= @MAXID)
		BEGIN 
		DECLARE @SIID INT , @SubName VARCHAR(100)
		SELECT @S1 = SubId,  @SIID  = StuId FROM #temp WHERE Id = @Count 

		SELECT  @SubName =  SubjectName FROM Res_SubjectSetup S1 WHERE S1.SubID = @S1 AND S1.ClassId IN(@C1, @C2)
		PRINT @SubName

		SELECT  @S2=  SubID FROM Res_SubjectSetup  WHERE SubjectName = @SubName AND ClassId IN(@C1, @C2) AND SubID <> @S1
		
		PRINT @s1 PRINT @s2

		SELECT @HighMark =  SubjectConvertedMarks FROM #tempSub WHERE SubjectName = @SubName
		--SELECT @HighMark =  MAX(SubjectConvertedMarks) FROM Res_MainExamResultSubjectDetails M
		--								WHERE M.SubjectID IN (@S1,@S2) AND M.MainExamId IN (SELECT MainExamId FROM Res_MainExam WHERE ClassId IN (@C1,@C2))
		PRINT 'Highest Mark > ' + CAST( @HighMark AS VARCHAR(50))

			UPDATE [Res_MainExamResultSubjectDetails] 
			SET [SubjectHighestMark] = @HighMark
			WHERE StudentIID = @SIID AND ( SubjectID = @S1 OR SubjectID = @S2)
			AND MainExamId  IN (SELECT MainExamId FROM Res_MainExam WHERE ClassId IN (@C1,@C2) )

		SET @Count = @Count +1
		END

	DROP TABLE #tempSub
		END																
END
-- EXEC ProcessHighestMark 1,6,22,2,0,2

