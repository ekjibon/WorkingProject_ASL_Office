/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetGrandExamFailList]'))
BEGIN
DROP PROCEDURE  rptGetGrandExamFailList
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kawsar
-- Create date: 
-- Description:	
-- =============================================
--execute [dbo].[rptGetGrandExamFailList] 7,1,5,41
Create PROCEDURE [dbo].[rptGetGrandExamFailList] 
	-- Add the parameters for the stored procedure here
	
	@GrandExamId int,
	@VersionId INT=NULL,
	@ShiftId INT=NULL,
	@SectionId INT=NULL

AS
BEGIN
 DECLARE @GS1  INT =0, @GS2 INT = 0, @GS3 INT  =0 , @ClassId INT , @GroupId INT 
--First Grand Sub Exam 
	select top 1 @GS1= GrandSubExamId from Res_GrandSubExam where GrandExamId =@GrandExamId AND IsDeleted = 0
	print 'Grand Sub Exam1 '+ +convert(varchar(100),@GS1)

	--Second Grand Sub Exam 
	select   @GS2= GrandSubExamId from Res_GrandSubExam where GrandExamId =@GrandExamId AND IsDeleted = 0 ORDER BY GrandSubExamId ASC
		 OFFSET 1 ROWS  
		FETCH NEXT 1 ROW ONLY
	print 'Grand Sub Exam2 '+ +convert(varchar(100),@GS2)

	select   @GS3= GrandSubExamId from Res_GrandSubExam where GrandExamId =@GrandExamId AND IsDeleted = 0 ORDER BY GrandSubExamId ASC
		 OFFSET 2 ROWS  
		FETCH NEXT 1 ROW ONLY
	print 'Grand Sub Exam3 '+ +convert(varchar(100),@GS3)

	DECLARE @MId INT 
	SELECT @MId = MainExamId,@ClassId =[ClassId] , @GroupId = GroupId FROM Res_GrandMeritListConfig
	WHERE [ClassId]= (SELECT ClassId FROM Ins_Section WHERE SectionId = @SectionId)
	AND [GroupId] = (SELECT GroupId FROM Ins_Section WHERE SectionId = @SectionId)
	AND IsDeleted = 0

