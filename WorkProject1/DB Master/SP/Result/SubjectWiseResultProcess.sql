IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SubjectWiseResultProcess]'))
BEGIN
DROP PROCEDURE  SubjectWiseResultProcess
END
GO
/****** Object:  StoredProcedure [dbo].[SubjectWiseResultProcess]    Script Date: 5/21/2019 3:43:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- EXEC SubjectWiseResultProcess 11,22,32,1064,85,89
Create Procedure [dbo].[SubjectWiseResultProcess]
(
	@SessionId INT=NULL, 
	@ClassId    INT=NULL, 
	@TermId   INT=NULL, 
	@MainExamId   INT=NULL,
	@SubjectId   INT=NULL,
	@SectionId   INT=NULL
)
As
BEGIN
-----------------start Declare 
DECLARE @Count INT = 0,@termName varchar(max),@Percentage int,@TotalExamCount int,@Autumn int , @Winter int ,@AutumnPercentage int , @WinterPercentage int , @BranchId int
-----------------end Declare 
	SELECT top 1 @termName = [Name] from dbo.Res_Terms where TermId=@TermId
	SELECT	 @BranchId=BranchId FROM  dbo.Res_Terms WHERE TermId=@TermId

	SET @Percentage=100;
	SET @termName =UPPER(@termName)

	IF(@termName like '%WIN%')
	BEGIN
		SET @Percentage=40;
	END

	IF(@termName like '%SUM%')
	BEGIN
		SET @Percentage=20;
	END

PRINT 'Term name :'+ @termName+'  '+ cast(@Percentage as varchar)

	SELECT StudentID INTO #StuList 
	FROM Res_StudentSubject S INNER JOIN dbo.Student_BasicInfo SB ON SB.StudentIID = S.StudentID
	WHERE SB.SessionId = @SessionId AND SB.ClassId =  @ClassId AND S.SubjectID = @SubjectId AND SB.SectionId = @SectionId AND S.[Status] = 'A' AND S.IsDeleted = 0 AND SB.BranchId=@BranchId

SELECT @Count = @@ROWCOUNT


-----------------start Delete 
		DELETE  FROM [dbo].[Res_MERSubExamResult] 
		WHERE SubjectID  = @SubjectId AND MainExamID = @MainExamId AND StudentIID IN (SELECT * FROM #StuList) 

		DELETE  FROM [dbo].[Res_MainExamResultSubjectDetails] 
		WHERE SubjectID  = @SubjectId AND MainExamID = @MainExamId AND StudentIID IN (SELECT * FROM #StuList) 
-----------------end Delete 


-----------------start Mark Process
		INSERT INTO [dbo].[Res_MERSubExamResult]
		SELECT  SubjectID,MainExamID,SubExamID,StudentIID,ObtainMarks,
				(ISNULL(dbo.SubExamtotalConv(MM.ObtainMarks,MM.SubjectID,MM.MainExamID,MM.SubExamID),0)),
				0.0,MM.IsAbsent
		FROM Res_MainExamMarks MM
		WHERE MM.ClassId = @ClassId AND MM.MainExamID = @MainExamId AND StudentIID IN (SELECT * FROM #StuList)
		AND MM.SubjectID  = @SubjectId
-----------------end Mark Process

----------------Start Subject Mark Process
SELECT @TotalExamCount = COUNT(SubExamId) FROM dbo.Res_SubExam WHERE SubjectId=@SubjectId and MainExamId=@MainExamId AND IsDeleted = 0 AND SectionId = @SectionId
PRINT @TotalExamCount
IF(@termName like '%Au%')
BEGIN
	SET @Percentage=100
	print @termName
		INSERT INTO [dbo].[Res_MainExamResultSubjectDetails]([StudentIID]
				   ,[SubjectID],[MainExamId],[SubjectObtMarks] ,
				    [SubjectConvertedMarks]
				   ,[SubjectConvertedMarksFraction]
				   ,[SubjectGP]
				   ,[SubjectGL]
				   ,[SubjectHighestMark]
				   ,[SubjectIsPass]
				   ,[SubjectIsAbsent]
				   ,[TotalExamNo]
				   ,[IsECA])
		SELECT StudentIID, SR.SubjectID,SR.MainExamId,SUM(SubExamTotalConv) AS ObtMark
		, dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount) AS ConvMark
		, dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount) AS ConvFracMark
		, dbo.GPCalculationBySubId(@SessionId,@ClassId,
		dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount)
		,SR.SubjectID,@MainExamId) AS  GP
		, dbo.GLCalculationBySubId(@SessionId,@ClassId,
		dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount	)
		,SR.SubjectID,@MainExamId) AS  GL
		,0,1,0,0,ISNULL((SELECT  IsECA FROM Res_SubjectSetup WHERE IsECA =1 AND SubID = SR.SubjectID ),0)
		 FROM Res_MERSubExamResult SR
		 Inner JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId 
		WHERE  SR.MainExamID = @MainExamId  AND StudentIID IN (SELECT * FROM #StuList) AND SR.SubjectID = @SubjectId
		GROUP BY SR.StudentIID, SR.SubjectID,SR.MainExamId,SE.IsMidYear
	
END
if(@termName like '%WINTER%')
BEGIN
PRINT 'WINTER'

		SELECT * FROM Res_MERSubExamResult SR
				INNER JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId 
		WHERE  SR.MainExamID = @MainExamId  AND StudentIID IN (SELECT * FROM #StuList) AND SR.SubjectID = @SubjectId 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------21 for Class KG
				 IF(@ClassId = 21)
		BEGIN
		SET @Percentage=100
			INSERT INTO [dbo].[Res_MainExamResultSubjectDetails]([StudentIID]
           ,[SubjectID],[MainExamId],[SubjectObtMarks] ,
		   WinterMarks
		   ,SubjectConvertedMarks
           ,[SubjectConvertedMarksFraction]
           ,[SubjectGP]
           ,[SubjectGL]
           ,[SubjectHighestMark]
           ,[SubjectIsPass]
           ,[SubjectIsAbsent]
           ,[TotalExamNo]
		   ,[IsECA])
	SELECT SR.StudentIID, SR.SubjectID,SR.MainExamId,SUM(SubExamTotalConv) AS ObtMark
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId, @Percentage ,@TotalExamCount) AS WinterMarks
			,0
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount) AS ConvFracMark
			,dbo.GPCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount)
			,SR.SubjectID,@MainExamId) AS  GP
			, dbo.GLCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(ROUND(SubExamTotalConv,0)),SR.SubjectID,@MainExamId,@Percentage ,@TotalExamCount)
			,SR.SubjectID,@MainExamId) AS  GL
			,0,1,0,0,ISNULL((SELECT  IsECA FROM Res_SubjectSetup WHERE IsECA =1 AND SubID = SR.SubjectID ),0)
	FROM	Res_MERSubExamResult SR
			INNER JOIN dbo.Student_BasicInfo SB ON SB.StudentIID = SR.StudentIID
			Inner JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId  AND SE.SectionId = SB.SectionId
		
	WHERE  SR.MainExamID = @MainExamId  AND SR.StudentIID IN (SELECT * FROM #StuList) AND SR.SubjectID = @SubjectId and se.IsMidYear=0
	GROUP BY SR.StudentIID, SR.SubjectID  , SR.MainExamId,SE.IsMidYear

					UPDATE sr	set SubjectGL=dbo.GLCalculationBySubId(@SessionId,@ClassId,ROUND((ISNULL(WinterMarks,0)),0),@SubjectID,@MainExamId)
								,SubjectConvertedMarks=ROUND((ISNULL(WinterMarks,0)),0)
				FROM [dbo].[Res_MainExamResultSubjectDetails]  sr 
				WHERE  sr.MainExamID = @MainExamId  AND sr.SubjectID = @SubjectId AND sr.StudentIID IN (SELECT * FROM #StuList)
END

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------22 for Class 1
				ELSE IF(@ClassId = 22)
		BEGIN
		SET @Percentage=100
			INSERT INTO [dbo].[Res_MainExamResultSubjectDetails]([StudentIID]
           ,[SubjectID],[MainExamId],[SubjectObtMarks] ,
		   WinterMarks
		   ,SubjectConvertedMarks
           ,[SubjectConvertedMarksFraction]
           ,[SubjectGP]
           ,[SubjectGL]
           ,[SubjectHighestMark]
           ,[SubjectIsPass]
           ,[SubjectIsAbsent]
           ,[TotalExamNo]
		   ,[IsECA])
	SELECT StudentIID, SR.SubjectID,SR.MainExamId,SUM(SubExamTotalConv) AS ObtMark
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId, @Percentage ,@TotalExamCount) AS WinterMarks
			,0
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount) AS ConvFracMark
			,dbo.GPCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount)
			,SR.SubjectID,@MainExamId) AS  GP
			, dbo.GLCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(ROUND(SubExamTotalConv,0)),SR.SubjectID,@MainExamId,@Percentage ,@TotalExamCount)
			,SR.SubjectID,@MainExamId) AS  GL
			,0,1,0,0,ISNULL((SELECT  IsECA FROM Res_SubjectSetup WHERE IsECA =1 AND SubID = SR.SubjectID ),0)
	FROM	Res_MERSubExamResult SR
			Inner JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId 
	WHERE  SR.MainExamID = @MainExamId  AND StudentIID IN (SELECT * FROM #StuList) AND SR.SubjectID = @SubjectId and se.IsMidYear=0
	GROUP BY SR.StudentIID, SR.SubjectID  , SR.MainExamId,SE.IsMidYear

					UPDATE sr	set SubjectGL=dbo.GLCalculationBySubId(@SessionId,@ClassId,ROUND((ISNULL(WinterMarks,0)),0),@SubjectID,@MainExamId)
								,SubjectConvertedMarks=ROUND((ISNULL(WinterMarks,0)),0)
				FROM [dbo].[Res_MainExamResultSubjectDetails]  sr 
				WHERE  sr.MainExamID = @MainExamId  AND sr.SubjectID = @SubjectId AND sr.StudentIID IN (SELECT * FROM #StuList)
END

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------23 for Class 2
				ELSE IF(@ClassId = 23 )
		BEGIN
		SET @Percentage=100
			INSERT INTO [dbo].[Res_MainExamResultSubjectDetails]([StudentIID]
           ,[SubjectID],[MainExamId],[SubjectObtMarks] ,
		   WinterMarks
		   ,SubjectConvertedMarks
           ,[SubjectConvertedMarksFraction]
           ,[SubjectGP]
           ,[SubjectGL]
           ,[SubjectHighestMark]
           ,[SubjectIsPass]
           ,[SubjectIsAbsent]
           ,[TotalExamNo]
		   ,[IsECA])
	SELECT StudentIID, SR.SubjectID,SR.MainExamId,SUM(SubExamTotalConv) AS ObtMark
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId, @Percentage ,@TotalExamCount) AS WinterMarks
			,0
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount) AS ConvFracMark
			,dbo.GPCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount)
			,SR.SubjectID,@MainExamId) AS  GP
			, dbo.GLCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(ROUND(SubExamTotalConv,0)),SR.SubjectID,@MainExamId,@Percentage ,@TotalExamCount)
			,SR.SubjectID,@MainExamId) AS  GL
			,0,1,0,0,ISNULL((SELECT  IsECA FROM Res_SubjectSetup WHERE IsECA =1 AND SubID = SR.SubjectID ),0)
	FROM	Res_MERSubExamResult SR
			Inner JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId 
	WHERE  SR.MainExamID = @MainExamId  AND StudentIID IN (SELECT * FROM #StuList) AND SR.SubjectID = @SubjectId and se.IsMidYear=0
	GROUP BY SR.StudentIID, SR.SubjectID  , SR.MainExamId,SE.IsMidYear

					UPDATE sr	set SubjectGL=dbo.GLCalculationBySubId(@SessionId,@ClassId,ROUND((ISNULL(WinterMarks,0)),0),@SubjectID,@MainExamId)
								,SubjectConvertedMarks=ROUND((ISNULL(WinterMarks,0)),0)
				FROM [dbo].[Res_MainExamResultSubjectDetails]  sr 
				WHERE  sr.MainExamID = @MainExamId  AND sr.SubjectID = @SubjectId AND sr.StudentIID IN (SELECT * FROM #StuList)
END
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------24 for Class 3
		ELSE IF(@ClassId = 24 AND (@SubjectId =1 OR @SubjectId =2 OR @SubjectId =3))
		BEGIN
			INSERT INTO [dbo].[Res_MainExamResultSubjectDetails]([StudentIID]
           ,[SubjectID],[MainExamId],[SubjectObtMarks] ,
		   WinterMarks
		   ,SubjectConvertedMarks
           ,[SubjectConvertedMarksFraction]
           ,[SubjectGP]
           ,[SubjectGL]
           ,[SubjectHighestMark]
           ,[SubjectIsPass]
           ,[SubjectIsAbsent]
           ,[TotalExamNo]
		   ,[IsECA])
	SELECT StudentIID, SR.SubjectID,SR.MainExamId,SUM(SubExamTotalConv) AS ObtMark
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId, @Percentage ,@TotalExamCount-1) AS WinterMarks
			,0
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount-1) AS ConvFracMark
			,dbo.GPCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount-1)
			,SR.SubjectID,@MainExamId) AS  GP
			, dbo.GLCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv (SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage ,@TotalExamCount-1)
			,SR.SubjectID,@MainExamId) AS  GL
			,0,1,0,0,ISNULL((SELECT  IsECA FROM Res_SubjectSetup WHERE IsECA =1 AND SubID = SR.SubjectID ),0)
	FROM	Res_MERSubExamResult SR
			Inner JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId 
	WHERE  SR.MainExamID = @MainExamId  AND StudentIID IN (SELECT * FROM #StuList) AND SR.SubjectID = @SubjectId and se.IsMidYear=0
	GROUP BY SR.StudentIID, SR.SubjectID  , SR.MainExamId,SE.IsMidYear

	SET @Percentage=60
	PRINT '2'
	UPDATE mrsd SET MidYearSubObtMarks=(
				SELECT SUM(SubExamTotalObt) FROM Res_MERSubExamResult SR
						INNER JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId and se.MainExamId=sr.MainExamId
				WHERE sr.MainExamId=mrsd.MainExamId and sr.SubjectID=mrsd.SubjectID and sr.StudentIID=mrsd.StudentIID and se.IsMidYear=1
			),

			MidYearSubConvtMarks=(
				SELECT  (SUM(SubExamTotalObt)*@Percentage)/100 FROM Res_MERSubExamResult SR
						INNER JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId and se.MainExamId=sr.MainExamId
				WHERE sr.MainExamId=mrsd.MainExamId and sr.SubjectID=mrsd.SubjectID and sr.StudentIID=mrsd.StudentIID and se.IsMidYear=1
			)
	FROM [dbo].[Res_MainExamResultSubjectDetails] mrsd WHERE mrsd.MainExamId = @MainExamId AND mrsd.SubjectID = @SubjectId AND mrsd.StudentIID  IN (SELECT * FROM #StuList) 

			PRINT '3'
				UPDATE sr	set SubjectGL=dbo.GLCalculationBySubId(@SessionId,@ClassId,ROUND((ISNULL(WinterMarks,0)+ISNULL(MidYearSubConvtMarks,0)),0),@SubjectID,@MainExamId)
								,SubjectConvertedMarks=ROUND((ISNULL(WinterMarks,0)+ISNULL(MidYearSubConvtMarks,0)),0)
				FROM [dbo].[Res_MainExamResultSubjectDetails]  sr 
				WHERE  sr.MainExamID = @MainExamId  AND sr.SubjectID = @SubjectId AND sr.StudentIID IN (SELECT * FROM #StuList)
END
		------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		ELSE IF(@ClassId = 24 AND (@SubjectId =4 OR @SubjectId =5 OR @SubjectId =6 OR @SubjectId =7 OR @SubjectId =8 OR @SubjectId =9))
		BEGIN
		SET @Percentage=100
			INSERT INTO [dbo].[Res_MainExamResultSubjectDetails]([StudentIID]
           ,[SubjectID],[MainExamId],[SubjectObtMarks] ,
		   WinterMarks
		   ,SubjectConvertedMarks
           ,[SubjectConvertedMarksFraction]
           ,[SubjectGP]
           ,[SubjectGL]
           ,[SubjectHighestMark]
           ,[SubjectIsPass]
           ,[SubjectIsAbsent]
           ,[TotalExamNo]
		   ,[IsECA])
	SELECT StudentIID, SR.SubjectID,SR.MainExamId,SUM(SubExamTotalConv) AS ObtMark
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId, @Percentage ,@TotalExamCount) AS WinterMarks
			,0
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount) AS ConvFracMark
			,dbo.GPCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount)
			,SR.SubjectID,@MainExamId) AS  GP
			, dbo.GLCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(ROUND(SubExamTotalConv,0)),SR.SubjectID,@MainExamId,@Percentage ,@TotalExamCount)
			,SR.SubjectID,@MainExamId) AS  GL
			,0,1,0,0,ISNULL((SELECT  IsECA FROM Res_SubjectSetup WHERE IsECA =1 AND SubID = SR.SubjectID ),0)
	FROM	Res_MERSubExamResult SR
			Inner JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId 
	WHERE  SR.MainExamID = @MainExamId  AND StudentIID IN (SELECT * FROM #StuList) AND SR.SubjectID = @SubjectId and se.IsMidYear=0
	GROUP BY SR.StudentIID, SR.SubjectID  , SR.MainExamId,SE.IsMidYear

					UPDATE sr	set SubjectGL=dbo.GLCalculationBySubId(@SessionId,@ClassId,ROUND((ISNULL(WinterMarks,0)),0),@SubjectID,@MainExamId)
								,SubjectConvertedMarks=ROUND((ISNULL(WinterMarks,0)),0)
				FROM [dbo].[Res_MainExamResultSubjectDetails]  sr 
				WHERE  sr.MainExamID = @MainExamId  AND sr.SubjectID = @SubjectId AND sr.StudentIID IN (SELECT * FROM #StuList)
END
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------25 for Class 4
		ELSE IF(@ClassId = 25 AND (@SubjectId =60 OR @SubjectId =61 OR @SubjectId =62 OR @SubjectId =63))
		BEGIN
			INSERT INTO [dbo].[Res_MainExamResultSubjectDetails]([StudentIID]
           ,[SubjectID],[MainExamId],[SubjectObtMarks] ,
		   WinterMarks
		   ,SubjectConvertedMarks
           ,[SubjectConvertedMarksFraction]
           ,[SubjectGP]
           ,[SubjectGL]
           ,[SubjectHighestMark]
           ,[SubjectIsPass]
           ,[SubjectIsAbsent]
           ,[TotalExamNo]
		   ,[IsECA])
	SELECT StudentIID, SR.SubjectID,SR.MainExamId,SUM(SubExamTotalConv) AS ObtMark
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId, @Percentage ,@TotalExamCount-1) AS WinterMarks
			,0
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount-1) AS ConvFracMark
			,dbo.GPCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount-1)
			,SR.SubjectID,@MainExamId) AS  GP
			, dbo.GLCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage ,@TotalExamCount-1)
			,SR.SubjectID,@MainExamId) AS  GL
			,0,1,0,0,ISNULL((SELECT  IsECA FROM Res_SubjectSetup WHERE IsECA =1 AND SubID = SR.SubjectID ),0)
	FROM	Res_MERSubExamResult SR
			Inner JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId 
	WHERE  SR.MainExamID = @MainExamId  AND StudentIID IN (SELECT * FROM #StuList) AND SR.SubjectID = @SubjectId and se.IsMidYear=0
	GROUP BY SR.StudentIID, SR.SubjectID  , SR.MainExamId,SE.IsMidYear

	SET @Percentage=60
	PRINT '2'
	UPDATE mrsd SET MidYearSubObtMarks=(
				SELECT SUM(SubExamTotalObt) FROM Res_MERSubExamResult SR
						INNER JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId and se.MainExamId=sr.MainExamId
				WHERE sr.MainExamId=mrsd.MainExamId and sr.SubjectID=mrsd.SubjectID and sr.StudentIID=mrsd.StudentIID and se.IsMidYear=1
			),

			MidYearSubConvtMarks=(
				SELECT  (SUM(SubExamTotalObt)*@Percentage)/100 FROM Res_MERSubExamResult SR
						INNER JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId and se.MainExamId=sr.MainExamId
				WHERE sr.MainExamId=mrsd.MainExamId and sr.SubjectID=mrsd.SubjectID and sr.StudentIID=mrsd.StudentIID and se.IsMidYear=1
			)
	FROM [dbo].[Res_MainExamResultSubjectDetails] mrsd WHERE mrsd.MainExamId = @MainExamId AND mrsd.SubjectID = @SubjectId AND mrsd.StudentIID IN (SELECT * FROM #StuList)

			PRINT '3'
				UPDATE sr	set SubjectGL=dbo.GLCalculationBySubId(@SessionId,@ClassId,ROUND((ISNULL(WinterMarks,0)+ISNULL(MidYearSubConvtMarks,0)),0),@SubjectID,@MainExamId)
								,SubjectConvertedMarks=ROUND((ISNULL(WinterMarks,0)+ISNULL(MidYearSubConvtMarks,0)),0)
				FROM [dbo].[Res_MainExamResultSubjectDetails]  sr 
				WHERE  sr.MainExamID = @MainExamId  AND sr.SubjectID = @SubjectId AND sr.StudentIID IN (SELECT * FROM #StuList)
END
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		ELSE IF(@ClassId = 25 AND (@SubjectId =64 OR @SubjectId =65 OR @SubjectId =66 OR @SubjectId =67 OR @SubjectId =68))
		BEGIN
		SET @Percentage=100
			INSERT INTO [dbo].[Res_MainExamResultSubjectDetails]([StudentIID]
           ,[SubjectID],[MainExamId],[SubjectObtMarks] ,
		   WinterMarks
		   ,SubjectConvertedMarks
           ,[SubjectConvertedMarksFraction]
           ,[SubjectGP]
           ,[SubjectGL]
           ,[SubjectHighestMark]
           ,[SubjectIsPass]
           ,[SubjectIsAbsent]
           ,[TotalExamNo]
		   ,[IsECA])
	SELECT StudentIID, SR.SubjectID,SR.MainExamId,SUM(SubExamTotalConv) AS ObtMark
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId, @Percentage ,@TotalExamCount) AS WinterMarks
			,0
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount) AS ConvFracMark
			,dbo.GPCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount)
			,SR.SubjectID,@MainExamId) AS  GP
			, dbo.GLCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(ROUND(SubExamTotalConv,0)),SR.SubjectID,@MainExamId,@Percentage ,@TotalExamCount)
			,SR.SubjectID,@MainExamId) AS  GL
			,0,1,0,0,ISNULL((SELECT  IsECA FROM Res_SubjectSetup WHERE IsECA =1 AND SubID = SR.SubjectID ),0)
	FROM	Res_MERSubExamResult SR
			Inner JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId 
	WHERE  SR.MainExamID = @MainExamId  AND StudentIID IN (SELECT * FROM #StuList) AND SR.SubjectID = @SubjectId and se.IsMidYear=0
	GROUP BY SR.StudentIID, SR.SubjectID  , SR.MainExamId,SE.IsMidYear

						UPDATE sr	set SubjectGL=dbo.GLCalculationBySubId(@SessionId,@ClassId,ROUND((ISNULL(WinterMarks,0)),0),@SubjectID,@MainExamId)
								,SubjectConvertedMarks=ROUND((ISNULL(WinterMarks,0)),0)
				FROM [dbo].[Res_MainExamResultSubjectDetails]  sr 
				WHERE  sr.MainExamID = @MainExamId  AND sr.SubjectID = @SubjectId AND sr.StudentIID IN (SELECT * FROM #StuList)
END
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------26 for Class 5
		ELSE IF(@ClassId = 26 AND (@SubjectId =49 OR @SubjectId =50 OR @SubjectId =51 OR @SubjectId =52 OR @SubjectId =53 ))
		BEGIN
	
			INSERT INTO [dbo].[Res_MainExamResultSubjectDetails]([StudentIID]
           ,[SubjectID],[MainExamId],[SubjectObtMarks] ,
		   WinterMarks
		   ,SubjectConvertedMarks
           ,[SubjectConvertedMarksFraction]
           ,[SubjectGP]
           ,[SubjectGL]
           ,[SubjectHighestMark]
           ,[SubjectIsPass]
           ,[SubjectIsAbsent]
           ,[TotalExamNo]
		   ,[IsECA]
		   ,[MidYearSubConvtMarks]
		   ,[MidYearSubObtMarks]
		   )
	SELECT StudentIID, SR.SubjectID,SR.MainExamId,SUM(SubExamTotalConv) AS ObtMark
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId, @Percentage ,@TotalExamCount-1) AS WinterMarks
			,0
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount-1) AS ConvFracMark
			,dbo.GPCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount-1)
			,SR.SubjectID,@MainExamId) AS  GP
			, dbo.GLCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage ,@TotalExamCount-1)
			,SR.SubjectID,@MainExamId) AS  GL
			,0,1,0,0,ISNULL((SELECT  IsECA FROM Res_SubjectSetup WHERE IsECA =1 AND SubID = SR.SubjectID ),0),0,0
	FROM	Res_MERSubExamResult SR
			Inner JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId 
	WHERE  SR.MainExamID = @MainExamId  AND StudentIID IN (SELECT * FROM #StuList) AND SR.SubjectID = @SubjectId and se.IsMidYear=0
	GROUP BY SR.StudentIID, SR.SubjectID  , SR.MainExamId,SE.IsMidYear

	SET @Percentage=60
	PRINT '2'
	UPDATE mrsd SET MidYearSubObtMarks=(
				SELECT SUM(SubExamTotalObt) FROM Res_MERSubExamResult SR
						INNER JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId and se.MainExamId=sr.MainExamId
				WHERE sr.MainExamId=mrsd.MainExamId and sr.SubjectID=mrsd.SubjectID and sr.StudentIID=mrsd.StudentIID and se.IsMidYear=1
			),

			MidYearSubConvtMarks=(
				SELECT  ([dbo].[SubjectwiseMidTotalConv](SR.SubExamTotalObt,sr.SubjectID,sr.MainExamId, @Percentage,@SectionId)) FROM Res_MERSubExamResult SR
						INNER JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId and se.MainExamId=sr.MainExamId
				WHERE sr.MainExamId=mrsd.MainExamId and sr.SubjectID=mrsd.SubjectID and sr.StudentIID=mrsd.StudentIID and se.IsMidYear=1
			)
	FROM [dbo].[Res_MainExamResultSubjectDetails] mrsd WHERE mrsd.MainExamId = @MainExamId AND mrsd.SubjectID = @SubjectId AND mrsd.StudentIID IN  (SELECT * FROM #StuList)

			PRINT '3'
				UPDATE sr	set SubjectGL=dbo.GLCalculationBySubId(@SessionId,@ClassId,ROUND((ISNULL(WinterMarks,0)+ISNULL(MidYearSubConvtMarks,0)),0),@SubjectID,@MainExamId)
								,SubjectConvertedMarks=ROUND((ISNULL(WinterMarks,0)+ISNULL(MidYearSubConvtMarks,0)),0)
				FROM [dbo].[Res_MainExamResultSubjectDetails]  sr 
				WHERE  sr.MainExamID = @MainExamId  AND sr.SubjectID = @SubjectId AND sr.StudentIID IN (SELECT * FROM #StuList)
END
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		ELSE IF(@ClassId = 26 AND (@SubjectId =54 OR @SubjectId =55  ))
		BEGIN
	SET @Percentage=60
			INSERT INTO [dbo].[Res_MainExamResultSubjectDetails]([StudentIID]
           ,[SubjectID],[MainExamId],[SubjectObtMarks] ,
		   WinterMarks
		   ,SubjectConvertedMarks
           ,[SubjectConvertedMarksFraction]
           ,[SubjectGP]
           ,[SubjectGL]
           ,[SubjectHighestMark]
           ,[SubjectIsPass]
           ,[SubjectIsAbsent]
           ,[TotalExamNo]
		   ,[IsECA]
		   ,[MidYearSubConvtMarks]
		   ,[MidYearSubObtMarks])
	SELECT StudentIID, SR.SubjectID,SR.MainExamId,SUM(SubExamTotalConv) AS ObtMark
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId, @Percentage ,@TotalExamCount-1) AS WinterMarks
			,0
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount-1) AS ConvFracMark
			,dbo.GPCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount-1)
			,SR.SubjectID,@MainExamId) AS  GP
			, dbo.GLCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage ,@TotalExamCount-1)
			,SR.SubjectID,@MainExamId) AS  GL
			,0,1,0,0,ISNULL((SELECT  IsECA FROM Res_SubjectSetup WHERE IsECA =1 AND SubID = SR.SubjectID ),0),0,0
	FROM	Res_MERSubExamResult SR
			Inner JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId 
	WHERE  SR.MainExamID = @MainExamId  AND StudentIID IN (SELECT * FROM #StuList) AND SR.SubjectID = @SubjectId and se.IsMidYear=0
	GROUP BY SR.StudentIID, SR.SubjectID  , SR.MainExamId,SE.IsMidYear

	SET @Percentage=40
	PRINT '2'
	UPDATE mrsd SET MidYearSubObtMarks=(
				SELECT SUM(SubExamTotalObt) FROM Res_MERSubExamResult SR
						INNER JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId and se.MainExamId=sr.MainExamId
				WHERE sr.MainExamId=mrsd.MainExamId and sr.SubjectID=mrsd.SubjectID and sr.StudentIID=mrsd.StudentIID and se.IsMidYear=1
			),

			MidYearSubConvtMarks=(
				SELECT  ([dbo].[SubjectwiseMidTotalConv](SR.SubExamTotalObt,sr.SubjectID,sr.MainExamId, @Percentage,@SectionId)) FROM Res_MERSubExamResult SR
						INNER JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId and se.MainExamId=sr.MainExamId
				WHERE sr.MainExamId=mrsd.MainExamId and sr.SubjectID=mrsd.SubjectID and sr.StudentIID=mrsd.StudentIID and se.IsMidYear=1
			)
	FROM [dbo].[Res_MainExamResultSubjectDetails] mrsd WHERE mrsd.MainExamId = @MainExamId AND mrsd.SubjectID = @SubjectId AND mrsd.StudentIID IN(SELECT * FROM #StuList)

			PRINT '3'
				UPDATE sr	set SubjectGL=dbo.GLCalculationBySubId(@SessionId,@ClassId,ROUND((ISNULL(WinterMarks,0)+ISNULL(MidYearSubConvtMarks,0)),0),@SubjectID,@MainExamId)
								,SubjectConvertedMarks=ROUND((ISNULL(WinterMarks,0)+ISNULL(MidYearSubConvtMarks,0)),0)
				FROM [dbo].[Res_MainExamResultSubjectDetails]  sr 
				WHERE  sr.MainExamID = @MainExamId  AND sr.SubjectID = @SubjectId AND sr.StudentIID IN(SELECT * FROM #StuList)
END
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		ELSE IF(@ClassId = 26 AND (@SubjectId =56 OR @SubjectId =57 OR @SubjectId =58 OR @SubjectId=59))
		BEGIN
		SET @Percentage=100
			INSERT INTO [dbo].[Res_MainExamResultSubjectDetails]([StudentIID]
           ,[SubjectID],[MainExamId],[SubjectObtMarks] ,
		   WinterMarks
		   ,SubjectConvertedMarks
           ,[SubjectConvertedMarksFraction]
           ,[SubjectGP]
           ,[SubjectGL]
           ,[SubjectHighestMark]
           ,[SubjectIsPass]
           ,[SubjectIsAbsent]
           ,[TotalExamNo]
		   ,[IsECA])
	SELECT StudentIID, SR.SubjectID,SR.MainExamId,SUM(SubExamTotalConv) AS ObtMark
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId, @Percentage ,@TotalExamCount) AS WinterMarks
			,0
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount) AS ConvFracMark
			,dbo.GPCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount)
			,SR.SubjectID,@MainExamId) AS  GP
			, dbo.GLCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(ROUND(SubExamTotalConv,0)),SR.SubjectID,@MainExamId,@Percentage ,@TotalExamCount)
			,SR.SubjectID,@MainExamId) AS  GL
			,0,1,0,0,ISNULL((SELECT  IsECA FROM Res_SubjectSetup WHERE IsECA =1 AND SubID = SR.SubjectID ),0)
	FROM	Res_MERSubExamResult SR
			Inner JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId 
	WHERE  SR.MainExamID = @MainExamId  AND StudentIID IN (SELECT * FROM #StuList) AND SR.SubjectID = @SubjectId and se.IsMidYear=0
	GROUP BY SR.StudentIID, SR.SubjectID  , SR.MainExamId,SE.IsMidYear

						UPDATE sr	set SubjectGL=dbo.GLCalculationBySubId(@SessionId,@ClassId,ROUND((ISNULL(WinterMarks,0)),0),@SubjectID,@MainExamId)
								,SubjectConvertedMarks=ROUND((ISNULL(WinterMarks,0)),0)
				FROM [dbo].[Res_MainExamResultSubjectDetails]  sr 
				WHERE  sr.MainExamID = @MainExamId  AND sr.SubjectID = @SubjectId AND sr.StudentIID IN (SELECT * FROM #StuList)
END
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------27 for Class 6
		ELSE IF(@ClassId = 27 AND (@SubjectId =27 OR @SubjectId =28 OR @SubjectId =29 OR @SubjectId =30 OR @SubjectId =31 OR @SubjectId =34 ))
		BEGIN
		--By Default 40 %
		SET @Percentage = 40;
			INSERT INTO [dbo].[Res_MainExamResultSubjectDetails]([StudentIID]
           ,[SubjectID],[MainExamId],[SubjectObtMarks] ,
		   WinterMarks
		   ,SubjectConvertedMarks
           ,[SubjectConvertedMarksFraction]
           ,[SubjectGP]
           ,[SubjectGL]
           ,[SubjectHighestMark]
           ,[SubjectIsPass]
           ,[SubjectIsAbsent]
           ,[TotalExamNo]
		   ,[IsECA])
	SELECT StudentIID, SR.SubjectID,SR.MainExamId,SUM(SubExamTotalConv) AS ObtMark
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId, @Percentage ,@TotalExamCount-1) AS WinterMarks
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount-1) AS ConvMark
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount-1) AS ConvFracMark
			,dbo.GPCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount-1)
			,SR.SubjectID,@MainExamId) AS  GP
			, dbo.GLCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage ,@TotalExamCount-1)
			,SR.SubjectID,@MainExamId) AS  GL
			,0,1,0,0,ISNULL((SELECT  IsECA FROM Res_SubjectSetup WHERE IsECA =1 AND SubID = SR.SubjectID ),0)
	FROM	Res_MERSubExamResult SR
			Inner JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId 
	WHERE  SR.MainExamID = @MainExamId  AND StudentIID IN (SELECT * FROM #StuList) AND SR.SubjectID = @SubjectId and se.IsMidYear=0
	GROUP BY SR.StudentIID, SR.SubjectID  , SR.MainExamId,SE.IsMidYear
	SET @Percentage=60
	PRINT '2'
	UPDATE mrsd SET MidYearSubObtMarks=(
				SELECT SUM(SubExamTotalObt) FROM Res_MERSubExamResult SR
						INNER JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId and se.MainExamId=sr.MainExamId
				WHERE sr.MainExamId=mrsd.MainExamId and sr.SubjectID=mrsd.SubjectID and sr.StudentIID=mrsd.StudentIID and se.IsMidYear=1
			),

			MidYearSubConvtMarks=(
				SELECT  ([dbo].[SubjectwiseMidTotalConv](SR.SubExamTotalObt,sr.SubjectID,sr.MainExamId, @Percentage,@SectionId)) FROM Res_MERSubExamResult SR
						INNER JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId and se.MainExamId=sr.MainExamId
				WHERE sr.MainExamId=mrsd.MainExamId and sr.SubjectID=mrsd.SubjectID and sr.StudentIID=mrsd.StudentIID and se.IsMidYear=1
			)
	FROM [dbo].[Res_MainExamResultSubjectDetails] mrsd
			WHERE mrsd.MainExamId = @MainExamId AND mrsd.SubjectID = @SubjectId AND mrsd.StudentIID IN(SELECT * FROM #StuList)

			PRINT '3'
				UPDATE sr	set SubjectGL=dbo.GLCalculationBySubId(@SessionId,@ClassId,ROUND((ISNULL(WinterMarks,0)+ISNULL(MidYearSubConvtMarks,0)),0),@SubjectID,@MainExamId)
								,SubjectConvertedMarks=ROUND((ISNULL(WinterMarks,0)+ISNULL(MidYearSubConvtMarks,0)),0)
				FROM [dbo].[Res_MainExamResultSubjectDetails]  sr 
				WHERE  sr.MainExamID = @MainExamId  AND sr.SubjectID = @SubjectId AND sr.StudentIID IN (SELECT * FROM #StuList)
END
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		ELSE IF(@ClassId = 27 AND (@SubjectId =32 OR @SubjectId =33))
		BEGIN
		SET @Percentage=60
			INSERT INTO [dbo].[Res_MainExamResultSubjectDetails]([StudentIID]
           ,[SubjectID],[MainExamId],[SubjectObtMarks] ,
		   WinterMarks
		   ,SubjectConvertedMarks
           ,[SubjectConvertedMarksFraction]
           ,[SubjectGP]
           ,[SubjectGL]
           ,[SubjectHighestMark]
           ,[SubjectIsPass]
           ,[SubjectIsAbsent]
           ,[TotalExamNo]
		   ,[IsECA])
	SELECT StudentIID, SR.SubjectID,SR.MainExamId,SUM(SubExamTotalConv) AS ObtMark
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId, @Percentage ,@TotalExamCount-1) AS WinterMarks
			,0
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount-1) AS ConvFracMark
			,dbo.GPCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount-1)
			,SR.SubjectID,@MainExamId) AS  GP
			, dbo.GLCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage ,@TotalExamCount-1)
			,SR.SubjectID,@MainExamId) AS  GL
			,0,1,0,0,ISNULL((SELECT  IsECA FROM Res_SubjectSetup WHERE IsECA =1 AND SubID = SR.SubjectID ),0)
	FROM	Res_MERSubExamResult SR
			Inner JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId 
	WHERE  SR.MainExamID = @MainExamId  AND StudentIID IN (SELECT * FROM #StuList) AND SR.SubjectID = @SubjectId and se.IsMidYear=0
	GROUP BY SR.StudentIID, SR.SubjectID  , SR.MainExamId,SE.IsMidYear
	SET @Percentage=40
	PRINT '2'
	UPDATE mrsd SET MidYearSubObtMarks=(
				SELECT SUM(SubExamTotalObt) FROM Res_MERSubExamResult SR
						INNER JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId and se.MainExamId=sr.MainExamId
				WHERE sr.MainExamId=mrsd.MainExamId and sr.SubjectID=mrsd.SubjectID and sr.StudentIID=mrsd.StudentIID and se.IsMidYear=1
			),

			MidYearSubConvtMarks=(
				SELECT  ([dbo].[SubjectwiseMidTotalConv](SR.SubExamTotalObt,sr.SubjectID,sr.MainExamId, @Percentage,@SectionId)) FROM Res_MERSubExamResult SR
						INNER JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId and se.MainExamId=sr.MainExamId
				WHERE sr.MainExamId=mrsd.MainExamId and sr.SubjectID=mrsd.SubjectID and sr.StudentIID=mrsd.StudentIID and se.IsMidYear=1
			)
	FROM [dbo].[Res_MainExamResultSubjectDetails] mrsd
				WHERE mrsd.MainExamId = @MainExamId AND mrsd.SubjectID = @SubjectId AND mrsd.StudentIID IN(SELECT * FROM #StuList)
			PRINT '3'
				UPDATE sr	set SubjectGL=dbo.GLCalculationBySubId(@SessionId,@ClassId,ROUND((ISNULL(WinterMarks,0)+ISNULL(MidYearSubConvtMarks,0)),0),@SubjectID,@MainExamId)
								,SubjectConvertedMarks=ROUND((WinterMarks+MidYearSubConvtMarks),0)
				FROM [dbo].[Res_MainExamResultSubjectDetails]  sr 
				WHERE  sr.MainExamID = @MainExamId  AND sr.SubjectID = @SubjectId AND sr.StudentIID  IN (SELECT * FROM #StuList)
END
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		ELSE IF(@ClassId = 27 AND ( @SubjectId =35  OR @SubjectId =37 OR @SubjectId =36 ))
		BEGIN
		SET @Percentage=100
			INSERT INTO [dbo].[Res_MainExamResultSubjectDetails]([StudentIID]
           ,[SubjectID],[MainExamId],[SubjectObtMarks] ,
		   WinterMarks
		   ,SubjectConvertedMarks
           ,[SubjectConvertedMarksFraction]
           ,[SubjectGP]
           ,[SubjectGL]
           ,[SubjectHighestMark]
           ,[SubjectIsPass]
           ,[SubjectIsAbsent]
           ,[TotalExamNo]
		   ,[IsECA])
	SELECT StudentIID, SR.SubjectID,SR.MainExamId,SUM(SubExamTotalConv) AS ObtMark
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId, @Percentage ,@TotalExamCount) AS WinterMarks
			,0
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount) AS ConvFracMark
			,dbo.GPCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount)
			,SR.SubjectID,@MainExamId) AS  GP
			, dbo.GLCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(ROUND(SubExamTotalConv,0)),SR.SubjectID,@MainExamId,@Percentage ,@TotalExamCount)
			,SR.SubjectID,@MainExamId) AS  GL
			,0,1,0,0,ISNULL((SELECT  IsECA FROM Res_SubjectSetup WHERE IsECA =1 AND SubID = SR.SubjectID ),0)
	FROM	Res_MERSubExamResult SR
			Inner JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId 
	WHERE  SR.MainExamID = @MainExamId  AND StudentIID IN (SELECT * FROM #StuList) AND SR.SubjectID = @SubjectId and se.IsMidYear=0
	GROUP BY SR.StudentIID, SR.SubjectID  , SR.MainExamId,SE.IsMidYear
						
						UPDATE sr	set SubjectGL=dbo.GLCalculationBySubId(@SessionId,@ClassId,ROUND((ISNULL(WinterMarks,0)),0),@SubjectID,@MainExamId)
								,SubjectConvertedMarks=ROUND((ISNULL(WinterMarks,0)),0)
				FROM [dbo].[Res_MainExamResultSubjectDetails]  sr 
				WHERE  sr.MainExamID = @MainExamId  AND sr.SubjectID = @SubjectId AND sr.StudentIID IN (SELECT * FROM #StuList)
END
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		ELSE IF(@ClassId = 28 AND (@SubjectId =47  OR @SubjectId =48  OR @SubjectId =122))
		BEGIN
		SET @Percentage=100
			INSERT INTO [dbo].[Res_MainExamResultSubjectDetails]([StudentIID]
           ,[SubjectID],[MainExamId],[SubjectObtMarks] ,
		   WinterMarks
		   ,SubjectConvertedMarks
           ,[SubjectConvertedMarksFraction]
           ,[SubjectGP]
           ,[SubjectGL]
           ,[SubjectHighestMark]
           ,[SubjectIsPass]
           ,[SubjectIsAbsent]
           ,[TotalExamNo]
		   ,[IsECA])
	SELECT StudentIID, SR.SubjectID,SR.MainExamId,SUM(SubExamTotalConv) AS ObtMark
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId, @Percentage ,@TotalExamCount) AS WinterMarks
			,0
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount) AS ConvFracMark
			,dbo.GPCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount)
			,SR.SubjectID,@MainExamId) AS  GP
			, dbo.GLCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(ROUND(SubExamTotalConv,0)),SR.SubjectID,@MainExamId,@Percentage ,@TotalExamCount)
			,SR.SubjectID,@MainExamId) AS  GL
			,0,1,0,0,ISNULL((SELECT  IsECA FROM Res_SubjectSetup WHERE IsECA =1 AND SubID = SR.SubjectID ),0)
	FROM	Res_MERSubExamResult SR
			Inner JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId 
	WHERE  SR.MainExamID = @MainExamId  AND StudentIID IN (SELECT * FROM #StuList) AND SR.SubjectID = @SubjectId and se.IsMidYear=0
	GROUP BY SR.StudentIID, SR.SubjectID  , SR.MainExamId,SE.IsMidYear
						
						UPDATE sr	set SubjectGL=dbo.GLCalculationBySubId(@SessionId,@ClassId,ROUND((ISNULL(WinterMarks,0)),0),@SubjectID,@MainExamId)
								,SubjectConvertedMarks=ROUND((ISNULL(WinterMarks,0)),0)
				FROM [dbo].[Res_MainExamResultSubjectDetails]  sr 
				WHERE  sr.MainExamID = @MainExamId  AND sr.SubjectID = @SubjectId AND sr.StudentIID IN (SELECT * FROM #StuList)
END
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------Others
     ELSE
	 		BEGIN
			INSERT INTO [dbo].[Res_MainExamResultSubjectDetails]([StudentIID]
           ,[SubjectID],[MainExamId],[SubjectObtMarks] ,
		   WinterMarks
		   ,SubjectConvertedMarks
           ,[SubjectConvertedMarksFraction]
           ,[SubjectGP]
           ,[SubjectGL]
           ,[SubjectHighestMark]
           ,[SubjectIsPass]
           ,[SubjectIsAbsent]
           ,[TotalExamNo]
		   ,[IsECA])
	SELECT StudentIID, SR.SubjectID,SR.MainExamId,SUM(SubExamTotalConv) AS ObtMark
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId, @Percentage ,@TotalExamCount-1) AS WinterMarks
			,0
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount-1) AS ConvFracMark
			,dbo.GPCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount-1)
			,SR.SubjectID,@MainExamId) AS  GP
			, dbo.GLCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage ,@TotalExamCount-1)
			,SR.SubjectID,@MainExamId) AS  GL
			,0,1,0,0,ISNULL((SELECT  IsECA FROM Res_SubjectSetup WHERE IsECA =1 AND SubID = SR.SubjectID ),0)
	FROM	Res_MERSubExamResult SR
			Inner JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId 
	WHERE  SR.MainExamID = @MainExamId  AND StudentIID IN (SELECT * FROM #StuList) AND SR.SubjectID = @SubjectId and se.IsMidYear=0
	GROUP BY SR.StudentIID, SR.SubjectID  , SR.MainExamId,SE.IsMidYear

	SET @Percentage=60
	PRINT '2'
	UPDATE mrsd SET MidYearSubObtMarks=(
				SELECT SUM(SubExamTotalObt) FROM Res_MERSubExamResult SR
						INNER JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId and se.MainExamId=sr.MainExamId
				WHERE sr.MainExamId=mrsd.MainExamId and sr.SubjectID=mrsd.SubjectID and sr.StudentIID=mrsd.StudentIID and se.IsMidYear=1
			),

			MidYearSubConvtMarks=(
				SELECT  ([dbo].[SubjectwiseMidTotalConv](SR.SubExamTotalObt,sr.SubjectID,sr.MainExamId, @Percentage,@SectionId)) FROM Res_MERSubExamResult SR
						INNER JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId and se.MainExamId=sr.MainExamId
				WHERE sr.MainExamId=mrsd.MainExamId and sr.SubjectID=mrsd.SubjectID and sr.StudentIID=mrsd.StudentIID and se.IsMidYear=1
			)
	FROM [dbo].[Res_MainExamResultSubjectDetails] mrsd
	           WHERE mrsd.MainExamId = @MainExamId AND mrsd.SubjectID = @SubjectId AND mrsd.StudentIID IN(SELECT * FROM #StuList)

			PRINT '3'
				UPDATE sr	set SubjectGL=dbo.GLCalculationBySubId(@SessionId,@ClassId,ROUND((ISNULL(WinterMarks,0)+ISNULL(MidYearSubConvtMarks,0)),0),@SubjectID,@MainExamId)
								,SubjectConvertedMarks=ROUND((ISNULL(WinterMarks,0)+ISNULL(MidYearSubConvtMarks,0)),0)
				FROM [dbo].[Res_MainExamResultSubjectDetails]  sr 
				WHERE  sr.MainExamID = @MainExamId  AND sr.SubjectID = @SubjectId AND sr.StudentIID IN (SELECT * FROM #StuList)
END


END
IF(@termName LIKE '%SUMMER%')
BEGIN
	IF(@BranchId=9 AND @ClassId=27)
	BEGIN
		SELECT @Autumn= MainExamId FROM dbo.Res_MainExam M
		INNER JOIN dbo.Res_Terms t ON t.TermId=m.TermId where UPPER([Name])=UPPER('Autumn(Secondary)')
		and m.ClassId=@ClassId and m.SessionId=@SessionId

		PRINT @Autumn

		SELECT	@Winter= MainExamId FROM dbo.Res_MainExam M
				INNER JOIN dbo.Res_Terms t ON t.TermId=m.TermId 
		WHERE UPPER([Name])=UPPER('Winter(Secondary)')
				AND m.ClassId=@ClassId and m.SessionId=@SessionId
	END
	ELSE
	BEGIN
		SELECT @Autumn= MainExamId FROM dbo.Res_MainExam M
		INNER JOIN dbo.Res_Terms t ON t.TermId=m.TermId where UPPER([Name])=UPPER('Autumn')
		and m.ClassId=@ClassId and m.SessionId=@SessionId

		PRINT @Autumn

		SELECT	@Winter= MainExamId FROM dbo.Res_MainExam M
				INNER JOIN dbo.Res_Terms t ON t.TermId=m.TermId 
		WHERE UPPER([Name])=UPPER('WINTER')
				AND m.ClassId=@ClassId and m.SessionId=@SessionId
	END
	
 
PRINT @Winter
SELECT @TotalExamCount = COUNT(SubExamId) FROM dbo.Res_SubExam WHERE SubjectId=@SubjectId and MainExamId=@MainExamId AND IsDeleted = 0 AND SectionId = @SectionId and IsMidYear=0 and IsFinal=0

SET @AutumnPercentage =10
SET @WinterPercentage =10
IF( @ClassId=21 OR (@ClassId=22 AND @SubjectId<>85) OR (@ClassId=23 AND (@SubjectId=69 OR @SubjectId=70 OR @SubjectId=71 OR @SubjectId=72 OR @SubjectId=73 OR @SubjectId=74 OR @SubjectId=76))
OR (@ClassId=24 AND (@SubjectId=4 OR @SubjectId=5 OR @SubjectId=6 OR @SubjectId=8)) OR (@ClassId=25 AND (@SubjectId=64 OR @SubjectId=65 OR @SubjectId=67))
OR (@ClassId=26 AND @SubjectId=57) OR (@BranchId=8 AND @ClassId=27 AND @SubjectId=35)
OR (@BranchId=9 AND @ClassId=27 AND @SubjectId=35 ) OR (@ClassId=28 AND @SubjectId=47))
	BEGIN
	SET @Percentage=80
	END
ELSE IF((@ClassId=26 AND (@SubjectId=54 OR @SubjectId=55)) OR (@BranchId=8 AND @ClassId=27 AND (@SubjectId=32 OR @SubjectId=33)))
	BEGIN
	SET @Percentage=60
	END
ELSE IF((@ClassId=27 AND @SubjectId=36 ) OR (@ClassId=28 AND @SubjectId=48))
	BEGIN
	SET @Percentage=55
	SET @WinterPercentage =35
	END
--Class 1 and sub ECA

ELSE IF( @SubjectId=9 OR  @SubjectId=37 OR  @SubjectId=59 OR  @SubjectId=68 OR  @SubjectId=77 OR @SubjectId = 85 OR  @SubjectId=122)
	BEGIN
	SET @Percentage=100
	SET @AutumnPercentage =0
	SET @WinterPercentage =0
	END
print '1'
	INSERT INTO [dbo].[Res_MainExamResultSubjectDetails]([StudentIID]
           ,[SubjectID],[MainExamId],[SubjectObtMarks] ,
		   SubjectHighestMark
		   ,SubjectConvertedMarks
           ,[SubjectConvertedMarksFraction]
           ,[SubjectGP]
           ,[SubjectGL]
           ,[SubjectIsPass]
           ,[SubjectIsAbsent]
           ,[TotalExamNo]
		   ,[IsECA])
	SELECT StudentIID, SR.SubjectID,SR.MainExamId,SUM(SubExamTotalConv) AS ObtMark
			, dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId, @Percentage ,@TotalExamCount),0
			, dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount) AS ConvFracMark
			, dbo.GPCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount)
			,SR.SubjectID,@MainExamId) AS  GP
			, dbo.GLCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv (SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage ,@TotalExamCount)
			,SR.SubjectID,@MainExamId) AS  GL
			,1,0,0,ISNULL((SELECT  IsECA FROM Res_SubjectSetup WHERE IsECA =1 AND SubID = SR.SubjectID ),0)
	FROM Res_MERSubExamResult SR
		INNER JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId and se.IsFinal=0
	WHERE  SR.MainExamID = @MainExamId  AND StudentIID IN (SELECT * FROM #StuList) AND SR.SubjectID = @SubjectId and se.IsFinal=0
	GROUP BY SR.StudentIID, SR.SubjectID  , SR.MainExamId,SE.IsFinal



SET @Percentage=60
--EXEC SubjectWiseResultProcess 11,30,39,1058,96,120
IF((@ClassId=30 AND (@SubjectId=94 OR @SubjectId=96 OR @SubjectId=106)) OR @ClassId=31)
BEGIN
	IF (@ClassId=30)
		BEGIN
		SET @Percentage=30
		END
	ELSE
		BEGIN
			SET @TotalExamCount=2
			INSERT INTO [dbo].[Res_MainExamResultSubjectDetails]([StudentIID] ,[SubjectID],[MainExamId],[SubjectObtMarks] , SubjectHighestMark
			,SubjectConvertedMarks ,[SubjectConvertedMarksFraction] ,[SubjectGP] ,[SubjectGL],[SubjectIsPass] ,[SubjectIsAbsent]
			,[TotalExamNo],[IsECA])
			SELECT StudentIID, SR.SubjectID,SR.MainExamId,0 AS ObtMark
			, 0 AS WinterMarks,0
			, 0 AS ConvFracMark
			, dbo.GPCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount)
			,SR.SubjectID,@MainExamId) AS  GP
			, dbo.GLCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv (SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage ,@TotalExamCount)
			,SR.SubjectID,@MainExamId) AS  GL
			,1,0,0,ISNULL((SELECT  IsECA FROM Res_SubjectSetup WHERE IsECA =1 AND SubID = SR.SubjectID ),0)
			FROM Res_MERSubExamResult SR
			INNER JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId and se.IsFinal=1
			WHERE  SR.MainExamID = @MainExamId  AND StudentIID IN (SELECT * FROM #StuList) AND SR.SubjectID = @SubjectId and se.IsFinal=1
			GROUP BY SR.StudentIID, SR.SubjectID  , SR.MainExamId,SE.IsFinal

		SET @Percentage=40
		END
	   

		update mrsd set MidYearSubObtMarks=(
	select SUM(SubExamTotalConv) FROM Res_MERSubExamResult SR
	 Inner JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId and se.MainExamId=sr.MainExamId
	 where sr.MainExamId=mrsd.MainExamId and sr.SubjectID=mrsd.SubjectID and sr.StudentIID=mrsd.StudentIID and se.IsFinal=1  AND MockType='Mock-3'
	),
	FinalYearSubObtMarks2=(
	select SUM(SubExamTotalConv) FROM Res_MERSubExamResult SR
	 Inner JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId and se.MainExamId=sr.MainExamId
	 where sr.MainExamId=mrsd.MainExamId and sr.SubjectID=mrsd.SubjectID and sr.StudentIID=mrsd.StudentIID and se.IsFinal=1  AND MockType='Mock-2'
	),
	MidYearSubConvtMarks=(
	select  (SUM(SubExamTotalConv)*@Percentage)/100 FROM Res_MERSubExamResult SR
	 Inner JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId and se.MainExamId=sr.MainExamId
	 where sr.MainExamId=mrsd.MainExamId and sr.SubjectID=mrsd.SubjectID and sr.StudentIID=mrsd.StudentIID and se.IsFinal=1 AND MockType='Mock-3'
	),
	FinalYearSubConvtMarks2=(
	select  (SUM(SubExamTotalConv)*@Percentage)/100 FROM Res_MERSubExamResult SR
	 Inner JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId and se.MainExamId=sr.MainExamId
	 where sr.MainExamId=mrsd.MainExamId and sr.SubjectID=mrsd.SubjectID and sr.StudentIID=mrsd.StudentIID and se.IsFinal=1 AND MockType='Mock-2'
	),
	WinterMarks=(
	select (ROUND(SubjectConvertedMarks,0)*10)/100 from [dbo].[Res_MainExamResultSubjectDetails] mrs where mrs.StudentIID=mrsd.StudentIID and mrs.SubjectID=mrsd.SubjectID
	and mrs.MainExamId=@Winter
	),
	AutumnMarks=(
	select (ROUND(SubjectConvertedMarks,0)*10)/100 from [dbo].[Res_MainExamResultSubjectDetails] mrs where mrs.StudentIID=mrsd.StudentIID and mrs.SubjectID=mrsd.SubjectID
	and mrs.MainExamId=@Autumn
	)
	from [dbo].[Res_MainExamResultSubjectDetails] mrsd 

	where mrsd.MainExamId=@MainExamId and mrsd.SubjectID=@SubjectId

END


ELSE
BEGIN

	IF((@ClassId=26 AND (@SubjectId=54 OR @SubjectId=55)) OR (@BranchId=8 AND @ClassId=27 AND (@SubjectId=32 OR @SubjectId=33)))
	BEGIN
	SET @Percentage=20
	END
	
	PRINT '2'
	update mrsd set MidYearSubObtMarks=(
	select SUM(SubExamTotalConv) FROM Res_MERSubExamResult SR
	 Inner JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId and se.MainExamId=sr.MainExamId
	 where sr.MainExamId=mrsd.MainExamId and sr.SubjectID=mrsd.SubjectID and sr.StudentIID=mrsd.StudentIID and se.IsFinal=1
	),
	MidYearSubConvtMarks=(
	select  (SUM(SubExamTotalConv)*@Percentage)/100 FROM Res_MERSubExamResult SR
	 Inner JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId and se.MainExamId=sr.MainExamId
	 where sr.MainExamId=mrsd.MainExamId and sr.SubjectID=mrsd.SubjectID and sr.StudentIID=mrsd.StudentIID and se.IsFinal=1
	),
	WinterMarks=(
	select (ROUND(SubjectConvertedMarks,0)*@WinterPercentage)/100 from [dbo].[Res_MainExamResultSubjectDetails] mrs where mrs.StudentIID=mrsd.StudentIID and mrs.SubjectID=mrsd.SubjectID and mrs.SubjectID<> 85
	and mrs.MainExamId=@Winter
	),
	AutumnMarks=(
	select (ROUND(SubjectConvertedMarks,0)*@AutumnPercentage)/100 from [dbo].[Res_MainExamResultSubjectDetails] mrs where mrs.StudentIID=mrsd.StudentIID and mrs.SubjectID=mrsd.SubjectID and mrs.SubjectID<> 85
	and mrs.MainExamId=@Autumn
	)
	from [dbo].[Res_MainExamResultSubjectDetails] mrsd 

	where mrsd.MainExamId=@MainExamId and mrsd.SubjectID=@SubjectId --AND mrsd.SubjectID <> 85 
END

print '3'
 update sr set SubjectConvertedMarksFraction=(isnull(SubjectHighestMark,0)+isnull(MidYearSubConvtMarks,0)+isnull(FinalYearSubConvtMarks2,0))
  from [dbo].[Res_MainExamResultSubjectDetails]  sr 
  WHERE  sr.MainExamID = @MainExamId  AND sr.SubjectID = @SubjectId

   update sr set SubjectGL=dbo.GLCalculationBySubId(@SessionId,@ClassId,(isnull(SubjectConvertedMarksFraction,0)+isnull(WinterMarks,0)+isnull(AutumnMarks,0)),@SubjectID,@MainExamId)
 ,SubjectConvertedMarks=(isnull(SubjectConvertedMarksFraction,0)+isnull(WinterMarks,0)+isnull(AutumnMarks,0))
  from [dbo].[Res_MainExamResultSubjectDetails]  sr 
  WHERE  sr.MainExamID = @MainExamId  AND sr.SubjectID = @SubjectId
END
----------------end Subject Mark Process
END
