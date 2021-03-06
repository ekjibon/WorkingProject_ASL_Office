/****** Object:  StoredProcedure [dbo].[SP_GetEmpAllInfo]    Script Date: 11/18/2017 6:37:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetResultCheckUp]'))
BEGIN
DROP PROCEDURE  [GetResultCheckUp]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --select * from Res_ClassSubjectConfig  WHERE VersionId =1 AND SessionId = 1017 AND ClassId = 6 AND GroupId = 0
Create Proc [dbo].[GetResultCheckUp] -- GetResultCheckUp 91,1,1017,1,6,0
(
@MainExamId int ,
@VersionId INT ,
@SessionId INT ,
@ShiftId INT,
@ClassId int,
@GroupId int
)
As
BEGIN

	DELETE Res_DividedExamMarkSetup WHERE DividedExamFullMarks = 0 OR DividedExamExamMarks = 0

	DECLARE @TotalStud INT=0,@BranchId INT,
	@TSubject int =0, @TComSub INT =0, @TSelSub INT =0 , @T3rdSub INT =0 , @T4thSub INT =0, @TRelSub INT = 0,
	@Count INT =0 ,@Counter INT =1 , @IsSuccess BIT = 1 , @ErrorMsg VARCHAR(500) 


	CREATE TABLE #StuSubProb 
	(
		StudentId INT ,
		TotalSub INT NULL,
		Com INT NULL,
		Sel INT NULL,
		Forth INT NULL,
		Third INT NULL
	)

	SET @ErrorMsg = ' ';

	SELECT @BranchId  = BranchId FROm Ins_Shift WHERE ShiftId = @ShiftId

	SELECT ROW_NUMBER() OVER(ORDER BY (SELECT Rollno)) AS Id, StudentIID INTO #StuList FROM Student_BasicInfo 
	WHERE VersionID =  @VersionId AND BranchID = @BranchId AND SessionId = @SessionId AND 
	ShiftID = @ShiftId AND   ClassId = @ClassId AND GroupId = @GroupId AND Status = 'A'


	SELECT @TotalStud= COUNT(StudentIID)  FROM Student_BasicInfo WHERE StudentIID IN (SELECT StudentIID FROM #StuList) and SessionId=@SessionId
	

	 select count(StudentID) AS TotalStudent, t.TotalSub INTO #TotalSub from
	 (
	 SELECT StudentID,COUNT(SubjectID) TotalSub FROM Res_StudentSubject 
	 WHERE StudentID IN (SELECT StudentIID from #StuList) AND IsDeleted = 0 and SessionId=@SessionId
	 GROUP BY StudentID
	 ) t
	 group by TotalSub 
	  IF(@@ROWCOUNT=0)
		BEGIN
			SET	@IsSuccess =  0
			SET @ErrorMsg =  ISNULL( @ErrorMsg , '') +  'No Subjects Procces Found!!.' + CHAR(13)+CHAR(10)
		END
	 
	--- Onlyt Error for Compulsary Subject
	  IF (( SELECT  COUNT( Distinct StudentID) FROM Res_StudentSubject  
	 WHERE StudentID IN (SELECT StudentIID from #StuList) AND SubjectType = 'C' AND IsDeleted = 0
	  ) < @TotalStud)
	 BEGIN
			SET	@IsSuccess =  0
			SET @ErrorMsg =  ISNULL( @ErrorMsg , '') +  'All Student Compulsary Subject Not Procced !!.' + CHAR(13)+CHAR(10)
	 END

	SELECT * FROM #TotalSub

	IF EXISTS (SELECT * FROM Res_ClassSubjectConfig WHERE VersionId = @VersionId AND SessionId = @SessionId AND ClassId = @ClassId AND GroupId = @GroupId)
	BEGIN
		
	 SELECT @TSubject = TotalSub ,
			@TComSub = TotalCompolsary,
			@TSelSub = TotalSelective,
			@T3rdSub = TotalThird,
			@T4thSub = TotalForth
			 FROM Res_ClassSubjectConfig WHERE VersionId = @VersionId AND SessionId = @SessionId AND ClassId = @ClassId AND GroupId = @GroupId
			
			 SET @Counter = 1 
			 SELECT @Count = COUNT(*) from #StuList
		WHILE (@Counter <= @Count) --  looping all student and if mismatch found add to error list
		   BEGIN
				DECLARE @StuId  INT ,@STSubject int =0, @STComSub INT , @STSelSub INT , @ST3rdSub INT , @ST4thSub INT
				SELECT @StuId = StudentIID FROM #StuList WHERE Id = @Counter
								 
				SELECT @STSubject =   COUNT(  StudentID) FROM Res_StudentSubject  	 WHERE StudentID = @StuId AND IsDeleted  = 0 and SessionId=@SessionId

				PRINT @StuId

					IF(@STSubject <> @TSubject) -- Total Student Subject Not Match 
					BEGIN
					PRINT '>>'
						IF NOT EXISTS (SELECT * FROM #StuSubProb WHERE StudentId = @StuId)
							INSERT INTO #StuSubProb VALUES(@StuId,@STSubject,NULL,NULL,NULL,NULL)
						ELSE
							UPDATE #StuSubProb SET TotalSub = @STSubject WHERE StudentId = @StuId 
					END

					SELECT @STComSub =   COUNT(  StudentID) FROM Res_StudentSubject  	 WHERE StudentID = @StuId AND SubjectType = 'C' AND IsDeleted  = 0 and SessionId=@SessionId
					IF(@STComSub <> @TComSub) -- If Total Compolsay Subject Not Match 
					BEGIN
						IF NOT EXISTS (SELECT * FROM #StuSubProb WHERE StudentId = @StuId)
							INSERT INTO #StuSubProb VALUES(@StuId,NULL,@STComSub,NULL,NULL,NULL)
						ELSE
							UPDATE #StuSubProb SET Com = @STComSub WHERE StudentId = @StuId
					END

					SELECT @STSelSub =   COUNT(  StudentID) FROM Res_StudentSubject  	 WHERE StudentID = @StuId AND SubjectType = 'S' AND IsDeleted  = 0 and SessionId=@SessionId
					IF(@STSelSub <> @TSelSub ) -- If Total Selective Subject Not Match 
					BEGIN
						IF NOT EXISTS (SELECT * FROM #StuSubProb WHERE StudentId = @StuId)
							INSERT INTO #StuSubProb VALUES(@StuId,NULL,NULL,@STSelSub,NULL,NULL)
						ELSE
							UPDATE #StuSubProb SET Sel = @STSelSub WHERE StudentId = @StuId
					END

					SELECT @ST4thSub =   COUNT(  StudentID) FROM Res_StudentSubject  	 WHERE StudentID = @StuId AND SubjectType in('F','F1','F2') AND IsDeleted  = 0 and SessionId=@SessionId
					IF(@ST4thSub <> @T4thSub ) -- If Total Compolsay Subject Not Match 
					BEGIN
						IF NOT EXISTS (SELECT * FROM #StuSubProb WHERE StudentId = @StuId)
							INSERT INTO #StuSubProb VALUES(@StuId,NULL,NULL,NULL,@ST4thSub,NULL)
						ELSE
							UPDATE #StuSubProb SET Forth = @ST4thSub WHERE StudentId = @StuId
					END

					SELECT @ST3rdSub =   COUNT(  StudentID) FROM Res_StudentSubject  	 WHERE StudentID = @StuId AND SubjectType = 'H' AND IsDeleted  = 0 and SessionId=@SessionId
					IF(@ST3rdSub <> @T3rdSub ) -- If Total Thired Subject Not Match 
					BEGIN
						IF NOT EXISTS (SELECT * FROM #StuSubProb WHERE StudentId = @StuId)
							INSERT INTO #StuSubProb VALUES(@StuId,NULL,NULL,NULL,NULL,@ST3rdSub)
						ELSE
							UPDATE #StuSubProb SET Third = @ST3rdSub WHERE StudentId = @StuId 
					END



				SET @Counter = @Counter + 1
				 
		   END

		  
	END
	ELSE
	BEGIN
		SET	@IsSuccess =  0
		SET @ErrorMsg =  ISNULL( @ErrorMsg , '') +  'Class Subject Not Configured!!.' + CHAR(13)+CHAR(10)
	END
	

	  SELECT @TotalStud AS TotalStud,@TSubject AS TSubject, @TComSub AS TComSub , @TSelSub AS TSelSub , @T3rdSub AS T3rdSub , @T4thSub AS T4thSub , @TRelSub AS TRelSub

	 SELECT  SB.StudentIID, SB.StudentInsID,SB.RollNo,SB.FullName , T.TotalSub,T.Com,T.Sel,T.Forth,T.Third  FROM #StuSubProb T
		   INNER JOIN  Student_BasicInfo SB ON SB.StudentIID = T.StudentID  and  sb.SessionId=@SessionId 
		   IF(@@ROWCOUNT>0)
		BEGIN
			SET	@IsSuccess =  0
			SET @ErrorMsg =  ISNULL( @ErrorMsg , '') +  'Some Error Found in Student Subject List.Please Check!!.' + CHAR(13)+CHAR(10)
		END

		---------------------------------------------------------------------------------------------------------------------------------------

	 --SELECT * FROM Qry_MarkSetup Q WHERE Q.MainExamId =@MainExamId

	 CREATE TABLE #MarksSetup (
	    SubID INT,
		SubjectName VARCHAR(100),
		SubjectType VARCHAR(10),
		ReportSerialNo INT,		
		IsMainExam BIT,
		IsSubExam BIT,
		IsDividedExam BIT
        
      )

	  SELECT ROW_NUMBER() OVER(ORDER BY (SELECT ReportSerialNo)) AS Id, SubID  INTO #Subjects  FROM Res_SubjectSetup 
	  WHERE VersionID = @VersionId AND SessionId = @SessionId AND ClassId = @ClassId AND GroupId =  @GroupId AND IsDeleted =0
	  SELECT @Count = @@ROWCOUNT
	  --SELECT * from #Subjects
	   WHILE (@Counter <= @Count)
	   BEGIN
				DECLARE @SubId int , @IsMainExam BIT = 0 ,@IsSubExam BIT = 0  ,@IsDividedExam BIT = 0 
				SELECT @SubId = SubID FROM #Subjects WHERE Id = @Counter
				INSERT INTO #MarksSetup SELECT SubID, SubjectName, SubjectType,ReportSerialNo,0,0,0 FROM Res_SubjectSetup WHERE SubID = @SubId

				IF  EXISTS(SELECT * FROM Res_MainExamMarkSetup WHERE MainExamSubjectID = @SubId AND MainExamId= @MainExamId)
				BEGIN
						UPDATE #MarksSetup SET IsMainExam =  1 WHERE SubID = @SubId

						
						IF EXISTS(SELECT S.MainExamMarkSetupId FROM  Res_SubExamMarkSetup S INNER JOIN Res_MainExamMarkSetup M ON S.MainExamMarkSetupId = M.Id
						 WHERE M.MainExamId = @MainExamId AND M.MainExamSubjectID =  @SubId AND  M.IsDeleted = 0 AND S.IsDeleted = 0)
						BEGIN
							UPDATE #MarksSetup SET IsSubExam =  1 WHERE SubID = @SubId

							IF EXISTS(SELECT D.SubExamMarkSetupId FROM  Res_SubExamMarkSetup S INNER JOIN Res_MainExamMarkSetup M ON S.MainExamMarkSetupId = M.Id
												INNER JOIN Res_DividedExamMarkSetup D ON D.SubExamMarkSetupId = S.Id
							 WHERE M.MainExamId = @MainExamId AND M.MainExamSubjectID =  @SubId AND  M.IsDeleted = 0 AND S.IsDeleted = 0 AND D.IsDeleted = 0)
								BEGIN
									UPDATE #MarksSetup SET IsDividedExam =  1 WHERE SubID = @SubId
								END
								
						END	
									
				END
				
				


				SET @Counter =  @Counter +1
	   END

	   SELECT * FROM #MarksSetup WHERE IsMainExam = 0 OR IsSubExam = 0  OR IsDividedExam = 0
	   IF(@@ROWCOUNT>0)
		BEGIN
			SET	@IsSuccess =  0
			SET @ErrorMsg =  ISNULL( @ErrorMsg , '') +  'Incomplete marks setup exists .' + CHAR(13)+CHAR(10)
		END

	    ---------------- Mark setup with Zero Value
	   SELECT QM.SubExamId , SE.SubExamName , SE.SubExamOrder , QM.DividedExamId , DE.DividedExamName , DE.DividedExamOrder , QM.DividedExamExamMarks , QM.DividedExamFullMarks
	    FROM Qry_MarkSetup QM 
		  INNER JOIN Res_SubExam SE ON SE.SubExamId = QM.SubExamID
		  INNER JOIN Res_DividedExam DE ON DE.DividedExamId = QM.DividedExamID
		WHERE ( QM.DividedExamExamMarks = 0 OR QM.DividedExamFullMarks = 0 ) AND QM.MainExamId = @MainExamId AND QM.DIsDeleted = 0 
		
		IF(@@ROWCOUNT>0)
		BEGIN
			SET	@IsSuccess =  0
			SET @ErrorMsg =  ISNULL( @ErrorMsg , '') +  ' Mark Setup with Zero value!' + CHAR(13)+CHAR(10)
		END

	   ----------------- Marks Entry 

	   -------- Obtain Marks Greater Than Exam Marks
	   SELECT MM.StudentIID,SB.RollNo,SB.StudentInsID,SB.FullName ,MM.SubExamID,SE.SubExamName,MM.DividedExamID,DE.DividedExamName, MM.SubjectID,SS.SubjectName,SS.ReportSerialNo,MM.ObtainMarks 
	   FROM Res_MainExamMarks MM 
	   INNER JOIN Student_BasicInfo SB ON SB.StudentIID = MM.StudentIID
	   INNER JOIN Res_SubExam SE ON SE.SubExamId = MM.SubExamID
	   INNER JOIN Res_DividedExam DE ON DE.DividedExamId = MM.DividedExamID
	   INNER JOIN Res_SubjectSetup SS ON SS.SubID = MM.SubjectID
	   WHERE MM.StudentIID IN (SELECT StudentIID FROM #StuList)
	   AND	MM.ObtainMarks>(SELECT DividedExamExamMarks from Qry_MarkSetup WHERE MainExamId= @MainExamId AND MainExamSubjectID = MM.SubjectID AND DividedExamId = MM.DividedExamID AND DIsDeleted =0)

	   IF(@@ROWCOUNT>0)
		BEGIN
			SET	@IsSuccess =  0
			SET @ErrorMsg =  ISNULL( @ErrorMsg , '') +  ' OBTAIN MARK is greater than EXAM MARK! ' + CHAR(13)+CHAR(10)
		END

	  ------------ Double Entry Students
		SELECT  T.StudentIID, SB.RollNo,SB.StudentInsID,SB.FullName,SS.SubjectName,SS.ReportSerialNo,DE.DividedExamName FROM 
		(
	  SELECT MM.StudentIID,MM.SubjectID,MM.SubExamID,MM.DividedExamID
	  FROM Res_MainExamMarks MM 	  
	   WHERE MM.StudentIID IN (SELECT StudentIID FROM #StuList)
	   GROUP BY MM.StudentIID,MM.SubjectID,MM.SubExamID,MM.DividedExamID
	   HAVING COUNT(MM.StudentIID)>1
	   ) T  INNER JOIN Student_BasicInfo SB ON SB.StudentIID = T.StudentIID
	    INNER JOIN Res_SubjectSetup SS ON SS.SubID = T.SubjectID
		INNER JOIN Res_DividedExam DE ON DE.DividedExamId = T.DividedExamID

		 IF(@@ROWCOUNT>0)
		BEGIN
			SET	@IsSuccess =  0
			SET @ErrorMsg =  ISNULL( @ErrorMsg , '') +  ' Double Entry marks Found! ' + CHAR(13)+CHAR(10)
		END


		 ------------ Absent With Marks Students
		  SELECT MM.StudentIID,SB.RollNo,SB.StudentInsID,SB.FullName ,MM.SubExamID,SE.SubExamName,MM.DividedExamID,DE.DividedExamName, MM.SubjectID,SS.SubjectName,SS.ReportSerialNo,MM.ObtainMarks 
	   FROM Res_MainExamMarks MM 
	   INNER JOIN Student_BasicInfo SB ON SB.StudentIID = MM.StudentIID
	   INNER JOIN Res_SubExam SE ON SE.SubExamId = MM.SubExamID
	   INNER JOIN Res_DividedExam DE ON DE.DividedExamId = MM.DividedExamID
	   INNER JOIN Res_SubjectSetup SS ON SS.SubID = MM.SubjectID
	   WHERE MM.StudentIID IN (SELECT StudentIID FROM #StuList)
	   AND	MM.ObtainMarks > 0 AND MM.IsAbsent = 1 AND MM.IsDeleted  = 0

	   IF(@@ROWCOUNT>0)
		BEGIN
			SET	@IsSuccess =  0
			SET @ErrorMsg =  ISNULL( @ErrorMsg , '') +  ' INVALID Mark for Absent Student Found!' + CHAR(13)+CHAR(10)
		END

		---------------- Not Inputed Marks


		SELECT T.StudentIID,T.SubjectID, T.DividedExamId, DE.DividedExamName, MEM.ObtainMarks INTO #NOTInMarks FROM
			(
			SELECT SB.StudentIID,SB.StudentInsID,Sb.RollNo, SB.FullName , SS.SubjectID,QM.DividedExamId
			FROM Student_BasicInfo SB 
			INNER JOIN Res_StudentSubject  SS ON SS.StudentID = SB.StudentIID
			INNER JOIN Qry_MarkSetup QM ON QM.MainExamSubjectID = SS.SubjectID and QM.MainExamId=@MainExamId ---MainExamId checked added by Saul 
			WHERE SB.StudentIID IN (SELECT StudentIID FROM #StuList)
			) T LEFT JOIN Res_MainExamMarks MEM ON MEM.SubjectID = T.SubjectID AND MEM.StudentIID =  T.StudentIID AND T.DividedExamId= MEM.DividedExamID
			INNER JOIN Res_DividedExam DE ON DE.DividedExamId = T.DividedExamId
			
		   WHERE MEM.ObtainMarks IS NULL
		
		  
		 --SELECT * FROM #NOTInMarks    ORDER BY StudentIID 

		 SELECT T1.StudentIID,SB.StudentInsID,SB.RollNo,SB.FullName,SS.SubjectName, T1.[DividedExamName] FROM 
		(
			SELECT T.StudentIID,T.SubjectID,
			 [DividedExamName] = STUFF(
					 (SELECT ',' + #NOTInMarks.DividedExamName FROM #NOTInMarks 
					 WHERE #NOTInMarks.StudentIID = T.StudentIID AND #NOTInMarks.SubjectID = T.SubjectID  ORDER BY #NOTInMarks.DividedExamId  FOR XML PATH ('')), 1, 1, ''
				   ) 
			FROM #NOTInMarks T
		  GROUP BY T.StudentIID , T.SubjectID
	  ) T1
	 INNER JOIN Student_BasicInfo SB ON SB.StudentIID = T1.StudentIID
	 INNER JOIN Res_SubjectSetup SS ON SS.SubID = T1.SubjectID AND SS.SubjectType  != 'T'
	 WHERE SB.StudentIID IN (SELECT StudentIID FROM #StuList)
	  ORDER BY T1.StudentIID , SS.ReportSerialNo

	   IF(@@ROWCOUNT>0)
		BEGIN
			SET	@IsSuccess =  0
			SET @ErrorMsg =  ISNULL( @ErrorMsg , '') + ' MARKS have not been placed for the specific subject!' + CHAR(13)+CHAR(10)
		END

	  SELECT TOP 1 @IsSuccess AS IsSuccess,@ErrorMsg AS ErrorMsg, (SELECT MainExamName FROM Res_MainExam WHERE MainExamId  = @MainExamId) AS MainExamName , * 
	  FROM view_CommonTableNames WHERE VersionId = @VersionId AND BranchId = @BranchId AND ShiftId = @ShiftId AND
	   SessionId = @SessionId AND   ClassId = @ClassId AND GroupId =  @GroupId
	  


	  DROP TABLE #MarksSetup
	  DROP TABLE #Subjects
	  DROP TABLE #NOTInMarks
	  DROP TABLE #StuList
END


-- GetResultCheckUp 1005,6,1,0
