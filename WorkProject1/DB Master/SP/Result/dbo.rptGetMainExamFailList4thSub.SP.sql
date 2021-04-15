/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetMainExamFailList4thSub]'))
BEGIN
DROP PROCEDURE  rptGetMainExamFailList4thSub
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
--execute [dbo].[rptGetMainExamFailList4thSub] 11,1,1,45
CREATE PROCEDURE [dbo].[rptGetMainExamFailList4thSub] 
	@MainExamId int,
	@VersionId INT=NULL,
	@ShiftId INT=NULL,
	@SectionId INT=NULL

AS
BEGIN
DECLARE @MS1  INT =0, @MS2 INT = 0, @MS3 INT  =0 , @ClassId INT , @GroupId INT 
--First Main Sub Exam 
	select top 1 @MS1= SubExamId from Res_SubExam where MainExamId =@MainExamId AND IsDeleted = 0
	print 'Main Sub Exam1 '+ +convert(varchar(100),@MS1)

	--Second Main Sub Exam 
	select   @MS2= SubExamId from Res_SubExam where MainExamId =@MainExamId AND IsDeleted = 0 ORDER BY SubExamId ASC
		 OFFSET 1 ROWS  
		FETCH NEXT 1 ROW ONLY
	print 'Main Sub Exam2 '+ +convert(varchar(100),@MS2)

	select   @MS3= SubExamId from Res_SubExam where MainExamId =@MainExamId AND IsDeleted = 0 ORDER BY SubExamId ASC
		 OFFSET 2 ROWS  
		FETCH NEXT 1 ROW ONLY
	print 'Main Sub Exam3 '+ +convert(varchar(100),@MS3)

	


