/****** Object:  StoredProcedure [dbo].[ProccessMarks]    Script Date: 7/22/2017 @GrandExamId:26:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGrandExamOverallPassFailStatistic]'))
BEGIN
DROP PROCEDURE  rptGrandExamOverallPassFailStatistic
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- execute [rptGrandExamOverallPassFailStatistic] ' GrandExamId IN (1,2,3) AND IsDeleted=0 ',1,9
CREATE PROCEDURE [dbo].[rptGrandExamOverallPassFailStatistic]
(
@GrandExamIds nvarchar(max),
@VersionId Int,
@SessionId Int
)

AS
BEGIN
	create table #GrandExamIds
	(
	ID INT IDENTITY(1,1) NOT NULL,
	[GrandExamId] [int]  NOT NULL,
	[GrandExamName] [nvarchar](max) NOT NULL,
	[VersionId] [int] NOT NULL,
	[SessionId] [int] NOT NULL,
	[ClassId] [int] NOT NULL,
	[GroupId] [int] NOT NULL,
	)	
	--SELECT * FROM #GrandExamIds DROP TABLE #GrandExamIds
	declare @Sql nvarchar(Max)
	set @Sql='INSERT INTO #GrandExamIds (GrandExamId, GrandExamName, VersionId, SessionId,ClassId, GroupId)
		      SELECT GrandExamId, GrandExamName, VersionId, SessionId, ClassId, GroupId FROM Res_GrandExam '
		 IF(@GrandExamIds IS NOT NULL and  @GrandExamIds <> '')
		 BEGIN
	 SET @sql = @sql + ' WHERE '+ @GrandExamIds
		 END
	 		  EXEC(@sql)

--DECLARE @GrandExamId INT=11, @ClassId INT=11, @GroupId INT=1,@SectionId INT=69
--DECLARE @GrandExamId INT=6, @ClassId INT=6, @GroupId INT=0,@SectionId INT=40
--------Overall Statiistics-----------------------------------------------------------------------------------------------------------------
		DECLARE @TotalStudent INT, @TotalExaminee INT, @TotallAbsent INT, @PartialAbsent INT, @TotalPass INT, @TotalFail INT
		DECLARE @PassPer Decimal(18,3) = 0.0, @FailPer Decimal(18,3) = 0.0

		SELECT [StudentIID],[VersionID],[SessionId],[BranchID],[ShiftID],[ClassId],[GroupId],[SectionId],[StudentInsID],[RollNo]
		INTO #STUDENTLIST FROM [dbo].[Student_BasicInfo] WHERE VersionID=@VersionId AND SessionId=@SessionId 
		AND ClassId IN (SELECT ClassId FROM #GrandExamIds) AND IsDeleted=0 AND STATUS='A' ORDER BY RollNo

		--SELECT * INTO #GrandExamResult FROM [Res_GrandExamResult] WHERE GrandExamId IN (SELECT GrandExamId FROM #GrandExamIds) AND StudentIID IN (SELECT [StudentIID] FROM #STUDENTLIST)
		
		SELECT L.VersionID,L.BranchID,L.ClassId,L.GroupId,L.RollNo,L.SessionId,L.ShiftID,L.SectionId,R.* INTO #GrandExamResult 
		FROM [Res_GrandResult] R INNER JOIN #STUDENTLIST L ON R.StudentIID=L.StudentIID			
		WHERE GrandExamId IN (SELECT GrandExamId FROM #GrandExamIds)

		--SELECT COUNT(*) FROM #GrandExamResult WHERE ClassId=1 
		
		SELECT @TotalStudent=COUNT(StudentIID) FROM #STUDENTLIST

		SELECT @TotalExaminee=COUNT(StudentIID) FROM #GrandExamResult

		SELECT @TotallAbsent=(@TotalStudent-@TotalExaminee),  @TotalPass=COUNT(IsPass) FROM #GrandExamResult WHERE IsPass=1

		SET @TotalFail=(@TotalExaminee-@TotalPass)
		SET @PassPer = (100.00*@TotalPass)/@TotalExaminee
		SET @FailPer = (100.00*@TotalFail)/@TotalExaminee		

		CREATE TABLE #OverallStatiistics
		(
			ID INT IDENTITY(1,1),
			TotalStudent INT NULL,
			TotalPresent INT NULL,
			TotallAbsent INT NULL,
			TotalPass INT NULL,
			TotalFail INT NULL,
			PassPer DECIMAL(18,3) NULL,	
			FailPer  DECIMAL(18,3) NULL				
		)
		INSERT INTO #OverallStatiistics(TotalStudent,TotalPresent,TotallAbsent,TotalPass,TotalFail,PassPer,FailPer)
		VALUES(CAST(@TotalStudent AS INT),CAST(@TotalExaminee AS INT),CAST(@TotallAbsent AS INT),CAST(@TotalPass AS INT),CAST(@TotalFail AS INT),@PassPer,@FailPer)	
		
		SELECT * FROM #OverallStatiistics
		
		--CREATE TABLE #OverallStatiistics
		--(
		--	ID INT IDENTITY(1,1),
		--	[Property] VARCHAR(50) NOT NULL,
		--	[VALUE] DECIMAL(18,3) NOT NULL			
		--)
		--INSERT INTO #OverallStatiistics SELECT 'Total Student', @TotalStudent
		--INSERT INTO #OverallStatiistics SELECT 'Total Examinee', @TotalExaminee
		--INSERT INTO #OverallStatiistics SELECT 'Totally Absent', @TotallAbsent
		--INSERT INTO #OverallStatiistics SELECT 'Pass', @TotalPass
		--INSERT INTO #OverallStatiistics SELECT 'Fail', @TotalFail
		--INSERT INTO #OverallStatiistics SELECT '% In Pass', @PassPer
		--INSERT INTO #OverallStatiistics SELECT '% In Fail', @FailPer
		--INSERT INTO #OverallStatiistics(TotalStudent,TotalPresent,TotallAbsent,TotalPass,TotalFail,PassPer,FailPer)
		
		

-------Overall Statiistics--------------------------------------------------------------------------------------------------------------------
-------Version & Session Wise Grade Summery Single--------------------------------------------------------------------------------------------------------------
	
	CREATE TABLE #GradeWiseReport
	(
	ID INT IDENTITY(1,1),
	ClassID INT,
	ClassName VARCHAR(150) NOT NULL,
	TotalStudent INT NULL,
	Grade VARCHAR(10) NULL, 
	NoOfStudent INT NULL,
	TotalPass INT NULL,
	[Percentages] DECIMAL(18,3) NULL
	)
	INSERT INTO #GradeWiseReport(ClassID,ClassName,Grade,NoOfStudent) 
	SELECT C.ClassId, C.ClassName, GL,
	(SELECT COUNT(StudentIID) FROM #GrandExamResult R WHERE R.GradeLetter=G.GL AND StudentIID IN ( SELECT StudentIID FROM #STUDENTLIST l WHERE l.ClassId=C.ClassId ) )	 
	FROM Res_GradingSystem AS G INNER JOIN #GrandExamResult AS M ON G.GL=M.GradeLetter
	INNER JOIN Ins_ClassInfo AS C ON G.ClassID=C.ClassId AND G.VersionID=C.VersionId
	WHERE G.SessionID=@SessionId and G.IsDeleted=0 AND G.ClassID IN(SELECT ClassId FROM #GrandExamIds)
	GROUP BY M.GradeLetter, G.GL,C.ClassId,C.ClassName
	--SELECT * FROM #GradeWiseReport	
	UPDATE #GradeWiseReport SET TotalPass=@TotalFail, [Percentages]=100.00 WHERE Grade='F'
	--------sET tOTAL

			DECLARE @INDEX INT=1, @ROW INT =0;
		Create Table #ClassWiseStudent
		(
		ID INT IDENTITY(1,1),
		ClassId INT,
		--TotalStudent INT NULL,	
		--TotalPass INT NULL,
		--[Percentages] DECIMAL(18,3) NULL
		)
		INSERT INTO #ClassWiseStudent (ClassId)
		SELECT distinct ClassId  FROM #STUDENTLIST
		SET @ROW=@@ROWCOUNT

		 WHILE (@INDEX <= @ROW)
		 BEGIN
			DECLARE @NoOfStudent INT =0, @NoOfPassStudent INT=0;
			SELECT @NoOfStudent=Count(*)  FROM #GrandExamResult WHERE 
			StudentIID IN (SELECT StudentIID FROM #STUDENTLIST WHERE ClassId =(SELECT ClassId FROM #ClassWiseStudent WHERE ID=@INDEX))

			SELECT @NoOfPassStudent=Count(*)  FROM #GrandExamResult WHERE IsPass=1 AND
			StudentIID IN (SELECT StudentIID FROM #STUDENTLIST WHERE ClassId =(SELECT ClassId FROM #ClassWiseStudent WHERE ID=@INDEX))

			UPDATE #GradeWiseReport SET TotalStudent=@NoOfStudent, TotalPass=@NoOfPassStudent,
			Percentages=(100*CAST(@NoOfPassStudent AS decimal(18,3)))/CAST(@NoOfStudent AS decimal(18,3))
			WHERE ClassID =(SELECT ClassId FROM #ClassWiseStudent WHERE ID=@INDEX)
			SET @INDEX=@INDEX+1;
		 END		

	--------sET tOTAL	
		SELECT T.* , G.Marks_From FROM #GradeWiseReport T	INNER JOIN Res_GradingSystem G ON T.Grade = G.GL AND T.ClassID = G.ClassID 
		WHERE VersionID = @VersionId AND SessionID = @SessionId 
		ORDER BY G.Marks_From DESC

-------Version & Session Wise Grade Summery Single	--------------------------------------------------------------------------------------------------------------	
-------GPRangeWise--------------------------------------------------------------------------------------------------------------------------------
		
		SELECT
		V.VersionName,
		C.ClassId,
		C.ClassName,
		G.GroupId,
		G.GroupName,
		SE.SectionId,
		SE.SectionName,
		(CASE 
		WHEN GPA=5 THEN 1
		WHEN GPA < 5 AND GPA >= 4.75 THEN 2
		WHEN GPA < 4.75 AND GPA >= 4.50 THEN 3
		WHEN GPA < 4.50 AND GPA >= 4.25 THEN 4
		WHEN GPA < 4.25 AND GPA >= 4.00 THEN 5
		WHEN GPA < 3.75 AND GPA >= 3.50 THEN 6
		WHEN GPA < 3.50 AND GPA >= 3.25 THEN 7
		WHEN GPA < 3.25 AND GPA >= 2.00 THEN 8
		WHEN GPA < 2.00 AND GPA <> 0 THEN 9
		ELSE 100

		END) Category,

		(CASE 
		WHEN GPA=5 THEN '5'
		WHEN GPA < 5 AND GPA >= 4.75 THEN '>= 4.75'
		WHEN GPA < 4.75 AND GPA >= 4.50 THEN '>= 4.50'
		WHEN GPA < 4.50 AND GPA >= 4.25 THEN '>= 4.25'
		WHEN GPA < 4.25 AND GPA >= 4.00 THEN '>= 4.00'
		WHEN GPA < 3.75 AND GPA >= 3.50 THEN '>= 3.50'
		WHEN GPA < 3.50 AND GPA >= 3.25 THEN '>= 3.25'
		WHEN GPA < 3.25 AND GPA >= 2.00 THEN '>= 2.00'
		WHEN GPA < 2.00 AND GPA <> 0 THEN '< 2.00'
		ELSE '0' 

		END) CategoryName,
		R.StudentIID,
		 GPA ,
		 (SELECT COUNT(StudentIID) FROM #GrandExamResult WHERE IsPass=1 AND VersionID=S.VersionID AND ClassId=S.ClassId AND GroupId=S.GroupId AND SectionId=S.SectionId) AS PassStu
		 FROM Res_GrandResult R
		 INNER JOIN Student_BasicInfo S ON R.StudentIID = S.StudentIID
		 INNER JOIN Ins_ClassInfo C ON C.ClassId = S.ClassId
		 INNER JOIN Ins_Version V ON V.VersionId = C.VersionId
		 INNER JOIN Ins_Group G ON G.GroupId = S.GroupId
		 INNER JOIN Ins_Section SE ON SE.SectionId = S.SectionId
		WHERE R.GrandExamId IN (SELECT GrandExamId FROM #GrandExamIds)

		ORDER BY Category
-------GPRangeWise--------------------------------------------------------------------------------------------------------------------------------
	 
	   DROP TABLE #OverallStatiistics,#STUDENTLIST,#GrandExamResult,#GradeWiseReport, #GrandExamIds,#ClassWiseStudent
END


--SELECT * FROM Student_BasicInfo WHERE ClassId=4 AND IsDeleted=0 AND STATUS='A' ORDER BY RollNo
--SELECT * FROM Res_GrandExamResult WHERE GrandExamId= StudentIID=4601
