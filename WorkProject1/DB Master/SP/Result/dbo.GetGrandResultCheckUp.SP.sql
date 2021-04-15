/****** Object:  StoredProcedure [dbo].[SP_GetEmpAllInfo]    Script Date: 11/18/2017 6:37:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetGrandResultCheckUp]'))
BEGIN
DROP PROCEDURE  [GetGrandResultCheckUp]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [dbo].[GetGrandResultCheckUp] -- GetGrandResultCheckUp 1,1,8,1,1,0
(
@GrandExamId int ,
@VersionId INT ,
@SessionId INT ,
@ShiftId INT,
@ClassId int,
@GroupId int
)
As
BEGIN

DECLARE   @M1  INT = 0 , @M2  INT = 0 , @M3  INT = 0 
DECLARE @TotalStud INT=0,@BranchId INT,
	@TSubject int =0, @TComSub INT =0, @TSelSub INT =0 , @T3rdSub INT =0 , @T4thSub INT =0, @TRelSub INT = 0,
	@Count INT =0 ,@Counter INT =1 , @IsSuccess BIT = 1 , @ErrorMsg VARCHAR(500) , @MainExamCount INT = 0

	SELECT @BranchId  = BranchId FROm Ins_Shift WHERE ShiftId = @ShiftId

	DELETE Res_GrandExamMarkSetup WHERE ExamFullMarks = 0 
	DELETE Res_GrandSubExamMarkSetup WHERE SubExamFullMarks = 0 OR SubExamExamMarks = 0
	DELETE Res_GrandDividedExamMarkSetup WHERE DividedExamFullMarks = 0 OR DividedExamExamMarks = 0

	SELECT ROW_NUMBER() OVER(ORDER BY (SELECT Rollno)) AS Id, StudentIID INTO #StuList FROM Student_BasicInfo 
	WHERE VersionID =  @VersionId AND BranchID = @BranchId AND SessionId = @SessionId AND ShiftID = @ShiftId AND   ClassId = @ClassId AND GroupId = @GroupId AND Status = 'A'
	
	
	select  @MainExamCount=Count(*) from Res_GrandSetup G INNER JOIN Res_MainExam M ON M.MainExamId= G.MainExamId
	  where GrandExamId =@GrandExamId AND G.IsDeleted = 0 AND M.MainExamGrandShowOrder = 1 group by M.MainExamId
	--SELECT * FROM #StuList

	--SELECT TOP 1 * FROM Res_MainExamResult WHERE MainExamId = @M3  AND StudentIID IN (SELECT StudentIID FROM #StuList)

	--First Main Exam 
	select  @M1= G.MainExamId from Res_GrandSetup G INNER JOIN Res_MainExam M ON M.MainExamId= G.MainExamId
	  where GrandExamId =@GrandExamId AND G.IsDeleted = 0 AND M.MainExamGrandShowOrder = 1
	print 'First Main Exam '+ +convert(varchar(100),@M1)
	--Second Main Exam
	select  @M2= G.MainExamId from Res_GrandSetup G INNER JOIN Res_MainExam M ON M.MainExamId= G.MainExamId
	  where GrandExamId =@GrandExamId AND G.IsDeleted = 0 AND M.MainExamGrandShowOrder = 2
	print 'Second Main Exam '+ +convert(varchar(100),@M2)

	--Third Main Exam 
	select  @M3= G.MainExamId from Res_GrandSetup G INNER JOIN Res_MainExam M ON M.MainExamId= G.MainExamId
	  where GrandExamId =@GrandExamId AND G.IsDeleted = 0 AND M.MainExamGrandShowOrder = 3
	print 'Third Main Exam ' +convert(varchar(100),@M3)


	IF(@M1=0 and @MainExamCount >=1 )
	BEGIN
		SET	@IsSuccess =  0
		SET @ErrorMsg =  ISNULL( @ErrorMsg , '') +  'Main Exam 1 is not Found at config. Check Main Exam Order or Is Grand' + CHAR(13)+CHAR(10)
	END
	IF(@M2=0 and @MainExamCount >=2)
	BEGIN
		SET	@IsSuccess =  0
		SET @ErrorMsg =  ISNULL( @ErrorMsg , '') +  'Main Exam 2 is not Found at config. Check Main Exam Order or Is Grand' + CHAR(13)+CHAR(10)
	END
	IF(@M3=0 and @MainExamCount >=3)
	BEGIN
		SET	@IsSuccess =  0
		SET @ErrorMsg =  ISNULL( @ErrorMsg , '') +  'Main Exam 3 is not Found at config. Check Main Exam Order or Is Grand' + CHAR(13)+CHAR(10)
	END
	--Config Checked
	IF (@MainExamCount >=1)
	BEGIN
	IF NOT EXISTS(SELECT TOP 1 * FROM Res_MainExamResult WHERE MainExamId = @M1  AND StudentIID IN (SELECT StudentIID FROM #StuList))
	BEGIN
		SET	@IsSuccess =  0
		SET @ErrorMsg =  ISNULL( @ErrorMsg , '') +  'Main Exam 1 Process not found!!' + CHAR(13)+CHAR(10)
	END
	END
	IF (@MainExamCount >=2)
	BEGIN
	IF NOT EXISTS(SELECT TOP 1 * FROM Res_MainExamResult WHERE MainExamId = @M2  AND StudentIID IN (SELECT StudentIID FROM #StuList))
	BEGIN
		SET	@IsSuccess =  0
		SET @ErrorMsg =  ISNULL( @ErrorMsg , '') +  'Main Exam 2 Process not found!!' + CHAR(13)+CHAR(10)		
	END
	END

	IF (@MainExamCount >=3)
	BEGIN
	IF NOT EXISTS(SELECT TOP 1 * FROM Res_MainExamResult WHERE MainExamId = @M3  and @MainExamCount >=3  AND StudentIID IN (SELECT StudentIID FROM #StuList))
	BEGIN
		SET	@IsSuccess =  0
		SET @ErrorMsg =  ISNULL( @ErrorMsg , '') +  'Main Exam 3 Process not found!!' + CHAR(13)+CHAR(10)		
	END
	END

	-------------------------------------------------------------------------------------------------------------------------------------------------------------------


	CREATE TABLE #StuSubProb 
	(
		StudentId INT ,
		TotalSub INT NULL,
		Com INT NULL,
		Sel INT NULL,
		Forth INT NULL,
		Third INT NULL
	)

	

	SELECT @TotalStud= COUNT(StudentIID)  FROM Student_BasicInfo WHERE StudentIID IN (SELECT StudentIID FROM #StuList)

	

	 CREATE TABLE #MarksSetup (
	    SubID INT,
		SubjectName VARCHAR(100),
		SubjectType VARCHAR(10),
		ReportSerialNo INT,		
		IsGrandExam BIT,
		IsSubExam BIT,
		IsDividedExam BIT,
		IsGrandConfig BIT
        
      )

	  SELECT ROW_NUMBER() OVER(ORDER BY (SELECT ReportSerialNo)) AS Id, SubID  INTO #Subjects  FROM Res_SubjectSetup 
	  WHERE VersionID = @VersionId AND SessionId = @SessionId AND ClassId = @ClassId AND GroupId =  @GroupId AND IsDeleted =0
	  SELECT @Count = @@ROWCOUNT

	  --SELECT * from #Subjects
	  SET @Counter = 1
	   WHILE (@Counter <= @Count)
	   BEGIN
	    
				DECLARE @SubId int , @IsGrandExam BIT = 0 ,@IsSubExam BIT = 0  ,@IsDividedExam BIT = 0 
				SELECT @SubId = SubID FROM #Subjects WHERE Id = @Counter
				PRINT @SubId

				-- Set All subject false
				INSERT INTO #MarksSetup SELECT SubID, SubjectName, SubjectType,ReportSerialNo,0,0,0,0 FROM Res_SubjectSetup WHERE SubID = @SubId

				IF EXISTS(SELECT * FROM Res_GrandConfig WHERE GrandExamId =@GrandExamId AND SubjectId = @SubId )
				BEGIN
					UPDATE #MarksSetup SET IsGrandConfig =  1 WHERE SubID = @SubId
				END

				IF  EXISTS(SELECT * FROM Res_GrandExamMarkSetup WHERE ExamSubjectID = @SubId AND GrandExamId= @GrandExamId)
				BEGIN
						UPDATE #MarksSetup SET IsGrandExam =  1 WHERE SubID = @SubId

						
						IF EXISTS(SELECT S.GrandExamMarkSetupId FROM  Res_GrandSubExamMarkSetup S 
						INNER JOIN Res_GrandExamMarkSetup G ON S.GrandExamMarkSetupId = G.GrandExamMarkSetupId
						WHERE G.GrandExamId = @GrandExamId AND G.ExamSubjectID =  @SubId AND  G.IsDeleted = 0 AND S.IsDeleted = 0)
						BEGIN
							UPDATE #MarksSetup SET IsSubExam =  1 WHERE SubID = @SubId

							IF EXISTS(SELECT D.SubExamMarkSetupId FROM Res_GrandExamMarkSetup G 
							INNER JOIN Res_GrandSubExamMarkSetup S  ON S.GrandExamMarkSetupId = G.GrandExamMarkSetupId
							INNER JOIN Res_GrandDividedExamMarkSetup D ON D.SubExamMarkSetupId = S.GrandSubExamMarkSetupId
							 WHERE G.GrandExamId = @GrandExamId AND G.ExamSubjectID =  @SubId AND  G.IsDeleted = 0 AND S.IsDeleted = 0 AND D.IsDeleted = 0)
								BEGIN
									UPDATE #MarksSetup SET IsDividedExam =  1 WHERE SubID = @SubId
								END
								
						END	
									
				END
				
				


				SET @Counter =  @Counter +1
	   END

	   SELECT * FROM #MarksSetup WHERE IsGrandExam = 0 OR IsSubExam = 0  OR IsDividedExam = 0 OR IsGrandConfig = 0
	   IF(@@ROWCOUNT>0)
		BEGIN
			SET	@IsSuccess =  0
			SET @ErrorMsg =  ISNULL( @ErrorMsg , '') +  'Incomplete marks  setup./ Grand Config Missing. ' + CHAR(13)+CHAR(10)
		END

	   
	   IF NOT EXISTS(SELECT TOP 1 * FROM Res_GrandMeritListConfig WHERE VersionId = @VersionId AND  SessionId = @SessionId AND ClassId =@ClassId AND GroupId = @GroupId)
	BEGIN
		SET	@IsSuccess =  0
		SET @ErrorMsg =  ISNULL( @ErrorMsg , '') +  'Grand Merit  Not Configured!!' + CHAR(13)+CHAR(10)
	END

	 



		  
		

		

	  SELECT TOP 1 @IsSuccess AS IsSuccess,@ErrorMsg AS ErrorMsg, (SELECT GrandExamName  FROM Res_GrandExam WHERE GrandExamId  = @GrandExamId) AS GrandExamName , * 
	  FROM view_CommonTableNames WHERE VersionId = @VersionId AND BranchId = @BranchId AND ShiftId = @ShiftId AND
	   SessionId = @SessionId AND   ClassId = @ClassId AND GroupId =  @GroupId
	  


	  DROP TABLE #MarksSetup
	  DROP TABLE #Subjects
	  DROP TABLE #StuList
END


-- GetGrandResultCheckUp 1005,6,1,0