DECLARE @OrderBy VARCHAR(500), @Sql varchar(max),@WhereClause varchar(max) , @MaxCount INT , @Count int =1
DECLARE @SubName varchar(100),@SubObt decimal(10,2), @StuId BIGINT ,@SubID INT , @TotalStudent INT , @FailStudent INT , @PassStudent DECIMAL(10,2) , @PassPer Decimal(10,2) = 0.0


	
		SELECT @TotalStudent = COUNT(StudentIID)  FROM Student_BasicInfo WHERE SectionId =@SectionId AND Status='A' -- AND GroupId = @GroupId
		SELECT @PassStudent = COUNT(R.StudentIID) FROM [Res_MainExamResult] R
		INNER JOIN Student_BasicInfo S ON S.StudentIID = R.StudentIID
		WHERE MainExamId = @MainExamId AND S.SectionId =@SectionId AND IsPass =1
		SET  @FailStudent = @TotalStudent - @PassStudent
		SET @PassPer = (@PassStudent * 100)/@TotalStudent

			CREATE TABLE #temp
			(
	
				StuIID BIGINT ,
				FailSubjects Varchar(Max),
				Total decimal(10,2),
				TotalFraction decimal(10,2),
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

			INSERT INTO #ResultDeatils
			SELECT S.SubID, S.SubjectName, SD.SubjectConvertedMarks as SubjectObtMarks,SD.StudentIID

			FROM [dbo].[Res_MainExamResultSubjectDetails] SD 
			INNER JOIN Res_SubjectSetup S ON S.SubID = SD.SubjectID --AND S.NoEffectOnExam = 0
			INNER JOIN Student_BasicInfo ST ON ST.StudentIID = SD.StudentIID AND ST.ShiftID =@ShiftId AND ST.SectionId = @SectionId			
			WHERE Sd.MainExamId =  @MainExamId AND SD.SubjectIsPass = 0  AND S.IsFourth = 1

			INSERT INTO #temp(StuIID,FailSubjects,Total,TotalFraction, TotalFail,Position)
			SELECT S.StudentIID,'',R.TotalConvertedMarks,R.TotalConvertedMarksFraction, 0,0

			FROM [dbo].[Res_MainExamResult] R INNER JOIN Student_BasicInfo S ON S.StudentIID = R.StudentIID
			WHERE R.MainExamId = @MainExamId 
			AND R.StudentIID IN (SELECT StudentIID FROM #ResultDeatils GROUP BY StudentIID)

			PRINT 'Total Fail :' + CAST(@@ROWCOUNT AS VARCHAR)

			
			

			
			SELECT @MaxCount = COUNT(*) FROM #ResultDeatils
			PRINT @MaxCount
			 WHILE (@Count <= @MaxCount)
				BEGIN
				 SELECT @SubID =SubID, @StuId = StudentIID , @SubName = SubjectName,@SubObt = SubjectObtMarks  FROM #ResultDeatils WHERE Id = @Count
					SET @SubName = @SubName + '(' + CAST(@SubObt AS varchar)+ ')'
		
					print @SubID
					IF(@MS1!=0 OR @MS1 IS NOT NULL)
					BEGIN
		
						SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_DividedExam WHERE SubExamId=@MS1  AND DividedExamType='W1')
						+ '-(' + CAST( WrittenObt1 AS varchar) +')'
						  FROM Res_MEResultDetails WHERE WrittenIsPass1 =0 AND SubjectID =@SubID AND StudentIID = @StuId AND SubExamId =@MS1 
			
						SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_DividedExam WHERE SubExamId=@MS1  AND DividedExamType='W2')
						+ '-(' + CAST( WrittenObt2 AS varchar) +')'
						  FROM Res_MEResultDetails WHERE WrittenIsPass3 =0 AND SubjectID =@SubID AND StudentIID = @StuId AND SubExamId =@MS1 

						  SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_DividedExam WHERE SubExamId=@MS1  AND DividedExamType='W2')
						+ '-(' + CAST( WrittenObt3 AS varchar) +')'
						  FROM Res_MEResultDetails WHERE WrittenIsPass3 =0 AND SubjectID =@SubID AND StudentIID = @StuId AND SubExamId =@MS1 

						SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_DividedExam WHERE SubExamId=@MS1  AND DividedExamType='S')
						+ '-(' + CAST( SubjectiveObt AS varchar) +')'
						  FROM Res_MEResultDetails WHERE SubjectiveIsPass =0 AND SubjectID =@SubID AND StudentIID = @StuId AND SubExamId =@MS1 

						SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_DividedExam WHERE SubExamId=@MS1  AND DividedExamType='O')
						+ '-(' + CAST( ObjectiveObt AS varchar) +')'
						  FROM Res_MEResultDetails WHERE ObjectiveIsPass =0 AND SubjectID =@SubID AND StudentIID = @StuId AND SubExamId =@MS1 

						  SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_DividedExam WHERE SubExamId=@MS1  AND DividedExamType='P')
						+ '-(' + CAST( PracticalObt AS varchar) +')'
						  FROM Res_MEResultDetails WHERE PracticalIsPass =0 AND SubjectID =@SubID AND StudentIID = @StuId AND SubExamId =@MS1

						--PRINT @SubName
					END
					IF(@MS2!=0 OR @MS2 IS NOT NULL)
					BEGIN
		
						SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_DividedExam WHERE SubExamId=@MS2  AND DividedExamType='W1')
						+ '-(' + CAST( WrittenObt1 AS varchar) +')'
						  FROM Res_MEResultDetails WHERE WrittenIsPass1 =0 AND SubjectID =@SubID AND StudentIID = @StuId AND SubExamId =@MS2 
			
						SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_DividedExam WHERE SubExamId=@MS2  AND DividedExamType='W2')
						+ '-(' + CAST( WrittenObt2 AS varchar) +')'
						  FROM Res_MEResultDetails WHERE WrittenIsPass3 =0 AND SubjectID =@SubID AND StudentIID = @StuId AND SubExamId =@MS2 

						  SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_DividedExam WHERE SubExamId=@MS2  AND DividedExamType='W2')
						+ '-(' + CAST( WrittenObt3 AS varchar) +')'
						  FROM Res_MEResultDetails WHERE WrittenIsPass3 =0 AND SubjectID =@SubID AND StudentIID = @StuId AND SubExamId =@MS2 

						SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_DividedExam WHERE SubExamId=@MS2  AND DividedExamType='S')
						+ '-(' + CAST( SubjectiveObt AS varchar) +')'
						  FROM Res_MEResultDetails WHERE SubjectiveIsPass =0 AND SubjectID =@SubID AND StudentIID = @StuId AND SubExamId =@MS2 

						SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_DividedExam WHERE SubExamId=@MS2  AND DividedExamType='O')
						+ '-(' + CAST( ObjectiveObt AS varchar) +')'
						  FROM Res_MEResultDetails WHERE ObjectiveIsPass =0 AND SubjectID =@SubID AND StudentIID = @StuId AND SubExamId =@MS2 

						  SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_DividedExam WHERE SubExamId=@MS2  AND DividedExamType='P')
						+ '-(' + CAST( PracticalObt AS varchar) +')'
						  FROM Res_MEResultDetails WHERE PracticalIsPass =0 AND SubjectID =@SubID AND StudentIID = @StuId AND SubExamId =@MS2

						--
					END
					IF(@MS3!=0 OR @MS3 IS NOT NULL)
					BEGIN
		
						SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_DividedExam WHERE SubExamId=@MS3  AND DividedExamType='W1')
						+ '-(' + CAST( WrittenObt1 AS varchar) +')'
						  FROM Res_MEResultDetails WHERE WrittenIsPass1 =0 AND SubjectID =@SubID AND StudentIID = @StuId AND SubExamId =@MS3 
			
						SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_DividedExam WHERE SubExamId=@MS3  AND DividedExamType='W2')
						+ '-(' + CAST( WrittenObt2 AS varchar) +')'
						  FROM Res_MEResultDetails WHERE WrittenIsPass3 =0 AND SubjectID =@SubID AND StudentIID = @StuId AND SubExamId =@MS3 

						  SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_DividedExam WHERE SubExamId=@MS3  AND DividedExamType='W2')
						+ '-(' + CAST( WrittenObt3 AS varchar) +')'
						  FROM Res_MEResultDetails WHERE WrittenIsPass3 =0 AND SubjectID =@SubID AND StudentIID = @StuId AND SubExamId =@MS3 

						SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_DividedExam WHERE SubExamId=@MS3  AND DividedExamType='S')
						+ '-(' + CAST( SubjectiveObt AS varchar) +')'
						  FROM Res_MEResultDetails WHERE SubjectiveIsPass =0 AND SubjectID =@SubID AND StudentIID = @StuId AND SubExamId =@MS3 

						SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_DividedExam WHERE SubExamId=@MS3  AND DividedExamType='O')
						+ '-(' + CAST( ObjectiveObt AS varchar) +')'
						  FROM Res_MEResultDetails WHERE ObjectiveIsPass =0 AND SubjectID =@SubID AND StudentIID = @StuId AND SubExamId =@MS3 

						  SELECT  @SubName = @SubName +  (SELECT DividedExamName  FROM Res_DividedExam WHERE SubExamId=@MS3  AND DividedExamType='P')
						+ '-(' + CAST( PracticalObt AS varchar) +')'
						  FROM Res_MEResultDetails WHERE PracticalIsPass =0 AND SubjectID =@SubID AND StudentIID = @StuId AND SubExamId =@MS3

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
			,SV.StudentInsID,SV.RollNo,SV.FullName,

			RIGHT(#temp.FailSubjects,LEN(#temp.FailSubjects)-1) + '--' + CAST( #temp.TotalFail AS varchar) AS FailSubjects,

			#temp.TotalFail,#temp.Total,#temp.Position,#temp.TotalFraction
			,(SELECT 
				CASE WHEN IsPass=1 THEN 'Passed'
					ELSE 'Failed' End
			  FROM Res_MainExamResult WHERE StudentIID = #temp.StuIID) AS ResultStatus
			  , 'Fail List on Forth Subject' AS ReportName
			 FROM #temp 
			INNER JOIN vwStudentBasic SV ON SV.StudentIID = #temp.StuIID
ORDER BY Position

DROP TABLE #temp
DROP TABLE #ResultDeatils

END

---  EXEC rptGetMainExamFailList4thSub 11,1,5,1