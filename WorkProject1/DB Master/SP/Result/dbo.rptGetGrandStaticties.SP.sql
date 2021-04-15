/****** Object:  StoredProcedure [dbo].[ProccessMarks]    Script Date: 7/22/2017 @GrandExamId:26:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetGrandStaticties]'))
BEGIN
DROP PROCEDURE  rptGetGrandStaticties
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[rptGetGrandStaticties]
(
@GrandExamId int,
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

		SELECT StudentIID INTO #SID FROM Student_BasicInfo WHERE SectionId =@SectionId

		DECLARE @Max INT , @Count INT =1 , @TotalStudent DECIMAL(10,2) , @FailStudent INT , @PassStudent INT , @PassPer Decimal(10,2) = 0.0

		SELECT @TotalStudent = COUNT(StudentIID)  FROM Student_BasicInfo WHERE ClassId =@ClassId AND GroupId = @GroupId AND Status ='A'
		SELECT @PassStudent = COUNT(StudentIID) FROM [Res_GrandResult] WHERE GrandExamId = @GrandExamId AND IsPass = 1
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
		  SELECT distinct
			'Examinee' As Deatils
			,SD.SubjectID
			,COUNT(GR.Id) AS Total
   
		  FROM [dbo].[Res_GrandResult] GR 
		  INNER JOIN [dbo].[Res_GrandResultSubjectDetails] SD ON GR.GrandExamId = SD.GrandExamId AND GR.StudentIID = SD.StudentIID 
		  INNER JOIN Res_MEResultDetails RD ON RD.MainExamId=GR.GrandExamId AND GR.StudentIID = RD.StudentIID

		  WHERE GR.GrandExamId = @GrandExamId AND SD.SubjectIsAbsent =0
  

		  GROUP BY SD.SubjectID,GR.Id
		  ORDER BY SD.SubjectID


		  INSERT INTO #temp
			SELECT distinct
			'Absent' As Deatils
			,SD.SubjectID
			,COUNT(GR.Id) AS Total
   
		  FROM [dbo].[Res_GrandResult] GR 
		  INNER JOIN [dbo].[Res_GrandResultSubjectDetails] SD ON GR.GrandExamId = SD.GrandExamId AND GR.StudentIID = SD.StudentIID 
		  INNER JOIN Res_MEResultDetails RD ON RD.MainExamId=GR.GrandExamId AND GR.StudentIID = RD.StudentIID
		  WHERE GR.GrandExamId = @GrandExamId AND SD.SubjectIsAbsent =1 AND SD.StudentIID IN (SELECT StudentIID FROM #SID)
		  GROUP BY SD.SubjectID,GR.Id
  
		  IF(@@ROWCOUNT=0)
		  BEGIN
				INSERT INTO #temp SELECT 'Absent' , SubId,0  FROM #temp WHERE Details='Student'
		  END

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
					FROM [dbo].[Res_GrandResultSubjectDetails] SD --ON GR.GrandExamId = SD.GrandExamId AND GR.StudentIID = SD.StudentIID 
					WHERE SD.GrandExamId = @GrandExamId AND SD.SubjectGL =@GL AND SD.StudentIID IN (SELECT StudentIID FROM #SID)
					GROUP BY SD.SubjectID,SD.SubjectGL

					SET @Count = @Count +1
			END

			INSERT INTO #temp
			SELECT distinct
			'Pass' As Deatils
			,SD.SubjectID
			,COUNT(SD.SubjectID) AS Total
   
		  FROM [dbo].[Res_GrandResult] GR 
		  RIGHT JOIN [dbo].[Res_GrandResultSubjectDetails] SD ON GR.GrandExamId = SD.GrandExamId AND GR.StudentIID = SD.StudentIID 
		 
		  WHERE GR.GrandExamId = @GrandExamId AND SD.SubjectIsPass = 1-- AND GR.IsPass =1 
		  AND SD.StudentIID IN (SELECT StudentIID FROM #SID)
		  GROUP BY SD.SubjectID

		  SELECT S.SubjectName, #temp.*,S.ReportSerialNo FROM #temp INNER JOIN Res_SubjectSetup S ON S.SubID = #temp.SubId ORDER BY #temp.ID, S.ReportSerialNo
		 
		SELECT SubjectGP, COUNT(SubjectGP) Total FROM [dbo].[Res_GrandResultSubjectDetails] SD 
		WHERE SD.GrandExamId = @GrandExamId
		GROUP BY SubjectGP 
		ORDER BY SubjectGP DESC

		-------------------------------------------------------------- Summery Report ---------------------------------------------------------

		SELECT @TotalStudent AS TotalStudent,@PassStudent AS PassStudent,@FailStudent AS FailStudent,@PassPer AS PassPer, S.[SubjectName],MS.ExamFullMarks,MS.ExamPassMark, Q.* 
		FROM (
			SELECT  RD.SubjectID , MAX(RD.SubjectHighestMark) AS Highest,MIN(RD.SubjectConvertedMarks) AS Lowest ,
			ISNULL((SELECT COUNT(*) FROM [Res_GrandResultSubjectDetails] WHERE RD.SubjectID =  SubjectID AND SubjectIsPass=0 GROUP BY SubjectID),0) AS Failed
			FROM [Res_GrandResultSubjectDetails] RD
			INNER JOIN Student_BasicInfo ST ON ST.StudentIID = Rd.StudentIID AND ST.Status = 'A'
			WHERE RD.GrandExamId= @GrandExamId
			GROUP BY RD.SubjectID 
		) AS Q
		INNER JOIN Res_SubjectSetup S ON S.SubID = Q.SubjectID
		INNER JOIN Res_GrandExamMarkSetup MS ON MS.ExamSubjectID= Q.SubjectID AND MS.GrandExamId = @GrandExamId
		
		ORDER BY S.ReportSerialNo

		-------------------------------------------------------------- Count Failed ---------------------------------------------------------

		SELECT COUNT(StudentIID) AS NoOfStudent, C AS NoOfFailed 
		FROM (
					SELECT RD.StudentIID, COUNT(RD.SubjectId) AS C 
			FROM Res_GrandResultSubjectDetails RD
			INNER JOIN Res_GrandResult GR ON GR.GrandExamId = RD.GrandExamId ANd GR.StudentIID = RD.StudentIID AND GR.IsPass =0
			INNER JOIN Res_SubjectSetup S ON S.SubID = RD.SubjectID 
			WHERE RD.GrandExamId = @GrandExamId AND RD.SubjectIsPass =0 AND S.NoEffectOnExam = 0 
				GROUP BY RD.StudentIID 
			) AS Q GROUP BY Q.C


		-------------------------------------------------------------- Section Wise Summary -------------------------------------------------
		INSERT INTO #SectionWiseSumm
		SELECT 'Total Student', COUNT(StudentIID)  FROM Student_BasicInfo WHERE ClassId =@ClassId AND GroupId = @GroupId AND SectionId = @SectionId AND Status ='A'
		SELECT @TotalStudent =  COUNT(StudentIID)  FROM Student_BasicInfo WHERE ClassId =@ClassId AND GroupId = @GroupId AND SectionId = @SectionId AND Status ='A'
		
		INSERT INTO #SectionWiseSumm
		SELECT 'Pass Student', COUNT(G.StudentIID)
		FROM [Res_GrandResult] G
		INNER JOIN Student_BasicInfo S ON S.StudentIID= G.StudentIID AND S.SectionId = @SectionId
		WHERE GrandExamId = @GrandExamId AND IsPass = 1
			
		INSERT INTO #SectionWiseSumm
		SELECT 'Pass Student(%)', CEILING(  ((COUNT(G.StudentIID) * 100)/ @TotalStudent ))
		FROM [Res_GrandResult] G
		INNER JOIN Student_BasicInfo S ON S.StudentIID= G.StudentIID AND S.SectionId = @SectionId
		WHERE GrandExamId = @GrandExamId AND IsPass = 1

		INSERT INTO #SectionWiseSumm
		SELECT 'Fail Student', COUNT(G.StudentIID) 
		FROM [Res_GrandResult] G
		INNER JOIN Student_BasicInfo S ON S.StudentIID= G.StudentIID AND S.SectionId = @SectionId
		WHERE GrandExamId = @GrandExamId AND IsPass = 0

		INSERT INTO #SectionWiseSumm
		SELECT 'Fail Student(%)', ((COUNT(G.StudentIID) *100)/@TotalStudent)
		FROM [Res_GrandResult] G
		INNER JOIN Student_BasicInfo S ON S.StudentIID= G.StudentIID AND S.SectionId = @SectionId
		WHERE GrandExamId = @GrandExamId AND IsPass = 0


		  SELECT @Max =COUNT(ID) FROM #tGrade
		  SET @Count  = 1
		 WHILE (@Count <= @Max)
			BEGIN
			
			SELECT @GL = GL FROM #tGrade WHERE ID =  @Count
				INSERT INTO #SectionWiseSumm
				SELECT @GL, COUNT(G.StudentIID) 
				FROM [Res_GrandResult] G
				INNER JOIN Student_BasicInfo S ON S.StudentIID= G.StudentIID AND S.SectionId = @SectionId
				WHERE GrandExamId = @GrandExamId AND G.GradeLetter  =@GL

					SET @Count = @Count +1
			END
		INSERT INTO #SectionWiseSumm
		SELECT C AS NoOfFailed , COUNT(StudentIID) AS NoOfStudent
		FROM (
					SELECT RD.StudentIID, COUNT(RD.SubjectId) AS C 
			FROM Res_GrandResultSubjectDetails RD
			INNER JOIN Res_GrandResult GR ON GR.GrandExamId = RD.GrandExamId ANd GR.StudentIID = RD.StudentIID AND GR.IsPass =0
			INNER JOIN Res_SubjectSetup S ON S.SubID = RD.SubjectID 
			INNER JOIN Student_BasicInfo ST ON ST.StudentIID = RD.StudentIID AND SectionId  =@SectionId
			WHERE RD.GrandExamId = @GrandExamId AND RD.SubjectIsPass =0 AND S.NoEffectOnExam = 0 
				GROUP BY RD.StudentIID 
			) AS Q GROUP BY Q.C


			SELECT  * FROM #SectionWiseSumm
	--	SELECT 	FROM Res_GrandResultSubjectDetails SD				
	-- GROUP BY 

		  DROP table #temp
		  DROP table #tGrade
		  DROP TABLE #SID
		  DROP TABLE #SectionWiseSumm

END
   --  rptGetGrandStaticties 6,6,0,19
	