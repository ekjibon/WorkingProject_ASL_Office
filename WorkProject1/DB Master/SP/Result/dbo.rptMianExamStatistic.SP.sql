/****** Object:  StoredProcedure [dbo].[ProccessMarks]    Script Date: 7/22/2017 @MainExamId:26:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptMianExamStatistic]'))
BEGIN
DROP PROCEDURE  rptMianExamStatistic
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- execute [rptMianExamStatistic] 13,5,3,54
-- execute [rptMianExamStatistic] 1004,11,1,138
CREATE PROCEDURE [dbo].[rptMianExamStatistic]
(
@MainExamId INT, --6 BAFSK
@ClassId INT,
@GroupId INT,
@SectionId INT
)
AS
BEGIN
--DECLARE @MainExamId INT=11, @ClassId INT=11, @GroupId INT=1,@SectionId INT=69
--DECLARE @MainExamId INT=6, @ClassId INT=6, @GroupId INT=0,@SectionId INT=40
--------Overall Statiistics-----------------------------------------------------------------------------------------------------------------
		DECLARE @TotalStudent INT, @TotalPresent INT, @TotallAbsent INT, @PartialAbsent INT, @TotalPass INT, @TotalFail INT
		DECLARE @PassPer Decimal(18,3) = 0.0, @FailPer Decimal(18,3) = 0.0
		DECLARE @Session INT =0, @Version INT =0;
		SELECT @Session=SessionId, @Version=VersionId FROM Res_MainExam WHERE MainExamId=@MainExamId AND IsDeleted=0

		SELECT [StudentIID],FullName, [VersionID],[SessionId],[BranchID],[ShiftID],[ClassId],[GroupId],[SectionId],[StudentInsID],[RollNo]
		INTO #STUDENTLIST FROM [dbo].[Student_BasicInfo] WHERE VersionID=@Version AND SessionId=@Session AND ClassId=@ClassId AND GroupId=@GroupId AND SectionId=@SectionId 
		AND IsDeleted=0 AND STATUS='A' ORDER BY RollNo
		
		SELECT * INTO #MainExamResult FROM [Res_MainExamResult] WHERE MainExamId=@MainExamId AND StudentIID IN (SELECT [StudentIID] FROM #STUDENTLIST)

		SELECT @TotalStudent=COUNT(StudentIID) FROM #STUDENTLIST

		SELECT @TotalPresent=COUNT(StudentIID) FROM #MainExamResult

		IF(@TotalPresent=0)
		BEGIN
			RETURN 0
		END
		

		SELECT @TotallAbsent=(@TotalStudent-@TotalPresent),  @TotalPass=COUNT(IsPass) FROM #MainExamResult WHERE IsPass=1

		SET @TotalFail=(@TotalPresent-@TotalPass)
		SET @PassPer = (100.00*@TotalPass)/@TotalPresent
		SET @FailPer = (100.00*@TotalFail)/@TotalPresent		

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
		VALUES(CAST(@TotalStudent AS INT),CAST(@TotalPresent AS INT),CAST(@TotallAbsent AS INT),CAST(@TotalPass AS INT),CAST(@TotalFail AS INT),@PassPer,@FailPer)	
		
		SELECT * FROM #OverallStatiistics
		--SELECT CAST( @TotalStudent AS INT),@TotalPresent,@TotallAbsent,@TotalPass,@TotalFail,@PassPer,@FailPer FROM #OverallStatiistics
		

-------Overall Statiistics--------------------------------------------------------------------------------------------------------------------
-------Grade wise  Report (C15)	--------------------------------------------------------------------------------------------------------------
	
	CREATE TABLE #GradeWiseReport
	(
	ID INT IDENTITY(1,1),
	Grade VARCHAR(10) NOT NULL,
	TotalStudent INT NULL,
	TotalPass INT NULL,
	[Percentages] DECIMAL(18,3) NULL
	)
	
	INSERT INTO #GradeWiseReport(Grade,TotalStudent,TotalPass,[Percentages]) 
	select GL, COUNT(StudentIID), @TotalPass, 
	(case when  @TotalPass=0 then  0 ELSE (100.00*COUNT(StudentIID))/@TotalPass END)
	 from Res_GradingSystem AS G INNER JOIN #MainExamResult AS M ON G.GL=M.GradeLetter	
	WHERE ClassId=@ClassId 
	AND SessionID=(select SessionId from Res_MainExam where MainExamId= @MainExamId) 
	and IsDeleted=0 
	GROUP BY M.GradeLetter, G.GL,G.Marks_From, M.IsPass
	ORDER BY G.Marks_From DESC
	UPDATE #GradeWiseReport SET TotalPass=@TotalFail, [Percentages]=(100.00*TotalStudent)/@TotalStudent  WHERE Grade='F'
	
	SELECT * FROM #GradeWiseReport	
-------Grade wise  Report (C15)	--------------------------------------------------------------------------------------------------------------	

-------GPA wise  Report (C15)	--------------------------------------------------------------------------------------------------------------		
	
	CREATE TABLE #GPRangeWise
	(
	ID INT IDENTITY(1,1),
	GradeRange VARCHAR(10) NOT NULL,
	TotalStudent INT NULL,
	TotalPass INT NULL,
	[Percentages] DECIMAL(18,3) NULL	
	)
			IF EXISTS(SELECT * FROM #MainExamResult WHERE GPA=5.00)
			BEGIN
					INSERT INTO #GPRangeWise(GradeRange,TotalStudent,TotalPass,[Percentages])
					(SELECT '5', COUNT(*),@TotalPass,(100.00*COUNT(StudentIID))/@TotalPass FROM #MainExamResult WHERE GPA=5.00)					
			END
			ELSE
			BEGIN 
					INSERT INTO #GPRangeWise(GradeRange,TotalStudent,TotalPass,[Percentages])
					values('5', 0,@TotalPass,0.00)
				
			END

			IF EXISTS(SELECT * FROM #MainExamResult WHERE GPA<5 and GPA>=4.75)
			BEGIN
					INSERT INTO #GPRangeWise(GradeRange,TotalStudent,TotalPass,[Percentages])
					(SELECT '>=4.75', COUNT(*),@TotalPass,(100.00*COUNT(StudentIID))/@TotalPass FROM #MainExamResult WHERE GPA<5 and GPA>=4.75)
			END
			ELSE
			BEGIN 
					INSERT INTO #GPRangeWise(GradeRange,TotalStudent,TotalPass,[Percentages])
					values( '>=4.75',0,@TotalPass,0.00)
			END

			IF EXISTS(SELECT * FROM #MainExamResult WHERE GPA<4.75 and GPA>=4.50)
			BEGIN
					INSERT INTO #GPRangeWise(GradeRange,TotalStudent,TotalPass,[Percentages])
					(SELECT '>=4.50', COUNT(*),@TotalPass,(100.00*COUNT(StudentIID))/@TotalPass FROM #MainExamResult WHERE GPA<4.75 and GPA>=4.50)
			END
			ELSE
			BEGIN 
					INSERT INTO #GPRangeWise(GradeRange,TotalStudent,TotalPass,[Percentages])
					values('>=4.50', 0,@TotalPass,0.00)
			END

			IF EXISTS(SELECT * FROM #MainExamResult WHERE GPA<4.50 and GPA>=4.25)
			BEGIN
					INSERT INTO #GPRangeWise(GradeRange,TotalStudent,TotalPass,[Percentages])
					(SELECT '>=4.25', COUNT(*),@TotalPass,(100.00*COUNT(StudentIID))/@TotalPass FROM #MainExamResult WHERE GPA<4.50 and GPA>=4.25)
			END
			ELSE
			BEGIN 
					INSERT INTO #GPRangeWise(GradeRange,TotalStudent,TotalPass,[Percentages])
					values('>=4.25',0,@TotalPass,0.00)
			END
			
			IF EXISTS(SELECT * FROM #MainExamResult WHERE GPA<4.25 and GPA>=4.00)
			BEGIN
					INSERT INTO #GPRangeWise(GradeRange,TotalStudent,TotalPass,[Percentages])
					(SELECT '>=4.00', COUNT(*),@TotalPass,(100.00*COUNT(StudentIID))/@TotalPass FROM #MainExamResult WHERE GPA<4.25 and GPA>=4.00)
			END
			ELSE
			BEGIN 
					INSERT INTO #GPRangeWise(GradeRange,TotalStudent,TotalPass,[Percentages])
					values('>=4.00',0,@TotalPass,0.00)
			END

			IF EXISTS(SELECT * FROM #MainExamResult WHERE GPA<4.00 and GPA>=3.75)
			BEGIN
					INSERT INTO #GPRangeWise(GradeRange,TotalStudent,TotalPass,[Percentages])
					(SELECT '>=3.75', COUNT(*),@TotalPass,(100.00*COUNT(StudentIID))/@TotalPass FROM #MainExamResult WHERE GPA<4.00 and GPA>=3.75)
			END
			ELSE
			BEGIN 
					INSERT INTO #GPRangeWise(GradeRange,TotalStudent,TotalPass,[Percentages])
					values( '>=3.75',0,@TotalPass,0.00 )
			END
			
			IF EXISTS(SELECT * FROM #MainExamResult WHERE GPA<3.75 and GPA>=3.50)
			BEGIN
					INSERT INTO #GPRangeWise(GradeRange,TotalStudent,TotalPass,[Percentages])
					(SELECT '>=3.50', COUNT(*),@TotalPass,(100.00*COUNT(StudentIID))/@TotalPass FROM #MainExamResult WHERE GPA<3.75 and GPA>=3.50)
			END
			ELSE
			BEGIN 
					INSERT INTO #GPRangeWise(GradeRange,TotalStudent,TotalPass,[Percentages])
					values( '>=3.50', 0,@TotalPass,0.00)
			END
			
			IF EXISTS(SELECT * FROM #MainExamResult WHERE  GPA<3.50 and GPA>=3.25)
			BEGIN
					INSERT INTO #GPRangeWise(GradeRange,TotalStudent,TotalPass,[Percentages])
					(SELECT  '>=3.25', COUNT(*),@TotalPass,(100.00*COUNT(StudentIID))/@TotalPass FROM #MainExamResult WHERE GPA<3.50 and GPA>=3.25)
			END
			ELSE
			BEGIN 
					INSERT INTO #GPRangeWise(GradeRange,TotalStudent,TotalPass,[Percentages])
					values('>=3.25',0,@TotalPass,0.00)
			END
	
			IF EXISTS(SELECT * FROM #MainExamResult WHERE GPA<3.25 and GPA>=3.00)
			BEGIN
					INSERT INTO #GPRangeWise(GradeRange,TotalStudent,TotalPass,[Percentages])
					(SELECT '>=3.00', COUNT(*),@TotalPass,(100.00*COUNT(StudentIID))/@TotalPass FROM #MainExamResult WHERE GPA<3.25 and GPA>=3.00)
			END
			ELSE
			BEGIN 
					INSERT INTO #GPRangeWise(GradeRange,TotalStudent,TotalPass,[Percentages])
					values('>=3.00',0,@TotalPass,0.00 )
			END
			
			IF EXISTS(SELECT * FROM #MainExamResult WHERE GPA<3.00 and GPA>=2.00)
			BEGIN
					INSERT INTO #GPRangeWise(GradeRange,TotalStudent,TotalPass,[Percentages])
					(SELECT '>=2.00', COUNT(*),@TotalPass,(100.00*COUNT(StudentIID))/@TotalPass FROM #MainExamResult WHERE GPA<3.00 and GPA>=2.00)
			END
			ELSE
			BEGIN 
					INSERT INTO #GPRangeWise(GradeRange,TotalStudent,TotalPass,[Percentages])
					values( '>=2.00', 0,@TotalPass,0.00)
			END
			
			IF EXISTS(SELECT * FROM #MainExamResult WHERE GPA<2.00 and GPA>0.00)
			BEGIN
						INSERT INTO #GPRangeWise(GradeRange,TotalStudent,TotalPass,[Percentages])
			(SELECT '< 2', COUNT(*),@TotalPass,(100.00*COUNT(StudentIID))/@TotalPass FROM #MainExamResult WHERE GPA<2.00 and GPA>0.00)
			END
			ELSE
			BEGIN 
					INSERT INTO #GPRangeWise(GradeRange,TotalStudent,TotalPass,[Percentages])
					values( '< 2', 0,@TotalPass,0.00 )
			END
			
			IF EXISTS(SELECT * FROM #MainExamResult WHERE GPA=0.00)
			BEGIN
					INSERT INTO #GPRangeWise(GradeRange,TotalStudent,TotalPass,[Percentages])
					(SELECT '0', COUNT(*),@TotalPass,(100.00*COUNT(StudentIID))/@TotalStudent FROM #MainExamResult WHERE GPA=0.00)
			END
			ELSE
			BEGIN 
					INSERT INTO #GPRangeWise(GradeRange,TotalStudent,TotalPass,[Percentages])
					values('0',0,@TotalPass,0.00)
			END	
		
			--UPDATE #GPRangeWise SET TotalPass=@TotalFail, [Percentages]=100.00 WHERE GradeRange='0'
		   select distinct * from 	#GPRangeWise

				
-------GPA wise  Report (C15)	--------------------------------------------------------------------------------------------------------------		

-------Obtained GPA wise  Report	--------------------------------------------------------------------------------------------------------------	
	
	Create Table #ObtainedGPAwiseReport
	(
	ID INT IDENTITY(1,1),
	GradeRange VARCHAR(10) NOT NULL,
	TotalStudent INT NULL,
	TotalPass INT NULL,
	[Percentages] DECIMAL(18,3) NULL
	)
		INSERT INTO #ObtainedGPAwiseReport(GradeRange,TotalStudent,TotalPass,[Percentages])
		(SELECT DISTINCT M.GPA, COUNT(StudentIID), @TotalPass, (case when  @TotalPass=0 then  0 ELSE (100.00*COUNT(StudentIID))/@TotalPass END)  FROM #MainExamResult AS M  GROUP BY M.GPA)
	    UPDATE #ObtainedGPAwiseReport SET TotalPass=@TotalFail,
		 [Percentages]=(case when @TotalStudent=0 then 0 ELSE (100.00*TotalStudent)/@TotalStudent END ) WHERE GradeRange='0.00'
		SELECT * FROM #ObtainedGPAwiseReport ORDER BY GradeRange DESC
	
-------Obtained GPA wise  Report-----------------------------------------------------------------------------------------------------------------	

-------Subject wise GPA wise  Report--------------------------------------------------------------------------------------------------------------	

	SELECT * INTO #RSDetails FROM .[dbo].[Res_MainExamResultSubjectDetails] 
	WHERE StudentIID IN (SELECT StudentIID FROM #STUDENTLIST)	
						
	Create Table #SubjectwiseGPA
	(
	ID INT IDENTITY(1,1),
	SubjectName VARCHAR(150) NOT NULL,
	Grade VARCHAR(10) NULL,
	TotalStudent INT NULL,
	[TotalPass] INT NULL,
	[Percentages] DECIMAL(18,3) NULL,
	ReportSerialNo INT NULL
	)										
	 INSERT INTO #SubjectwiseGPA(SubjectName,ReportSerialNo, Grade,TotalStudent,TotalPass,[Percentages])
	 SELECT DISTINCT S.SubjectName+''+ CASE WHEN (SELECT COUNT(*) FROM [Res_StudentSubject] AS B INNER JOIN #STUDENTLIST AS L ON B.StudentID=L.StudentIID
	 WHERE SubjectID=D.SubjectID AND SubjectType='F')=0 THEN '' ELSE ' ('+ CAST((SELECT COUNT(*) FROM [Res_StudentSubject] AS B INNER JOIN #STUDENTLIST AS L ON B.StudentID=L.StudentIID
	 WHERE SubjectID=D.SubjectID AND SubjectType='F') AS varchar(10)) +' Student(s) taken as 4th)' END,
	 S.ReportSerialNo,
	 D.SubjectGL, COUNT(StudentIID), 
	(SELECT COUNT(*) FROM #RSDetails WHERE SubjectID = D.SubjectID AND SubjectIsPass=1),
	(CAST(ISNULL((SELECT COUNT(*) FROM #RSDetails WHERE SubjectID = D.SubjectID AND SubjectIsPass=1),0.00)AS decimal(18,3))*100.00)/ (ISNULL((SELECT COUNT(*) FROM #RSDetails WHERE SubjectID = D.SubjectID),0.00))
	FROM #RSDetails D INNER JOIN Res_SubjectSetup S ON D.SubjectID=S.SubID AND S.IsDeleted=0 AND S.SubjectType != 'P' 
	GROUP BY D.SubjectID, S.SubjectName, D.SubjectGL, S.ReportSerialNo
	
	
	SELECT SWG.* , G.Marks_From FROM #SubjectwiseGPA	SWG
	INNER JOIN Res_GradingSystem G ON SWG.Grade = G.GL 
	AND G.VersionID = @Version AND G.SessionID = @Session AND G.ClassID =  @ClassId
	ORDER BY G.Marks_From DESC
	

	---------------SubjectWise Fail List---------------------------------------------------------------------------------------------------------
	Create Table #SubjectwiseFail 
	(
	ID INT IDENTITY(1,1),
	SubjectName VARCHAR(160) NOT NULL,
	TotalStudent INT NULL,	
	[Percentages] DECIMAL(18,3) NULL,
	ReportSerialNo INT NULL
	)
	INSERT INTO #SubjectwiseFail(SubjectName,ReportSerialNo, TotalStudent,[Percentages])
	SELECT DISTINCT S.SubjectName,S.ReportSerialNo,(SELECT COUNT(*) FROM #RSDetails WHERE SubjectID = D.SubjectID AND SubjectIsPass=0),
			(CAST(ISNULL((SELECT COUNT(*) 
			FROM #RSDetails 
			WHERE SubjectID = D.SubjectID 
			AND SubjectIsPass=0),0.00)AS decimal(18,3))*100.00)/(CAST(ISNULL((SELECT COUNT(*) FROM #RSDetails WHERE SubjectID = D.SubjectID),0.00) AS decimal(18,3)))	
	FROM #RSDetails D 
	INNER JOIN Res_SubjectSetup S ON D.SubjectID=S.SubID 
	AND S.IsDeleted=0 AND D.SubjectIsPass=0 
	--GROUP BY D.SubjectID, S.SubjectName	, S.ReportSerialNo
	ORDER BY S.ReportSerialNo
	SELECT * FROM #SubjectwiseFail		ORDER BY ReportSerialNo

	 ---------------SubjectWise Fail List---------------------------------------------------------------------------------------------------------
	 
	 ---------------Fail Statitics---------------------------------------------------------------------------------------------------------
		DECLARE @INDEX INT=1, @ROW INT =0;
		Create Table #FailStatitics
		(
		ID INT IDENTITY(1,1),
		NoOfSubject VARCHAR(160) NOT NULL,
		TotalStudent INT NULL,	
		[Percentages] DECIMAL(18,3) NULL
		)

	 	Create Table #FailSubject
		(
		ID INT IDENTITY(1,1),
		StudentIID BIGINT NOT NULL,
		NoOfSubject INT NULL
		)
		-- comment by Kawsar
			--INSERT INTO #FailSubject (StudentIID)
			--SELECT distinct StudentIID  FROM #RSDetails where SubjectIsPass=0 AND MainExamId = @MainExamId
			--SET @ROW=@@ROWCOUNT
				
		 --WHILE (@INDEX <= @ROW)
		 --BEGIN
			--DECLARE @NoOfSubject INT =0;
			--		IF EXISTS(SELECT IsFailImpact FROM [Res_FouthSubjectRules] WHERE VersionID=@Version AND SessionID=@Session AND ClassID=@ClassId AND GroupID=@GroupId AND IsDeleted=0 AND Status='A' AND IsFailImpact=1)
			--		BEGIN
			--			SELECT @NoOfSubject=Count(*)  FROM #RSDetails where StudentIID=(SELECT StudentIID FROM #FailSubject WHERE ID=@INDEX) and SubjectIsPass=0		
			--		END
			--		ELSE
			--		BEGIN
			--			SELECT @NoOfSubject=Count(*)  FROM #RSDetails where StudentIID=(SELECT StudentIID FROM #FailSubject WHERE ID=@INDEX) and SubjectIsPass=0
			--			AND [SubjectID] NOT IN(SELECT subjectID FROM  [dbo].[Res_StudentSubject] WHERE StudentID=(SELECT StudentIID FROM #FailSubject WHERE ID=@INDEX) and SUBJECTTYPE='F')
			--		END			
			--UPDATE #FailSubject SET NoOfSubject=@NoOfSubject WHERE ID=@INDEX
			--SET @INDEX=@INDEX+1;
		 --END	

		 --INSERT INTO #FailStatitics (NoOfSubject, TotalStudent, [Percentages])
		 -- SELECT Cast(NoOfSubject as varchar(5))+' Sub', Count(*) as st, Cast((100.00*Count(*))/ @TotalPresent AS decimal(18,3))
		 -- FROM #FailSubject GROUP BY NoOfSubject
		 -- --select * from #FailSubject
		 -- SELECT * FROM #FailStatitics

			INSERT INTO #FailStatitics (NoOfSubject, TotalStudent, [Percentages])
			SELECT CAST( ff AS VARCHAR(10)) + ' Sub', COUNT(StudentIID),Cast((100.00*ff)/ @TotalFail AS decimal(18,3)) FROM  (

				SELECT        StudentIID, COUNT( SubjectID) as ff
				FROM            Res_MainExamResultSubjectDetails
				WHERE
				SubjectIsPass = 0 AND
				 StudentIID IN (SELECT StudentIID FROM #STUDENTLIST)
				AND MainExamId = @MainExamId
				GRoUP BY StudentIID
				)  AS T

				GROUP BY ff

		----  SELECT Cast(NoOfSubject as varchar(5))+' Sub', Count(*) as st, Cast((100.00*Count(*))/ @TotalPresent AS decimal(18,3))
		--  FROM #FailSubject GROUP BY NoOfSubject
		  --select * from #FailSubject
		  SELECT * FROM #FailStatitics
---------------------Fail Statitics---------------------------------------------------------------------------------------------------------
---------------------Section Wise_Grade Tab-------------------------------------------------------------------------------------------------
		Create Table #SectionWise_GradeTab
		(
		ID INT IDENTITY(1,1),
		StudentId Varchar(160) NOT NULL,
		FullName Varchar(200) NOT NULL,
		Roll INT NOT NULL,
		SubjectName Varchar(160) NOT NULL,
		SujectMark Decimal(18,3) Null,
		SubjectGL  Varchar(16)  NOT NULL,
		[FourthSubNameGPA] Varchar(160) NOT NULL,
		TotalMark Decimal(18,3) NOT NULL,
		[GPAWith4] Decimal(18,3) NOT NULL,
		[GPAWithout4] Decimal(18,3) NOT NULL,
		[OverallGrade] Varchar(5) NOT NULL,
		NoOfFailSubject INT NULL	,
		ReportSerialNo 	INT NULL	
		)

		INSERT INTO #SectionWise_GradeTab (StudentId,FullName, Roll, SubjectName, SujectMark,SubjectGL, [FourthSubNameGPA], TotalMark, [GPAWith4],[GPAWithout4],[OverallGrade],NoOfFailSubject, ReportSerialNo)
		  SELECT B.[StudentInsID],B.FullName, B.RollNo,S.SubjectName, D.SubjectObtMarks,D.SubjectGL,
		  ISNULL((SELECT TOP 1 S.SubjectName +' (GP '+cast(R.SubjectGP as varchar(10))+')' FROM Res_StudentSubject SS
				 INNER JOIN #RSDetails R ON SS.StudentID=R.StudentIID AND SS.SubjectID=R.SubjectID
				 INNER JOIN Res_SubjectSetup AS S ON SS.SubjectID=S.SubID AND S.SubjectType!='P' AND S.IsFourth=1
				  WHERE SS.StudentID=D.StudentIID AND SS.IsDeleted=0  AND SS.SubjectType='F'),''),
				  R.TotalConvertedMarks, R.GPA, R.GPAWithOut4Sub, R.GradeLetter, 
				  (SELECT NoOfSubject FROM  #FailSubject WHERE StudentIID=R.StudentIID)		 ,
				  S.ReportSerialNo
		  FROM #RSDetails D  INNER JOIN #MainExamResult R ON D.StudentIID=R.StudentIID
		  INNER JOIN #STUDENTLIST B ON D.StudentIID=B.StudentIID
		  INNER JOIN Res_SubjectSetup S ON D.SubjectID=S.SubID 
		  ORDER BY S.ReportSerialNo 

		SELECT * FROM #SectionWise_GradeTab



---------------------Section Wise_Grade Tab-------------------------------------------------------------------------------------------------

	   DROP TABLE #OverallStatiistics,#STUDENTLIST,#MainExamResult,#GradeWiseReport,#GPRangeWise,#ObtainedGPAwiseReport,#SubjectwiseGPA,#RSDetails,#SubjectwiseFail,#SectionWise_GradeTab;
END