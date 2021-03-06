/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetFailStudentList]'))
BEGIN
DROP PROCEDURE  GetFailStudentList
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
--  execute [dbo].[GetFailStudentList] 1,4,9,1,45,0,105,NULL,1,23
CREATE PROCEDURE [dbo].[GetFailStudentList] 
(

	@SessionId int =NULL,
	@BranchID int =NULL,
	@ShiftId int =NULL,
	@ClassId int =NULL,

	@SectionId int =NULL,
	@StudentInsID nvarchar(150)=NULL,
	@ByGrand BIT,
	@ExamId int
)
AS
BEGIN
	DECLARE @OrderBy VARCHAR(500), @Sql varchar(max),@WhereClause varchar(max) , @MaxCount INT , @Count int =1
	DECLARE @SubName varchar(100),@SubObt decimal(10,2), @StuId BIGINT ,@SubID INT , @TotalStudent INT , @FailStudent INT , @PassStudent DECIMAL(10,2) , @PassPer Decimal(10,2) = 0.0
	CREATE TABLE #temp
			(
			   StuIID BIGINT 
			  ,[VersionID] INT
			  ,[SessionId] INT 
			  ,[BranchID] INT
			  ,[ShiftID] INT
			  ,[ClassId] INT
			  ,[GroupId] INT
			  ,[SectionId] INT
			  ,[StudentInsID] NVARCHAR(MAX)
			  ,[RollNo] INT
			   ,FailSubjects Varchar(Max)
			   ,Total decimal(10,2)
			   ,TotalFail int
			   ,Position INT
			   ,[Remarks] VARCHAR(MAX)
			)
			CREATE TABLE #ResultDeatils
			(
				Id INT IDENTITY(1,1),
				SubID BIGINT ,
				SubjectName Varchar(100),
				SubjectObtMarks decimal(10,2),
				StudentIID BIGINT
			)
 IF(@ByGrand=1)
 BEGIN
		DECLARE @GrandExamId INT
		SET @GrandExamId=@ExamId;		
	DECLARE @GS1  INT =0, @GS2 INT = 0, @GS3 INT  =0 --, @ClassId INT , @GroupId INT 
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
	SELECT @MId = MainExamId FROM Res_GrandMeritListConfig
	WHERE [ClassId]= @ClassId  AND IsDeleted = 0
			---MUSTAK
			INSERT INTO #temp(StuIID,VersionID,SessionId,BranchID,ShiftID,ClassId,GroupId,SectionId,StudentInsID,RollNo,FailSubjects,Total,TotalFail,Position,Remarks)
			SELECT S.StudentIID,S.VersionID,S.SessionId,S.BranchID,S.ShiftID,S.ClassId,S.GroupId,S.SectionId,S.StudentInsID,S.RollNo,'',R.TotalConvertedMarks,0,0,''
			--SELECT S.StudentIID,'',R.TotalConvertedMarks,0,0

			FROM [dbo].[Res_GrandResult] R INNER JOIN Student_BasicInfo S ON S.StudentIID = R.StudentIID
			WHERE R.GrandExamId = @GrandExamId 

			AND S.BranchID = COALESCE(@BranchID,S.BranchID)
			AND S.SessionId = COALESCE(@SessionId,S.SessionId)
			AND S.ShiftID = COALESCE(@ShiftId,S.ShiftID)
			AND S.ClassId = COALESCE(@ClassId,S.ClassId)

			AND S.SectionId = COALESCE(@SectionId,S.SectionId)
			AND S.StudentInsID=COALESCE(@StudentInsID, S.StudentInsID)
			AND S.IsDeleted=0 AND R.IsPass = 0
	        ---MUSTAK
			PRINT 'Total Fail :' + CAST(@@ROWCOUNT AS VARCHAR)

			INSERT INTO #ResultDeatils
			SELECT S.SubID, S.SubjectName, SD.SubjectConvertedMarks as SubjectObtMarks,SD.StudentIID

			FROM [dbo].[Res_GrandResultSubjectDetails] SD 
			INNER JOIN Res_SubjectSetup S ON S.SubID = SD.SubjectID --AND S.NoEffectOnExam = 0
			INNER JOIN Student_BasicInfo ST ON ST.StudentIID = SD.StudentIID AND ST.ShiftID =@ShiftId AND ST.SectionId = @SectionId
			INNER JOIN #temp T ON T.StuIID = SD.StudentIID
			WHERE Sd.GrandExamId =  @GrandExamId AND SD.SubjectIsPass = 0  
			

			
			SELECT @MaxCount = COUNT(*) FROM #ResultDeatils
			PRINT @MaxCount
			 WHILE (@Count <= @MaxCount)
				BEGIN
				 SELECT @SubID =SubID, @StuId = StudentIID   FROM #ResultDeatils WHERE Id = @Count	

					UPDATE #temp SET 
					TotalFail = TotalFail + 1 
					WHERE #temp.StuIID = @StuId

					SET @Count = @Count +1		
					
				END

			UPDATE #temp 
			SET Position = rowNumber 
			FROM #temp
			INNER JOIN 
			(SELECT StuIID, row_number() OVER (ORDER BY TotalFail , Total DESC) as rowNumber
			FROM #temp) drRowNumbers ON drRowNumbers.StuIID = #temp.StuIID



			SELECT --SV.StudentIID,SV.RollNo,FullName,
			#temp.StuIID,#temp.VersionID,#temp.SessionId,#temp.BranchID,#temp.ShiftID,#temp.ClassId,#temp.GroupId,#temp.SectionId,#temp.StudentInsID,#temp.RollNo,#temp.FailSubjects,
			#temp.TotalFail,#temp.Total,#temp.Position, CONVERT(BIT,0 )AS promote  
			 FROM #temp ORDER BY Position
			--INNER JOIN vwStudentBasic SV ON SV.StudentIID = #temp.StuIID
			

DROP TABLE #temp
DROP TABLE #ResultDeatils
END
 ELSE
 BEGIN
		DECLARE @MainExamId INT
		SET @MainExamId=@ExamId		
	DECLARE @MS1  INT =0, @MS2 INT = 0, @MS3 INT  =0  
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

		SELECT @TotalStudent = COUNT(StudentIID)  FROM Student_BasicInfo WHERE SectionId =@SectionId AND Status='A' -- AND GroupId = @GroupId
		SELECT @PassStudent = COUNT(R.StudentIID) FROM [Res_MainExamResult] R
		INNER JOIN Student_BasicInfo S ON S.StudentIID = R.StudentIID
		WHERE MainExamId = @MainExamId AND S.SectionId =@SectionId AND IsPass =1
		SET  @FailStudent = @TotalStudent - @PassStudent
		SET @PassPer = (@PassStudent * 100)/@TotalStudent

						---MUSTAK
			INSERT INTO #temp(StuIID,SessionId,BranchID,ShiftID,ClassId,SectionId,StudentInsID,RollNo,FailSubjects,Total,TotalFail,Position,Remarks)
			SELECT S.StudentIID,S.SessionId,S.BranchID,S.ShiftID,S.ClassId,S.SectionId,S.StudentInsID,S.RollNo,'',R.TotalConvertedMarks,0,0,''
			--SELECT S.StudentIID,'',R.TotalConvertedMarks,0,0

			FROM [dbo].[Res_MainExamResult] R INNER JOIN Student_BasicInfo S ON S.StudentIID = R.StudentIID
			WHERE R.MainExamId = @MainExamId

			AND S.BranchID = COALESCE(@BranchID,S.BranchID)
			AND S.SessionId = COALESCE(@SessionId,S.SessionId)
			AND S.ShiftID = COALESCE(@ShiftId,S.ShiftID)
			AND S.ClassId = COALESCE(@ClassId,S.ClassId)

			AND S.SectionId = COALESCE(@SectionId,S.SectionId)
			AND S.StudentInsID=COALESCE(@StudentInsID, S.StudentInsID)
			AND S.IsDeleted=0 AND R.IsPass = 0
	        ---MUSTAK 		

			PRINT 'Total Fail :' + CAST(@@ROWCOUNT AS VARCHAR)

			INSERT INTO #ResultDeatils
			SELECT S.SubID, S.SubjectName, SD.SubjectConvertedMarks as SubjectObtMarks,SD.StudentIID

			FROM [dbo].[Res_MainExamResultSubjectDetails] SD 
			INNER JOIN Res_SubjectSetup S ON S.SubID = SD.SubjectID --AND S.NoEffectOnExam = 0
			INNER JOIN Student_BasicInfo ST ON ST.StudentIID = SD.StudentIID AND ST.ShiftID =@ShiftId AND ST.SectionId = @SectionId
			INNER JOIN #temp T ON T.StuIID = SD.StudentIID
			WHERE Sd.MainExamId =  @MainExamId AND SD.SubjectIsPass = 0  
			

			
			SELECT @MaxCount = COUNT(*) FROM #ResultDeatils
			PRINT @MaxCount
			 WHILE (@Count <= @MaxCount)
				BEGIN
				 SELECT @SubID =SubID, @StuId = StudentIID  FROM #ResultDeatils WHERE Id = @Count					
					
					UPDATE #temp SET 					
					TotalFail = TotalFail + 1 
					WHERE #temp.StuIID = @StuId

					SET @Count = @Count +1		
					
				END
			-----------------------
			UPDATE #temp 
			SET Position = rowNumber 
			FROM #temp
			INNER JOIN 
			(SELECT StuIID, row_number() OVER (ORDER BY TotalFail , Total DESC) as rowNumber
			FROM #temp) drRowNumbers ON drRowNumbers.StuIID = #temp.StuIID



			SELECT --SV.StudentIID,SV.RollNo,FullName,
			#temp.StuIID,#temp.VersionID,#temp.SessionId,#temp.BranchID,#temp.ShiftID,#temp.ClassId,#temp.GroupId,#temp.SectionId,#temp.StudentInsID,#temp.RollNo,#temp.FailSubjects,
			#temp.TotalFail,#temp.Total,#temp.Position, CONVERT(BIT,0 )AS promote  
			 FROM #temp ORDER BY Position
			--INNER JOIN vwStudentBasic SV ON SV.StudentIID = #temp.StuIID

			-----------------------
		DROP TABLE #temp
		DROP TABLE #ResultDeatils


 END
---  execute [dbo].[GetFailStudentList] 13,1,1,33,
 END
 
 