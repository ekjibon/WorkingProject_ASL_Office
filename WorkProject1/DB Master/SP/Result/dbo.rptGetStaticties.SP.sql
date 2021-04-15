/****** Object:  StoredProcedure [dbo].[ProccessMarks]    Script Date: 7/22/2017 @MainExamId:26:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetStaticties]'))
BEGIN
DROP PROCEDURE  rptGetStaticties
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
--execute rptGetStaticties 1,,0,23 

CREATE PROCEDURE [dbo].[rptGetStaticties]
(
@MainExamId int,
@ClassId int,
@GroupId INT,
@SectionId int
)
AS
BEGIN

		CREATE TABLE #temp
		(
			ID INT IDENTITY(1,1),
			Details VARCHAR(50),
			SubId INT,
			Total INT
		)

		CREATE TABLE #tGrade
		(
			ID INT IDENTITY(1,1),
			GL VARCHAR(50)
		)

		CREATE TABLE #SectionWiseSumm
		(
			ID INT IDENTITY(1,1),
			Criteria VARCHAR(50),
			TotalStu INT
		)

		CREATE TABLE #GPRengeWise
		(
			GPARang VARCHAR(50),
			TotalStu INT
		)

		SELECT StudentIID INTO #SID FROM Student_BasicInfo WHERE ClassId =@ClassId AND GroupId=@GroupId
		AND (/*For Class Wise*/CASE WHEN (DB_NAME()='mgsc_new_2018')
			THEN SectionId ELSE @SectionId END)=SectionId
		
		SELECT * INTO #Res_MainExamResult FROM Res_MainExamResult 
					WHERE MainExamId=@MainExamId AND StudentIID IN(SELECT StudentIID FROM #SID)


		DECLARE @branch varchar(20),@shift varchar(20),@session varchar(20)
		SELECT 
			TOP(1)
			@branch=b.BranchName
			,@shift=sf.ShiftName
			,@session=ses.SessionName
		FROM Student_BasicInfo stu
		INNER JOIN Ins_Branch b ON stu.BranchID=b.BranchId
		INNER JOIN Ins_Shift sf ON stu.ShiftID=sf.ShiftId
		INNER JOIN Ins_Session ses ON stu.SessionId=ses.SessionId
		WHERE stu.ClassId =@ClassId AND stu.SectionId=@SectionId AND GroupId=@GroupId
		DECLARE @Max INT , @Count INT =1 , @TotalStudent DECIMAL(10,2) , @FailStudent INT , @PassStudent INT , @PassPer Decimal(10,2) = 0.0

		SELECT @TotalStudent = COUNT(StudentIID)  FROM Student_BasicInfo WHERE ClassId =@ClassId AND GroupId = @GroupId AND Status ='A'
		SELECT @PassStudent = COUNT(StudentIID) FROM [Res_MainExamResult] WHERE MainExamId = @MainExamId AND IsPass = 1
		SET  @FailStudent = @TotalStudent - @PassStudent
		SET @PassPer = (@PassStudent * 100)/@TotalStudent


		  INSERT INTO #temp
		  SELECT 
			'Student' As Deatils
			,SS.SubjectID
			,COUNT(SS.SubjectID) AS Total
		  FROM  Res_StudentSubject SS			   
		  WHERE SS.StudentID  IN (SELECT StudentIID FROM #SID)
		  GROUP BY SS.SubjectID
		  ORDER BY SS.SubjectID 



		  INSERT INTO #temp
		  SELECT 
			'Examinee' As Deatils
			,merd.SubjectID
			,COUNT(merd.StudentIID) AS Total
		  FROM  [dbo].[Res_MainExamResultSubjectDetails] merd 
		  WHERE merd.MainExamId=@MainExamId 
		  AND merd.StudentIID IN (SELECT StudentIID FROM #SID)
		  GROUP BY merd.SubjectID


		  INSERT INTO #temp
			SELECT DISTINCT 
			'Absent' As Deatils
			,t.SubId
			,(SELECT Total FROM #temp WHERE Details='Student' AND SubId=t.SubId)
			-ISNULL((SELECT Total FROM #temp WHERE Details='Examinee' AND SubId=t.SubId),0) AS Total
		  FROM #temp t
  
		 
		  INSERT INTO #temp
		  SELECT 
			merd.SubjectGL As Deatils
			,merd.SubjectID
			,COUNT(merd.StudentIID) AS Total
		  FROM  [dbo].[Res_MainExamResultSubjectDetails] merd 
		  WHERE merd.MainExamId=7  AND merd.StudentIID IN (SELECT StudentIID FROM #SID)
		  GROUP BY merd.SubjectID,merd.SubjectGL,merd.SubjectGP
		  ORDER BY merd.SubjectGP desc

		  -------------------- Grade Wise 
		  INSERT INTO #tGrade SELECT GL FROM Res_GradingSystem WHERE ClassID = @ClassId ORDER BY GP DESC

		  SELECT @Max =COUNT(ID) FROM #tGrade

		 WHILE (@Count <= @Max)
			BEGIN
			DECLARE @GL VARCHAR(5)
			SELECT @GL = GL FROM #tGrade WHERE ID =  @Count
					INSERT INTO #temp
					SELECT distinct
					SD.SubjectGL,
					SD.SubjectID,
					COUNT(SD.SubjectID) AS Total		
					FROM [dbo].[Res_MainExamResultSubjectDetails] SD --ON GR.MainExamId = SD.MainExamId AND GR.StudentIID = SD.StudentIID 
					WHERE SD.MainExamId = @MainExamId AND SD.SubjectGL =@GL AND SD.StudentIID IN (SELECT StudentIID FROM #SID)
					GROUP BY SD.SubjectID,SD.SubjectGL

					SET @Count = @Count +1
			END

			INSERT INTO #temp
			SELECT distinct
			'Pass' As Deatils
			,SD.SubjectID
			,COUNT(SD.SubjectID) AS Total
		  FROM #Res_MainExamResult GR 
		  RIGHT JOIN [dbo].[Res_MainExamResultSubjectDetails] SD ON GR.MainExamId = SD.MainExamId AND GR.StudentIID = SD.StudentIID 
		  WHERE GR.MainExamId = @MainExamId AND SD.SubjectIsPass = 1   -- AND GR.IsPass =1 
		  AND SD.StudentIID IN (SELECT StudentIID FROM #SID)
		  GROUP BY SD.SubjectID

		  SELECT S.SubjectName, #temp.*,S.ReportSerialNo FROM #temp INNER JOIN Res_SubjectSetup S ON S.SubID = #temp.SubId 
		  WHERE S.IsDeleted = 0 AND S.ClassId = @ClassId AND S.GroupId = @GroupId
		  ORDER BY  S.ReportSerialNo
		 


		 SELECT SubjectGP,MAX(Total) AS Total,MAX(GPA) as GPA
		 FROM (
					SELECT GL SubjectGP,0 Total,GP GPA FROM [Res_GradingSystem]
					WHERE ClassID=(SELECT TOP(1) ClassID FROM #SID)
					AND SessionID=(SELECT TOP(1) SessionID FROM #SID)
				UNION
					SELECT GradeLetter SubjectGP,COUNT(*) Total,0 GPA FROM #Res_MainExamResult 
					WHERE MainExamId=@MainExamId AND StudentIID IN(SELECT StudentIID FROM #SID)
					GROUP BY GradeLetter
			)
			temp
			GROUP BY SubjectGP
			ORDER BY GPA DESC

		-------------------------------------------------------------- Summery Report ---------------------------------------------------------
		SELECT 
		mr.GPA
		INTO #tgpa 
		FROM #Res_MainExamResult mr 
		WHERE mr.StudentIID IN (SELECT StudentIID FROM #SID) AND mr.MainExamId=@MainExamId
		
		SELECT
			@branch BranchName
			,@shift ShiftName
			,@session SessionName  
			,s.SubjectName 
			,q.MainExamFullMarks  ExamFullMarks
			,q.MainExamPassMark ExamPassMark 
			,d.SubjectHighestMark Highest
			,MIN(d.SubjectConvertedMarks)  Lowest
			,(SELECT COUNT(*) FROM [Res_MainExamResultSubjectDetails] dts WHERE dts.SubjectID=s.SubID AND dts.MainExamId=q.MainExamId and SubjectIsPass=0) AS Failed
			,(SELECT MAX(Total) FROM #temp WHERE Details='Student') TotalStudent
			,(SELECT COUNT(*) FROM #tgpa WHERE GPA>0) PassStudent
			,(SELECT COUNT(*) FROM #tgpa WHERE GPA=0) FailStudent
		FROM Qry_MarkSetup q
		INNER JOIN Res_SubjectSetup s ON q.MainExamSubjectID=s.SubID
		INNER JOIN [Res_MainExamResultSubjectDetails] d ON q.MainExamId=d.MainExamId AND q.MainExamSubjectID=d.SubjectID
		--INNER JOIN Student_BasicInfo stu ON d.StudentIID=stu.StudentIID
		WHERE q.MainExamId=@MainExamId  AND d.StudentIID IN (SELECT StudentIID FROM #SID)
		GROUP BY
			q.MainExamId
			,s.SubID
			,s.SubjectName
			,q.MainExamFullMarks
			,q.MainExamPassMark
			,d.SubjectHighestMark
			,s.ReportSerialNo
		ORDER BY s.ReportSerialNo

		-------------------------------------------------------------- Count Failed ---------------------------------------------------------

		SELECT 
			COUNT(StudentIID) AS NoOfStudent
			,C AS NoOfFailed 
		FROM (
				SELECT  
					d.StudentIID
					,COUNT(d.SubjectID) C
				FROM  [Res_MainExamResultSubjectDetails] d 
				WHERE d.MainExamId=@MainExamId AND d.SubjectIsPass=0
				AND d.StudentIID IN (SELECT StudentIID FROM #SID)
				GROUP BY d.StudentIID 
			) AS Q GROUP BY Q.C


		-------------------------------------------------------------- Section Wise Summary -------------------------------------------------
		INSERT INTO #SectionWiseSumm
		SELECT 'Total Student', COUNT(StudentIID)  FROM Student_BasicInfo WHERE ClassId =@ClassId AND GroupId = @GroupId AND SectionId = @SectionId AND Status ='A'
		SELECT @TotalStudent =  COUNT(StudentIID)  FROM Student_BasicInfo WHERE ClassId =@ClassId AND GroupId = @GroupId AND SectionId = @SectionId AND Status ='A'
		
		INSERT INTO #SectionWiseSumm
		SELECT 'Pass Student', COUNT(G.StudentIID)
		FROM [Res_MainExamResult] G
		INNER JOIN Student_BasicInfo S ON S.StudentIID= G.StudentIID AND S.SectionId = @SectionId
		WHERE MainExamId = @MainExamId AND IsPass = 1
			
		INSERT INTO #SectionWiseSumm
		SELECT 'Pass Student(%)', CEILING(  ((COUNT(G.StudentIID) * 100)/ @TotalStudent ))
		FROM [Res_MainExamResult] G
		INNER JOIN Student_BasicInfo S ON S.StudentIID= G.StudentIID AND S.SectionId = @SectionId
		WHERE MainExamId = @MainExamId AND IsPass = 1

		INSERT INTO #SectionWiseSumm
		SELECT 'Fail Student', COUNT(G.StudentIID) 
		FROM [Res_MainExamResult] G
		INNER JOIN Student_BasicInfo S ON S.StudentIID= G.StudentIID AND S.SectionId = @SectionId
		WHERE MainExamId = @MainExamId AND IsPass = 0

		INSERT INTO #SectionWiseSumm
		SELECT 'Fail Student(%)', ((COUNT(G.StudentIID) *100)/@TotalStudent)
		FROM [Res_MainExamResult] G
		INNER JOIN Student_BasicInfo S ON S.StudentIID= G.StudentIID AND S.SectionId = @SectionId
		WHERE MainExamId = @MainExamId AND IsPass = 0


		  SELECT @Max =COUNT(ID) FROM #tGrade
		  SET @Count  = 1
		 WHILE (@Count <= @Max)
			BEGIN
			
			SELECT @GL = GL FROM #tGrade WHERE ID =  @Count
				INSERT INTO #SectionWiseSumm
				SELECT @GL, COUNT(G.StudentIID) 
				FROM [Res_MainExamResult] G
				INNER JOIN Student_BasicInfo S ON S.StudentIID= G.StudentIID AND S.SectionId = @SectionId
				WHERE MainExamId = @MainExamId AND G.GradeLetter  =@GL

					SET @Count = @Count +1
			END
		INSERT INTO #SectionWiseSumm
		SELECT C AS NoOfFailed , COUNT(StudentIID) AS NoOfStudent
		FROM (
					SELECT RD.StudentIID, COUNT(RD.SubjectId) AS C 
			FROM Res_MainExamResultSubjectDetails RD
			INNER JOIN Res_MainExamResult GR ON GR.MainExamId = RD.MainExamId ANd GR.StudentIID = RD.StudentIID AND GR.IsPass =0
			INNER JOIN Res_SubjectSetup S ON S.SubID = RD.SubjectID 
			INNER JOIN Student_BasicInfo ST ON ST.StudentIID = RD.StudentIID AND SectionId  =@SectionId
			WHERE RD.MainExamId = @MainExamId AND RD.SubjectIsPass =0 AND S.NoEffectOnExam = 0 
				GROUP BY RD.StudentIID 
			) AS Q GROUP BY Q.C

			SELECT  * FROM #SectionWiseSumm

			INSERT INTO #GPRengeWise
			SELECT '5',(SELECT COUNT(*) FROM #Res_MainExamResult WHERE GPA=5.00)
			INSERT INTO #GPRengeWise
			SELECT '>=4.75',(SELECT COUNT(*) FROM #Res_MainExamResult WHERE GPA<5 and GPA>=4.75)
			INSERT INTO #GPRengeWise
			SELECT '>=4.50',(SELECT COUNT(*) FROM #Res_MainExamResult WHERE GPA<4.75 and GPA>=4.50)
			INSERT INTO #GPRengeWise
			SELECT '>=4.25',(SELECT COUNT(*) FROM #Res_MainExamResult WHERE GPA<4.50 and GPA>=4.25)
			INSERT INTO #GPRengeWise
			SELECT '>=4.00',(SELECT COUNT(*) FROM #Res_MainExamResult WHERE GPA<4.25 and GPA>=4.00)
			INSERT INTO #GPRengeWise
			SELECT '>=3.75',(SELECT COUNT(*) FROM #Res_MainExamResult WHERE GPA<4.00 and GPA>=3.75)
			INSERT INTO #GPRengeWise
			SELECT '>=3.50',(SELECT COUNT(*) FROM #Res_MainExamResult WHERE GPA<3.75 and GPA>=3.50)
			INSERT INTO #GPRengeWise
			SELECT '>=3.25',(SELECT COUNT(*) FROM #Res_MainExamResult WHERE GPA<3.50 and GPA>=3.25)
			INSERT INTO #GPRengeWise
			SELECT '>=3.00',(SELECT COUNT(*) FROM #Res_MainExamResult WHERE GPA<3.25 and GPA>=3.00)
			INSERT INTO #GPRengeWise
			SELECT '>=2.00',(SELECT COUNT(*) FROM #Res_MainExamResult WHERE GPA<3.00 and GPA>=2.00)

			SELECT * FROM #GPRengeWise

			SELECT 
			(SELECT MAX(Total) FROM #temp WHERE Details='Student') TotalStudent
			,(SELECT COUNT(*) FROM #Res_MainExamResult) TotalExaminee
			,(SELECT COUNT(*) FROM #Res_MainExamResult Where GPA>0) Success
			,(SELECT COUNT(*) FROM #Res_MainExamResult Where GPA=0) Fail
			,(((SELECT COUNT(*) FROM #Res_MainExamResult Where GPA>0)*100)/(SELECT COUNT(*) FROM #Res_MainExamResult)) PassPercenage
			,(((SELECT COUNT(*) FROM #Res_MainExamResult Where GPA=0)*100)/(SELECT COUNT(*) FROM #Res_MainExamResult)) FailPercentage
		  DROP table #temp,#tGrade,#SID,#SectionWiseSumm,#tgpa,#Res_MainExamResult,#GPRengeWise
END

  --execute rptGetStaticties 5,5,0,29

--SubjectwiseGrade&Fail
--	SELECT 
--distinct s.SubjectName, (select count(distinct [StudentIID]) from [Res_MainExamResultSubjectDetails] where SubjectGL='A' and SubjectID=rd.SubjectID ) as A,
--(select count(distinct [StudentIID]) from [Res_MainExamResultSubjectDetails] where SubjectGL='A+' and SubjectID=rd.SubjectID ) as [A+],
--(select count(distinct [StudentIID]) from [Res_MainExamResultSubjectDetails] where SubjectGL='A-' and SubjectID=rd.SubjectID ) as [A-],
--(select count(distinct [StudentIID]) from [Res_MainExamResultSubjectDetails] where SubjectGL='B' and SubjectID=rd.SubjectID ) as [B],
--(select count(distinct [StudentIID]) from [Res_MainExamResultSubjectDetails] where SubjectGL='C' and SubjectID=rd.SubjectID ) as [C],
--(select count(distinct [StudentIID]) from [Res_MainExamResultSubjectDetails] where SubjectGL='D' and SubjectID=rd.SubjectID ) as [D],
--(select count(distinct [StudentIID]) from [Res_MainExamResultSubjectDetails] where SubjectGL='F' and SubjectID=rd.SubjectID ) as [F]
--FROM [mgsc_new_2018].[dbo].[Res_MainExamResultSubjectDetails] as rd inner join Res_SubjectSetup as s on rd.SubjectID=s.SubID where s.ClassId=3 and s.GroupId=0
--SubjectwiseGrade&Fail