DECLARE @OrderBy VARCHAR(500), @Sql varchar(max),@WhereClause varchar(max) , @MaxCount INT , @Count int =1
DECLARE @SubName varchar(100),@SubObt decimal(10,2), @StuId BIGINT ,@SubID INT , @TotalStudent INT , @FailStudent INT , @PassStudent DECIMAL(10,2) , @PassPer Decimal(10,2) = 0.0
	
		SELECT @TotalStudent = COUNT(StudentIID)  FROM Student_BasicInfo WHERE SectionId =@SectionId AND Status='A' and IsDeleted=0 -- AND GroupId = @GroupId

		SELECT @PassStudent = COUNT(R.StudentIID) FROM [Res_GrandResult] R
		INNER JOIN Student_BasicInfo S ON S.StudentIID = R.StudentIID
		WHERE GrandExamId = @GrandExamId AND S.SectionId =@SectionId AND IsPass =1
		SET  @FailStudent = @TotalStudent - @PassStudent
		SET @PassPer = (@PassStudent * 100)/ISNULL( @TotalStudent,0)

			CREATE TABLE #temp
			(
				StuIID BIGINT ,
				FailSubjects Varchar(Max),
				Total decimal(10,2),
				TotalFail int,
				Position INT
			)
			CREATE TABLE #ResultDeatils
			(
				Id INT IDENTITY(1,1),
				SubID BIGINT ,
				SubjectName Varchar(100),
				SubjectObtMarks decimal(10,2),
				StudentIID BIGINT
			)

			INSERT INTO #temp(StuIID,FailSubjects,Total,TotalFail,Position)
			SELECT S.StudentIID,'',R.TotalConvertedMarks,0,0

			FROM [dbo].[Res_GrandResult] R INNER JOIN Student_BasicInfo S ON S.StudentIID = R.StudentIID AND s.Status='A' and s.IsDeleted=0
			WHERE R.GrandExamId = @GrandExamId 
			AND S.VersionID = COALESCE(@VersionId,S.VersionID)
			AND S.ShiftID = COALESCE(@ShiftId,S.ShiftID)
			AND S.SectionId = COALESCE(@SectionId,S.SectionId)
			AND R.IsPass = 0

			PRINT 'Total Fail :' + CAST(@@ROWCOUNT AS VARCHAR)

			INSERT INTO #ResultDeatils
			SELECT S.SubID, S.SubjectName, SD.SubjectConvertedMarks as SubjectObtMarks,SD.StudentIID

			FROM [dbo].[Res_GrandResultSubjectDetails] SD 
			INNER JOIN Res_SubjectSetup S ON S.SubID = SD.SubjectID AND S.NoEffectOnExam = 0
			INNER JOIN Student_BasicInfo ST ON ST.StudentIID = SD.StudentIID AND ST.ShiftID =@ShiftId AND ST.SectionId = @SectionId and st.IsDeleted=0 and st.Status='A'
			INNER JOIN Res_StudentSubject SS ON SS.StudentID  = SD.StudentIID AND SS.SubjectID = SD.SubjectID AND SS.SubjectType<>'F'
			INNER JOIN #temp T ON T.StuIID = SD.StudentIID
			WHERE Sd.GrandExamId =  @GrandExamId AND SD.SubjectIsPass = 0  

			IF( (DB_Name())='eusc_new_2018')
			BEGIN
				INSERT INTO #ResultDeatils
				SELECT S.SubID, S.SubjectName, MSD.SubjectConvertedMarks as SubjectObtMarks,MSD.StudentIID
	
				FROM Res_MainExamResultSubjectDetails MSD 
				INNER JOIN Res_SubjectSetup S ON S.SubID = MSD.SubjectID 
	
				WHERE MSD.MainExamId =  @MId AND MSD.SubjectIsPass = 0

			END
			SELECT @MaxCount = COUNT(*) FROM #ResultDeatils
			PRINT @MaxCount
			 WHILE (@Count <= @MaxCount)
				BEGIN
				 SELECT @SubID =SubID, @StuId = StudentIID , @SubName = SubjectName,@SubObt = SubjectObtMarks  FROM #ResultDeatils WHERE Id = @Count
					SET @SubName = @SubName + '(' + CAST(@SubObt AS varchar)+ ')'
		
					print @SubID
					IF(@GS1!=0 OR @GS1 IS NOT NULL)
					BEGIN
		
						SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_GrandDividedExam WHERE GrandSubExamId=@GS1  AND DividedExamType='W1')
						+ '-(' + CAST( WrittenObt1 AS varchar) +')'
						  FROM Res_GrandResultMarksDetails WHERE WrittenIsPass1 =0 AND SubjectID =@SubID AND StudentIID = @StuId AND GrandSubExamId =@GS1 
			
						SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_GrandDividedExam WHERE GrandSubExamId=@GS1  AND DividedExamType='W2')
						+ '-(' + CAST( WrittenObt2 AS varchar) +')'
						  FROM Res_GrandResultMarksDetails WHERE WrittenIsPass3 =0 AND SubjectID =@SubID AND StudentIID = @StuId AND GrandSubExamId =@GS1 

						  SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_GrandDividedExam WHERE GrandSubExamId=@GS1  AND DividedExamType='W2')
						+ '-(' + CAST( WrittenObt3 AS varchar) +')'
						  FROM Res_GrandResultMarksDetails WHERE WrittenIsPass3 =0 AND SubjectID =@SubID AND StudentIID = @StuId AND GrandSubExamId =@GS1 

						SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_GrandDividedExam WHERE GrandSubExamId=@GS1  AND DividedExamType='S')
						+ '-(' + CAST( SubjectiveObt AS varchar) +')'
						  FROM Res_GrandResultMarksDetails WHERE SubjectiveIsPass =0 AND SubjectID =@SubID AND StudentIID = @StuId AND GrandSubExamId =@GS1 

						SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_GrandDividedExam WHERE GrandSubExamId=@GS1  AND DividedExamType='O')
						+ '-(' + CAST( ObjectiveObt AS varchar) +')'
						  FROM Res_GrandResultMarksDetails WHERE ObjectiveIsPass =0 AND SubjectID =@SubID AND StudentIID = @StuId AND GrandSubExamId =@GS1 

						  SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_GrandDividedExam WHERE GrandSubExamId=@GS1  AND DividedExamType='P')
						+ '-(' + CAST( PracticalObt AS varchar) +')'
						  FROM Res_GrandResultMarksDetails WHERE PracticalIsPass =0 AND SubjectID =@SubID AND StudentIID = @StuId AND GrandSubExamId =@GS1

						--PRINT @SubName
					END
					IF(@GS2!=0 OR @GS2 IS NOT NULL)
					BEGIN
		
						SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_GrandDividedExam WHERE GrandSubExamId=@GS2  AND DividedExamType='W1')
						+ '-(' + CAST( WrittenObt1 AS varchar) +')'
						  FROM Res_GrandResultMarksDetails WHERE WrittenIsPass1 =0 AND SubjectID =@SubID AND StudentIID = @StuId AND GrandSubExamId =@GS2 
			
						SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_GrandDividedExam WHERE GrandSubExamId=@GS2  AND DividedExamType='W2')
						+ '-(' + CAST( WrittenObt2 AS varchar) +')'
						  FROM Res_GrandResultMarksDetails WHERE WrittenIsPass3 =0 AND SubjectID =@SubID AND StudentIID = @StuId AND GrandSubExamId =@GS2 

						  SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_GrandDividedExam WHERE GrandSubExamId=@GS2  AND DividedExamType='W2')
						+ '-(' + CAST( WrittenObt3 AS varchar) +')'
						  FROM Res_GrandResultMarksDetails WHERE WrittenIsPass3 =0 AND SubjectID =@SubID AND StudentIID = @StuId AND GrandSubExamId =@GS2 

						SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_GrandDividedExam WHERE GrandSubExamId=@GS2  AND DividedExamType='S')
						+ '-(' + CAST( SubjectiveObt AS varchar) +')'
						  FROM Res_GrandResultMarksDetails WHERE SubjectiveIsPass =0 AND SubjectID =@SubID AND StudentIID = @StuId AND GrandSubExamId =@GS2 

						SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_GrandDividedExam WHERE GrandSubExamId=@GS2  AND DividedExamType='O')
						+ '-(' + CAST( ObjectiveObt AS varchar) +')'
						  FROM Res_GrandResultMarksDetails WHERE ObjectiveIsPass =0 AND SubjectID =@SubID AND StudentIID = @StuId AND GrandSubExamId =@GS2 

						  SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_GrandDividedExam WHERE GrandSubExamId=@GS2  AND DividedExamType='P')
						+ '-(' + CAST( PracticalObt AS varchar) +')'
						  FROM Res_GrandResultMarksDetails WHERE PracticalIsPass =0 AND SubjectID =@SubID AND StudentIID = @StuId AND GrandSubExamId =@GS2

						--
					END
					IF(@GS3!=0 OR @GS3 IS NOT NULL)
					BEGIN
		
						SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_GrandDividedExam WHERE GrandSubExamId=@GS3  AND DividedExamType='W1')
						+ '-(' + CAST( WrittenObt1 AS varchar) +')'
						  FROM Res_GrandResultMarksDetails WHERE WrittenIsPass1 =0 AND SubjectID =@SubID AND StudentIID = @StuId AND GrandSubExamId =@GS3 
			
						SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_GrandDividedExam WHERE GrandSubExamId=@GS3  AND DividedExamType='W2')
						+ '-(' + CAST( WrittenObt2 AS varchar) +')'
						  FROM Res_GrandResultMarksDetails WHERE WrittenIsPass3 =0 AND SubjectID =@SubID AND StudentIID = @StuId AND GrandSubExamId =@GS3 

						  SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_GrandDividedExam WHERE GrandSubExamId=@GS3  AND DividedExamType='W2')
						+ '-(' + CAST( WrittenObt3 AS varchar) +')'
						  FROM Res_GrandResultMarksDetails WHERE WrittenIsPass3 =0 AND SubjectID =@SubID AND StudentIID = @StuId AND GrandSubExamId =@GS3 

						SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_GrandDividedExam WHERE GrandSubExamId=@GS3  AND DividedExamType='S')
						+ '-(' + CAST( SubjectiveObt AS varchar) +')'
						  FROM Res_GrandResultMarksDetails WHERE SubjectiveIsPass =0 AND SubjectID =@SubID AND StudentIID = @StuId AND GrandSubExamId =@GS3 

						SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_GrandDividedExam WHERE GrandSubExamId=@GS3  AND DividedExamType='O')
						+ '-(' + CAST( ObjectiveObt AS varchar) +')'
						  FROM Res_GrandResultMarksDetails WHERE ObjectiveIsPass =0 AND SubjectID =@SubID AND StudentIID = @StuId AND GrandSubExamId =@GS3 

						  SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_GrandDividedExam WHERE GrandSubExamId=@GS3  AND DividedExamType='P')
						+ '-(' + CAST( PracticalObt AS varchar) +')'
						  FROM Res_GrandResultMarksDetails WHERE PracticalIsPass =0 AND SubjectID =@SubID AND StudentIID = @StuId AND GrandSubExamId =@GS3

						--
					END
		
					PRINT @SubName




					UPDATE #temp SET 
					FailSubjects = FailSubjects + ','+ @SubName ,
					TotalFail = TotalFail + 1 
					WHERE #temp.StuIID = @StuId

					SET @Count = @Count +1		
					PRINT 'C>>' + CAST(@Count AS VARCHAR)
				END

			UPDATE #temp 
			SET Position = rowNumber 
			FROM #temp
			INNER JOIN 
			(SELECT StuIID, row_number() OVER (ORDER BY TotalFail , Total DESC) as rowNumber
			FROM #temp) drRowNumbers ON drRowNumbers.StuIID = #temp.StuIID



			SELECT @TotalStudent AS TotalStudent ,@PassStudent AS PassStudent,@FailStudent AS FailStudent,@PassPer AS PassPer, SV.VersionName,SV.SessionName, SV.BranchName,SV.ShiftName,SV.ClassName,SV.GroupName,SV.SectionName
			,SV.Studentiid,SV.StudentInsID,SV.RollNo,SV.FullName,

			RIGHT(#temp.FailSubjects,
				(
				CASE 
					WHEN LEN(#temp.FailSubjects)=0 THEN #temp.FailSubjects
					ELSE LEN(ISNULL( #temp.FailSubjects,','))-1 
				END)
				) + '--' + CAST( #temp.TotalFail AS varchar) AS FailSubjects,

			#temp.TotalFail,#temp.Total,#temp.Position
			 FROM #temp 
			INNER JOIN vwStudentBasic SV ON SV.StudentIID = #temp.StuIID
ORDER BY Position

DROP TABLE #temp
DROP TABLE #ResultDeatils
END

---  EXEC rptGetGrandExamFailList 4,'1','1','1'