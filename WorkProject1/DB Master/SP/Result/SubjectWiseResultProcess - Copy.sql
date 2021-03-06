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
-- EXEC SubjectWiseResultProcess 11,24,6,1020,1,97
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
DECLARE @Count INT = 0,@termName varchar(max),@Percentage int,@TotalExamCount int,@Autumn int , @Winter int
-----------------end Declare 
	SELECT top 1 @termName = [Name] from dbo.Res_Terms where TermId=@TermId

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
	WHERE SB.SessionId = @SessionId AND SB.ClassId =  @ClassId AND S.SubjectID = @SubjectId AND SB.SectionId = @SectionId

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
				((dbo.SubExamtotalConv(MM.ObtainMarks,MM.SubjectID,MM.MainExamID,MM.SubExamID))),
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
		GROUP BY SR.StudentIID, SR.SubjectID  , SR.MainExamId,SE.IsMidYear
	
END
if(@termName like '%WINTER%')
BEGIN
PRINT 'WINTER'

		SELECT * FROM Res_MERSubExamResult SR
				INNER JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId 
		WHERE  SR.MainExamID = @MainExamId  AND StudentIID IN (SELECT * FROM #StuList) AND SR.SubjectID = @SubjectId 

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
			,dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId, @Percentage ,@TotalExamCount-1) AS WinterMarks,0
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
	FROM [dbo].[Res_MainExamResultSubjectDetails] mrsd

PRINT '3'
	UPDATE sr	set SubjectGL=dbo.GLCalculationBySubId(@SessionId,@ClassId,(WinterMarks+MidYearSubConvtMarks),@SubjectID,@MainExamId)
					,SubjectConvertedMarks=(WinterMarks+MidYearSubConvtMarks)
	FROM [dbo].[Res_MainExamResultSubjectDetails]  sr 
	WHERE  sr.MainExamID = @MainExamId  AND sr.SubjectID = @SubjectId

END
IF(@termName LIKE '%SUMMER%')
BEGIN
	SELECT @Autumn= MainExamId FROM dbo.Res_MainExam M
	INNER JOIN dbo.Res_Terms t ON t.TermId=m.TermId where UPPER([Name])=UPPER('Autumn')
	and m.ClassId=@ClassId and m.SessionId=@SessionId

PRINT @Autumn

	SELECT	@Winter= MainExamId FROM dbo.Res_MainExam M
			INNER JOIN dbo.Res_Terms t ON t.TermId=m.TermId 
	WHERE UPPER([Name])=UPPER('WINTER')
			AND m.ClassId=@ClassId and m.SessionId=@SessionId
 
PRINT @Winter

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
			, dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId, @Percentage ,@TotalExamCount-1) AS WinterMarks,0
			, dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount-1) AS ConvFracMark
			, dbo.GPCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv(SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage,@TotalExamCount-1)
			,SR.SubjectID,@MainExamId) AS  GP
			, dbo.GLCalculationBySubId(@SessionId,@ClassId,
			dbo.SubjectwiseTotalConv (SUM(SubExamTotalConv),SR.SubjectID,@MainExamId,@Percentage ,@TotalExamCount-1)
			,SR.SubjectID,@MainExamId) AS  GL
			,1,0,0,ISNULL((SELECT  IsECA FROM Res_SubjectSetup WHERE IsECA =1 AND SubID = SR.SubjectID ),0)
	FROM Res_MERSubExamResult SR
		INNER JOIN dbo.Res_SubExam SE on se.SubExamId=sr.SubExamId and se.IsFinal=0
	WHERE  SR.MainExamID = @MainExamId  AND StudentIID IN (SELECT * FROM #StuList) AND SR.SubjectID = @SubjectId and se.IsFinal=0
	GROUP BY SR.StudentIID, SR.SubjectID  , SR.MainExamId,SE.IsFinal

SET @Percentage=60

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
select (SubjectConvertedMarks*10)/100 from [dbo].[Res_MainExamResultSubjectDetails] mrs where mrs.StudentIID=mrsd.StudentIID and mrs.SubjectID=mrsd.SubjectID
and mrs.MainExamId=@Winter
),
AutumnMarks=(
select (SubjectConvertedMarks*10)/100 from [dbo].[Res_MainExamResultSubjectDetails] mrs where mrs.StudentIID=mrsd.StudentIID and mrs.SubjectID=mrsd.SubjectID
and mrs.MainExamId=@Autumn
)
from [dbo].[Res_MainExamResultSubjectDetails] mrsd 

where mrsd.MainExamId=@MainExamId and mrsd.SubjectID=@SubjectId


print '3'
 update sr set SubjectConvertedMarksFraction=(SubjectHighestMark+MidYearSubConvtMarks)
  from [dbo].[Res_MainExamResultSubjectDetails]  sr 
  WHERE  sr.MainExamID = @MainExamId  AND sr.SubjectID = @SubjectId

   update sr set SubjectGL=dbo.GLCalculationBySubId(@SessionId,@ClassId,(SubjectConvertedMarksFraction+WinterMarks+AutumnMarks),@SubjectID,@MainExamId)
 ,SubjectConvertedMarks=(SubjectConvertedMarksFraction+WinterMarks+AutumnMarks)
  from [dbo].[Res_MainExamResultSubjectDetails]  sr 
  WHERE  sr.MainExamID = @MainExamId  AND sr.SubjectID = @SubjectId
END
----------------end Subject Mark Process
END
