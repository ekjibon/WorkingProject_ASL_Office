/****** Object:  StoredProcedure [dbo].[rptGetGrandResult]    Script Date: 7/22/2017 4:39:59 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetGrandResult]'))
BEGIN
DROP PROCEDURE  rptGetGrandResult
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec rptGetGrandResult 1 ,3548
CREATE proc [dbo].[rptGetGrandResult] 
	@GrandExamId INT ,
	@StuIds VARCHAR(MAX)
as
begin
IF 1=0 BEGIN
    SET FMTONLY OFF
end
SELECT value  INTO #StuId
FROM STRING_SPLIT(@StuIds, ',')  

-- Create TempTable
select * into #tempGrand from Res_TempGrandResult

DECLARE   
		  @GS1  INT =0, @GS2 INT = 0, @GS3 INT  =0
		  , @M1  INT = 0 
		, @M2  INT = 0 , @M3  INT = 0 , @M4  INT = 0 
		, @M1S1  INT = 0 , @M1S2 INT = 0 , @M1S3 INT = 0 
		, @M2S1  INT = 0 , @M2S2 INT = 0 , @M2S3 INT = 0 
		, @M3S1  INT = 0 , @M3S2 INT = 0 , @M3S3 INT = 0 
		, @M4S1  INT = 0 , @M4S2 INT = 0 , @M4S3 INT = 0 
, @Sql VARCHAR(MAX) = ''

	--First Grand Sub Exam 
	select top 1 @GS1= GrandSubExamId from Res_GrandSubExam where GrandExamId =@GrandExamId AND IsDeleted = 0
	print 'Grand Sub Exam 1 :'+ +convert(varchar(100),@GS1)

	--Second Grand Sub Exam 
	select   @GS2= GrandSubExamId from Res_GrandSubExam where GrandExamId =@GrandExamId AND IsDeleted = 0 ORDER BY GrandSubExamId ASC
		 OFFSET 1 ROWS  
		FETCH NEXT 1 ROW ONLY
	print 'Grand Sub Exam 2'+ +convert(varchar(100),@GS2)

	select   @GS3= GrandSubExamId from Res_GrandSubExam where GrandExamId =@GrandExamId AND IsDeleted = 0 ORDER BY GrandSubExamId ASC
		 OFFSET 2 ROWS  
		FETCH NEXT 1 ROW ONLY
	print 'Grand Sub Exam 3'+ +convert(varchar(100),@GS3)
	select  G.MainExamId from Res_GrandSetup G INNER JOIN Res_MainExam M ON M.MainExamId= G.MainExamId
	  where GrandExamId =1 AND G.IsDeleted = 0 AND M.MainExamGrandShowOrder = 1

	--First Main Exam 
	select  @M1= G.MainExamId from Res_GrandSetup G INNER JOIN Res_MainExam M ON M.MainExamId= G.MainExamId
	  where GrandExamId =@GrandExamId AND G.IsDeleted = 0 AND M.MainExamGrandShowOrder = 1
	print 'First Main Exam '+ +convert(varchar(100),@M1)
	--Second Main Exam
	select  @M2= G.MainExamId from Res_GrandSetup G INNER JOIN Res_MainExam M ON M.MainExamId= G.MainExamId
	  where GrandExamId =@GrandExamId AND G.IsDeleted = 0 AND M.MainExamGrandShowOrder = 2
	print 'Second Main Exam '+ +convert(varchar(100),@M2)
	select  * from Res_GrandSetup G INNER JOIN Res_MainExam M ON M.MainExamId= G.MainExamId
	  where GrandExamId =7
	--Third Main Exam 
	select  @M3= G.MainExamId from Res_GrandSetup G INNER JOIN Res_MainExam M ON M.MainExamId= G.MainExamId
	  where GrandExamId =@GrandExamId AND G.IsDeleted = 0 AND M.MainExamGrandShowOrder = 3
	print 'Third Main Exam ' +convert(varchar(100),@M3)

	--Third Main Exam 
	select  @M4= G.MainExamId from Res_GrandSetup G INNER JOIN Res_MainExam M ON M.MainExamId= G.MainExamId
	  where GrandExamId =@GrandExamId AND G.IsDeleted = 0 AND M.MainExamGrandShowOrder = 4
	print 'Forth Main Exam ' +convert(varchar(100),@M4)


	----First Main Exam 
	--select top 1 @M1= MainExamId from Res_GrandSetup where GrandExamId =@GrandExamId AND IsDeleted = 0
	--print 'First Main Exam '+ +convert(varchar(100),@M1)
	----Second Main Exam
	--select  @M2 =MainExamId from Res_GrandSetup where GrandExamId =@GrandExamId AND IsDeleted = 0 order by MainExamId 
	--offset 1 rows  fetch next 1 row only
	--print 'Second Main Exam '+ +convert(varchar(100),@M2)

	----Third Main Exam 
	--select  @M3 =MainExamId from Res_GrandSetup where GrandExamId =@GrandExamId AND IsDeleted = 0 order by MainExamId 
	--offset 1 rows  fetch next 2 row only
	--print 'Third Main Exam ' +convert(varchar(100),@M3)

	----Third Main Exam 
	--select  @M4 =MainExamId from Res_GrandSetup where GrandExamId =@GrandExamId AND IsDeleted = 0 order by MainExamId 
	--offset 1 rows  fetch next 3 row only
	--print 'Forth Main Exam ' +convert(varchar(100),@M4)


	--Get Sub Exam by M 1
	SELECT TOP 1 @M1S1 = SubExamId FROM Res_SubExam WHERE MainExamId= @M1 AND IsDeleted = 0
		
		PRINT 'M 1 S 1: ' +convert(varchar(100),@M1S1)
		SELECT @M1S2 = SubExamId  FROM Res_SubExam WHERE MainExamId= @M1 AND IsDeleted = 0 ORDER BY SubExamId ASC
		 OFFSET 1 ROWS  
		FETCH NEXT 1 ROW ONLY
		PRINT 'M 1 S 2: ' +convert(varchar(100),@M1S2)

		SELECT @M1S3 = SubExamId  FROM Res_SubExam WHERE MainExamId= @M1 AND IsDeleted = 0 ORDER BY SubExamId ASC
		 OFFSET 2 ROWS  
		FETCH NEXT 1 ROW ONLY
		PRINT 'M 1 S 3: ' +convert(varchar(100),@M1S3)

			--Get Sub Exam by M 2
	SELECT TOP 1 @M2S1 = SubExamId FROM Res_SubExam WHERE MainExamId= @M2 AND IsDeleted = 0
		PRINT @M2S1
		
		PRINT 'M 2 S 1: ' +convert(varchar(100),@M2S1)

		SELECT @M2S2 = SubExamId  FROM Res_SubExam WHERE MainExamId= @M2 AND IsDeleted = 0 ORDER BY SubExamId ASC
		 OFFSET 1 ROWS  
		FETCH NEXT 1 ROW ONLY
	
			PRINT 'M2 S2: ' +convert(varchar(100),@M2S2)
		SELECT @M2S3 = SubExamId  FROM Res_SubExam WHERE MainExamId= @M2 AND IsDeleted = 0 ORDER BY SubExamId ASC
		 OFFSET 2 ROWS  
		FETCH NEXT 1 ROW ONLY
		
			PRINT 'M2 S3: ' +convert(varchar(100),@M2S3)

			--Get Sub Exam by M 3
	SELECT TOP 1 @M3S1 = SubExamId FROM Res_SubExam WHERE MainExamId= @M3 AND IsDeleted = 0
	
			PRINT 'M3 S1: ' +convert(varchar(100),@M3S1)
		SELECT @M3S2 = SubExamId  FROM Res_SubExam WHERE MainExamId= @M3 AND IsDeleted = 0 ORDER BY SubExamId ASC
		 OFFSET 1 ROWS  
		FETCH NEXT 1 ROW ONLY
		
			PRINT 'M3 S2: ' +convert(varchar(100),@M3S2)
		SELECT @M3S3 = SubExamId  FROM Res_SubExam WHERE MainExamId= @M3 AND IsDeleted = 0 ORDER BY SubExamId ASC
		 OFFSET 2 ROWS  
		FETCH NEXT 1 ROW ONLY
		
			PRINT 'M3 S3 ' +convert(varchar(100),@M3S3)
	--Get Sub Exam by M 4
	SELECT TOP 1 @M4S1 = SubExamId FROM Res_SubExam WHERE MainExamId= @M4 AND IsDeleted = 0
	
			PRINT 'M3 S1: ' +convert(varchar(100),@M3S1)
		SELECT @M4S2 = SubExamId  FROM Res_SubExam WHERE MainExamId= @M4 AND IsDeleted = 0 ORDER BY SubExamId ASC
		 OFFSET 1 ROWS  
		FETCH NEXT 1 ROW ONLY
		
			PRINT 'M4 S2: ' +convert(varchar(100),@M3S2)
		SELECT @M4S3 = SubExamId  FROM Res_SubExam WHERE MainExamId= @M4 AND IsDeleted = 0 ORDER BY SubExamId ASC
		 OFFSET 2 ROWS  
		FETCH NEXT 1 ROW ONLY
		
			PRINT 'M4 S3 ' +convert(varchar(100),@M3S3)

SELECT * INTO #tempQry_MarkSetup From dbo.[Qry_MarkSetup] WHERE MainExamId = @M1 OR MainExamId = @M2 OR MainExamId =@M3 OR MainExamId= @M4
SELECT * INTO #tempQry_GrandMarkSetup From dbo.[Qry_GrandMarkSetup] WHERE GrandExamId = @GrandExamId AND DIsDeleted =0
 -- Insert in TempTable  #tempGrand
 INSERT into #tempGrand(
 GrandExamName,
	   [StudentIID]
	  ,SubjectId

	  ,[TotalMarks]
	  ,[GradeLetter]
      ,[GPA]
      ,[GPAWithOut4Sub]
      ,[OverAllMerit]
	  ,[SubjectIsPass]
      ,[SectionWiseMerit]
      ,[ShiftWiseMerit]
      ,[ClassWiseMerit]
      ,[TotalConvertedMarks]
      ,[TotalConvertedMarksFraction]
      ,[FailStudentGPA]
      ,[TotalGP]
      ,[TotalGPWithOut4Sub]
	  ,[SubjectObtMarks]
      ,[SubjectConvertedMarks]
	  ,[SubjectConvertedFrac]
      ,[SubjectGP]
      ,[SubjectGL]
      ,[SubjectHighestMark]
      ,[SubjectOriginalObtMarks]
	  ,[VirtualConvertedMarks1]
      ,[VirtualIsPass1]
      ,[VirtualConvertedMarks2]
      ,[VirtualIsPass2]
	  ,[SubjectName]
	  ,[ReportSerialNo]
      ,[Student_SubjectType]
      ,[IsNoEffectOnExam]
	  ,[Org_SubjectType]
	  ,[MyProperty]

 ) 
 SELECT  
 GE.GrandExamName,
	  G.[StudentIID]
	  ,GrandSUBDEL.SubjectID
	  ,G.[TotalMarks]
	  ,G.GradeLetter
      ,G.[GPA]
      ,G.[GPAWithOut4Sub]
      ,G.[OverAllMerit]
	  ,GrandSUBDEL.SubjectIsPass 
      ,G.[SectionWiseMerit]
      ,G.[ShiftWiseMerit]
      ,G.[ClassWiseMerit]
      ,G.[TotalConvertedMarks]
      ,G.[TotalConvertedMarksFraction]
      ,G.[FailStudentGPA]
      ,G.[TotalGP]
      ,G.[TotalGPWithOut4Sub]
	  ,GrandSUBDEL.[SubjectObtMarks]
      ,GrandSUBDEL.[SubjectConvertedMarks]
	  ,GrandSUBDEL.[SubjectConvertedMarksFraction]
      ,GrandSUBDEL.[SubjectGP]
      ,GrandSUBDEL.[SubjectGL]
      ,GrandSUBDEL.[SubjectHighestMark]
      ,GrandSUBDEL.[SubjectOriginalObtMarks]
	  ,GrandSUBDEL.[VirtualConvertedMarks1]
      ,GrandSUBDEL.[VirtualIsPass1]
      ,GrandSUBDEL.[VirtualConvertedMarks2]
      ,GrandSUBDEL.[VirtualIsPass2]
	  ,SUB.[SubjectName]
	  ,SUB.[ReportSerialNo]
	  ,SUB.SubjectType
	  ,SUB.NoEffectOnExam
	  ,SSUB.SubjectType
	  ,G.MyProperty
	 
	   FROM [dbo].[Res_GrandResult] G
	  INNER JOIN Res_GrandResultSubjectDetails GrandSUBDEL on (G.GrandExamId=GrandSUBDEL.GrandExamId and G.StudentIID=GrandSUBDEL.StudentIID)
	  INNER JOIN Res_SubjectSetup SUB ON GrandSUBDEL.SubjectID = SUB.SubID 
	  INNER JOIN Res_StudentSubject SSUB ON (SSUB.SubjectID = SUB.SubID AND SSUB.[StudentID]=G.StudentIID)
	  INNER JOIN Res_GrandExam GE ON GE.GrandExamId = G.GrandExamId
	  WHERE G.GrandExamId =@GrandExamId 
	  ORDER BY G.StudentIID, SUB.[ReportSerialNo]

	  --- Grand Sub Exam Update
	    BEGIN
		 Update TG set 
		 TG.GS1W1Obt =GMD.[WrittenObt1]
		 ,TG.GS1W1Conv =GMD.[WrittenConv1]
		 ,TG.GS1W1Frac =GMD.[WrittenFrac1]
		 ,TG.GS1W1IsPass =GMD.[WrittenIsPass1]
		 ,TG.GS1W2Obt =GMD.[WrittenObt2]
		 ,TG.GS1W2Conv =GMD.[WrittenConv2]
		 ,TG.GS1W2Frac =GMD.[WrittenFrac2]
		 ,TG.GS1W2IsPass =GMD.[WrittenIsPass2]
		 ,TG.GS1W3Obt =GMD.[WrittenObt3]
		 ,TG.GS1W3Conv =GMD.[WrittenConv3]
		 ,TG.GS1W3Frac =GMD.[WrittenFrac3]
		 ,TG.GS1W3IsPass =GMD.[WrittenIsPass3]
		 ,TG.GS1SubObt =GMD.[SubjectiveObt]
		 ,TG.GS1SubConv =GMD.[SubjectiveConv]
		 ,TG.GS1SubFrac =GMD.[SubjectiveFrac]
		 ,TG.GS1SubIsPass =GMD.[SubjectiveIsPass]
		 ,TG.GS1ObjObt=GMD.[ObjectiveObt]
		 ,TG.GS1ObjConv=GMD.[ObjectiveConv]
		 ,TG.GS1ObjFrac=GMD.[ObjectiveFrac]
		 ,TG.GS1ObjIsPass=GMD.[ObjectiveIsPass]
		 ,TG.GS1PraObt=GMD.[PracticalObt]
		 ,TG.GS1PraConv=GMD.[PracticalConv]
		 ,TG.GS1PraFrac=GMD.[PracticalFrac]
		 ,TG.GS1PraIsPass=GMD.[PracticalIsPass]
		 ,TG.GS1TotalConv=GMD.SubExamTotalConv
		 ,TG.GS1TotalObt=GMD.SubExamTotalObt
		 ,TG.GS1TotalFrac=GMD.SubExamTotalFrac
		 ,TG.GS1OrigTotalObt=GMD.SubExamOriginalTotalObt
		 ,TG.GS1SubExamIsPass=GMD.SubExamIsPass
		 ,TG.GS1SOPTotalObt=GMD.SOPTotalObt
		 ,TG.GS1SOPTotalConv=GMD.SOPTotalConv
		 ,TG.GS1SOPTotalFrac=GMD.SOPTotalFrac
		
	    FROM #tempGrand TG
		INNER JOIN  Res_GrandResultMarksDetails GMD ON GMD.[StudentIID] = TG.StudentIID	AND TG.SubjectId = GMD.SubjectID AND GMD.GrandSubExamId = @GS1
		
		
		 Update TG set 
		 TG.GS2W1Obt =GMD.[WrittenObt1]
		 ,TG.GS2W1Conv =GMD.[WrittenConv1]
		 ,TG.GS2W1Frac =GMD.[WrittenFrac1]
		 ,TG.GS2W1IsPass =GMD.[WrittenIsPass1]
		 ,TG.GS2W2Obt =GMD.[WrittenObt2]
		 ,TG.GS2W2Conv =GMD.[WrittenConv2]
		 ,TG.GS2W2Frac =GMD.[WrittenFrac2]
		 ,TG.GS2W2IsPass =GMD.[WrittenIsPass2]
		 ,TG.GS2W3Obt =GMD.[WrittenObt3]
		 ,TG.GS2W3Frac =GMD.[WrittenFrac3]
		 ,TG.GS2W3Conv =GMD.[WrittenConv3]
		 ,TG.GS2W3IsPass =GMD.[WrittenIsPass3]
		 ,TG.GS2SubObt =GMD.[SubjectiveObt]
		 ,TG.GS2SubConv =GMD.[SubjectiveConv]
		 ,TG.GS2SubFrac =GMD.[SubjectiveFrac]
		 ,TG.GS2SubIsPass =GMD.[SubjectiveIsPass]
		 ,TG.GS2ObjObt=GMD.[ObjectiveObt]
		 ,TG.GS2ObjConv=GMD.[ObjectiveConv]
		 ,TG.GS2ObjFrac=GMD.[ObjectiveFrac]
		 ,TG.GS2ObjIsPass=GMD.[ObjectiveIsPass]
		 ,TG.GS2PraObt=GMD.[PracticalObt]
		 ,TG.GS2PraConv=GMD.[PracticalConv]
		 ,TG.GS2PraFrac=GMD.[PracticalFrac]
		 ,TG.GS2PraIsPass=GMD.[PracticalIsPass]
		,TG.GS2TotalConv=GMD.SubExamTotalConv
		 ,TG.[GS2TotalObt]=GMD.SubExamTotalObt
		,TG.GS2TotalFrac=GMD.SubExamTotalFrac
		 ,TG.GS2OrigTotalObt=GMD.SubExamOriginalTotalObt

		 ,TG.GS2SOPTotalObt=GMD.SOPTotalObt
		 ,TG.GS2SOPTotalConv=GMD.SOPTotalConv
		 ,TG.GS2SOPTotalFrac=GMD.SOPTotalFrac
	    FROM #tempGrand TG
		INNER JOIN  Res_GrandResultMarksDetails GMD ON GMD.[StudentIID] = TG.StudentIID	AND TG.SubjectId = GMD.SubjectID AND GMD.GrandSubExamId = @GS2
	
	 Update TG set 
		 TG.GS3W1Obt =GMD.[WrittenObt1]
		 ,TG.GS3W1Conv =GMD.[WrittenConv1]
		 ,TG.GS3W1Frac =GMD.[WrittenFrac1]
		 ,TG.GS3W1IsPass =GMD.[WrittenIsPass1]
		 ,TG.GS3W2Obt =GMD.[WrittenObt2]
		 ,TG.GS3W2Conv =GMD.[WrittenConv2]
		 ,TG.GS3W2Frac =GMD.[WrittenFrac2]
		 ,TG.GS3W2IsPass =GMD.[WrittenIsPass2]
		 ,TG.GS3W3Obt =GMD.[WrittenObt3]
		 ,TG.GS3W3Frac =GMD.[WrittenFrac3]
		 ,TG.GS3W3Conv =GMD.[WrittenConv3]
		 ,TG.GS3W3IsPass =GMD.[WrittenIsPass3]
		 ,TG.GS3SubObt =GMD.[SubjectiveObt]
		 ,TG.GS3SubConv =GMD.[SubjectiveConv]
		 ,TG.GS3SubFrac =GMD.[SubjectiveFrac]
		 ,TG.GS3SubIsPass =GMD.[SubjectiveIsPass]
		 ,TG.GS3ObjObt=GMD.[ObjectiveObt]
		 ,TG.GS3ObjConv=GMD.[ObjectiveConv]
		 ,TG.GS3ObjFrac=GMD.[ObjectiveFrac]
		 ,TG.GS3ObjIsPass=GMD.[ObjectiveIsPass]
		 ,TG.GS3PraObt=GMD.[PracticalObt]
		 ,TG.GS3PraConv=GMD.[PracticalConv]
		 ,TG.GS3PraFrac=GMD.[PracticalFrac]
		 ,TG.GS3PraIsPass=GMD.[PracticalIsPass]
		,TG.GS3TotalConv=GMD.SubExamTotalConv
		 ,TG.[GS3TotalObt]=GMD.SubExamTotalObt
		,TG.GS3TotalFrac=GMD.SubExamTotalFrac
		 ,TG.GS3OrigTotalObt=GMD.SubExamOriginalTotalObt

		 ,TG.GS3SOPTotalObt=GMD.SOPTotalObt
		 ,TG.GS3SOPTotalConv=GMD.SOPTotalConv
		 ,TG.GS3SOPTotalFrac=GMD.SOPTotalFrac
	    FROM #tempGrand TG
		INNER JOIN  Res_GrandResultMarksDetails GMD ON GMD.[StudentIID] = TG.StudentIID	AND TG.SubjectId = GMD.SubjectID AND GMD.GrandSubExamId = @GS3
	

	--- Update marks Setup For Grand
		UPDATE  TG SET 
			TG.GS1W1IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType ='W1' AND SubExamId= @GS1 And GrandExamId=@GrandExamId),0),
			TG.GS2W1IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType ='W1' AND SubExamId= @GS2 And GrandExamId=@GrandExamId),0),
			TG.GS3W1IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType ='W1' AND SubExamId= @GS3 And GrandExamId=@GrandExamId),0),
								 																							
			TG.GS1W2IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType ='W2' AND SubExamId= @GS1 And GrandExamId=@GrandExamId),0),
			TG.GS2W2IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType ='W2' AND SubExamId= @GS2 And GrandExamId=@GrandExamId),0),
			TG.GS3W2IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType ='W2' AND SubExamId= @GS3 And GrandExamId=@GrandExamId),0),
								 																							
			TG.GS1W3IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType ='W3' AND SubExamId= @GS1 And GrandExamId=@GrandExamId),0),
			TG.GS2W3IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType ='W3' AND SubExamId= @GS2 And GrandExamId=@GrandExamId),0),
			TG.GS3W3IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType ='W3' AND SubExamId= @GS3 And GrandExamId=@GrandExamId),0),
																															
			TG.GS1SubIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType = 'S' AND SubExamId= @GS1 And GrandExamId=@GrandExamId),0),
			TG.GS2SubIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType = 'S' AND SubExamId= @GS2 And GrandExamId=@GrandExamId),0),
			TG.GS3SubIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType = 'S' AND SubExamId= @GS3 And GrandExamId=@GrandExamId),0),
																										 					
			TG.GS1ObjIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType = 'O' AND SubExamId= @GS1 And GrandExamId=@GrandExamId),0),
			TG.GS2ObjIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType = 'O' AND SubExamId= @GS2 And GrandExamId=@GrandExamId),0),
			TG.GS3ObjIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType = 'O' AND SubExamId= @GS3 And GrandExamId=@GrandExamId),0),
																										 					
			TG.GS1PraIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType = 'P' AND SubExamId= @GS1 And GrandExamId=@GrandExamId),0),
			TG.GS2PraIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType = 'P' AND SubExamId= @GS2 And GrandExamId=@GrandExamId),0),
			TG.GS3PraIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType = 'P' AND SubExamId= @GS3 And GrandExamId=@GrandExamId),0),


			TG.GS1W1ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType ='W1' AND SubExamId= @GS1 And GrandExamId=@GrandExamId),0),
			TG.GS2W1ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType ='W1' AND SubExamId= @GS2 And GrandExamId=@GrandExamId),0),
			TG.GS3W1ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType ='W1' AND SubExamId= @GS3 And GrandExamId=@GrandExamId),0),
								 																							
			TG.GS1W2ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType ='W2' AND SubExamId= @GS1 And GrandExamId=@GrandExamId),0),
			TG.GS2W2ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType ='W2' AND SubExamId= @GS2 And GrandExamId=@GrandExamId),0),
			TG.GS3W2ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType ='W2' AND SubExamId= @GS3 And GrandExamId=@GrandExamId),0),
								 																							
			TG.GS1W3ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType ='W3' AND SubExamId= @GS1 And GrandExamId=@GrandExamId),0),
			TG.GS2W3ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType ='W3' AND SubExamId= @GS2 And GrandExamId=@GrandExamId),0),
			TG.GS3W3ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType ='W3' AND SubExamId= @GS3 And GrandExamId=@GrandExamId),0),
																															
			TG.GS1SubExamMark = ISNULL((SELECT DividedExamExamMarks FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType = 'S' AND SubExamId= @GS1 And GrandExamId=@GrandExamId),0),
			TG.GS2SubExamMark = ISNULL((SELECT DividedExamExamMarks FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType = 'S' AND SubExamId= @GS2 And GrandExamId=@GrandExamId),0),
			TG.GS3SubExamMark = ISNULL((SELECT DividedExamExamMarks FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType = 'S' AND SubExamId= @GS3 And GrandExamId=@GrandExamId),0),
																										 					
			TG.GS1ObjExamMark = ISNULL((SELECT DividedExamExamMarks FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType = 'O' AND SubExamId= @GS1 And GrandExamId=@GrandExamId),0),
			TG.GS2ObjExamMark = ISNULL((SELECT DividedExamExamMarks FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType = 'O' AND SubExamId= @GS2 And GrandExamId=@GrandExamId),0),
			TG.GS3ObjExamMark = ISNULL((SELECT DividedExamExamMarks FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType = 'O' AND SubExamId= @GS3 And GrandExamId=@GrandExamId),0),
																										 					
			TG.GS1PraExamMark = ISNULL((SELECT DividedExamExamMarks FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType = 'P' AND SubExamId= @GS1 And GrandExamId=@GrandExamId),0),
			TG.GS2PraExamMark = ISNULL((SELECT DividedExamExamMarks FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType = 'P' AND SubExamId= @GS2 And GrandExamId=@GrandExamId),0),
			TG.GS3PraExamMark = ISNULL((SELECT DividedExamExamMarks FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID AND DividedExamType = 'P' AND SubExamId= @GS3 And GrandExamId=@GrandExamId),0),

		TG.GFullMark = M.ExamFullMarks,
		TG.GExamMark = M.ExamPassMark

		FROM #tempGrand TG INNER JOIN #tempQry_GrandMarkSetup  M ON M.ExamSubjectID =   TG.SubjectId AND GrandExamId = @GrandExamId  
			
			UPDATE  TG SET 
			TG.GS1ExamConvMark =  ISNULL((SELECT top 1 [SubExamFullMarks] FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID  AND SubExamId= @GS1 And GrandExamId=@GrandExamId),0),
			TG.GS2ExamConvMark =  ISNULL((SELECT top 1 [SubExamFullMarks] FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID  AND SubExamId= @GS2 And GrandExamId=@GrandExamId),0),
			TG.GS3ExamConvMark =  ISNULL((SELECT top 1 [SubExamFullMarks] FROM #tempQry_GrandMarkSetup MS WHERE Ms.ExamSubjectID=M.ExamSubjectID  AND SubExamId= @GS3 And GrandExamId=@GrandExamId),0)
			
		FROM #tempGrand TG INNER JOIN #tempQry_GrandMarkSetup  M ON M.ExamSubjectID =   TG.SubjectId AND GrandExamId = @GrandExamId  
			

		END 


	 
	  
	  IF(@M1 != null or @M1 != 0) ---  BEGIN M1
	  BEGIN
		DECLARE @MName1  varchar(200)  = (select MainExamName from Res_MainExam where MainExamId=@M1)
	 	print ' Main Exam 1: ' +@MName1
	  --M1 S1
	  IF(@M1S1 != null or @M1S1 != 0)
	  BEGIN
		    Update TG set 
		  TG.[M1Name] = @MName1
		 ,TG.M1S1Name = (SELECT SubExamName FROM Res_SubExam WHERE Res_SubExam.SubExamId = @M1S1)
		 ,TG.M1S1W1Obt =MERD.[WrittenObt1]
		 ,TG.M1S1W1Conv =MERD.[WrittenConv1]
		 ,TG.M1S1W1Frac =MERD.[WrittenFrac1]
		 ,TG.M1S1W1IsPass =MERD.[WrittenIsPass1]
		 ,TG.M1S1W1IsAbs =MERD.[WrittenIsAbsent1]
		 ,TG.M1S1W2Obt =MERD.[WrittenObt2]
		 ,TG.M1S1W2Conv =MERD.[WrittenConv2]
		 ,TG.M1S1W2Frac =MERD.[WrittenFrac2]
		 ,TG.M1S1W2IsPass =MERD.[WrittenIsPass2]
		 ,TG.M1S1W2IsAbs =MERD.[WrittenIsAbsent2]
		 ,TG.M1S1W3Obt =MERD.[WrittenObt3]
		 ,TG.M1S1W3Conv =MERD.[WrittenConv3]
		 ,TG.M1S1W3Frac =MERD.[WrittenFrac3]
		 ,TG.M1S1W3IsPass =MERD.[WrittenIsPass3]
		 ,TG.M1S1W3IsAbs =MERD.[WrittenIsAbsent3]
		 ,TG.M1S1SubObt =MERD.[SubjectiveObt]
		 ,TG.M1S1SubConv =MERD.[SubjectiveConv]
		 ,TG.M1S1SubFrac =MERD.[SubjectiveFrac]
		 ,TG.M1S1SubIsPass =MERD.[SubjectiveIsPass]
		 ,TG.M1S1SubIsAbs =MERD.[SubjectiveIsAbsent]
		 ,TG.M1S1ObjObt=MERD.[ObjectiveObt]
		 ,TG.M1S1ObjConv=MERD.[ObjectiveConv]
		 ,TG.M1S1ObjFrac=MERD.[ObjectiveFrac]
		 ,TG.M1S1ObjIsPass=MERD.[ObjectiveIsPass]
		 ,TG.M1S1ObjIsAbs=MERD.[ObjectiveIsAbsent]
		 ,TG.M1S1PraObt=MERD.[PracticalObt]
		 ,TG.M1S1PraConv=MERD.[PracticalConv]
		 ,TG.M1S1PraFrac=MERD.[PracticalFrac]
		 ,TG.M1S1PraIsPass=MERD.[PracticalIsPass]
		 ,TG.M1S1PraIsAbs=MERD.[PracticalIsAbsent]
		 ,TG.M1S1TotalObt=MERD.[SubExamTotalObt]
		 ,TG.M1S1TotalConv=MERD.[SubExamTotalConv]
		 ,TG.M1S1TotalFrac=MERD.[SubExamTotalFrac]
		 ,TG.M1S1OrigTotalObt  =MERD.SubExamOriginalTotalObt
		 ,TG.M1S1IsPass=MERD.[SubExamIsPass]
		 ,TG.M1S1IsAbs=MERD.[SubExamIsAbsent]
		 ,TG.M1S1SOPTotalObt = MERD.SOPTotalObt
		 ,TG.M1S1SOPTotalConv= MERD.SOPTotalConv
		 ,TG.M1S1SOPTotalFrac = MERD.SOPTotalFrac
	    FROM #tempGrand TG
		INNER JOIN  Res_MEResultDetails MERD ON [SubExamId]  = @M1S1  AND MERD.[StudentIID] = TG.StudentIID	AND TG.SubjectId = MERD.SubjectID

		END --  End of M1S1

	  --M1 S2

	  IF(@M1S2 != null or @M1S2 != 0)
	  BEGIN
		    Update TG set 
		
		 TG.M1S2Name = (SELECT SubExamName FROM Res_SubExam WHERE Res_SubExam.SubExamId = @M1S2)
		 ,TG.M1S2W1Obt =MERD.[WrittenObt1]
		 ,TG.M1S2W1Conv =MERD.[WrittenConv1]
		 ,TG.M1S2W1Frac =MERD.[WrittenFrac1]
		 ,TG.M1S2W1IsPass =MERD.[WrittenIsPass1]
		 ,TG.M1S2W1IsAbs =MERD.[WrittenIsAbsent1]
		 ,TG.M1S2W2Obt =MERD.[WrittenObt2]
		 ,TG.M1S2W2Conv =MERD.[WrittenConv2]
		 ,TG.M1S2W2Frac =MERD.[WrittenFrac2]
		 ,TG.M1S2W2IsPass =MERD.[WrittenIsPass2]
		 ,TG.M1S2W2IsAbs =MERD.[WrittenIsAbsent2]
		 ,TG.M1S2W3Obt =MERD.[WrittenObt3]
		 ,TG.M1S2W3Conv =MERD.[WrittenConv3]
		 ,TG.M1S2W3Frac =MERD.[WrittenFrac3]
		 ,TG.M1S2W3IsPass =MERD.[WrittenIsPass3]
		 ,TG.M1S2W3IsAbs =MERD.[WrittenIsAbsent3]
		 ,TG.M1S2SubObt =MERD.[SubjectiveObt]
		 ,TG.M1S2SubConv =MERD.[SubjectiveConv]
		 ,TG.M1S2SubFrac =MERD.[SubjectiveFrac]
		 ,TG.M1S2SubIsPass =MERD.[SubjectiveIsPass]
		 ,TG.M1S2SubIsAbs =MERD.[SubjectiveIsAbsent]
		 ,TG.M1S2ObjObt=MERD.[ObjectiveObt]
		 ,TG.M1S2ObjConv=MERD.[ObjectiveConv]
		 ,TG.M1S2ObjFrac=MERD.[ObjectiveFrac]
		 ,TG.M1S2ObjIsPass=MERD.[ObjectiveIsPass]
		 ,TG.M1S2ObjIsAbs=MERD.[ObjectiveIsAbsent]
		 ,TG.M1S2PraObt=MERD.[PracticalObt]
		 ,TG.M1S2PraConv=MERD.[PracticalConv]
		 ,TG.M1S2PraFrac=MERD.[PracticalFrac]
		 ,TG.M1S2PraIsPass=MERD.[PracticalIsPass]
		 ,TG.M1S2PraIsAbs=MERD.[PracticalIsAbsent]
		 ,TG.M1S2TotalObt=MERD.[SubExamTotalObt]
		 ,TG.M1S2TotalConv=MERD.[SubExamTotalConv]
		 ,TG.M1S2TotalFrac=MERD.[SubExamTotalFrac]
		 ,TG.M1S2OrigTotalObt  =MERD.SubExamOriginalTotalObt
		 ,TG.M1S2IsPass=MERD.[SubExamIsPass]
		 ,TG.M1S2IsAbs=MERD.[SubExamIsAbsent]
		 ,TG.M1S2SOPTotalObt = MERD.SOPTotalObt
		 ,TG.M1S2SOPTotalConv= MERD.SOPTotalConv
		 ,TG.M1S2SOPTotalFrac = MERD.SOPTotalFrac

	    FROM #tempGrand TG
		INNER JOIN  Res_MEResultDetails MERD ON [SubExamId]  = @M1S2  AND MERD.[StudentIID] = TG.StudentIID	AND TG.SubjectId = MERD.SubjectID
	
	
		PRINT @@rowcount

		
		END --  END OF M1S2

	  IF(@M1S3 != null or @M1S3 != 0)
	  BEGIN
		  Update TG set 
		  TG.M1S3Name = (SELECT SubExamName FROM Res_SubExam WHERE Res_SubExam.SubExamId = @M1S3)
		 ,TG.M1S3W1Obt =MERD.[WrittenObt1]
		 ,TG.M1S3W1Conv =MERD.[WrittenConv1]
		 ,TG.M1S3W1Frac =MERD.[WrittenFrac1]
		 ,TG.M1S3W1IsPass =MERD.[WrittenIsPass1]
		 ,TG.M1S3W1IsAbs =MERD.[WrittenIsAbsent1]
		 ,TG.M1S3W2Obt =MERD.[WrittenObt2]
		 ,TG.M1S3W2Conv =MERD.[WrittenConv2]
		 ,TG.M1S3W2Frac =MERD.[WrittenFrac2]
		 ,TG.M1S3W2IsPass =MERD.[WrittenIsPass2]
		 ,TG.M1S3W2IsAbs =MERD.[WrittenIsAbsent2]
		 ,TG.M1S3W3Obt =MERD.[WrittenObt3]
		 ,TG.M1S3W3Conv =MERD.[WrittenConv3]
		 ,TG.M1S3W3Frac =MERD.[WrittenFrac3]
		 ,TG.M1S3W3IsPass =MERD.[WrittenIsPass3]
		 ,TG.M1S3W3IsAbs =MERD.[WrittenIsAbsent3]
		 ,TG.M1S3SubObt =MERD.[SubjectiveObt]
		 ,TG.M1S3SubConv =MERD.[SubjectiveConv]
		 ,TG.M1S3SubFrac =MERD.[SubjectiveFrac]
		 ,TG.M1S3SubIsPass =MERD.[SubjectiveIsPass]
		 ,TG.M1S3SubIsAbs =MERD.[SubjectiveIsAbsent]
		 ,TG.M1S3ObjObt=MERD.[ObjectiveObt]
		 ,TG.M1S3ObjConv=MERD.[ObjectiveConv]
		 ,TG.M1S3ObjFrac=MERD.[ObjectiveFrac]
		 ,TG.M1S3ObjIsPass=MERD.[ObjectiveIsPass]
		 ,TG.M1S3ObjIsAbs=MERD.[ObjectiveIsAbsent]
		 ,TG.M1S3PraObt=MERD.[PracticalObt]
		 ,TG.M1S3PraConv=MERD.[PracticalConv]
		 ,TG.M1S3PraFrac=MERD.[PracticalFrac]
		 ,TG.M1S3PraIsPass=MERD.[PracticalIsPass]
		 ,TG.M1S3PraIsAbs=MERD.[PracticalIsAbsent]
		 ,TG.M1S3TotalObt=MERD.[SubExamTotalObt]
		 ,TG.M1S3TotalConv=MERD.[SubExamTotalConv]
		 ,TG.M1S3TotalFrac=MERD.[SubExamTotalFrac]
		 ,TG.M1S3OrigTotalObt  =MERD.SubExamOriginalTotalObt
		 ,TG.M1S3IsPass=MERD.[SubExamIsPass]
		 ,TG.M1S3IsAbs=MERD.[SubExamIsAbsent]
		 ,TG.M1S3SOPTotalObt = MERD.SOPTotalObt
		 ,TG.M1S3SOPTotalConv= MERD.SOPTotalConv
		 ,TG.M1S3SOPTotalFrac = MERD.SOPTotalFrac

	    FROM #tempGrand TG
		INNER JOIN  Res_MEResultDetails MERD ON [SubExamId]  = @M1S3  AND MERD.[StudentIID] = TG.StudentIID	AND TG.SubjectId = MERD.SubjectID
	END --  END OF M1S3


	--------------------------------------------------------------------- Update All GP, GL,GPA Subjectwise
			UPDATE  TG SET 
			TG.M1SubjectGP = SUBDET.SubjectGP  , 
			TG.M1SubjectGL = SUBDET.SubjectGL , 
	
			TG.M1SubjectObtMarks = SUBDET.SubjectObtMarks,
			TG.M1SubjectConvertedMarks  = SUBDET.SubjectConvertedMarks,
			TG.M1SubjectConvMarksFrac = SUBDET.SubjectConvertedMarksFraction,
			TG.M1SubjectHighestMarks = SUBDET.SubjectHighestMark,
			TG.M1SubjectIsPass = SUBDET.SubjectIsPass,
			TG.M1VirtualConvertedMarks1 = SUBDET.VirtualConvertedMarks1,
			TG.M1VirtualIsPass1 = SUBDET.VirtualIsPass1,
			TG.M1VirtualConvertedMarks2 = SUBDET.VirtualConvertedMarks2,
			TG.M1VirtualIsPass2 = SUBDET.VirtualIsPass2
			FROM #tempGrand TG INNER JOIN  [Res_MainExamResultSubjectDetails] SUBDET  ON SUBDET.SubjectID =  TG.SubjectID AND SUBDET.StudentIID= TG.StudentIID  AND SUBDET.MainExamId = @M1

	----- --------------------------------------------------------------- Update All GP, GL,GPA For M1
			UPDATE  TG SET 
			TG.M1IsPass  = RES.IsPass,
			TG.M1GPA = RES.GPA, 
			TG.M1GradeLetter = RES.GradeLetter,
			TG.M1TotalGP  = RES.TotalGP,
			TG.M1FailStudentGPA = RES.FailStudentGPA,
			TG.M1ClassWiseMerit = RES.ClassWiseMerit ,
			TG.M1SectionWiseMerit= RES.SectionWiseMerit,		 
			TG.M1ShiftWiseMerit = RES.ShiftWiseMerit,
			TG.[M1TotalConvertedMarks] = RES.TotalConvertedMarks,
			TG.[M1TotalConvertedMarksFraction] = RES.TotalConvertedMarksFraction 
			FROM #tempGrand TG INNER JOIN [dbo].[Res_MainExamResult] RES  ON RES.MainExamId =  @M1  and RES.StudentIID=TG.StudentIID
			
			UPDATE  TG SET 
		
			TG.M1S1W1IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M1S1 And MainExamid=@M1),0),
			TG.M1S2W1IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M1S2 And MainExamid=@M1),0),
			TG.M1S3W1IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M1S3 And MainExamid=@M1),0),

			TG.M1S1W1ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M1S1 And MainExamid=@M1),0),
			TG.M1S2W1ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M1S2 And MainExamid=@M1),0),
			TG.M1S3W1ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M1S3 And MainExamid=@M1),0),
					
			
			TG.M1S1W1FullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M1S1 And MainExamid=@M1),0),
			TG.M1S2W1FullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M1S2 And MainExamid=@M1),0),
			TG.M1S3W1FullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M1S3 And MainExamid=@M1),0),
							 																											 
			TG.M1S1W2IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M1S1 And MainExamid=@M1),0),
			TG.M1S2W2IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M1S2 And MainExamid=@M1),0),
			TG.M1S3W2IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M1S3 And MainExamid=@M1),0),
			
			TG.M1S1W2ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M1S1 And MainExamid=@M1),0),
			TG.M1S2W2ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M1S2 And MainExamid=@M1),0),
			TG.M1S3W2ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M1S3 And MainExamid=@M1),0),
						
						
			TG.M1S1W2FullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M1S1 And MainExamid=@M1),0),
			TG.M1S2W2FullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M1S2 And MainExamid=@M1),0),
			TG.M1S3W2FullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M1S3 And MainExamid=@M1),0),
						 																						 					
			TG.M1S1W3IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M1S1 And MainExamid=@M1),0),
			TG.M1S2W3IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M1S2 And MainExamid=@M1),0),
			TG.M1S3W3IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M1S3 And MainExamid=@M1),0),
			
			TG.M1S1W3ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M1S1 And MainExamid=@M1),0),
			TG.M1S2W3ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M1S2 And MainExamid=@M1),0),
			TG.M1S3W3ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M1S3 And MainExamid=@M1),0),
						
			TG.M1S1W3FullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M1S1 And MainExamid=@M1),0),
			TG.M1S2W3FullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M1S2 And MainExamid=@M1),0),
			TG.M1S3W3FullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M1S3 And MainExamid=@M1),0),
																													 					
			TG.M1S1SubIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'S' AND SubExamId= @M1S1 And MainExamid=@M1),0),
			TG.M1S2SubIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'S' AND SubExamId= @M1S2 And MainExamid=@M1),0),
			TG.M1S3SubIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'S' AND SubExamId= @M1S3 And MainExamid=@M1),0),
			
			TG.M1S1SubExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='S' AND SubExamId= @M1S1 And MainExamid=@M1),0),
			TG.M1S2SubExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='S' AND SubExamId= @M1S2 And MainExamid=@M1),0),
			TG.M1S3SubExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='S' AND SubExamId= @M1S3 And MainExamid=@M1),0),
					
			TG.M1S1SubFullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='S' AND SubExamId= @M1S1 And MainExamid=@M1),0),
			TG.M1S2SubFullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='S' AND SubExamId= @M1S2 And MainExamid=@M1),0),
			TG.M1S3SubFullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='S' AND SubExamId= @M1S3 And MainExamid=@M1),0),
		
																									 				 					 
			TG.M1S1ObjIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'O' AND SubExamId= @M1S1 And MainExamid=@M1),0),
			TG.M1S2ObjIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'O' AND SubExamId= @M1S2 And MainExamid=@M1),0),
			TG.M1S3ObjIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'O' AND SubExamId= @M1S3 And MainExamid=@M1),0),
			
			TG.M1S1ObjExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='O' AND SubExamId= @M1S1 And MainExamid=@M1),0),
			TG.M1S2ObjExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='O' AND SubExamId= @M1S2 And MainExamid=@M1),0),
			TG.M1S3ObjExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='O' AND SubExamId= @M1S3 And MainExamid=@M1),0),
						
			TG.M1S1ObjFullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='O' AND SubExamId= @M1S1 And MainExamid=@M1),0),
			TG.M1S2ObjFullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='O' AND SubExamId= @M1S2 And MainExamid=@M1),0),
			TG.M1S3ObjFullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='O' AND SubExamId= @M1S3 And MainExamid=@M1),0),
			
																									 		 							  
			TG.M1S1PraIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'P' AND SubExamId= @M1S1 And MainExamid=@M1),0),
			TG.M1S2PraIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'P' AND SubExamId= @M1S2 And MainExamid=@M1),0),
			TG.M1S3PraIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'P' AND SubExamId= @M1S3 And MainExamid=@M1),0),

			TG.M1S1PraExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='P' AND SubExamId= @M1S1 And MainExamid=@M1),0),
			TG.M1S2PraExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='P' AND SubExamId= @M1S2 And MainExamid=@M1),0),
			TG.M1S3PraExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='P' AND SubExamId= @M1S3 And MainExamid=@M1),0),
			
			TG.M1S1PraFullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='P' AND SubExamId= @M1S1 And MainExamid=@M1),0),
			TG.M1S2PraFullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='P' AND SubExamId= @M1S2 And MainExamid=@M1),0),
			TG.M1S3PraFullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='P' AND SubExamId= @M1S3 And MainExamid=@M1),0),

			TG.M1ExamMark = M.MainExamFullMarks
			

		FROM #tempGrand TG INNER JOIN #tempQry_MarkSetup  M ON M.MainExamSubjectID =   TG.SubjectId AND M.[MainExamId] = @M1  
			

			UPDATE  TG SET 
		
			TG.M1S1ExamMark =  ISNULL((SELECT top 1 SubExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID  AND SubExamId= @M1S1 And MainExamid=@M1),0),
			TG.M1S1ExamConvMark =  ISNULL((SELECT top 1 SubExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID  AND SubExamId= @M1S1 And MainExamid=@M1),0),
			
			TG.M1S2ExamMark =  ISNULL((SELECT top 1 SubExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID  AND SubExamId= @M1S2 And MainExamid=@M1),0),
			TG.M1S2ExamConvMark =  ISNULL((SELECT top 1 SubExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID  AND SubExamId= @M1S2 And MainExamid=@M1),0)
			

		FROM #tempGrand TG INNER JOIN #tempQry_MarkSetup  M ON M.MainExamSubjectID =   TG.SubjectId AND M.[MainExamId] = @M1  
		

		PRINT @@rowcount
		END --  M1 END 
		PRINT ' M1 Done'


		------------------------------------------------------------------------------------------------------------------- Main exam 2
	  IF(@M2 != null or @M2 != 0) ---  BEGIN M2
	  BEGIN
	
	  --M2 S1
	  IF(@M2S1 != null or @M2S1 != 0)
	  BEGIN
		    Update TG set 
		  TG.[M2Name] = (select MainExamName from Res_MainExam where MainExamId=@M2)
		 ,TG.M2S1Name = (SELECT SubExamName FROM Res_SubExam WHERE Res_SubExam.SubExamId = @M2S1)
		 ,TG.M2S1W1Obt =MERD.[WrittenObt1]
		 ,TG.M2S1W1Conv =MERD.[WrittenConv1]
		 ,TG.M2S1W1Frac =MERD.[WrittenFrac1]
		 ,TG.M2S1W1IsPass =MERD.[WrittenIsPass1]
		 ,TG.M2S1W1IsAbs =MERD.[WrittenIsAbsent1]
		 ,TG.M2S1W2Obt =MERD.[WrittenObt2]
		 ,TG.M2S1W2Conv =MERD.[WrittenConv2]
		 ,TG.M2S1W2Frac =MERD.[WrittenFrac2]
		 ,TG.M2S1W2IsPass =MERD.[WrittenIsPass2]
		 ,TG.M2S1W2IsAbs =MERD.[WrittenIsAbsent2]
		 ,TG.M2S1W3Obt =MERD.[WrittenObt3]
		 ,TG.M2S1W3Conv =MERD.[WrittenConv3]
		 ,TG.M2S1W3Frac =MERD.[WrittenFrac3]
		 ,TG.M2S1W3IsPass =MERD.[WrittenIsPass3]
		 ,TG.M2S1W3IsAbs =MERD.[WrittenIsAbsent3]
		 ,TG.M2S1SubObt =MERD.[SubjectiveObt]
		 ,TG.M2S1SubConv =MERD.[SubjectiveConv]
		 ,TG.M2S1SubFrac =MERD.[SubjectiveFrac]
		 ,TG.M2S1SubIsPass =MERD.[SubjectiveIsPass]
		 ,TG.M2S1SubIsAbs =MERD.[SubjectiveIsAbsent]
		 ,TG.M2S1ObjObt=MERD.[ObjectiveObt]
		 ,TG.M2S1ObjConv=MERD.[ObjectiveConv]
		 ,TG.M2S1ObjFrac=MERD.[ObjectiveFrac]
		 ,TG.M2S1ObjIsPass=MERD.[ObjectiveIsPass]
		 ,TG.M2S1ObjIsAbs=MERD.[ObjectiveIsAbsent]
		 ,TG.M2S1PraObt=MERD.[PracticalObt]
		 ,TG.M2S1PraConv=MERD.[PracticalConv]
		 ,TG.M2S1PraFrac=MERD.[PracticalFrac]
		 ,TG.M2S1PraIsPass=MERD.[PracticalIsPass]
		 ,TG.M2S1PraIsAbs=MERD.[PracticalIsAbsent]
		 ,TG.M2S1TotalObt=MERD.[SubExamTotalObt]
		 ,TG.M2S1TotalConv=MERD.[SubExamTotalConv]
		 ,TG.M2S1TotalFrac=MERD.[SubExamTotalFrac]
		 ,TG.M2S1OrigTotalObt =MERD.SubExamOriginalTotalObt
		 ,TG.M2S1IsPass=MERD.[SubExamIsPass]
		 ,TG.M2S1IsAbs=MERD.[SubExamIsAbsent]
		 ,TG.M2S1SOPTotalObt = MERD.SOPTotalObt
		 ,TG.M2S1SOPTotalConv= MERD.SOPTotalConv
		 ,TG.M2S1SOPTotalFrac = MERD.SOPTotalFrac
		
	    FROM #tempGrand TG
		INNER JOIN  Res_MEResultDetails MERD ON [SubExamId]  = @M2S1  AND MERD.[StudentIID] = TG.StudentIID	AND TG.SubjectId = MERD.SubjectID
	


		
		END --  End of M2S1

	  --M2 S2
	  IF(@M2S2 != null or @M2S2 != 0)
	  BEGIN
		    Update TG set 
		
		 TG.M2S2Name = (SELECT SubExamName FROM Res_SubExam WHERE Res_SubExam.SubExamId = @M2S2)
		 ,TG.M2S2W1Obt =MERD.[WrittenObt1]
		 ,TG.M2S2W1Conv =MERD.[WrittenConv1]
		 ,TG.M2S2W1Frac =MERD.[WrittenFrac1]
		 ,TG.M2S2W1IsPass =MERD.[WrittenIsPass1]
		 ,TG.M2S2W1IsAbs =MERD.[WrittenIsAbsent1]
		 ,TG.M2S2W2Obt =MERD.[WrittenObt2]
		 ,TG.M2S2W2Conv =MERD.[WrittenConv2]
		 ,TG.M2S2W2Frac =MERD.[WrittenFrac2]
		 ,TG.M2S2W2IsPass =MERD.[WrittenIsPass2]
		 ,TG.M2S2W2IsAbs =MERD.[WrittenIsAbsent2]
		 ,TG.M2S2W3Obt =MERD.[WrittenObt3]
		 ,TG.M2S2W3Conv =MERD.[WrittenConv3]
		 ,TG.M2S2W3Frac =MERD.[WrittenFrac3]
		 ,TG.M2S2W3IsPass =MERD.[WrittenIsPass3]
		 ,TG.M2S2W3IsAbs =MERD.[WrittenIsAbsent3]
		 ,TG.M2S2SubObt =MERD.[SubjectiveObt]
		 ,TG.M2S2SubConv =MERD.[SubjectiveConv]
		 ,TG.M2S2SubFrac =MERD.[SubjectiveFrac]
		 ,TG.M2S2SubIsPass =MERD.[SubjectiveIsPass]
		 ,TG.M2S2SubIsAbs =MERD.[SubjectiveIsAbsent]
		 ,TG.M2S2ObjObt=MERD.[ObjectiveObt]
		 ,TG.M2S2ObjConv=MERD.[ObjectiveConv]
		 ,TG.M2S2ObjFrac=MERD.[ObjectiveFrac]
		 ,TG.M2S2ObjIsPass=MERD.[ObjectiveIsPass]
		 ,TG.M2S2ObjIsAbs=MERD.[ObjectiveIsAbsent]
		 ,TG.M2S2PraObt=MERD.[PracticalObt]
		 ,TG.M2S2PraConv=MERD.[PracticalConv]
		 ,TG.M2S2PraFrac=MERD.[PracticalFrac]
		 ,TG.M2S2PraIsPass=MERD.[PracticalIsPass]
		 ,TG.M2S2PraIsAbs=MERD.[PracticalIsAbsent]
		 ,TG.M2S2TotalObt=MERD.[SubExamTotalObt]
		 ,TG.M2S2TotalConv=MERD.[SubExamTotalConv]
		 ,TG.M2S2TotalFrac=MERD.[SubExamTotalFrac]
		 ,TG.M2S2OrigTotalObt = MERD.[SubExamOriginalTotalObt]
		 ,TG.M2S2IsPass=MERD.[SubExamIsPass]
		 ,TG.M2S2IsAbs=MERD.[SubExamIsAbsent]
		 ,TG.M2S2SOPTotalObt = MERD.SOPTotalObt
		 ,TG.M2S2SOPTotalConv= MERD.SOPTotalConv
		 ,TG.M2S2SOPTotalFrac = MERD.SOPTotalFrac
	    FROM #tempGrand TG
		INNER JOIN  Res_MEResultDetails MERD ON [SubExamId]  = @M2S2  AND MERD.[StudentIID] = TG.StudentIID	AND TG.SubjectId = MERD.SubjectID
	
		END --  END OF M2S2

	  IF(@M2S3 != null or @M2S3 != 0)
	  BEGIN
		    Update TG set 
		
		 TG.M2S3Name = (SELECT SubExamName FROM Res_SubExam WHERE Res_SubExam.SubExamId = @M2S3)
		 ,TG.M2S3W1Obt =MERD.[WrittenObt1]
		 ,TG.M2S3W1Conv =MERD.[WrittenConv1]
		 ,TG.M2S3W1Frac =MERD.[WrittenFrac1]
		 ,TG.M2S3W1IsPass =MERD.[WrittenIsPass1]
		 ,TG.M2S3W1IsAbs =MERD.[WrittenIsAbsent1]
		 ,TG.M2S3W2Obt =MERD.[WrittenObt2]
		 ,TG.M2S3W2Conv =MERD.[WrittenConv2]
		 ,TG.M2S3W2Frac =MERD.[WrittenFrac2]
		 ,TG.M2S3W2IsPass =MERD.[WrittenIsPass2]
		 ,TG.M2S3W2IsAbs =MERD.[WrittenIsAbsent2]
		 ,TG.M2S3W3Obt =MERD.[WrittenObt3]
		 ,TG.M2S3W3Conv =MERD.[WrittenConv3]
		 ,TG.M2S3W3Frac =MERD.[WrittenFrac3]
		 ,TG.M2S3W3IsPass =MERD.[WrittenIsPass3]
		 ,TG.M2S3W3IsAbs =MERD.[WrittenIsAbsent3]
		 ,TG.M2S3SubObt =MERD.[SubjectiveObt]
		 ,TG.M2S3SubConv =MERD.[SubjectiveConv]
		 ,TG.M2S3SubFrac =MERD.[SubjectiveFrac]
		 ,TG.M2S3SubIsPass =MERD.[SubjectiveIsPass]
		 ,TG.M2S3SubIsAbs =MERD.[SubjectiveIsAbsent]
		 ,TG.M2S3ObjObt=MERD.[ObjectiveObt]
		 ,TG.M2S3ObjConv=MERD.[ObjectiveConv]
		 ,TG.M2S3ObjFrac=MERD.[ObjectiveFrac]
		 ,TG.M2S3ObjIsPass=MERD.[ObjectiveIsPass]
		 ,TG.M2S3ObjIsAbs=MERD.[ObjectiveIsAbsent]
		 ,TG.M2S3PraObt=MERD.[PracticalObt]
		 ,TG.M2S3PraConv=MERD.[PracticalConv]
		 ,TG.M2S3PraFrac=MERD.[PracticalFrac]
		 ,TG.M2S3PraIsPass=MERD.[PracticalIsPass]
		 ,TG.M2S3PraIsAbs=MERD.[PracticalIsAbsent]
		 ,TG.M2S3TotalObt=MERD.[SubExamTotalObt]
		 ,TG.M2S3TotalConv=MERD.[SubExamTotalConv]
		 ,TG.M2S3TotalFrac=MERD.[SubExamTotalFrac]
		 ,TG.M2S3OrigTotalObt = MERD.[SubExamOriginalTotalObt]
		 ,TG.M2S3IsPass=MERD.[SubExamIsPass]
		 ,TG.M2S3IsAbs=MERD.[SubExamIsAbsent]
		 ,TG.M2S3SOPTotalObt = MERD.SOPTotalObt
		 ,TG.M2S3SOPTotalConv= MERD.SOPTotalConv
		 ,TG.M2S3SOPTotalFrac = MERD.SOPTotalFrac
	    FROM #tempGrand TG
		INNER JOIN  Res_MEResultDetails MERD ON [SubExamId]  = @M2S3  AND MERD.[StudentIID] = TG.StudentIID	AND TG.SubjectId = MERD.SubjectID
	END --  END OF M2S2
	----------------------------------------------------------------------------- Update All GP, GL,GPA Subjectwise
			UPDATE  TG SET 
			TG.M2SubjectGP = SUBDET.SubjectGP  , 
			TG.M2SubjectGL = SUBDET.SubjectGL , 
			TG.M2SubjectObtMarks = SUBDET.SubjectObtMarks,
			TG.M2SubjectConvertedMarks  = SUBDET.SubjectConvertedMarks,
			TG.M2SubjectConvMarksFrac = SUBDET.SubjectConvertedMarksFraction,
			TG.M2SubjectHighestMarks = SUBDET.SubjectHighestMark,
			TG.M2SubjectIsPass = SUBDET.SubjectIsPass,
			TG.M2VirtualConvertedMarks1 = SUBDET.VirtualConvertedMarks1,
			TG.M2VirtualIsPass1 = SUBDET.VirtualIsPass1,
			TG.M2VirtualConvertedMarks2 = SUBDET.VirtualConvertedMarks2,
			TG.M2VirtualIsPass2 = SUBDET.VirtualIsPass2
			FROM #tempGrand TG INNER JOIN  [Res_MainExamResultSubjectDetails] SUBDET  ON SUBDET.SubjectID =  TG.SubjectID AND SUBDET.StudentIID= TG.StudentIID  AND SUBDET.MainExamId = @M2

	------------------------------------------------------------------------------ Update All GP, GL,GPA For M2
			UPDATE  TG SET 
				TG.M2IsPass  = RES.IsPass,
				TG.M2GPA = RES.GPA  ,
				TG.M2GradeLetter = RES.GradeLetter,
				TG.M2TotalGP = RES.TotalGP,
				TG.M2FailStudentGPA = RES.FailStudentGPA,
				TG.M2ClassWiseMerit = RES.ClassWiseMerit ,
				TG.M2SectionWiseMerit= RES.SectionWiseMerit,		 
				TG.M2ShiftWiseMerit = RES.ShiftWiseMerit,
				TG.[M2TotalConvertedMarks] = RES.TotalConvertedMarks,
				TG.[M2TotalConvertedMarksFraction] = RES.TotalConvertedMarksFraction 
			FROM #tempGrand TG INNER JOIN [dbo].[Res_MainExamResult] RES  ON RES.MainExamId =  @M2   and RES.StudentIID=TG.StudentIID
			
			UPDATE  TG SET 
		
			TG.M2S1W1IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M2S1 And MainExamid=@M2),0),
			TG.M2S2W1IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M2S2 And MainExamid=@M2),0),
			TG.M2S3W1IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M2S3 And MainExamid=@M2),0),

			TG.M2S1W1ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M2S1 And MainExamid=@M2),0),
			TG.M2S2W1ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M2S2 And MainExamid=@M2),0),
			TG.M2S3W1ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M2S3 And MainExamid=@M2),0),
			
			TG.M2S1W1FullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M2S1 And MainExamid=@M2),0),
			TG.M2S2W1FullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M2S2 And MainExamid=@M2),0),
			TG.M2S3W1FullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M2S3 And MainExamid=@M2),0),
							 																											 
			TG.M2S1W2IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M2S1 And MainExamid=@M2),0),
			TG.M2S2W2IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M2S2 And MainExamid=@M2),0),
			TG.M2S3W2IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M2S3 And MainExamid=@M2),0),
			
			TG.M2S1W2ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M2S1 And MainExamid=@M2),0),
			TG.M2S2W2ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M2S2 And MainExamid=@M2),0),
			TG.M2S3W2ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M2S3 And MainExamid=@M2),0),
			
			TG.M2S1W2FullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M2S1 And MainExamid=@M2),0),
			TG.M2S2W2FullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M2S2 And MainExamid=@M2),0),
			TG.M2S3W2FullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M2S3 And MainExamid=@M2),0),
			
								 																						 					
			TG.M2S1W3IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M2S1 And MainExamid=@M2),0),
			TG.M2S2W3IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M2S2 And MainExamid=@M2),0),
			TG.M2S3W3IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M2S3 And MainExamid=@M2),0),
			
			TG.M2S1W3ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M2S1 And MainExamid=@M2),0),
			TG.M2S2W3ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M2S2 And MainExamid=@M2),0),
			TG.M2S3W3ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M2S3 And MainExamid=@M2),0),
							
			TG.M2S1W3FullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M2S1 And MainExamid=@M2),0),
			TG.M2S2W3FullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M2S2 And MainExamid=@M2),0),
			TG.M2S3W3FullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M2S3 And MainExamid=@M2),0),
																														 					
			TG.M2S1SubIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'S' AND SubExamId= @M2S1 And MainExamid=@M2),0),
			TG.M2S2SubIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'S' AND SubExamId= @M2S2 And MainExamid=@M2),0),
			TG.M2S3SubIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'S' AND SubExamId= @M2S3 And MainExamid=@M2),0),
			
			TG.M2S1SubExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='S' AND SubExamId= @M2S1 And MainExamid=@M2),0),
			TG.M2S2SubExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='S' AND SubExamId= @M2S2 And MainExamid=@M2),0),
			TG.M2S3SubExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='S' AND SubExamId= @M2S3 And MainExamid=@M2),0),
						
			TG.M2S1SubFullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='S' AND SubExamId= @M2S1 And MainExamid=@M2),0),
			TG.M2S2SubFullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='S' AND SubExamId= @M2S2 And MainExamid=@M2),0),
			TG.M2S3SubFullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='S' AND SubExamId= @M2S3 And MainExamid=@M2),0),
		
																									 				 					 
			TG.M2S1ObjIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'O' AND SubExamId= @M2S1 And MainExamid=@M2),0),
			TG.M2S2ObjIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'O' AND SubExamId= @M2S2 And MainExamid=@M2),0),
			TG.M2S3ObjIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'O' AND SubExamId= @M2S3 And MainExamid=@M2),0),
			
			TG.M2S1ObjExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='O' AND SubExamId= @M2S1 And MainExamid=@M2),0),
			TG.M2S2ObjExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='O' AND SubExamId= @M2S2 And MainExamid=@M2),0),
			TG.M2S3ObjExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='O' AND SubExamId= @M2S3 And MainExamid=@M2),0),
						
			TG.M2S1ObjFullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='O' AND SubExamId= @M2S1 And MainExamid=@M2),0),
			TG.M2S2ObjFullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='O' AND SubExamId= @M2S2 And MainExamid=@M2),0),
			TG.M2S3ObjFullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='O' AND SubExamId= @M2S3 And MainExamid=@M2),0),
			
																									 		 							  
			TG.M2S1PraIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'P' AND SubExamId= @M2S1 And MainExamid=@M2),0),
			TG.M2S2PraIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'P' AND SubExamId= @M2S2 And MainExamid=@M2),0),
			TG.M2S3PraIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'P' AND SubExamId= @M2S3 And MainExamid=@M2),0),

			TG.M2S1PraExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='P' AND SubExamId= @M2S1 And MainExamid=@M2),0),
			TG.M2S2PraExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='P' AND SubExamId= @M2S2 And MainExamid=@M2),0),
			TG.M2S3PraExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='P' AND SubExamId= @M2S3 And MainExamid=@M2),0),
		
			TG.M2S1PraFullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='P' AND SubExamId= @M2S1 And MainExamid=@M2),0),
			TG.M2S2PraFullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='P' AND SubExamId= @M2S2 And MainExamid=@M2),0),
			TG.M2S3PraFullMark =  ISNULL((SELECT DividedExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='P' AND SubExamId= @M2S3 And MainExamid=@M2),0),
	
			TG.M2ExamMark =  ISNULL((SELECT TOP 1 MainExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND MainExamid=@M2),0)

		FROM #tempGrand TG INNER JOIN #tempQry_MarkSetup  M ON M.MainExamSubjectID =   TG.SubjectId AND M.[MainExamId] = @M2
			

			UPDATE  TG SET 
		
			TG.M2S1ExamMark =  ISNULL((SELECT top 1 SubExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID  AND SubExamId= @M2S1 And MainExamid=@M2),0),
			TG.M2S1ExamConvMark =  ISNULL((SELECT top 1 SubExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID  AND SubExamId= @M2S1 And MainExamid=@M2),0),
			
			TG.M2S2ExamMark =  ISNULL((SELECT top 1 SubExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID  AND SubExamId= @M2S2 And MainExamid=@M2),0),
			TG.M2S2ExamConvMark =  ISNULL((SELECT top 1 SubExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID  AND SubExamId= @M2S2 And MainExamid=@M2),0)
			

		FROM #tempGrand TG INNER JOIN #tempQry_MarkSetup  M ON M.MainExamSubjectID =   TG.SubjectId AND M.[MainExamId] = @M2  
		
		END --  M2 END	

	    ------------------------------------------------------------------------------------------------------------------- Main exam 3
	  
	  IF(@M3 != null or @M3 != 0) ---  BEGIN M3
	  BEGIN
		DECLARE @MName3  varchar(200)  = (select MainExamName from Res_MainExam where MainExamId=@M3)
		print ' Main Exam 3: ' +@MName3
	  --M3 S1
	  IF(@M3S1 != null or @M3S1 != 0)
	  BEGIN
		    Update TG set 
		  TG.[M3Name] = @MName3
		 ,TG.M3S1Name = (SELECT SubExamName FROM Res_SubExam WHERE Res_SubExam.SubExamId = @M3S1)
		 ,TG.M3S1W1Obt =MERD.[WrittenObt1]
		 ,TG.M3S1W1Conv =MERD.[WrittenConv1]
		 ,TG.M3S1W1Frac =MERD.[WrittenFrac1]
		 ,TG.M3S1W1IsPass =MERD.[WrittenIsPass1]
		 ,TG.M3S1W1IsAbs =MERD.[WrittenIsAbsent1]
		 ,TG.M3S1W2Obt =MERD.[WrittenObt2]
		 ,TG.M3S1W2Conv =MERD.[WrittenConv2]
		 ,TG.M3S1W2Frac =MERD.[WrittenFrac2]
		 ,TG.M3S1W2IsPass =MERD.[WrittenIsPass2]
		 ,TG.M3S1W2IsAbs =MERD.[WrittenIsAbsent2]
		 ,TG.M3S1W3Obt =MERD.[WrittenObt3]
		 ,TG.M3S1W3Conv =MERD.[WrittenConv3]
		 ,TG.M3S1W3Frac =MERD.[WrittenFrac3]
		 ,TG.M3S1W3IsPass =MERD.[WrittenIsPass3]
		 ,TG.M3S1W3IsAbs =MERD.[WrittenIsAbsent3]
		 ,TG.M3S1SubObt =MERD.[SubjectiveObt]
		 ,TG.M3S1SubConv =MERD.[SubjectiveConv]
		 ,TG.M3S1SubFrac =MERD.[SubjectiveFrac]
		 ,TG.M3S1SubIsPass =MERD.[SubjectiveIsPass]
		 ,TG.M3S1SubIsAbs =MERD.[SubjectiveIsAbsent]
		 ,TG.M3S1ObjObt=MERD.[ObjectiveObt]
		 ,TG.M3S1ObjConv=MERD.[ObjectiveConv]
		 ,TG.M3S1ObjFrac=MERD.[ObjectiveFrac]
		 ,TG.M3S1ObjIsPass=MERD.[ObjectiveIsPass]
		 ,TG.M3S1ObjIsAbs=MERD.[ObjectiveIsAbsent]
		 ,TG.M3S1PraObt=MERD.[PracticalObt]
		 ,TG.M3S1PraConv=MERD.[PracticalConv]
		 ,TG.M3S1PraFrac=MERD.[PracticalFrac]
		 ,TG.M3S1PraIsPass=MERD.[PracticalIsPass]
		 ,TG.M3S1PraIsAbs=MERD.[PracticalIsAbsent]
		 ,TG.M3S1TotalObt=MERD.[SubExamTotalObt]
		 ,TG.M3S1TotalConv=MERD.[SubExamTotalConv]
		 ,TG.M3S1TotalFrac=MERD.[SubExamTotalFrac]
		  ,TG.M3S1OrigTotalObt  =MERD.SubExamOriginalTotalObt
		 ,TG.M3S1IsPass=MERD.[SubExamIsPass]
		 ,TG.M3S1IsAbs=MERD.[SubExamIsAbsent]
		 ,TG.M3S1SOPTotalObt = MERD.SOPTotalObt
		 ,TG.M3S1SOPTotalConv= MERD.SOPTotalConv
		 ,TG.M3S1SOPTotalFrac = MERD.SOPTotalFrac
		
	    FROM #tempGrand TG
		INNER JOIN  Res_MEResultDetails MERD ON [SubExamId]  = @M3S1  AND MERD.[StudentIID] = TG.StudentIID	AND TG.SubjectId = MERD.SubjectID
	


		
		END --  End of M3S1

	  --M3 S2

	  IF(@M3S2 != null or @M3S2 != 0)
	  BEGIN
		    Update TG set 
		
		 TG.M3S2Name = (SELECT SubExamName FROM Res_SubExam WHERE Res_SubExam.SubExamId = @M3S2)
		 ,TG.M3S2W1Obt =MERD.[WrittenObt1]
		 ,TG.M3S2W1Conv =MERD.[WrittenConv1]
		 ,TG.M3S2W1Frac =MERD.[WrittenFrac1]
		 ,TG.M3S2W1IsPass =MERD.[WrittenIsPass1]
		 ,TG.M3S2W1IsAbs =MERD.[WrittenIsAbsent1]
		 ,TG.M3S2W2Obt =MERD.[WrittenObt2]
		 ,TG.M3S2W2Conv =MERD.[WrittenConv2]
		 ,TG.M3S2W2Frac =MERD.[WrittenFrac2]
		 ,TG.M3S2W2IsPass =MERD.[WrittenIsPass2]
		 ,TG.M3S2W2IsAbs =MERD.[WrittenIsAbsent2]
		 ,TG.M3S2W3Obt =MERD.[WrittenObt3]
		 ,TG.M3S2W3Conv =MERD.[WrittenConv3]
		 ,TG.M3S2W3Frac =MERD.[WrittenFrac3]
		 ,TG.M3S2W3IsPass =MERD.[WrittenIsPass3]
		 ,TG.M3S2W3IsAbs =MERD.[WrittenIsAbsent3]
		 ,TG.M3S2SubObt =MERD.[SubjectiveObt]
		 ,TG.M3S2SubConv =MERD.[SubjectiveConv]
		 ,TG.M3S2SubFrac =MERD.[SubjectiveFrac]
		 ,TG.M3S2SubIsPass =MERD.[SubjectiveIsPass]
		 ,TG.M3S2SubIsAbs =MERD.[SubjectiveIsAbsent]
		 ,TG.M3S2ObjObt=MERD.[ObjectiveObt]
		 ,TG.M3S2ObjConv=MERD.[ObjectiveConv]
		 ,TG.M3S2ObjFrac=MERD.[ObjectiveFrac]
		 ,TG.M3S2ObjIsPass=MERD.[ObjectiveIsPass]
		 ,TG.M3S2ObjIsAbs=MERD.[ObjectiveIsAbsent]
		 ,TG.M3S2PraObt=MERD.[PracticalObt]
		 ,TG.M3S2PraConv=MERD.[PracticalConv]
		 ,TG.M3S2PraFrac=MERD.[PracticalFrac]
		 ,TG.M3S2PraIsPass=MERD.[PracticalIsPass]
		 ,TG.M3S2PraIsAbs=MERD.[PracticalIsAbsent]
		 ,TG.M3S2TotalObt=MERD.[SubExamTotalObt]
		 ,TG.M3S2TotalConv=MERD.[SubExamTotalConv]
		 ,TG.M3S2TotalFrac=MERD.[SubExamTotalFrac]
		 ,TG.M3S2OrigTotalObt  =MERD.SubExamOriginalTotalObt
		 ,TG.M3S2IsPass=MERD.[SubExamIsPass]
		 ,TG.M3S2IsAbs=MERD.[SubExamIsAbsent]
		 ,TG.M3S2SOPTotalObt = MERD.SOPTotalObt
		 ,TG.M3S2SOPTotalConv= MERD.SOPTotalConv
		 ,TG.M3S2SOPTotalFrac = MERD.SOPTotalFrac
	    FROM #tempGrand TG
		INNER JOIN  Res_MEResultDetails MERD ON [SubExamId]  = @M3S2  AND MERD.[StudentIID] = TG.StudentIID	AND TG.SubjectId = MERD.SubjectID
	
	
		PRINT @@rowcount

		
		END --  END OF M3S2

	  IF(@M3S3 != null or @M3S3 != 0)
	  BEGIN
		  Update TG set 
		  TG.M3S3Name = (SELECT SubExamName FROM Res_SubExam WHERE Res_SubExam.SubExamId = @M3S3)
		 ,TG.M3S3W1Obt =MERD.[WrittenObt1]
		 ,TG.M3S3W1Conv =MERD.[WrittenConv1]
		 ,TG.M3S3W1Frac =MERD.[WrittenFrac1]
		 ,TG.M3S3W1IsPass =MERD.[WrittenIsPass1]
		 ,TG.M3S3W1IsAbs =MERD.[WrittenIsAbsent1]
		 ,TG.M3S3W2Obt =MERD.[WrittenObt2]
		 ,TG.M3S3W2Conv =MERD.[WrittenConv2]
		 ,TG.M3S3W2Frac =MERD.[WrittenFrac2]
		 ,TG.M3S3W2IsPass =MERD.[WrittenIsPass2]
		 ,TG.M3S3W2IsAbs =MERD.[WrittenIsAbsent2]
		 ,TG.M3S3W3Obt =MERD.[WrittenObt3]
		 ,TG.M3S3W3Conv =MERD.[WrittenConv3]
		 ,TG.M3S3W3Frac =MERD.[WrittenFrac3]
		 ,TG.M3S3W3IsPass =MERD.[WrittenIsPass3]
		 ,TG.M3S3W3IsAbs =MERD.[WrittenIsAbsent3]
		 ,TG.M3S3SubObt =MERD.[SubjectiveObt]
		 ,TG.M3S3SubConv =MERD.[SubjectiveConv]
		 ,TG.M3S3SubFrac =MERD.[SubjectiveFrac]
		 ,TG.M3S3SubIsPass =MERD.[SubjectiveIsPass]
		 ,TG.M3S3SubIsAbs =MERD.[SubjectiveIsAbsent]
		 ,TG.M3S3ObjObt=MERD.[ObjectiveObt]
		 ,TG.M3S3ObjConv=MERD.[ObjectiveConv]
		 ,TG.M3S3ObjFrac=MERD.[ObjectiveFrac]
		 ,TG.M3S3ObjIsPass=MERD.[ObjectiveIsPass]
		 ,TG.M3S3ObjIsAbs=MERD.[ObjectiveIsAbsent]
		 ,TG.M3S3PraObt=MERD.[PracticalObt]
		 ,TG.M3S3PraConv=MERD.[PracticalConv]
		 ,TG.M3S3PraFrac=MERD.[PracticalFrac]
		 ,TG.M3S3PraIsPass=MERD.[PracticalIsPass]
		 ,TG.M3S3PraIsAbs=MERD.[PracticalIsAbsent]
		 ,TG.M3S3TotalObt=MERD.[SubExamTotalObt]
		 ,TG.M3S3TotalConv=MERD.[SubExamTotalConv]
		 ,TG.M3S3TotalFrac=MERD.[SubExamTotalFrac]
		 ,TG.M3S3OrigTotalObt  =MERD.SubExamOriginalTotalObt
		 ,TG.M3S3IsPass=MERD.[SubExamIsPass]
		 ,TG.M3S3IsAbs=MERD.[SubExamIsAbsent]
		 ,TG.M3S3SOPTotalObt = MERD.SOPTotalObt
		 ,TG.M3S3SOPTotalConv= MERD.SOPTotalConv
		 ,TG.M3S3SOPTotalFrac = MERD.SOPTotalFrac
	    FROM #tempGrand TG
		INNER JOIN  Res_MEResultDetails MERD ON [SubExamId]  = @M3S3  AND MERD.[StudentIID] = TG.StudentIID	AND TG.SubjectId = MERD.SubjectID
	END --  END OF M3S3


	--------------------------------------------------------------------- Update All GP, GL,GPA Subjectwise
			UPDATE  TG SET 
			TG.M3SubjectGP = SUBDET.SubjectGP  , 
			TG.M3SubjectGL = SUBDET.SubjectGL , 
	
			TG.M3SubjectObtMarks = SUBDET.SubjectObtMarks,
			TG.M3SubjectConvertedMarks  = SUBDET.SubjectConvertedMarks,
			TG.M3SubjectConvMarksFrac = SUBDET.SubjectConvertedMarksFraction,
			TG.M3SubjectHighestMarks = SUBDET.SubjectHighestMark,
			TG.M3SubjectIsPass = SUBDET.SubjectIsPass,
			TG.M3VirtualConvertedMarks1 = SUBDET.VirtualConvertedMarks1,
			TG.M3VirtualIsPass1 = SUBDET.VirtualIsPass1,
			TG.M3VirtualConvertedMarks2 = SUBDET.VirtualConvertedMarks2,
			TG.M3VirtualIsPass2 = SUBDET.VirtualIsPass2
			FROM #tempGrand TG INNER JOIN  [Res_MainExamResultSubjectDetails] SUBDET  ON SUBDET.SubjectID =  TG.SubjectID AND SUBDET.StudentIID= TG.StudentIID  AND SUBDET.MainExamId = @M3

	----- --------------------------------------------------------------- Update All GP, GL,GPA For M3
			UPDATE  TG SET 
				TG.M3IsPass  = RES.IsPass,
				TG.M3GPA = RES.GPA  ,
				TG.M3GradeLetter = RES.GradeLetter,
				TG.M3TotalGP = RES.TotalGP,
				TG.M3FailStudentGPA = RES.FailStudentGPA,
				TG.M3ClassWiseMerit = RES.ClassWiseMerit ,
				TG.M3SectionWiseMerit= RES.SectionWiseMerit,		 
				TG.M3ShiftWiseMerit = RES.ShiftWiseMerit,
				TG.[M3TotalConvertedMarks] = RES.TotalConvertedMarks,
				TG.[M3TotalConvertedMarksFraction] = RES.TotalConvertedMarksFraction 
			FROM #tempGrand TG INNER JOIN [dbo].[Res_MainExamResult] RES  ON RES.MainExamId =  @M3  and RES.StudentIID=TG.StudentIID



			UPDATE  TG SET 

		    TG.M3S1W1IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M3S1 And MainExamid=@M3),0),
			TG.M3S2W1IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M3S2 And MainExamid=@M3),0),
			TG.M3S3W1IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M3S3 And MainExamid=@M3),0),

			TG.M3S1W1ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M3S1 And MainExamid=@M3),0),
			TG.M3S2W1ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M3S2 And MainExamid=@M3),0),
			TG.M3S3W1ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M3S3 And MainExamid=@M3),0),
								 																											 
			TG.M3S1W2IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M3S1 And MainExamid=@M3),0),
			TG.M3S2W2IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M3S2 And MainExamid=@M3),0),
			TG.M3S3W2IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M3S3 And MainExamid=@M3),0),
			
			TG.M3S1W2ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M3S1 And MainExamid=@M3),0),
			TG.M3S2W2ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M3S2 And MainExamid=@M3),0),
			TG.M3S3W2ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M3S3 And MainExamid=@M3),0),
			
								 																						 					
			TG.M3S1W3IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M3S1 And MainExamid=@M3),0),
			TG.M3S2W3IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M3S2 And MainExamid=@M3),0),
			TG.M3S3W3IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M3S3 And MainExamid=@M3),0),
			
			TG.M3S1W3ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M3S1 And MainExamid=@M3),0),
			TG.M3S2W3ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M3S2 And MainExamid=@M3),0),
			TG.M3S3W3ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M3S3 And MainExamid=@M3),0),
																														 					
			TG.M3S1SubIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'S' AND SubExamId= @M3S1 And MainExamid=@M3),0),
			TG.M3S2SubIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'S' AND SubExamId= @M3S2 And MainExamid=@M3),0),
			TG.M3S3SubIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'S' AND SubExamId= @M3S3 And MainExamid=@M3),0),
			
			TG.M3S1SubExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='S' AND SubExamId= @M3S1 And MainExamid=@M3),0),
			TG.M3S2SubExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='S' AND SubExamId= @M3S2 And MainExamid=@M3),0),
			TG.M3S3SubExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='S' AND SubExamId= @M3S3 And MainExamid=@M3),0),
			
																									 				 					 
			TG.M3S1ObjIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'O' AND SubExamId= @M3S1 And MainExamid=@M3),0),
			TG.M3S2ObjIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'O' AND SubExamId= @M3S2 And MainExamid=@M3),0),
			TG.M3S3ObjIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'O' AND SubExamId= @M3S3 And MainExamid=@M3),0),
			
			TG.M3S1ObjExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='O' AND SubExamId= @M3S1 And MainExamid=@M3),0),
			TG.M3S2ObjExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='O' AND SubExamId= @M3S2 And MainExamid=@M3),0),
			TG.M3S3ObjExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='O' AND SubExamId= @M3S3 And MainExamid=@M3),0),
			
																									 		 							  
			TG.M3S1PraIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'P' AND SubExamId= @M3S1 And MainExamid=@M3),0),
			TG.M3S2PraIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'P' AND SubExamId= @M3S2 And MainExamid=@M3),0),
			TG.M3S3PraIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'P' AND SubExamId= @M3S3 And MainExamid=@M3),0),

			TG.M3S1PraExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='P' AND SubExamId= @M3S1 And MainExamid=@M3),0),
			TG.M3S2PraExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='P' AND SubExamId= @M3S2 And MainExamid=@M3),0),
			TG.M3S3PraExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='P' AND SubExamId= @M3S3 And MainExamid=@M3),0),
			TG.M3ExamMark =  ISNULL((SELECT TOP 1 MainExamFullMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND MainExamid=@M3),0)

		FROM #tempGrand TG INNER JOIN #tempQry_MarkSetup  M ON M.MainExamSubjectID =   TG.SubjectId AND M.[MainExamId] = @M3  
			
		PRINT @@rowcount
		END --  M3 END 
		PRINT ' M3 Done'

		 ------------------------------------------------------------------------------------------------------------------- Main exam 3
	  
	  IF(@M4 != null or @M4 != 0) ---  BEGIN M4
	  BEGIN
		DECLARE @MName4  varchar(200)  = (select MainExamName from Res_MainExam where MainExamId=@M4)
	 	print ' Main Exam 4: ' +@MName4
	  --M4 S1
	  IF(@M4S1 != null or @M4S1 != 0)
	  BEGIN
		    Update TG set 
		  TG.[M4Name] = @MName1
		 ,TG.M4S1Name = (SELECT SubExamName FROM Res_SubExam WHERE Res_SubExam.SubExamId = @M4S1)
		 ,TG.M4S1W1Obt =MERD.[WrittenObt1]
		 ,TG.M4S1W1Conv =MERD.[WrittenConv1]
		 ,TG.M4S1W1Frac =MERD.[WrittenFrac1]
		 ,TG.M4S1W1IsPass =MERD.[WrittenIsPass1]
		 ,TG.M4S1W1IsAbs =MERD.[WrittenIsAbsent1]
		 ,TG.M4S1W2Obt =MERD.[WrittenObt2]
		 ,TG.M4S1W2Conv =MERD.[WrittenConv2]
		 ,TG.M4S1W2Frac =MERD.[WrittenFrac2]
		 ,TG.M4S1W2IsPass =MERD.[WrittenIsPass2]
		 ,TG.M4S1W2IsAbs =MERD.[WrittenIsAbsent2]
		 ,TG.M4S1W3Obt =MERD.[WrittenObt3]
		 ,TG.M4S1W3Conv =MERD.[WrittenConv3]
		 ,TG.M4S1W3Frac =MERD.[WrittenFrac3]
		 ,TG.M4S1W3IsPass =MERD.[WrittenIsPass3]
		 ,TG.M4S1W3IsAbs =MERD.[WrittenIsAbsent3]
		 ,TG.M4S1SubObt =MERD.[SubjectiveObt]
		 ,TG.M4S1SubConv =MERD.[SubjectiveConv]
		 ,TG.M4S1SubFrac =MERD.[SubjectiveFrac]
		 ,TG.M4S1SubIsPass =MERD.[SubjectiveIsPass]
		 ,TG.M4S1SubIsAbs =MERD.[SubjectiveIsAbsent]
		 ,TG.M4S1ObjObt=MERD.[ObjectiveObt]
		 ,TG.M4S1ObjConv=MERD.[ObjectiveConv]
		 ,TG.M4S1ObjFrac=MERD.[ObjectiveFrac]
		 ,TG.M4S1ObjIsPass=MERD.[ObjectiveIsPass]
		 ,TG.M4S1ObjIsAbs=MERD.[ObjectiveIsAbsent]
		 ,TG.M4S1PraObt=MERD.[PracticalObt]
		 ,TG.M4S1PraConv=MERD.[PracticalConv]
		 ,TG.M4S1PraFrac=MERD.[PracticalFrac]
		 ,TG.M4S1PraIsPass=MERD.[PracticalIsPass]
		 ,TG.M4S1PraIsAbs=MERD.[PracticalIsAbsent]
		 ,TG.M4S1TotalObt=MERD.[SubExamTotalObt]
		 ,TG.M4S1TotalConv=MERD.[SubExamTotalConv]
		 ,TG.M4S1TotalFrac=MERD.[SubExamTotalFrac]
		 ,TG.M4S1OrigTotalObt  =MERD.SubExamOriginalTotalObt
		 ,TG.M4S1IsPass=MERD.[SubExamIsPass]
		 ,TG.M4S1IsAbs=MERD.[SubExamIsAbsent]
		 ,TG.M4S1SOPTotalObt = MERD.SOPTotalObt
		 ,TG.M4S1SOPTotalConv= MERD.SOPTotalConv
		 ,TG.M4S1SOPTotalFrac = MERD.SOPTotalFrac
		
	    FROM #tempGrand TG
		INNER JOIN  Res_MEResultDetails MERD ON [SubExamId]  = @M4S1  AND MERD.[StudentIID] = TG.StudentIID	AND TG.SubjectId = MERD.SubjectID
	


		
		END --  End of M4S1

	  --M4 S2

	  IF(@M4S2 != null or @M4S2 != 0)
	  BEGIN
		    Update TG set 
		
		 TG.M4S2Name = (SELECT SubExamName FROM Res_SubExam WHERE Res_SubExam.SubExamId = @M4S2)
		 ,TG.M4S2W1Obt =MERD.[WrittenObt1]
		 ,TG.M4S2W1Conv =MERD.[WrittenConv1]
		 ,TG.M4S2W1Frac =MERD.[WrittenFrac1]
		 ,TG.M4S2W1IsPass =MERD.[WrittenIsPass1]
		 ,TG.M4S2W1IsAbs =MERD.[WrittenIsAbsent1]
		 ,TG.M4S2W2Obt =MERD.[WrittenObt2]
		 ,TG.M4S2W2Conv =MERD.[WrittenConv2]
		 ,TG.M4S2W2Frac =MERD.[WrittenFrac2]
		 ,TG.M4S2W2IsPass =MERD.[WrittenIsPass2]
		 ,TG.M4S2W2IsAbs =MERD.[WrittenIsAbsent2]
		 ,TG.M4S2W3Obt =MERD.[WrittenObt3]
		 ,TG.M4S2W3Conv =MERD.[WrittenConv3]
		 ,TG.M4S2W3Frac =MERD.[WrittenFrac3]
		 ,TG.M4S2W3IsPass =MERD.[WrittenIsPass3]
		 ,TG.M4S2W3IsAbs =MERD.[WrittenIsAbsent3]
		 ,TG.M4S2SubObt =MERD.[SubjectiveObt]
		 ,TG.M4S2SubConv =MERD.[SubjectiveConv]
		 ,TG.M4S2SubFrac =MERD.[SubjectiveFrac]
		 ,TG.M4S2SubIsPass =MERD.[SubjectiveIsPass]
		 ,TG.M4S2SubIsAbs =MERD.[SubjectiveIsAbsent]
		 ,TG.M4S2ObjObt=MERD.[ObjectiveObt]
		 ,TG.M4S2ObjConv=MERD.[ObjectiveConv]
		 ,TG.M4S2ObjFrac=MERD.[ObjectiveFrac]
		 ,TG.M4S2ObjIsPass=MERD.[ObjectiveIsPass]
		 ,TG.M4S2ObjIsAbs=MERD.[ObjectiveIsAbsent]
		 ,TG.M4S2PraObt=MERD.[PracticalObt]
		 ,TG.M4S2PraConv=MERD.[PracticalConv]
		 ,TG.M4S2PraFrac=MERD.[PracticalFrac]
		 ,TG.M4S2PraIsPass=MERD.[PracticalIsPass]
		 ,TG.M4S2PraIsAbs=MERD.[PracticalIsAbsent]
		 ,TG.M4S2TotalObt=MERD.[SubExamTotalObt]
		 ,TG.M4S2TotalConv=MERD.[SubExamTotalConv]
		 ,TG.M4S2TotalFrac=MERD.[SubExamTotalFrac]
		 ,TG.M4S2OrigTotalObt  =MERD.SubExamOriginalTotalObt
		 ,TG.M4S2IsPass=MERD.[SubExamIsPass]
		 ,TG.M4S2IsAbs=MERD.[SubExamIsAbsent]
		 ,TG.M4S2SOPTotalObt = MERD.SOPTotalObt
		 ,TG.M4S2SOPTotalConv= MERD.SOPTotalConv
		 ,TG.M4S2SOPTotalFrac = MERD.SOPTotalFrac
	    FROM #tempGrand TG
		INNER JOIN  Res_MEResultDetails MERD ON [SubExamId]  = @M4S2  AND MERD.[StudentIID] = TG.StudentIID	AND TG.SubjectId = MERD.SubjectID
	
	
		PRINT @@rowcount

		
		END --  END OF M4S2

	  IF(@M4S3 != null or @M4S3 != 0)
	  BEGIN
		  Update TG set 
		  TG.M4S3Name = (SELECT SubExamName FROM Res_SubExam WHERE Res_SubExam.SubExamId = @M4S3)
		 ,TG.M4S3W1Obt =MERD.[WrittenObt1]
		 ,TG.M4S3W1Conv =MERD.[WrittenConv1]
		 ,TG.M4S3W1Frac =MERD.[WrittenFrac1]
		 ,TG.M4S3W1IsPass =MERD.[WrittenIsPass1]
		 ,TG.M4S3W1IsAbs =MERD.[WrittenIsAbsent1]
		 ,TG.M4S3W2Obt =MERD.[WrittenObt2]
		 ,TG.M4S3W2Conv =MERD.[WrittenConv2]
		 ,TG.M4S3W2Frac =MERD.[WrittenFrac2]
		 ,TG.M4S3W2IsPass =MERD.[WrittenIsPass2]
		 ,TG.M4S3W2IsAbs =MERD.[WrittenIsAbsent2]
		 ,TG.M4S3W3Obt =MERD.[WrittenObt3]
		 ,TG.M4S3W3Conv =MERD.[WrittenConv3]
		 ,TG.M4S3W3Frac =MERD.[WrittenFrac3]
		 ,TG.M4S3W3IsPass =MERD.[WrittenIsPass3]
		 ,TG.M4S3W3IsAbs =MERD.[WrittenIsAbsent3]
		 ,TG.M4S3SubObt =MERD.[SubjectiveObt]
		 ,TG.M4S3SubConv =MERD.[SubjectiveConv]
		 ,TG.M4S3SubFrac =MERD.[SubjectiveFrac]
		 ,TG.M4S3SubIsPass =MERD.[SubjectiveIsPass]
		 ,TG.M4S3SubIsAbs =MERD.[SubjectiveIsAbsent]
		 ,TG.M4S3ObjObt=MERD.[ObjectiveObt]
		 ,TG.M4S3ObjConv=MERD.[ObjectiveConv]
		 ,TG.M4S3ObjFrac=MERD.[ObjectiveFrac]
		 ,TG.M4S3ObjIsPass=MERD.[ObjectiveIsPass]
		 ,TG.M4S3ObjIsAbs=MERD.[ObjectiveIsAbsent]
		 ,TG.M4S3PraObt=MERD.[PracticalObt]
		 ,TG.M4S3PraConv=MERD.[PracticalConv]
		 ,TG.M4S3PraFrac=MERD.[PracticalFrac]
		 ,TG.M4S3PraIsPass=MERD.[PracticalIsPass]
		 ,TG.M4S3PraIsAbs=MERD.[PracticalIsAbsent]
		 ,TG.M4S3TotalObt=MERD.[SubExamTotalObt]
		 ,TG.M4S3TotalConv=MERD.[SubExamTotalConv]
		 ,TG.M4S3TotalFrac=MERD.[SubExamTotalFrac]
		 ,TG.M4S3OrigTotalObt  =MERD.SubExamOriginalTotalObt
		 ,TG.M4S3IsPass=MERD.[SubExamIsPass]
		 ,TG.M4S3IsAbs=MERD.[SubExamIsAbsent]
		 ,TG.M4S3SOPTotalObt = MERD.SOPTotalObt
		 ,TG.M4S3SOPTotalConv= MERD.SOPTotalConv
		 ,TG.M4S3SOPTotalFrac = MERD.SOPTotalFrac
	    FROM #tempGrand TG
		INNER JOIN  Res_MEResultDetails MERD ON [SubExamId]  = @M4S3  AND MERD.[StudentIID] = TG.StudentIID	AND TG.SubjectId = MERD.SubjectID
	END --  END OF M4S3


	--------------------------------------------------------------------- Update All GP, GL,GPA Subjectwise
			UPDATE  TG SET 
			
			TG.M4SubjectGP = SUBDET.SubjectGP  , 
			TG.M4SubjectGL = SUBDET.SubjectGL , 
	
			TG.M4SubjectObtMarks = SUBDET.SubjectObtMarks,
			TG.M4SubjectConvertedMarks  = SUBDET.SubjectConvertedMarks,
			TG.M4SubjectConvMarksFrac = SUBDET.SubjectConvertedMarksFraction,
			TG.M4SubjectHighestMarks = SUBDET.SubjectHighestMark,
			TG.M4VirtualConvertedMarks1 = SUBDET.VirtualConvertedMarks1,
			TG.M4VirtualIsPass1 = SUBDET.VirtualIsPass1,
			TG.M4VirtualConvertedMarks2 = SUBDET.VirtualConvertedMarks2,
			TG.M4VirtualIsPass2 = SUBDET.VirtualIsPass2
			FROM #tempGrand TG INNER JOIN  [Res_MainExamResultSubjectDetails] SUBDET  ON SUBDET.SubjectID =  TG.SubjectID AND SUBDET.StudentIID= TG.StudentIID  AND SUBDET.MainExamId = @M4

	----- --------------------------------------------------------------- Update All GP, GL,GPA For M4
			UPDATE  TG SET 
				TG.M4IsPass  = RES.IsPass,
				TG.M4GPA = RES.GPA  ,
				TG.M4GradeLetter = RES.GradeLetter,
				TG.M4TotalGP = RES.TotalGP,
				TG.M4ClassWiseMerit = RES.ClassWiseMerit ,
				TG.M4SectionWiseMerit= RES.SectionWiseMerit,		 
				TG.M4ShiftWiseMerit = RES.ShiftWiseMerit,
				TG.M4TotalConvertedMarks = RES.TotalConvertedMarks,
				TG.M4TotalConvertedMarksFraction = RES.TotalConvertedMarksFraction 
			FROM #tempGrand TG INNER JOIN [dbo].[Res_MainExamResult] RES  ON RES.MainExamId =  @M4  and RES.StudentIID=TG.StudentIID
			
			UPDATE  TG SET 
		
			TG.M4S1W1IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M4S1 And MainExamid=@M4),0),
			TG.M4S2W1IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M4S2 And MainExamid=@M4),0),
			TG.M4S3W1IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M4S3 And MainExamid=@M4),0),

			TG.M4S1W1ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M4S1 And MainExamid=@M4),0),
			TG.M4S2W1ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M4S2 And MainExamid=@M4),0),
			TG.M4S3W1ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W1' AND SubExamId= @M4S3 And MainExamid=@M4),0),
								 																											 
			TG.M4S1W2IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M4S1 And MainExamid=@M4),0),
			TG.M4S2W2IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M4S2 And MainExamid=@M4),0),
			TG.M4S3W2IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M4S3 And MainExamid=@M4),0),
			
			TG.M4S1W2ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M4S1 And MainExamid=@M4),0),
			TG.M4S2W2ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M4S2 And MainExamid=@M4),0),
			TG.M4S3W2ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W2' AND SubExamId= @M4S3 And MainExamid=@M4),0),
			
								 																						 					
			TG.M4S1W3IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M4S1 And MainExamid=@M4),0),
			TG.M4S2W3IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M4S2 And MainExamid=@M4),0),
			TG.M4S3W3IsEnable =  ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M4S3 And MainExamid=@M4),0),
			
			TG.M4S1W3ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M4S1 And MainExamid=@M4),0),
			TG.M4S2W3ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M4S2 And MainExamid=@M4),0),
			TG.M4S3W3ExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='W3' AND SubExamId= @M4S3 And MainExamid=@M4),0),
																														 					
			TG.M4S1SubIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'S' AND SubExamId= @M4S1 And MainExamid=@M4),0),
			TG.M4S2SubIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'S' AND SubExamId= @M4S2 And MainExamid=@M4),0),
			TG.M4S3SubIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'S' AND SubExamId= @M4S3 And MainExamid=@M4),0),
			
			TG.M4S1SubExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='S' AND SubExamId= @M4S1 And MainExamid=@M4),0),
			TG.M4S2SubExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='S' AND SubExamId= @M4S2 And MainExamid=@M4),0),
			TG.M4S3SubExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='S' AND SubExamId= @M4S3 And MainExamid=@M4),0),
			
																									 				 					 
			TG.M4S1ObjIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'O' AND SubExamId= @M4S1 And MainExamid=@M4),0),
			TG.M4S2ObjIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'O' AND SubExamId= @M4S2 And MainExamid=@M4),0),
			TG.M4S3ObjIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'O' AND SubExamId= @M4S3 And MainExamid=@M4),0),
			
			TG.M4S1ObjExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='O' AND SubExamId= @M4S1 And MainExamid=@M4),0),
			TG.M4S2ObjExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='O' AND SubExamId= @M4S2 And MainExamid=@M4),0),
			TG.M4S3ObjExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='O' AND SubExamId= @M4S3 And MainExamid=@M4),0),
			
																									 		 							  
			TG.M4S1PraIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'P' AND SubExamId= @M4S1 And MainExamid=@M4),0),
			TG.M4S2PraIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'P' AND SubExamId= @M4S2 And MainExamid=@M4),0),
			TG.M4S3PraIsEnable = ISNULL((SELECT DividedExamIsEnable FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType = 'P' AND SubExamId= @M4S3 And MainExamid=@M4),0),

			TG.M4S1PraExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='P' AND SubExamId= @M4S1 And MainExamid=@M4),0),
			TG.M4S2PraExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='P' AND SubExamId= @M4S2 And MainExamid=@M4),0),
			TG.M4S3PraExamMark =  ISNULL((SELECT DividedExamExamMarks FROM #tempQry_MarkSetup MS WHERE Ms.MainExamSubjectId=M.MainExamSubjectID AND DividedExamType ='P' AND SubExamId= @M4S3 And MainExamid=@M4),0)
			
		FROM #tempGrand TG INNER JOIN #tempQry_MarkSetup  M ON M.MainExamSubjectID =   TG.SubjectId AND M.[MainExamId] = @M4  
			
		PRINT @@rowcount
		END --  M4 END 
		PRINT ' M4 Done'


-- Run SQL For Final 

IF((SELECT DB_NAME())='zcpsc_new_db' OR (SELECT DB_NAME())='zcpsc_new_db_GRtest')
BEGIN
		CREATE TABLE #t(
			StudentIID int
			,SubjectConvertedMarks decimal(18,2)
			,SubjectGP decimal(18,2)
			,SubjectIsPass bit
			,SecondPairSubID int
		)

		 	INSERT INTO #t 
			SELECT  t.StudentIID,t.SubjectConvertedFrac,t.SubjectGP,t.SubjectIsPass,s.SecondPairSubID FROM #tempGrand t
			INNER JOIN [dbo].[Res_SubjectSetup] s ON t.SubjectId=s.[SubID]
			 WHERE t.Student_SubjectType='T'  AND StudentIID IN( SELECT * FROM #StuId)
	
		
			SELECT  STU.StudentInsID,STU.FullName, STU.RollNo,Stu.FatherName,Stu.MotherName,
			SType.StudentTypeName,SHouse.HouseName,
			#tempGrand.* ,
			V.VersionName,
			B.BranchName,
			SH.ShiftName,
			SH.ShiftId,
			SE.SessionName,
			C.ClassName,
			G.GroupName,
			SEC.SectionName,
			I.Photo --,
			--AssSub.SubjectName AS AssSubjectName,
			--ASS.HandWriting,
			--ASS.PicReading,
			--ASS.Recitation,
			--ASS.Conversation,
			--ASS.ColourSense,
			--ASS.Art,
			--ASS.Music,
			--ASS.ParticipationInGames,
			--ASS.Obedience,
			--ASS.Tolerance,
			--ASS.SelfReliance,
			--ASS.Leadership,
			--ASS.Interaction_with_Teachers_and_Peers,
			--Att.PresentDay,
			--Att.TotalWorkingDays
			,(SELECT SubjectConvertedMarks FROM #t WHERE StudentIID=#tempGrand.StudentIID AND SecondPairSubID=#tempGrand.SubjectId) AS PairTotal
			,(SELECT SubjectGP FROM #t WHERE StudentIID=#tempGrand.StudentIID AND SecondPairSubID=#tempGrand.SubjectId) AS PairGP
			,(SELECT SubjectIsPass FROM #t WHERE StudentIID=#tempGrand.StudentIID AND SecondPairSubID=#tempGrand.SubjectId) AS PairIsPass
		 FROM #tempGrand 
			INNER JOIN  Student_BasicInfo STU ON #tempGrand.StudentIID = STU.StudentIID
			INNER JOIN Ins_Version V ON V.VersionId = STU.VersionID
			INNER JOIN Ins_Branch B ON B.BranchId = STU.BranchID
			INNER JOIN Ins_Shift SH ON SH.ShiftId = STU.ShiftID
			INNER JOIN Ins_Session SE ON SE.SessionId = STU.SessionId
			INNER JOIN Ins_ClassInfo C ON C.ClassId =STU.ClassId
			INNER JOIN Ins_Group G ON G.GroupId = STU.GroupId
			INNER JOIN Ins_Section SEC ON SEC.SectionId = STU.SectionId
			LEFT JOIN Ins_StudentType SType ON SType.StudentTypeId = STU.StudentTypeID
			LEFT JOIN Ins_House SHouse ON SHouse.HouseId  =  STU.HouseID
			LEFT OUTER JOIN Student_Image I ON I.StudentIID = STU.StudentIID
			--LEFT OUTER JOIN Res_GrandStudentAssessment ASS ON ASS.StudentID = #tempGrand.StudentIID --AND ASS.SubjectId = #tempGrand.SubjectId
			--LEFT OUTER JOIN Res_AssessmentSubject AssSub ON AssSub.AId = ASS.SubjectId
			--LEFT OUTER JOIN Att_ExamAttendance Att ON Att.StudentId = STU.StudentIID  AND Att.ExamId = '+CAST( @GrandExamId AS VARCHAR)+' AND Att.IsGrand= 1
			WHERE STU.StudentIID IN (SELECT * FROM #StuId ) AND #tempGrand.Student_SubjectType !='T'
			ORDER BY  STU.Rollno , #tempGrand.ReportSerialNo

			DROP TABLE #t
END
ELSE IF((SELECT DB_NAME())='mgsc_new_2018' OR (SELECT DB_NAME())='mgsc_new_2018_grand')
BEGIN
SELECT distinct  STU.StudentInsID,STU.FullName, STU.RollNo,Stu.FatherName,Stu.MotherName,STU.ShiftID,
			SType.StudentTypeName,SHouse.HouseName,
			#tempGrand.* ,
			V.VersionName,
			B.BranchName,
			SH.ShiftName,
			SH.ShiftId,
			SE.SessionName,
			C.ClassName,
			G.GroupName,
			SEC.SectionName,
			SHouse.HouseName,
			SType.StudentTypeName,
			I.Photo ,
			AssSub.SubjectName AS AssSubjectName,
			ASS.HandWriting,
			ASS.PicReading,
			ASS.Recitation,
			ASS.Conversation,
			ASS.ColourSense,
			ASS.Art,
			ASS.Music,
			ASS.ParticipationInGames,
			ASS.Obedience,
			ASS.Tolerance,
			ASS.SelfReliance,
			ASS.Leadership,
			ASS.Interaction_with_Teachers_and_Peers
			,M1Att.PresentDay  AS M1PresentDay
			,M1Att.TotalWorkingDays AS M1TotalWorkingDays
			,M2Att.PresentDay AS M2PresentDay
			,M2Att.TotalWorkingDays AS M2TotalWorkingDays
			,Att.PresentDay
			,Att.TotalWorkingDays
			,(SELECT TOP(1) [Comments] FROM Res_GradingSystem gs WHERE gs.VersionID=STU.VersionID and gs.SessionID=STU.SessionId and gs.ClassID=stu.ClassId AND gs.GL=#tempGrand.GradeLetter) TeacherComments
		 FROM #tempGrand 
			INNER JOIN  Student_BasicInfo STU ON #tempGrand.StudentIID = STU.StudentIID
			INNER JOIN Ins_Version V ON V.VersionId = STU.VersionID
			INNER JOIN Ins_Branch B ON B.BranchId = STU.BranchID
			INNER JOIN Ins_Shift SH ON SH.ShiftId = STU.ShiftID
			INNER JOIN Ins_Session SE ON SE.SessionId = STU.SessionId
			INNER JOIN Ins_ClassInfo C ON C.ClassId =STU.ClassId
			INNER JOIN Ins_Group G ON G.GroupId = STU.GroupId
			INNER JOIN Ins_Section SEC ON SEC.SectionId = STU.SectionId
			LEFT JOIN Ins_StudentType SType ON SType.StudentTypeId = STU.StudentTypeID
			LEFT JOIN Ins_House SHouse ON SHouse.HouseId  =  STU.HouseID
			LEFT OUTER JOIN Student_Image I ON I.StudentIID = STU.StudentIID
			LEFT OUTER JOIN Res_GrandStudentAssessment ASS ON ASS.StudentID = #tempGrand.StudentIID -- AND ASS.SubjectId = #tempGrand.SubjectId
			LEFT OUTER JOIN Res_AssessmentSubject AssSub ON AssSub.AId = ASS.SubjectId
			LEFT OUTER JOIN Att_ExamAttendance Att ON Att.StudentId = STU.StudentIID  AND Att.ExamId = @GrandExamId AND Att.IsGrand= 1
			LEFT OUTER JOIN Att_ExamAttendance M1Att ON M1Att.StudentId = STU.StudentIID  AND M1Att.ExamId = CONVERT(VARCHAR, @M1) AND M1Att.IsGrand= 0
			LEFT OUTER JOIN Att_ExamAttendance M2Att ON M2Att.StudentId = STU.StudentIID  AND M2Att.ExamId = CONVERT(VARCHAR, @M2) AND M2Att.IsGrand= 0
			WHERE STU.StudentIID IN (SELECT * FROM #StuId) ORDER BY  STU.Rollno , #tempGrand.ReportSerialNo
END
ELSE
BEGIN
		
			SELECT  STU.StudentInsID,STU.FullName, STU.RollNo,Stu.FatherName,Stu.MotherName,STU.ShiftID,
			SType.StudentTypeName,SHouse.HouseName,
			#tempGrand.* ,
			V.VersionName,
			B.BranchName,
			SH.ShiftName,
			SH.ShiftId,
			SE.SessionName,
			C.ClassName,
			G.GroupName,
			SEC.SectionName,
			SHouse.HouseName,
			SType.StudentTypeName,
			I.Photo --,

			--AssSub.SubjectName AS AssSubjectName,
			--ASS.HandWriting,
			--ASS.PicReading,
			--ASS.Recitation,
			--ASS.Conversation,
			--ASS.ColourSense,
			--ASS.Art,
			--ASS.Music,
			--ASS.ParticipationInGames,
			--ASS.Obedience,
			--ASS.Tolerance,
			--ASS.SelfReliance,
			--ASS.Leadership,
			--ASS.Interaction_with_Teachers_and_Peers,
			--,M1Att.PresentDay  AS M1PresentDay
			--,M1Att.TotalWorkingDays AS M1TotalWorkingDays
			--,M2Att.PresentDay AS M2PresentDay
			--,M2Att.TotalWorkingDays AS M2TotalWorkingDays
			,Att.PresentDay
			,Att.TotalWorkingDays
			,(SELECT TOP(1) [Comments] FROM Res_GradingSystem gs WHERE gs.VersionID=STU.VersionID and gs.SessionID=STU.SessionId and gs.ClassID=stu.ClassId AND gs.GL=#tempGrand.GradeLetter) TeacherComments
		 FROM #tempGrand 
			INNER JOIN  Student_BasicInfo STU ON #tempGrand.StudentIID = STU.StudentIID
			INNER JOIN Ins_Version V ON V.VersionId = STU.VersionID
			INNER JOIN Ins_Branch B ON B.BranchId = STU.BranchID
			INNER JOIN Ins_Shift SH ON SH.ShiftId = STU.ShiftID
			INNER JOIN Ins_Session SE ON SE.SessionId = STU.SessionId
			INNER JOIN Ins_ClassInfo C ON C.ClassId =STU.ClassId
			INNER JOIN Ins_Group G ON G.GroupId = STU.GroupId
			INNER JOIN Ins_Section SEC ON SEC.SectionId = STU.SectionId
			LEFT JOIN Ins_StudentType SType ON SType.StudentTypeId = STU.StudentTypeID
			LEFT JOIN Ins_House SHouse ON SHouse.HouseId  =  STU.HouseID
			LEFT OUTER JOIN Student_Image I ON I.StudentIID = STU.StudentIID
			--LEFT OUTER JOIN Res_GrandStudentAssessment ASS ON ASS.StudentID = #tempGrand.StudentIID --AND ASS.SubjectId = #tempGrand.SubjectId
			--LEFT OUTER JOIN Res_AssessmentSubject AssSub ON AssSub.AId = ASS.SubjectId
			LEFT OUTER JOIN Att_ExamAttendance Att ON Att.StudentId = STU.StudentIID  AND Att.ExamId = @GrandExamId AND Att.IsGrand= 1
			LEFT OUTER JOIN Att_ExamAttendance M1Att ON M1Att.StudentId = STU.StudentIID  AND M1Att.ExamId = CONVERT(VARCHAR, @M1) AND M1Att.IsGrand= 0
			LEFT OUTER JOIN Att_ExamAttendance M2Att ON M2Att.StudentId = STU.StudentIID  AND M2Att.ExamId = CONVERT(VARCHAR, @M2) AND M2Att.IsGrand= 0
			WHERE STU.StudentIID IN (SELECT * FROM #StuId) ORDER BY  STU.Rollno , #tempGrand.ReportSerialNo

	
	END

	-- select * from #tempGrand order by ReportSerialNo
	-- SELECT * FROM #tempQry_MarkSetup WHERE MainExamId=4 AND MainExamSubjectID = 36
	 DROP TABLE #tempGrand
	 DROP TABLE #tempQry_MarkSetup
	 DROP TABLE #tempQry_GrandMarkSetup
end  	 
 -- exec rptGetGrandResult 9 ,250





 


