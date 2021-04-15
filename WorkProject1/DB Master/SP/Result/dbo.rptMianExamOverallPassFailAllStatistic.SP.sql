/****** Object:  StoredProcedure [dbo].[ProccessMarks]    Script Date: 7/22/2017 @MainExamId:26:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptMianExamOverallPassFailAllStatistic]'))
BEGIN
DROP PROCEDURE  rptMianExamOverallPassFailAllStatistic
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
--  execute [rptMianExamOverallPassFailAllStatistic] '  MainExamId IN (7) AND IsDeleted=0 ',9

CREATE PROCEDURE [dbo].[rptMianExamOverallPassFailAllStatistic]
(
@MainExamIds nvarchar(max),
@SessionId INT
)
AS
BEGIN
	create table #MainExamIds
	(
	ID INT IDENTITY(1,1) NOT NULL,
	[MainExamId] [int]  NOT NULL,
	[MainExamName] [nvarchar](max) NOT NULL,
	[VersionId] [int] NOT NULL,
	[SessionId] [int] NOT NULL,
	[ClassId] [int] NOT NULL,
	[GroupId] [int] NOT NULL,
	)	
	--SELECT * FROM #MainExamIds DROP TABLE #MainExamIds
	declare @Sql nvarchar(Max)
	set @Sql='INSERT INTO #MainExamIds (MainExamId, MainExamName, VersionId, SessionId,ClassId, GroupId)
		      SELECT MainExamId, MainExamName, VersionId, SessionId, ClassId, GroupId FROM Res_MainExam '
		 IF(@MainExamIds IS NOT NULL and  @MainExamIds <> '')
		 BEGIN
	 SET @sql = @sql + ' WHERE '+ @MainExamIds
		 END
	 		  EXEC(@sql)

--DECLARE @MainExamId INT=11, @ClassId INT=11, @GroupId INT=1,@SectionId INT=69
--DECLARE @MainExamId INT=6, @ClassId INT=6, @GroupId INT=0,@SectionId INT=40
--------Overall Statiistics-----------------------------------------------------------------------------------------------------------------
		DECLARE @TotalStudent INT, @TotalExaminee INT, @TotallAbsent INT, @PartialAbsent INT, @TotalPass INT, @TotalFail INT
		DECLARE @PassPer Decimal(18,3) = 0.0, @FailPer Decimal(18,3) = 0.0

		SELECT [StudentIID],[VersionID],[SessionId],[BranchID],[ShiftID],[ClassId],[GroupId],[SectionId],[StudentInsID],[RollNo]
		INTO #STUDENTLIST FROM [dbo].[Student_BasicInfo] WHERE SessionId=@SessionId 
		AND ClassId IN (SELECT ClassId FROM #MainExamIds) AND IsDeleted=0 AND STATUS='A' ORDER BY RollNo

		--SELECT * INTO #MainExamResult FROM [Res_MainExamResult] WHERE MainExamId IN (SELECT MainExamId FROM #MainExamIds) AND StudentIID IN (SELECT [StudentIID] FROM #STUDENTLIST)
		
		SELECT L.VersionID,L.BranchID,L.ClassId,L.GroupId,L.RollNo,L.SessionId,L.ShiftID,L.SectionId,R.* INTO #MainExamResult 
		FROM [Res_MainExamResult] R INNER JOIN #STUDENTLIST L ON R.StudentIID=L.StudentIID			
		WHERE MainExamId IN (SELECT MainExamId FROM #MainExamIds)

		--SELECT COUNT(*) FROM #MainExamResult WHERE ClassId=1 
		
		SELECT @TotalStudent=COUNT(StudentIID) FROM #STUDENTLIST

		SELECT @TotalExaminee=COUNT(StudentIID) FROM #MainExamResult

		SELECT @TotallAbsent=(@TotalStudent-@TotalExaminee),  @TotalPass=COUNT(IsPass) FROM #MainExamResult WHERE IsPass=1

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

	
		

-------Overall Statiistics--------------------------------------------------------------------------------------------------------------------
-------Version & Session Wise Grade Summery AllVersions--------------------------------------------------------------------------------------------------------------
	
	CREATE TABLE #GradeWiseReport
	(
	ID INT IDENTITY(1,1),
	VersionName Varchar(50) NOT NULL,
	ClassID INT,
	ClassName VARCHAR(150) NOT NULL,
	ShiftName Varchar(50) NOT NULL,
	Section Varchar(50) NOT NULL,
	TotalStudent INT NULL,
	Grade VARCHAR(10) NULL,
	Category INT,
	NoOfStudent INT NULL,
	TotalPass INT NULL,
	[Percentages] DECIMAL(18,3) NULL
	)
	INSERT INTO #GradeWiseReport(VersionName,ClassID,ClassName,ShiftName,Section, TotalStudent, Grade,Category, NoOfStudent,TotalPass,[Percentages]) 
	SELECT (SELECT TOP 1 VersionName FROM view_CommonTableNames WHERE VersionId=M.VersionID),
	M.ClassId, (SELECT TOP 1 ClassName FROM view_CommonTableNames WHERE ClassId=M.ClassId),
	(SELECT TOP 1 ShiftName FROM view_CommonTableNames WHERE ShiftId=M.ShiftID),	
	(SELECT TOP 1 SectionName FROM view_CommonTableNames WHERE SectionId=M.SectionId),	
	(SELECT COUNT(StudentIID) FROM #MainExamResult R WHERE StudentIID IN
	(SELECT StudentIID FROM #STUDENTLIST l WHERE l.VersionID=M.VersionID AND l.ClassId=M.ClassId AND l.ShiftID=M.ShiftID AND l.SectionId=M.SectionId))
	,M.GradeLetter,
	CASE 
		WHEN M.GradeLetter='A+' THEN 1
		WHEN M.GradeLetter='A' THEN 2
		WHEN M.GradeLetter='A-' THEN 3
		WHEN M.GradeLetter='B' THEN 4
		WHEN M.GradeLetter='C' THEN 5
		WHEN M.GradeLetter='D' THEN 6
		ELSE 100

		END
	,(SELECT COUNT(StudentIID) FROM #MainExamResult R WHERE R.GradeLetter=M.GradeLetter AND StudentIID IN
	(SELECT StudentIID FROM #STUDENTLIST l WHERE l.VersionID=M.VersionID AND l.ClassId=M.ClassId AND l.ShiftID=M.ShiftID AND l.SectionId=M.SectionId))	
	,(SELECT COUNT(StudentIID) FROM #MainExamResult R WHERE R.IsPass=1 AND StudentIID IN
	(SELECT StudentIID FROM #STUDENTLIST l WHERE l.VersionID=M.VersionID AND l.ClassId=M.ClassId AND l.ShiftID=M.ShiftID AND l.SectionId=M.SectionId))	 
	,(100.00*(SELECT COUNT(StudentIID) FROM #MainExamResult R WHERE R.IsPass=1 AND StudentIID IN
	(SELECT StudentIID FROM #STUDENTLIST l WHERE l.VersionID=M.VersionID AND l.ClassId=M.ClassId AND l.ShiftID=M.ShiftID AND l.SectionId=M.SectionId)))/
	(SELECT COUNT(StudentIID) FROM #MainExamResult R WHERE StudentIID IN
	(SELECT StudentIID FROM #STUDENTLIST l WHERE l.VersionID=M.VersionID AND l.ClassId=M.ClassId AND l.ShiftID=M.ShiftID AND l.SectionId=M.SectionId))		  
	FROM #MainExamResult AS M 	
	WHERE M.SessionID=@SessionId
	GROUP BY M.GradeLetter, M.ClassId, M.VersionID, M.ShiftID, M.SectionId

	--UPDATE #GradeWiseReport SET [Percentages]=(100.00*NoOfStudent)/TotalStudent WHERE Grade='F'
	
	SELECT * FROM #GradeWiseReport
		Declare @GPAMin decimal(10,2)
		Declare @GPAMax decimal(10,2)
	 -------GPRangeWise--------------------------------------------------------------------------------------------------------------------------------
		CREATE TABLE #GPRangeWise
		(
		ID INT IDENTITY(1,1),
		VersionNAME VARCHAR(50) NULL,
		ClassId INT NULL,
		Class nVarchar(max) null,
		GroupName nVarchar(50) null,
		GroupId INT NULL,
		Section nVarchar(50) null,
		SectionId  INT NULL,
		TotalStudent INT NULL,
		GradeRange nVARCHAR(10) NOT NULL,
		Category INT NULL,
		NoOfStudent INT NULL,
		TotalPass INT NULL,
		[Percentages] DECIMAL(18,3) NULL	
		)
	INSERT  INTO #GPRangeWise(VersionNAME,ClassId,Class,GroupName,GroupId,Section,SectionId,TotalStudent,Category,GradeRange,NoOfStudent,TotalPass,[Percentages])
	select	
	V.VersionName,
		C.ClassId,
		C.ClassName,
		G.GroupName,
		G.GroupId,
		SE.SectionName,
		SE.SectionId,
		(SELECT COUNT(StudentIID) FROM #MainExamResult WHERE VersionID=M.VersionID AND ClassId=M.ClassId AND GroupId=M.GroupId AND SectionId=M.SectionId), 
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
		WHEN GPA < 5 AND GPA > 4.74 THEN  4.74
		WHEN GPA < 4.75 AND GPA > 4.49 THEN 4.49
		WHEN GPA < 4.50 AND GPA > 4.24 THEN 4.24
		WHEN GPA < 4.25 AND GPA > 3.99 THEN 3.99
		WHEN GPA < 3.75 AND GPA > 3.49 THEN 3.49
		WHEN GPA < 3.50 AND GPA > 3.24 THEN 3.24
		WHEN GPA < 3.25 AND GPA > 1.99 THEN 1.99
		WHEN GPA < 2.00 AND GPA <> 0 THEN 0
		ELSE 5
		END) ,
		 @GPAMax=( CASE 
		WHEN GPA=5 THEN 5
		WHEN GPA < 5 AND GPA >= 4.75 THEN  5
		WHEN GPA < 4.75 AND GPA >  4.49 THEN 4.75
		WHEN GPA < 4.50 AND GPA >= 4.24 THEN 4.50
		WHEN GPA < 4.25 AND GPA >= 3.99 THEN 4.25
		WHEN GPA < 3.75 AND GPA >= 3.49 THEN 3.75
		WHEN GPA < 3.50 AND GPA >= 3.24 THEN 3.50
		WHEN GPA < 3.25 AND GPA >= 1.99 THEN 3.25
		ELSE 0 END) ,
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
		END),
		 (SELECT COUNT(StudentIID) FROM #MainExamResult WHERE  VersionID=S.VersionID AND ClassId=S.ClassId AND GroupId=S.GroupId AND SectionId=S.SectionId and GPA < @GPAMax AND GPA > @GPAMin  ),
		 (SELECT COUNT(StudentIID) FROM #MainExamResult WHERE IsPass=1 AND VersionID=S.VersionID AND ClassId=S.ClassId AND GroupId=S.GroupId AND SectionId=S.SectionId and GPA < @GPAMax AND GPA > @GPAMin  ),
		 (100.00*(SELECT COUNT(StudentIID) FROM #MainExamResult WHERE IsPass=1 AND VersionID=M.VersionID AND ClassId=M.ClassId AND GroupId=M.GroupId AND SectionId=M.SectionId and GPA < @GPAMax AND GPA > @GPAMin  ))/
		 (SELECT COUNT(StudentIID) FROM #MainExamResult WHERE VersionID=M.VersionID AND ClassId=M.ClassId AND GroupId=M.GroupId AND SectionId=M.SectionId and GPA < @GPAMax AND GPA > @GPAMin  )
		 FROM #MainExamResult M
		 INNER JOIN Student_BasicInfo S ON M.StudentIID = S.StudentIID
		 INNER JOIN Ins_ClassInfo C ON C.ClassId = S.ClassId
		 INNER JOIN Ins_Version V ON V.VersionId = C.VersionId
		 INNER JOIN Ins_Group G ON G.GroupId = S.GroupId
		 INNER JOIN Ins_Section SE ON SE.SectionId = S.SectionId
		WHERE M.MainExamId IN (SELECT MainExamId FROM #MainExamIds)

		ORDER BY Category
			
				--UPDATE #GPRangeWise SET TotalPass=@TotalFail, [Percentages]=100.00 WHERE GradeRange='0'
				   select distinct VersionNAME,Class,GroupName,Section,TotalStudent,GradeRange,Category,NoOfStudent,TotalPass,[Percentages] from #GPRangeWise ORDER BY Class
			  

-------GPRangeWise--------------------------------------------------------------------------------------------------------------------------------
	 
	   DROP TABLE #OverallStatiistics,#STUDENTLIST,#MainExamResult,#GradeWiseReport, #MainExamIds,#GPRangeWise
END


