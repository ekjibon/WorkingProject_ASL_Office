/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ProccessTabulation]'))
BEGIN
DROP PROCEDURE  ProccessTabulation
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ProccessTabulation] 
	
	@MainExamId INT,
	@SubExamId INT,
	@ExamName VARCHAR(50),
	@DividedType VARCHAR(50),
	@IsObt BIT,
	@IsConv BIT,
	@IsFrac BIT
	
AS
BEGIN
	DECLARE @VersionId INT,
	@SessionId INT,
	@ClassId INT,
	@GroupId INT,
	@SectionId INT=0,
	@BranchID INT=0,
	@ShiftID INT=0 ,
	@SerialNo INT = 1
	,@IsHihestFrac [bit] = NULL

		DECLARE @TotalCalculatuonRule VARCHAR(1)
		DECLARE @BodyCalculatuonRule VARCHAR(1)
		SELECT @SerialNo=MainExamGrandShowOrder FROM Res_MainExam WHERE MainExamId = @MainExamId

	SELECT * INTO #TempQry_MarkSetup  FROM Qry_MarkSetup  WHERE MainExamId= @MainExamId AND SubExamId= @SubExamId

	SELECT @VersionId = VersionId,@SessionId=SessionId,@ClassId=ClassId,@GroupId=GroupId  FROM Res_MainExam WHERE MainExamId = @MainExamId
	Select @TotalCalculatuonRule=MMS.TotalCalculatuonRule,@BodyCalculatuonRule= MMS.BodyCalculationRule FROM [dbo].[Res_MarksMigratedSetup] MMS Where MMS.VersionID=@VersionId and MMS.SessionID=@SessionId and MMS.ClassID=@ClassId and MMS.IsDeleted=0

	
	SELECT @IsHihestFrac= IsFrac  FROM Res_HighestMarkConfig 
					 WHERE Versionid  = @VersionId AND SessionId =  @SessionId 
						AND ClassId = @ClassId AND GroupId = @GroupId

	INSERT INTO [dbo].[Res_Tabulation]
           ([VersionID],[SessionId],[BranchID],[ShiftID],[ClassId],[GroupId],[SectionId],[StudentId],[SubjectId],[GrandExamId],[MainExamId],[SubExamId]
				,[ExamName],[TotalMarks],[IsPass],[ExamSerial])

		SELECT @VersionId , @SessionId,@BranchID,@ShiftID,@ClassId,@GroupId,@SectionId, vr.StudentIID,vr.SubjectID,0,@MainExamId,@SubExamId,@ExamName, 
		CASE 
			WHEN    @DividedType='W1' THEN   dbo.ConvertMarks(vr.WrittenObt1   ,@BodyCalculatuonRule)
			WHEN    @DividedType='W2' THEN   dbo.ConvertMarks(vr.WrittenObt2   ,@BodyCalculatuonRule)
			WHEN    @DividedType='W3' THEN   dbo.ConvertMarks(vr.WrittenObt3   ,@BodyCalculatuonRule)
			WHEN    @DividedType='S'  THEN   dbo.ConvertMarks(vr.SubjectiveObt ,@BodyCalculatuonRule)
			WHEN    @DividedType='O'  THEN   dbo.ConvertMarks(vr.ObjectiveObt  ,@BodyCalculatuonRule)
			WHEN    @DividedType='P'  THEN   dbo.ConvertMarks(vr.PracticalObt  ,@BodyCalculatuonRule)

		END
		,
		CASE 
			WHEN    @DividedType='W1' THEN vr.WrittenIsPass1 
			WHEN    @DividedType='W2' THEN vr.WrittenIsPass2
			WHEN    @DividedType='W3' THEN vr.WrittenIsPass3
			WHEN    @DividedType='S' THEN vr.SubjectiveIsPass
			WHEN    @DividedType='O' THEN vr.ObjectiveIsPass
			WHEN    @DividedType='P'  THEN vr.PracticalIsPass

		END,
		@SerialNo

		FROM [ResultView] vr WHERE vr.MainExamId = @MainExamId AND vr.SubExamId=@SubExamId AND @IsObt = 1
		 AND EXISTS (SELECT top 1 id FROM  #TempQry_MarkSetup S WHERE S.DividedExamType=@DividedType AND S.MainExamSubjectID=vr.SubjectID  )

		INSERT INTO [dbo].[Res_Tabulation]
           ([VersionID],[SessionId],[BranchID],[ShiftID],[ClassId],[GroupId],[SectionId],[StudentId],[SubjectId],[GrandExamId],[MainExamId],[SubExamId]
				,[ExamName],[TotalMarks],[IsPass],[ExamSerial])

		SELECT @VersionId , @SessionId,@BranchID,@ShiftID,@ClassId,@GroupId,@SectionId, vr.StudentIID,vr.SubjectID,0,@MainExamId,@SubExamId,@ExamName + ' Conv', 
		CASE 
			WHEN    @DividedType='W1' THEN dbo.ConvertMarks(vr.WrittenConv1    ,@BodyCalculatuonRule)
			WHEN    @DividedType='W2' THEN dbo.ConvertMarks(vr.WrittenConv2	   ,@BodyCalculatuonRule)
			WHEN    @DividedType='W3' THEN dbo.ConvertMarks(vr.WrittenConv3	   ,@BodyCalculatuonRule)
			WHEN    @DividedType='S'  THEN dbo.ConvertMarks(vr.SubjectiveConv  ,@BodyCalculatuonRule)
			WHEN    @DividedType='O'  THEN dbo.ConvertMarks(vr.ObjectiveConv   ,@BodyCalculatuonRule)
			WHEN    @DividedType='P'  THEN dbo.ConvertMarks(vr.PracticalConv   ,@BodyCalculatuonRule)

		END
		,
		CASE 
			WHEN    @DividedType='W1' THEN vr.WrittenIsPass1 
			WHEN    @DividedType='W2' THEN vr.WrittenIsPass2
			WHEN    @DividedType='W3' THEN vr.WrittenIsPass3
			WHEN    @DividedType='S' THEN vr.SubjectiveIsPass
			WHEN    @DividedType='O' THEN vr.ObjectiveIsPass
			WHEN    @DividedType='P'  THEN vr.PracticalIsPass

		END,
		@SerialNo

		FROM [ResultView] vr WHERE vr.MainExamId = @MainExamId AND vr.SubExamId=@SubExamId AND @IsConv = 1
		
		 AND EXISTS (SELECT top 1 id FROM  #TempQry_MarkSetup S WHERE S.DividedExamType=@DividedType AND S.MainExamSubjectID=vr.SubjectID  )

	INSERT INTO [dbo].[Res_Tabulation]
           ([VersionID],[SessionId],[BranchID],[ShiftID],[ClassId],[GroupId],[SectionId],[StudentId],[SubjectId],[GrandExamId],[MainExamId],[SubExamId]
				,[ExamName],[TotalMarks],[IsPass],[ExamSerial])

		SELECT @VersionId , @SessionId,@BranchID,@ShiftID,@ClassId,@GroupId,@SectionId, vr.StudentIID,vr.SubjectID,0,@MainExamId,@SubExamId,@ExamName + ' Frac', 
		CASE 
			WHEN    @DividedType='W1' THEN dbo.ConvertMarks(vr.WrittenFrac1     ,@BodyCalculatuonRule)
			WHEN    @DividedType='W2' THEN dbo.ConvertMarks(vr.WrittenFrac2	    ,@BodyCalculatuonRule)
			WHEN    @DividedType='W3' THEN dbo.ConvertMarks(vr.WrittenFrac3	    ,@BodyCalculatuonRule)
			WHEN    @DividedType='S'  THEN dbo.ConvertMarks(vr.SubjectiveFrac   ,@BodyCalculatuonRule)
			WHEN    @DividedType='O'  THEN dbo.ConvertMarks(vr.ObjectiveFrac	,@BodyCalculatuonRule)
			WHEN    @DividedType='P'  THEN dbo.ConvertMarks(vr.PracticalFrac	,@BodyCalculatuonRule)
		END
		,
		CASE 
			WHEN    @DividedType='W1' THEN vr.WrittenIsPass1 
			WHEN    @DividedType='W2' THEN vr.WrittenIsPass2
			WHEN    @DividedType='W3' THEN vr.WrittenIsPass3
			WHEN    @DividedType='S' THEN vr.SubjectiveIsPass
			WHEN    @DividedType='O' THEN vr.ObjectiveIsPass
			WHEN    @DividedType='P'  THEN vr.PracticalIsPass
		END,
		@SerialNo
		 FROM [ResultView] vr WHERE vr.MainExamId = @MainExamId AND vr.SubExamId=@SubExamId AND @IsFrac = 1
		
		 AND EXISTS (SELECT top 1 id FROM  #TempQry_MarkSetup S WHERE S.DividedExamType=@DividedType AND S.MainExamSubjectID=vr.SubjectID  )

		--- For subexam total
			INSERT INTO [dbo].[Res_Tabulation]
           ([VersionID],[SessionId],[BranchID],[ShiftID],[ClassId],[GroupId],[SectionId],[StudentId],[SubjectId],[GrandExamId],[MainExamId],[SubExamId]
				,[ExamName],[TotalMarks],[IsPass],[ExamSerial])

		SELECT  @VersionId , @SessionId,@BranchID,@ShiftID,@ClassId,@GroupId,@SectionId, vr.StudentIID,vr.SubjectID,0,@MainExamId,@SubExamId,@ExamName, 
		CASE 
			WHEN    @DividedType='SETM'  THEN CAST( vr.SubExamTotalObt  AS VARCHAR(50)) 
			WHEN    @DividedType='SECTM' THEN  CAST( vr.SubExamTotalConv  AS VARCHAR(50)) 
			
			
		END
		,vr.SubExamIsPass,
		@SerialNo
				FROM [ResultView] vr WHERE vr.MainExamId = @MainExamId  AND vr.SubExamId=@SubExamId
		AND @IsObt = 0 AND @IsConv =0 AND @IsFrac = 0 
		AND (@DividedType='SETM' OR @DividedType='SECTM' )

  ---  Proccess TotalMarks, GPA , GL, Merit ,

			---  FOR TM , GPA, GL,ME
			INSERT INTO [dbo].[Res_Tabulation]
           ([VersionID],[SessionId],[BranchID],[ShiftID],[ClassId],[GroupId],[SectionId],[StudentId],[SubjectId],[GrandExamId],[MainExamId],[SubExamId]
				,[ExamName],[TotalMarks],[IsPass],[ExamSerial])

		SELECT distinct @VersionId , @SessionId,@BranchID,@ShiftID,@ClassId,@GroupId,@SectionId, vr.StudentIID,0,0,@MainExamId,@SubExamId,@ExamName, 
		CASE 
			WHEN    @DividedType='TM'  THEN CAST ((CASE WHEN @IsHihestFrac = 1 THEN vr.TotalConvertedMarksFraction ELSE vr.TotalConvertedMarks END ) AS varchar)
			WHEN    @DividedType='GPA' THEN CAST( vr.GPA  AS VARCHAR(50)) 
			WHEN    @DividedType='GL'  THEN CAST(vr.GradeLetter AS VARCHAR(50)) 
			WHEN    @DividedType='ME'  THEN CAST(vr.SectionWiseMerit AS VARCHAR(50)) --CONVERT( VARCHAR(50), 1 ) --
			
		END
		,vr.IsPass,@SerialNo 
		
		FROM [ResultView] vr WHERE vr.MainExamId = @MainExamId  --AND vr.SubExamId=@SubExamId
		AND @IsObt = 0 AND @IsConv =0 AND @IsFrac = 0 
		AND (@DividedType='TM' OR @DividedType='GPA' OR @DividedType='GL' OR @DividedType='ME')

		IF(DB_NAME()='glhs_new_2018')
		BEGIN
				----------- FOR Subject Total , SUb GL , Sub GP
		INSERT INTO [dbo].[Res_Tabulation]
           ([VersionID],[SessionId],[BranchID],[ShiftID],[ClassId],[GroupId],[SectionId],[StudentId],[SubjectId],[GrandExamId],[MainExamId],[SubExamId]
				,[ExamName],[TotalMarks],[IsPass],[ExamSerial])

		SELECT  @VersionId , @SessionId,@BranchID,@ShiftID,@ClassId,@GroupId,@SectionId, vr.StudentIID,vr.SubjectID,0,@MainExamId,@SubExamId,'SOP Conv', 
		CASE 
			
			WHEN    @DividedType='SCTM' THEN  CAST (vr.SOPTotalConv AS varchar) 
			
			
		END
		,vr.SubjectIsPass,@SerialNo FROM [ResultView] vr WHERE vr.MainExamId = @MainExamId  --AND vr.SubExamId=@SubExamId
		AND @IsObt = 0 AND @IsConv =0 AND @IsFrac = 0 
		AND ( @DividedType='SCTM' )
		END

		----------- FOR Subject Total , SUb GL , Sub GP
		INSERT INTO [dbo].[Res_Tabulation]
           ([VersionID],[SessionId],[BranchID],[ShiftID],[ClassId],[GroupId],[SectionId],[StudentId],[SubjectId],[GrandExamId],[MainExamId],[SubExamId]
				,[ExamName],[TotalMarks],[IsPass],[ExamSerial])

		SELECT  @VersionId , @SessionId,@BranchID,@ShiftID,@ClassId,@GroupId,@SectionId, vr.StudentIID,vr.SubjectID,0,@MainExamId,@SubExamId,@ExamName, 
		CASE 
			WHEN    @DividedType='V1'  THEN CAST( vr.VirtualConvertedMarks1  AS VARCHAR(50)) 
			WHEN    @DividedType='V2'  THEN CAST( vr.VirtualConvertedMarks2  AS VARCHAR(50)) 
			WHEN    @DividedType='STM'  THEN CAST( vr.SubjectObtMarks  AS VARCHAR(50)) 
			WHEN    @DividedType='SCTM' THEN  CAST ((CASE WHEN @IsHihestFrac = 1 THEN vr.SubjectConvertedMarksFraction ELSE vr.SubjectConvertedMarks END ) AS varchar) 
			WHEN    @DividedType='SGL'  THEN CAST(vr.SubjectGL AS VARCHAR(50)) 
			WHEN    @DividedType='SGP'  THEN CAST(vr.SubjectGP AS VARCHAR(50)) --CONVERT( VARCHAR(50), 1 ) --
			
		END
		,vr.SubjectIsPass,@SerialNo FROM [ResultView] vr WHERE vr.MainExamId = @MainExamId  --AND vr.SubExamId=@SubExamId
		AND @IsObt = 0 AND @IsConv =0 AND @IsFrac = 0 
		AND (@DividedType='STM' OR @DividedType='V1' OR @DividedType='V2' OR @DividedType='SCTM' OR @DividedType='SGL' OR @DividedType='SGP')

		


 UPDATE Res_Tabulation 
	SET SectionId = S.[SectionId] , BranchID = S.BranchID,ShiftID=S.ShiftID
	FROM  Student_BasicInfo S INNER JOIN Res_Tabulation 
	ON Res_Tabulation.StudentId = S.[StudentIID] AND Res_Tabulation.MainExamId = @MainExamId 
		
END	

--- ProccessTabulation 7,14,'Term Exam','SETM',0,0,0
--  Truncate Table [Res_Tabulation]
--- SELECT * FROM Res_Tabulation

 -- SELECT * FROM [dbo].[ResultView]

 --- Truncate Table [dbo].[Res_TabConfig]