IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ClassWiseResultProcess]'))
BEGIN
DROP PROCEDURE  ClassWiseResultProcess
END
GO
/****** Object:  StoredProcedure [dbo].[ClassWiseResultProcess]    Script Date: 5/21/2019 3:41:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--  EXEC ClassWiseResultProcess 11,29,38,1056,117
Create Procedure [dbo].[ClassWiseResultProcess]
(
 @SessionId INT=NULL, 
 @ClassId    INT=NULL, 
 @TermId   INT=NULL, 
 @MainExamId   INT=NULL,
 @SectionId   INT=NULL
)
As
BEGIN
-----------start Declare ------------
DECLARE @Count INT = 0
DECLARE  @TermName varchar(MAX),@mgs varchar,@AutumnId int,@WinterId int --@TotalSumMark INT = 0,
-----------end Declare 
--------------
	--SET @TotalSumMark =(select Count(*) from dbo.Res_MainExamMarkSetup where MainExamId=@MainExamId )*100
	--PRINT @TotalSumMark
	SELECT @TermName = [Name] from dbo.Res_Terms where TermId=@TermId
	PRINT @TermName
---------------Start Get Student
	SELECT SS.StudentID INTO #StuList 
	FROM Res_StudentSubject SS INNER JOIN 
	dbo.Student_BasicInfo SB ON SB.StudentIID = SS.StudentID
	WHERE SB.SessionId = @SessionId AND SB.ClassId =  @ClassId AND SB.SectionId = @SectionId AND SB.Status = 'A' AND SB.IsDeleted = 0 AND SS.TermId=@TermId
	
--SELECT * FROM #StuList

---------------End Get Student
SELECT @Count = @@ROWCOUNT
DELETE  FROM Res_MainExamResult 
WHERE  MainExamID = @MainExamId AND StudentIID IN (SELECT * FROM #StuList) 


----------start Autumn
if(@TermName LIKE '%Au%')
BEGIN

	--SELECT dbo.GetStudentTotalSub(SR.StudentIID,@MainExamId) 
	--SELECT * FROM #StuList
	
		INSERT INTO Res_MainExamResult
		SELECT @MainExamId, SR.StudentIID
		,dbo.GPCalculation(@SessionId,@ClassId,(SUM(SR.SubjectConvertedMarks)/dbo.GetStudentTotalSub(SR.StudentIID,@MainExamId))*100,100) AS  GP
		,dbo.GLCalculation(@SessionId,@ClassId,(SUM(SR.SubjectConvertedMarks)/dbo.GetStudentTotalSub(SR.StudentIID,@MainExamId))*100,100) AS  GL
		, SUM(ROUND(SR.SubjectConvertedMarks,0))
		,(CASE 
		WHEN @ClassId=29 OR @ClassId=30 OR @ClassId = 31 THEN(  SUM(ROUND(SR.SubjectConvertedMarks,0)) )
		ELSE( ISNULL((SELECT SUM(SubjectConvertedMarks) FROM Res_MainExamResultSubjectDetails WHERE ISEca =0 AND StudentIID = SR.StudentIID AND MainExamId = @MainExamId ),0))
		END )
		,ROUND(((SUM(SR.SubjectConvertedMarks)/(dbo.GetStudentTotalSub(SR.StudentIID,@MainExamId)))*100),0)
		,(CASE
		WHEN @ClassId=29 OR @ClassId=30 OR @ClassId = 31 THEN (ROUND(((SUM(SR.SubjectConvertedMarks)/(dbo.GetStudentTotalSub(SR.StudentIID,@MainExamId)))*100),0))
		ELSE(ROUND((SELECT (SUM(SubjectConvertedMarks)/(dbo.GetStudentTotalSub(SR.StudentIID,@MainExamId)-100))*100 FROM Res_MainExamResultSubjectDetails WHERE ISEca =0 AND StudentIID = SR.StudentIID AND MainExamId = @MainExamId ),0))
		END
		)
		,(CASE
		WHEN @ClassId=29 OR @ClassId=30 OR @ClassId = 31 THEN (dbo.GLCalculation(@SessionId,@ClassId,(SUM(SR.SubjectConvertedMarks)/dbo.GetStudentTotalSub(SR.StudentIID,@MainExamId))*100,100))
		ELSE(dbo.GLCalculation(@SessionId,@ClassId,(ISNULL((SELECT SUM(SubjectConvertedMarks) FROM Res_MainExamResultSubjectDetails WHERE ISEca =0 AND StudentIID = SR.StudentIID AND MainExamId = @MainExamId ),0)/(dbo.GetStudentTotalSub(SR.StudentIID,@MainExamId)-100))*100,100))
		END
		) AS  GLWECA
		,0
		FROM Res_MainExamResultSubjectDetails SR
		WHERE MainExamID = @MainExamId AND StudentIID IN (SELECT * FROM #StuList) 
		GROUP BY StudentIID, MainExamId
		
END
----------End Autumn
----------start Winter
if(@TermName LIKE '%Win%') -- 	EXEC ClassWiseResultProcess 11,31,20,1038,93

BEGIN
------------------
set @AutumnId=(select top 1 TermId from dbo.Res_Terms where ClassId=@ClassId and SessionId=@SessionId and [Name]='Winter')
PRINT 'Call Winter Section >>>>'
------------------



		INSERT INTO Res_MainExamResult
		SELECT @MainExamId, SR.StudentIID
		,dbo.GPCalculation(@SessionId,@ClassId,(SUM(SR.SubjectConvertedMarks)/dbo.GetStudentTotalSub(SR.StudentIID,@MainExamId))*100,100) AS  GP
		,dbo.GLCalculation(@SessionId,@ClassId,(SUM(SR.SubjectConvertedMarks)/dbo.GetStudentTotalSub(SR.StudentIID,@MainExamId))*100,100) AS  GL
		,ROUND(SUM(SR.SubjectConvertedMarks),0) 
		,(CASE 
		WHEN @ClassId=29 OR @ClassId=30 OR @ClassId = 31 THEN( ROUND(SUM(SR.SubjectConvertedMarks),0) )
		ELSE( ISNULL((SELECT SUM(SubjectConvertedMarks) FROM Res_MainExamResultSubjectDetails WHERE ISEca =0 AND StudentIID = SR.StudentIID AND MainExamId = @MainExamId ),0))
		END )
		,ROUND(((SUM(SR.SubjectConvertedMarks)/(dbo.GetStudentTotalSub(SR.StudentIID,@MainExamId)))*100),0)
		,(CASE
		WHEN @ClassId=29 OR @ClassId=30 OR @ClassId = 31 THEN (ROUND(((SUM(SR.SubjectConvertedMarks)/(dbo.GetStudentTotalSub(SR.StudentIID,@MainExamId)))*100),0))
		ELSE(ROUND((SELECT (SUM(SubjectConvertedMarks)/(dbo.GetStudentTotalSub(SR.StudentIID,@MainExamId)-100))*100 FROM Res_MainExamResultSubjectDetails WHERE ISEca =0 AND StudentIID = SR.StudentIID AND MainExamId = @MainExamId ),0))
		END
		)
		,(CASE
		WHEN @ClassId=29 OR @ClassId=30 OR @ClassId = 31 THEN (dbo.GLCalculation(@SessionId,@ClassId,(SUM(SR.SubjectConvertedMarks)/dbo.GetStudentTotalSub(SR.StudentIID,@MainExamId))*100,100))
		ELSE(dbo.GLCalculation(@SessionId,@ClassId,(ISNULL((SELECT SUM(SubjectConvertedMarks) FROM Res_MainExamResultSubjectDetails WHERE ISEca =0 AND StudentIID = SR.StudentIID AND MainExamId = @MainExamId ),0)/(dbo.GetStudentTotalSub(SR.StudentIID,@MainExamId)-100))*100,100))
		END
		) AS  GLWECA
		,0
		FROM Res_MainExamResultSubjectDetails SR
		WHERE MainExamID = @MainExamId AND StudentIID IN (SELECT * FROM #StuList) 
		GROUP BY StudentIID, MainExamId
END
----------End Winter
----------start Summer
if(@TermName LIKE '%Summer%')
BEGIN
PRINT 'Call Summer Section >>>>'

	
		INSERT INTO Res_MainExamResult
		SELECT @MainExamId, SR.StudentIID
		,dbo.GPCalculation(@SessionId,@ClassId,(SUM(SR.SubjectConvertedMarks)/dbo.GetStudentTotalSub(SR.StudentIID,@MainExamId))*100,100) AS  GP
		,dbo.GLCalculation(@SessionId,@ClassId,(SUM(SR.SubjectConvertedMarks)/dbo.GetStudentTotalSub(SR.StudentIID,@MainExamId))*100,100) AS  GL
		, SUM(ROUND(SR.SubjectConvertedMarks,0))
		,(CASE 
		WHEN @ClassId=29 OR @ClassId=30 OR @ClassId = 31 THEN(  SUM(ROUND(SR.SubjectConvertedMarks,0)) )
		ELSE( ISNULL((SELECT SUM(SubjectConvertedMarks) FROM Res_MainExamResultSubjectDetails WHERE ISEca =0 AND StudentIID = SR.StudentIID AND MainExamId = @MainExamId ),0))
		END )
		,ROUND(((SUM(SR.SubjectConvertedMarks)/(dbo.GetStudentTotalSub(SR.StudentIID,@MainExamId)))*100),0)
		,(CASE
		WHEN @ClassId=29 OR @ClassId=30 OR @ClassId = 31 THEN (ROUND(((SUM(SR.SubjectConvertedMarks)/(dbo.GetStudentTotalSub(SR.StudentIID,@MainExamId)))*100),0))
		ELSE(ROUND((SELECT (SUM(SubjectConvertedMarks)/(dbo.GetStudentTotalSub(SR.StudentIID,@MainExamId)-100))*100 FROM Res_MainExamResultSubjectDetails WHERE ISEca =0 AND StudentIID = SR.StudentIID AND MainExamId = @MainExamId ),0))
		END
		)
		,(CASE
		WHEN @ClassId=29 OR @ClassId=30 OR @ClassId = 31 THEN (dbo.GLCalculation(@SessionId,@ClassId,(SUM(SR.SubjectConvertedMarks)/dbo.GetStudentTotalSub(SR.StudentIID,@MainExamId))*100,100))
		ELSE(dbo.GLCalculation(@SessionId,@ClassId,(ISNULL((SELECT SUM(SubjectConvertedMarks) FROM Res_MainExamResultSubjectDetails WHERE ISEca =0 AND StudentIID = SR.StudentIID AND MainExamId = @MainExamId ),0)/(dbo.GetStudentTotalSub(SR.StudentIID,@MainExamId)-100))*100,100))
		END
		) AS  GLWECA
		,0
		FROM Res_MainExamResultSubjectDetails SR
		WHERE MainExamID = @MainExamId AND StudentIID IN (SELECT * FROM #StuList) 
		GROUP BY StudentIID, MainExamId
		
END
----------End Summer

END