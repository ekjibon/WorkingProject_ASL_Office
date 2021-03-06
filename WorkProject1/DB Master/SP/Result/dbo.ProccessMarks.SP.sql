/****** Object:  StoredProcedure [dbo].[ProccessMarks]    Script Date: 7/22/2017 4:26:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ProccessMarks]'))
BEGIN
DROP PROCEDURE  ProccessMarks
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
--EXEC ProccessMarks 1,1,1,9,2,336,1030,1056,1103,172,26.00,0,'R','R','sos_new_2018'

CREATE PROCEDURE [dbo].[ProccessMarks]  
	(@VersionId int,
	@SessionId int,
	@ShiftId int,
	@ClassId int,
    @GroupId int,
	@StudentIID int,
	@MainExamID int,
	@SubExamID int,
	@DivExamID int,
	@SubjectID int,
	@ObtainMarks decimal(8,2),
	@IsAbsent bit,
	@BodyCalculationRule VARCHAR(1),
	@TotalCalculatuonRule VARCHAR(1),
	@DBname VARCHAR(100)
	)
AS
BEGIN
PRINT 'W2 Abs : ' PRINT @IsAbsent
--Print '@StudentIID in >>>>>>>>>>>>>>>>>>:' print @StudentIID

CREATE TABLE #Res_SubjectSetup(
    SubIDSL int IDENTITY(1,1) NOT NULL,
	SubID int NOT NULL,
	IsPair bit NOT NULL,
	SubjectType nvarchar(10) NULL,
	FirstPairSubID int NOT NULL,
	SecondPairSubID int NOT NULL,
	IsDeleted bit Not Null
	)
Insert Into #Res_SubjectSetup
Select SS.SubID,
SS.IsPair,
SS.SubjectType,
SS.FirstPairSubID,
SS.SecondPairSubID,
SS.IsDeleted
From Res_SubjectSetup SS where SS.VersionID=@VersionId and SS.SessionId=@SessionId AND SS.ClassId=@ClassId AND SS.GroupId=@GroupId

DECLARE @DivExamFullmarks decimal(8,2)=0
, @DivExamExammarks decimal(8,2)=0
, @SubExamMSetupID int
, @DivExamType VARCHAR(10)
, @DivIsPassDepENDed bit=0
, @DivPassIspercentage decimal(8,2)=0
, @DivPassMark decimal(8,2)=0
, @DivIsPass bit=1
, @DivConvertedMarks decimal(8,2)=0
, @PTotalSubjectID int
, @TDivIsPass bit=1 , @MainExamResultID int
, @DividedExamMarkSetupID int
, @SubExamExamMark decimal(10,2)
, @SubExamFullMark decimal(10,2)
, @SubIsPassDepENDed bit
, @SubPassIspercentage bit
, @SubPassMark decimal(10,2)

SELECT @DividedExamMarkSetupID=QM.DibExamMarkSetupID, 
     @DivExamFullmarks=QM.DividedExamFullMarks,
	 @DivExamExammarks=QM.DividedExamExamMarks,
	 @DivExamID=QM.DividedExamId,
	 @SubExamMSetupID=QM.SubExamMarkSetupId,
     @DivIsPassDepENDed=QM.DividedExamIsPassDepEND,
	 @DivPassIspercentage=QM.DividedExamPassMarkIsPercent,  
	 @DivPassMark=QM.DividedExamPassMarks, 
	 @DivExamType=QM.DividedExamType,
	 @SubExamFullMark=QM.SubExamFullMarks,
	 @SubExamExamMark=QM.SubExamExamMarks,
	 @SubIsPassDepENDed=QM.SubExamIsPassDepEND,
	 @SubPassIspercentage=QM.SubExamPassMarkIsPercent,
	 @SubPassMark=QM.SubExamPassMark
	 FROM Qry_MarkSetup QM
	 WHERE QM.MainExamId = @MainExamId AND QM.SubExamId = @SubExamID AND QM.DividedExamID = @DivExamID AND QM.MainExamSubjectID = @SubjectID  AND QM.MIsDeleted=0 AND QM.SIsDeleted=0 AND QM.DIsDeleted=0
	  --print '@DBname>>>>>>>>>>>>>>>' print @DBname
	  print '@@SubExamFullMark>>>>>>>>>>>>>>>' print @SubExamFullMark
	  print '@@SubExamExamMarks>>>>>>>>>>>>>>>' print @SubExamExamMark

	 If(@DBname in ('btclisc_new_2018','sshs_new_2018__') AND @ClassId <> 46)
	 BEGIN
		 DECLARE @CTFullMark decimal(8,2)=0, @CTExamMark decimal(8,2)=0

		 SELECT 
		 @CTFullMark=QM.DividedExamFullMarks,
		 @CTExamMark=QM.DividedExamExamMarks
		 FROM Qry_MarkSetup QM
		 WHERE QM.MainExamId = @MainExamId AND QM.SubExamId = @SubExamID AND QM.DividedExamType ='W1' AND QM.MainExamSubjectID = @SubjectID  AND QM.MIsDeleted=0 AND QM.SIsDeleted=0 AND QM.DIsDeleted=0
		
			 set @SubExamFullMark=@SubExamFullMark-@CTFullMark
			 set @SubExamExamMark=@SubExamExamMark-@CTExamMark
		

		  -- print '@@CTFullMark>>>>>>>>>>>>>>>' print @CTFullMark
		  --print '@@SubExamFullMark>>>>>>>>>>>>>>>' print @SubExamFullMark
		  --print '@@SubExamExamMarks>>>>>>>>>>>>>>>' print @SubExamExamMark

	 END

	--print '@@MainExamId' print @MainExamId
	--print '@@@SubExamID' print @SubExamID

   -- print '@@@DivExamID' print @DivExamID
	--print '@@@SubjectID' print @SubjectID

	--print '@@@@DividedExamMarkSetupID' print @DividedExamMarkSetupID


IF Exists(Select TOP(1) * from [#Res_SubjectSetup] SS where SS.IsPair=1 and (SS.FirstPairSubID=@SubjectID OR SS.SecondPairSubID=@SubjectID) ) 
BEGIN
Select TOP(1) @PTotalSubjectID=SS.SubID from [#Res_SubjectSetup] SS 
where SS.IsPair=1 and (SS.FirstPairSubID=@SubjectID OR SS.SecondPairSubID=@SubjectID) and SS.[SubjectType] = 'T' and SS.[IsDeleted]=0
END

--DividedExamPass
--print '@DivExamExammarks' print @DivExamExammarks
SELECT @DivConvertedMarks=dbo.ConvertMarks((@DivExamFullmarks*@ObtainMarks)/@DivExamExammarks,@BodyCalculationRule)
if(@DivIsPassDepENDed=1)
Begin
	If(@DivPassIspercentage=0)
Begin

If(@ObtainMarks>=@DivPassMark)
SET @DivIsPass=1
ELSE
SET @DivIsPass=0
End
ELSE
Begin
If(((100*@ObtainMarks)/@DivExamExammarks)>=@DivPassMark)
	SET @DivIsPass=1
ELSE
	SET @DivIsPass=0
END
END




DECLARE		 @ResultSubjectDetailsId int=0
			,@ResultPairTotalSubjectDetailsId  int =0
			,@WObt1 decimal(8,2)=0
			, @WConv1 decimal(8,2)=0
			, @WFrac1 decimal(8,2)=0
			, @WIsPass1 bit =1
			, @WIsAbs1 bit =0
			, @WObt2 decimal(8,2)=0
			, @WConv2 decimal(8,2)=0
			, @WFrac2 decimal(8,2)=0
			, @WIsPass2 bit =1
			, @WIsAbs2 bit =0
			
			, @WObt3 decimal(8,2)=0
			, @WConv3 decimal(8,2)=0
			, @WFrac3 decimal(8,2)=0
			, @WIsPass3 bit =1
			, @WIsAbs3 bit =0
			
			, @SObt decimal(8,2)=0
			, @SConv decimal(8,2)=0
			, @SFrac decimal(8,2)=0
			, @SIsPass bit =1
			, @SIsAbs bit =0
			
			, @OObt decimal(8,2)=0
			, @OConv decimal(8,2)=0
			, @OFrac decimal(8,2)=0
			, @OIsPass bit =1
			, @OIsAbs bit =0
			
			, @PObt decimal(8,2)=0
			, @PConv decimal(8,2)=0
			, @PFrac decimal(8,2)=0
			, @PIsPass bit =1
			, @PIsAbs bit =0
			
			, @SubExamTotalObt decimal(8,2)=0
			, @SubExamOriginalTotalObt decimal(8,2)=0
			, @SubExamTotalConv decimal(8,2)=0
			, @SubExamTotalFrac decimal(8,2)=0
			, @SubExamIsPass bit=1
			, @SubExamIsAbsent bit=0
			
			
			
			/*For Pair Total*/
			, @TWObt1 decimal(8,2)=0
			, @TWConv1 decimal(8,2)=0
			, @TWFrac1 decimal(8,2)=0
			, @TWIsPass1 bit =1
			, @TWIsAbs1 bit =0
			
			, @TWObt2 decimal(8,2)=0
			, @TWConv2 decimal(8,2)=0
			, @TWFrac2 decimal(8,2)=0
			, @TWIsPass2 bit =1
			, @TWIsAbs2 bit =0
			
			, @TWObt3 decimal(8,2)=0
			, @TWConv3 decimal(8,2)=0
			, @TWFrac3 decimal(8,2)=0
			, @TWIsPass3 bit =1
			, @TWIsAbs3 bit =0
			
			, @TSObt decimal(8,2)=0
			, @TSConv decimal(8,2)=0
			, @TSFrac decimal(8,2)=0
			, @TSIsPass bit =1
			, @TSIsAbs bit =0
			
			, @TOObt decimal(8,2)=0
			, @TOConv decimal(8,2)=0
			, @TOFrac decimal(8,2)=0
			, @TOIsPass bit =1
			, @TOIsAbs bit =0
			
			, @TPObt decimal(8,2)=0
			, @TPConv decimal(8,2)=0
			, @TPFrac decimal(8,2)=0
			, @TPIsPass bit =1
			, @TPIsAbs bit =0
			
			, @TDivExamTotalObt decimal(8,2)=0
			, @TDivExamTotalConv decimal(8,2)=0
			, @TDivExamTotalFrac decimal(8,2)=0
			, @TDivExamIsPass bit=1
			, @TDivExamIsAbsent bit=0
			
			, @TDivExamExamMark decimal(10,2)=1
			, @TDivExamFullMark decimal(10,2)
			, @TDivIsPassDepENDed bit
			, @TDivPassIspercentage bit
			, @TDivPassMark decimal(10,2)
			
			, @TSubExamTotalObt decimal(8,2)=0
			, @TSubExamOriginalTotalObt decimal(8,2)=0
			, @TSubExamTotalConv decimal(8,2)=0
			, @TSubExamTotalFrac decimal(8,2)=0
			, @TSubExamIsPass bit=1
			, @TSubExamIsAbsent bit=0
			
			, @TSubExamExamMark decimal(10,2)
			, @TSubExamFullMark decimal(10,2)
			, @TSubIsPassDepENDed bit
			, @TSubPassIspercentage bit
			, @TSubPassMark decimal(10,2)
			
			
			, @TSubjectExamFullMark decimal(10,2)
			, @TSubjectIsPassDepENDed bit
			, @TSubjectPassIspercentage bit
			, @TSubjectPassMark decimal(10,2)
			, @SOPTotalObt decimal(10,2)
			, @SOPTotalConv decimal(10,2)
			, @SOPTotalFrac decimal(10,2)
			, @TSOPTotalObt decimal(10,2)
			, @TSOPTotalConv decimal(10,2)
			, @TSOPTotalFrac decimal(10,2)
DECLARE @FirstPairID int, @SecondPairID int, @PairID int,
			 @PWObt1 decimal(8,2)=0
			, @PWConv1 decimal(8,2)=0
			, @PWFrac1 decimal(8,2)=0


			, @PWObt2 decimal(8,2)=0
			, @PWConv2 decimal(8,2)=0
			, @PWFrac2 decimal(8,2)=0

			, @PWObt3 decimal(8,2)=0
			, @PWConv3 decimal(8,2)=0
			, @PWFrac3 decimal(8,2)=0

			, @PSObt decimal(8,2)=0
			, @PSConv decimal(8,2)=0
			, @PSFrac decimal(8,2)=0

			, @POObt decimal(8,2)=0
			, @POConv decimal(8,2)=0
			, @POFrac decimal(8,2)=0

			, @PPObt decimal(8,2)=0
			, @PPConv decimal(8,2)=0
			, @PPFrac decimal(8,2)=0
			,@STSubExamTotalConv decimal(8,2)=0


/*End pair Total*/

Select @TDivExamFullMark=QMS.[DividedExamFullMarks], @TDivExamExamMark=QMS.[DividedExamExamMarks], @TDivIsPassDepENDed=QMS.[DividedExamIsPassDepEND],@TDivPassIspercentage=QMS.[DividedExamPassMarkIsPercent], @TDivPassMark=QMS.[DividedExamPassMarks],
	@TSubExamFullMark=QMS.[SubExamFullMarks], @TSubExamExamMark=QMS.[SubExamExamMarks], @TSubIsPassDepENDed=QMS.[SubExamIsPassDepEND], @TSubPassIspercentage=QMS.[SubExamPassMarkIsPercent],@TSubPassMark=QMS.[SubExamPassMark],
	@TSubjectExamFullMark=QMS.MainExamFullMarks,@TSubjectIsPassDepENDed=QMS.MainExamIsPassDepEND,@TSubjectPassIspercentage=QMS.MainExamPassMarkIsPercent,@TSubjectPassMark=QMS.MainExamPassMark
	from [dbo].[Qry_MarkSetup] AS QMS where QMS.[MainExamId]=@MainExamID and QMS.[MainExamSubjectID]=@PTotalSubjectID and QMS.[SubExamId]=@SubExamID and QMS.[DividedExamId]=@DivExamID

	 If(@DBname in ('btclisc_new_2018','sshs_new_2018') AND @ClassId <> 46)
	 BEGIN
		 DECLARE @TCTFullMark decimal(8,2)=0, @TCTExamMark decimal(8,2)=0
		 PRINT CAST( @TSubExamExamMark AS VARCHAR)
		 SELECT 
		 @TCTFullMark=QMS.DividedExamFullMarks,
		 @TCTExamMark=QMS.DividedExamExamMarks
		 FROM Qry_MarkSetup QMS
		 WHERE QMS.MainExamId = @MainExamId AND QMS.SubExamId = @SubExamID AND QMS.DividedExamType ='W1' AND QMS.MainExamSubjectID = @PTotalSubjectID  AND QMS.MIsDeleted=0 AND QMS.SIsDeleted=0 AND QMS.DIsDeleted=0
		 set @TSubExamFullMark=@TSubExamFullMark-@TCTFullMark
		 set @TSubExamExamMark=@TSubExamExamMark-@TCTExamMark

		 PRINT CAST( @TSubExamExamMark AS VARCHAR) + '@TSubExamExamMark' + '  @@SubExamID ' + CAST( @SubExamID AS VARCHAR)
	 END

IF Not Exists (Select TOP 1 MERD.MainExamId  from [dbo].[Res_MEResultDetails] MERD Where MERD.MainExamId=@MainExamID and MERD.SubExamId=@SubExamID and MERD.SubjectID=@SubjectID And MERD.StudentIID=@StudentIID )  --and MERD.ResultSubjectDetailsId=@ResultSubjectDetailsId
Begin
--Print 'Inset Here..............................:'
/* First Time Insert For Marks Type Identification*/

	If(@DivExamType='W1')
	Begin
		SET @WObt1=@ObtainMarks;
		Set @WConv1=@DivConvertedMarks;
		Set @WFrac1=(@DivExamFullmarks*@ObtainMarks)/@DivExamExammarks;
		SET @WIsPass1=@DivIsPass;
		SET @WIsAbs1=@IsAbsent;

		--IF(@DBname = 'sos_new_2018') -- 
		--BEGIN
		--DECLARE @S3 INT 
		--SELECT @S3 = SubExamId FROM Res_SubExam WHERE MainExamId = @MainExamID AND SubExamOrder = 3
		--	IF EXISTS( SELECT TOP 1 * FROM Qry_MarkSetup QM WHERE QM.MainExamSubjectID = @SubjectID AND QM.SubExamId = @S3 AND QM.DividedExamType = 'W1' AND QM.MIsDeleted=0 AND QM.SIsDeleted=0 AND QM.DIsDeleted=0)
		--	BEGIN
		--		SET @WObt1=@ObtainMarks;
		--		Set @WConv1=@DivConvertedMarks;
		--		Set @WFrac1= (@DivExamFullmarks*@ObtainMarks)/@DivExamExammarks;
		--		SET @WIsPass1=@DivIsPass;
		--		SET @WIsAbs1=@IsAbsent;
		--	END
		--END

	End

	else If(@DivExamType='W2')
	Begin
		SET @WObt2=@ObtainMarks;
		Set @WConv2=@DivConvertedMarks;
		Set @WFrac2=(@DivExamFullmarks*@ObtainMarks)/@DivExamExammarks;
		SET @WIsPass2=@DivIsPass;
		SET @WIsAbs2=@IsAbsent;
	End

	else If(@DivExamType='W3')
	Begin
		SET @WObt3=@ObtainMarks;
		Set @WConv3=@DivConvertedMarks;
		Set @WFrac3=(@DivExamFullmarks*@ObtainMarks)/@DivExamExammarks;
		SET @WIsPass3=@DivIsPass;
		SET @WIsAbs3=@IsAbsent;
	End

	else If(@DivExamType='S')
	Begin
		SET @SObt=@ObtainMarks;
		Set @SConv=@DivConvertedMarks;
		Set @SFrac=(@DivExamFullmarks*@ObtainMarks)/@DivExamExammarks;
		SET @SIsPass=@DivIsPass;
		SET @SIsAbs=@IsAbsent;
	End

	else If(@DivExamType='O')
	Begin
		SET @OObt=@ObtainMarks;
		Set @OConv=@DivConvertedMarks;
		Set @OFrac=(@DivExamFullmarks*@ObtainMarks)/@DivExamExammarks;
		SET @OIsPass=@DivIsPass;
		SET @OIsAbs=@IsAbsent;
	End

	else If(@DivExamType='P')
	Begin
		SET @PObt=@ObtainMarks;
		Set @PConv=@DivConvertedMarks;
		Set @PFrac=(@DivExamFullmarks*@ObtainMarks)/@DivExamExammarks;
		SET @PIsPass=@DivIsPass;
		SET @PIsAbs=@IsAbsent;
	End
	

/*End Firtst Time Type Identification*/

	SET @SubExamTotalObt=@WConv1+@WConv2+@WConv3+@SConv+@OConv+@PConv;
	If(@DBname in ('btclisc_new_2018','sshs_new_2018') AND @ClassId <> 46)
	Begin
    	SET @SubExamTotalObt=@WConv2+@WConv3+@SConv+@OConv+@PConv;
	End
	SET @SubExamTotalFrac=((@SubExamTotalObt*@SubExamFullMark)/@SubExamExamMark)
	SET @SubExamOriginalTotalObt=@WObt1+@WObt2+@WObt3+@SObt+@OObt+@PObt;
	
	 print '@@DBname : '+@DBname
IF(@SubExamFullMark != @SubExamExamMark)
   Begin
	 SELECT @SubExamTotalConv=dbo.ConvertMarks((@SubExamTotalObt*@SubExamFullMark)/@SubExamExamMark,@BodyCalculationRule)
	 print '@@DBname : '+@DBname
	 If(@DBname in ('sos_new_2018') and @ClassId=9)
	 BEGIN
	   SELECT @SubExamTotalConv=dbo.ConvertMarks((@SubExamTotalObt* @SubExamFullMark  )/ @SubExamExamMark,@BodyCalculationRule)
	  print '@@SubExamFullMark>>>>>>>>>>>>>>>' print @SubExamFullMark
	  print '@@SubExamExamMarks>>>>>>>>>>>>>>>' print @SubExamExamMark
	  print '@@SubExamTotalConv>>>>>>>>>>>>>>>' print @SubExamTotalConv
	 END
	End
else 
  Begin
   SET @SubExamTotalConv=@SubExamTotalObt
  END

If(@SubIsPassDepENDed=1)
Begin

If(@SubPassIspercentage=0)
	Begin
		If(@SubExamTotalObt>=@SubPassMark)
		 SET @SubExamIsPass=1
		ELSE
		 SET @SubExamIsPass=0
	End
ELSE
	Begin
		If(((100*@SubExamTotalObt)/@SubExamExamMark)>=@SubPassMark)
		SET @SubExamIsPass=1
		ELSE
		SET @SubExamIsPass=0
	End
	End
IF(@DBname='mths_new_2018')
	BEGIN 
		If(@SubIsPassDepENDed=1)
	Begin

	If(@SubPassIspercentage=0)
	Begin
	If(@SubExamTotalConv>=@SubPassMark)
		SET @SubExamIsPass=1
	ELSE
		SET @SubExamIsPass=0
	End
	ELSE
		Begin
			If(((100*@SubExamTotalConv)/@SubExamExamMark)>=@SubPassMark)
				SET @SubExamIsPass=1
			ELSE
				SET @SubExamIsPass=0
		End
		End

	END

SET @SOPTotalObt=@SObt + @OObt + @PObt
SET @SOPTotalConv=@SConv + @OConv + @PConv
SET @SOPTotalFrac=@SFrac + @OFrac + @PFrac

/*If Any Div Exam Fail Then SubExam Is fail*/
IF(@DivIsPass=0)
	BEGIN
	set @SubExamIsPass=0
	END
/*End If Any Div Exam Fail Then SubExam Is fail */

/*For pair total First Time Insert*/
IF Exists(Select TOP 1 SS.FirstPairSubID from [#Res_SubjectSetup] SS where SS.IsPair=1 and (SS.FirstPairSubID=@SubjectID OR SS.SecondPairSubID=@SubjectID)) 
BEGIN


	If(@DivExamType='W1')
	Begin
		SET @TWObt1=@ObtainMarks;
		Set @TWConv1=dbo.ConvertMarks((@TDivExamFullMark*@ObtainMarks)/@TDivExamExamMark,@BodyCalculationRule)
		Set @TWFrac1=(@TDivExamFullMark*@ObtainMarks)/@TDivExamExamMark;
		SET @TWIsPass1=@TDivIsPass;
		SET @TWIsAbs1=@IsAbsent;

		if(@DBname='mmesc_new_2018')
		BEGIN
		 set @TWConv1=@WConv1
		END
	End

	else If(@DivExamType='W2')
	Begin
		SET @TWObt2=@ObtainMarks;
		Set @TWConv2=dbo.ConvertMarks((@TDivExamFullMark*@ObtainMarks)/@TDivExamExamMark,@BodyCalculationRule)
		Set @TWFrac2=(@TDivExamFullMark*@ObtainMarks)/@TDivExamExamMark;
		SET @TWIsPass2=@TDivIsPass;
		SET @TWIsAbs2=@IsAbsent;

		if(@DBname='mmesc_new_2018')
		BEGIN
		 set @TWConv2=@WConv2
		END
	End

	else If(@DivExamType='W3')
	Begin
		SET @TWObt3=@ObtainMarks;
		Set @TWConv3=dbo.ConvertMarks((@TDivExamFullMark*@ObtainMarks)/@TDivExamExamMark,@BodyCalculationRule)
		Set @TWFrac3=(@TDivExamFullMark*@ObtainMarks)/@TDivExamExamMark;
		SET @TWIsPass3=@TDivIsPass;
		SET @TWIsAbs3=@IsAbsent;

		if(@DBname='mmesc_new_2018')
		BEGIN
		 set @TWConv3=@WConv3
		END
	End

	else If(@DivExamType='S')
	Begin
	--if(@PTotalSubjectID=44)
	--BEGIN
	--print '@TDivExamFullMark>>>>>>>>>>>>>>>>>>>>>>>>>>>>>' print @TDivExamFullMark
	--print '@@TDivExamExamMark>>>>>>>>>>>>>>>>>>>>>>>>>>>>>' print @TDivExamExamMark
	--END
		SET @TSObt=@ObtainMarks;
		Set @TSConv=dbo.ConvertMarks((@TDivExamFullMark*@ObtainMarks)/@TDivExamExamMark,@BodyCalculationRule)
		Set @TSFrac=(@TDivExamFullMark*@ObtainMarks)/@TDivExamExamMark;
		SET @TSIsPass=@TDivIsPass;
		SET @TSIsAbs=@IsAbsent;

		if(@DBname='mmesc_new_2018')
		BEGIN
		 set @TSConv=@SConv
		END
	End

	else If(@DivExamType='O')
	Begin
		SET @TOObt=@ObtainMarks;
		Set @TOConv=dbo.ConvertMarks((@TDivExamFullMark*@ObtainMarks)/@TDivExamExamMark,@BodyCalculationRule)
		Set @TOFrac=(@TDivExamFullMark*@ObtainMarks)/@TDivExamExamMark;
		SET @TOIsPass=@TDivIsPass;
		SET @TOIsAbs=@IsAbsent;

		if(@DBname='mmesc_new_2018')
		BEGIN
		 set @TOConv=@OConv
		END
	End

	else If(@DivExamType='P')
		Begin
			SET @TPObt=@ObtainMarks;
			Set @TPConv=dbo.ConvertMarks((@TDivExamFullMark*@ObtainMarks)/@TDivExamExamMark,@BodyCalculationRule)
			Set @TPFrac=(@TDivExamFullMark*@ObtainMarks)/@TDivExamExamMark;
			SET @TPIsPass=@TDivIsPass;
			SET @TPIsAbs=@IsAbsent;


			if(@DBname='mmesc_new_2018')
			BEGIN
			 set @TPConv=@PConv
			END
		End
	
	

	SET @TSubExamTotalObt=@TWConv1+@TWConv2+@TWConv3+@TSConv+@TOConv+@TPConv;

	If(@DBname in ('btclisc_new_2018','sshs_new_2018') AND @ClassId <> 46)
	Begin
    	SET @TSubExamTotalObt=@TWConv1+@TWConv2+@TWConv3+@TSConv+@TOConv+@TPConv;
	End

	SET @TSubExamTotalFrac=((@TSubExamTotalObt*@TSubExamFullMark)/@TSubExamExamMark)
	SET @TSubExamOriginalTotalObt=@TWObt1+@TWObt2+@TWObt3+@TSObt+@TOObt+@TPObt;


IF(@TSubExamFullMark != @TSubExamExamMark)
	Begin
	  SELECT @TSubExamTotalConv=dbo.ConvertMarks((@TSubExamTotalObt*@TSubExamFullMark)/@TSubExamExamMark,@BodyCalculationRule)
	End
else 
    SET @TSubExamTotalConv=@TSubExamTotalObt


	if(@DBname='mmesc_new_2018')
			BEGIN
			-- set @TSubExamTotalConv=@TWConv1+@TWConv2+@TWConv3+@TSConv+@TOConv+@TPConv;
			 set @TSubExamTotalConv=@SubExamTotalConv ;
			END

If(@TSubIsPassDepENDed=1)
	Begin
	If(@TSubPassIspercentage=0)
		Begin
			If(@TSubExamTotalObt>=@SubPassMark)
			 SET @TSubExamIsPass=1
			ELSE
			 SET @TSubExamIsPass=0
			End
	ELSE
		Begin
			If(((100*@TSubExamTotalObt)/@TSubExamExamMark)>=@TSubPassMark)
			 SET @TSubExamIsPass=1
			ELSE
			 SET @TSubExamIsPass=0
		End
	End
	IF(@DBname='mths_new_2018')
	BEGIN 
		If(@TSubIsPassDepENDed=1)
		Begin
		If(@TSubPassIspercentage=0)
			Begin
				If(@TSubExamTotalConv>=@TSubPassMark)
				 SET @TSubExamIsPass=1
				ELSE
				 SET @TSubExamIsPass=0
				End
		ELSE
			Begin
				If(((100*@TSubExamTotalConv)/@TSubExamExamMark)>=@TSubPassMark)
				 SET @TSubExamIsPass=1
				ELSE
				 SET @TSubExamIsPass=0
			End
		End
	END


SET @TSOPTotalObt=@TSObt + @TOObt + @TPObt
SET @TSOPTotalConv=@TSConv + @TOConv + @TPConv
SET @TSOPTotalFrac=@TSFrac + @TOFrac + @TPFrac

/*For total, If Any Div Exam Fail Then SubExam Is fail*/
IF(@TDivIsPass=0)
	BEGIN
		set @TSubExamIsPass=0
	END
/*End For Total, If Any Div Exam Fail Then SubExam Is fail */

END

/*End pair total First Time Insert*/

/*End*/

--IF Not Exists (Select TOP 1 MERD.MainExamId  from [dbo].[Res_MEResultDetails] MERD Where MERD.MainExamId=@MainExamID and MERD.SubExamId=@SubExamID and MERD.SubjectID=@SubjectID And MERD.StudentIID=@StudentIID )  --and MERD.ResultSubjectDetailsId=@ResultSubjectDetailsId
--	Begin

		Insert Into [dbo].[Res_MEResultDetails]
		(  [SubjectID],[MainExamId],[StudentIID],[SubExamId],[SubExamTotalObt],[SubExamTotalConv],[SubExamTotalFrac],[SubExamIsPass],[SubExamIsAbsent],[WrittenObt1],[WrittenConv1]
		,[WrittenFrac1],[WrittenIsPass1],[WrittenIsAbsent1],[WrittenObt2],[WrittenConv2],[WrittenFrac2],[WrittenIsPass2],[WrittenIsAbsent2],[WrittenObt3],[WrittenConv3],[WrittenFrac3]
		,[WrittenIsPass3],[WrittenIsAbsent3],[SubjectiveObt],[SubjectiveConv],[SubjectiveFrac],[SubjectiveIsPass],[SubjectiveIsAbsent],[ObjectiveObt],[ObjectiveConv],[ObjectiveFrac]
		,[ObjectiveIsPass],[ObjectiveIsAbsent],[PracticalObt],[PracticalConv],[PracticalFrac],[PracticalIsPass],[PracticalIsAbsent],ResultSubjectDetailsId,SOPTotalObt,SOPTotalConv,SOPTotalFrac,SubExamOriginalTotalObt)
		values(@SubjectID,@MainExamID,@StudentIID,@SubExamID,@SubExamTotalObt,@SubExamTotalConv,@SubExamTotalFrac,@SubExamIsPass,@SubExamIsAbsent,@WObt1,@WConv1,@WFrac1,@WIsPass1,
		@WIsAbs1,@WObt2,@WConv2,@WFrac2,@WIsPass2,@WIsAbs2,@WObt3,@WConv3,@WFrac3,@WIsPass3,@WIsAbs3,@SObt,@SConv,@SFrac,@SIsPass,@SIsAbs,@OObt,@OConv,@OFrac,@OIsPass ,
		@OIsAbs,@PObt,@PConv ,@PFrac,@PIsPass,@PIsAbs,@ResultSubjectDetailsId,@SOPTotalObt,@SOPTotalConv,@SOPTotalFrac,@SubExamOriginalTotalObt)
		--Print 'Result Deatils Demo Insert Success'
      /*For Pair Total Insert*/
		IF Exists(Select TOP 1 [SubID] from [#Res_SubjectSetup] SS where SS.IsPair=1 and (SS.FirstPairSubID=@SubjectID OR SS.SecondPairSubID=@SubjectID )) 
		BEGIN
			IF Not Exists (Select TOP 1 [MarksDetailsID] from [dbo].[Res_MEResultDetails] MERD Where MERD.MainExamId=@MainExamID and MERD.SubExamId=@SubExamID and MERD.SubjectID=@PTotalSubjectID and MERD.StudentIID=@StudentIID)
		 		BEGIN
					--Print @TSubExamTotalObt
					 PRINT @TSIsPass
					 PRINT @PTotalSubjectID
					 PRINT @DivExamType

					Insert Into [dbo].[Res_MEResultDetails]
					([SubjectID],[MainExamId],[StudentIID],[SubExamId],[SubExamTotalObt],[SubExamTotalConv],[SubExamTotalFrac],[SubExamIsPass],[SubExamIsAbsent],[WrittenObt1]
					,[WrittenConv1],[WrittenFrac1],[WrittenIsPass1],[WrittenIsAbsent1],[WrittenObt2],[WrittenConv2],[WrittenFrac2],[WrittenIsPass2],[WrittenIsAbsent2],[WrittenObt3],[WrittenConv3]
					,[WrittenFrac3],[WrittenIsPass3],[WrittenIsAbsent3],[SubjectiveObt],[SubjectiveConv],[SubjectiveFrac],[SubjectiveIsPass],[SubjectiveIsAbsent],[ObjectiveObt],[ObjectiveConv]
					,[ObjectiveFrac],[ObjectiveIsPass],[ObjectiveIsAbsent],[PracticalObt],[PracticalConv],[PracticalFrac],[PracticalIsPass],[PracticalIsAbsent],ResultSubjectDetailsId,SOPTotalObt,SOPTotalConv,SOPTotalFrac,SubExamOriginalTotalObt)
					values(@PTotalSubjectID,@MainExamID,@StudentIID,@SubExamID,@TSubExamTotalObt,@TSubExamTotalConv,@TSubExamTotalFrac,@TSubExamIsPass,@TSubExamIsAbsent,
					@TWObt1,@TWConv1,@TWFrac1,@TWIsPass1,@TWIsAbs1,
					@TWObt2,@TWConv2,@TWFrac2,@TWIsPass2,@TWIsAbs2,
					@TWObt3,@TWConv3,@TWFrac3,@TWIsPass3,@TWIsAbs3,
					@TSObt,@TSConv,@TSFrac,@TSIsPass,@TSIsAbs,@TOObt,@TOConv,@TOFrac,@TOIsPass ,@TOIsAbs,
					@TPObt,@TPConv ,@TPFrac,@TPIsPass,@TPIsAbs,@ResultPairTotalSubjectDetailsId,@TSOPTotalObt,@TSOPTotalConv,@TSOPTotalFrac,@TSubExamOriginalTotalObt)
				End
			ELSE
				BEGIN
				
				PRINT '........'
				    PRINT @TSIsPass
					 PRINT @PTotalSubjectID
					 PRINT @DivExamType

				  SELECT @TWObt1=MERD.WrittenObt1,@TWConv1=MERD.WrittenConv1,@TWFrac1=MERD.WrittenFrac1,
								@TWObt2=MERD.WrittenObt2 ,@TWConv2=MERD.WrittenConv2 ,@TWFrac2=MERD.WrittenFrac2 ,
								@TWObt3=MERD.WrittenObt3 ,@TWConv3=MERD.WrittenConv3,@TWFrac3=MERD.WrittenFrac3,
								@TSObt=MERD.SubjectiveObt,@TSConv=MERD.SubjectiveConv,@TSFrac=MERD.SubjectiveFrac,
								@TOObt=MERD.ObjectiveObt,@TOConv=MERD.ObjectiveConv,@TOFrac=MERD.ObjectiveConv,
								@TPObt=MERD.PracticalObt,@TPConv=MERD.PracticalConv,@TPFrac=MERD.PracticalFrac,
								@TWIsPass1=MERD.WrittenIsPass1,@TWIsPass2=MERD.WrittenIsPass2,@TWIsPass3=MERD.WrittenIsPass3,
								@TSIsPass=MERD.SubjectiveIsPass,@TOIsPass=MERD.ObjectiveIsPass,@TPIsPass=MERD.PracticalIsPass,
								@STSubExamTotalConv=MERD.SubExamTotalConv
								from [dbo].[Res_MEResultDetails] MERD 
									Where MERD.MainExamId=@MainExamID and MERD.SubExamId=@SubExamID and MERD.SubjectID=@PTotalSubjectID  AND MERD.StudentIID=@StudentIID
		
		     

							Select @FirstPairID=SS.FirstPairSubID, @SecondPairID=SS.SecondPairSubID from [dbo].[Res_SubjectSetup] SS where SS.SubID=@PTotalSubjectID
							if(@FirstPairID=@SubjectID)
								SET @PairID=@SecondPairID;
							else
								SET  @PairID=@FirstPairID;

							SELECT @PWObt1=MERD.WrittenObt1,
							@PWConv1=MERD.WrittenConv1,
							@PWFrac1=MERD.WrittenFrac1,

							@PWObt2=MERD.WrittenObt2 ,
							@PWConv2=MERD.WrittenConv2 ,
							@PWFrac2=MERD.WrittenFrac2 ,

							@PWObt3=MERD.WrittenObt3 ,
							@PWConv3=MERD.WrittenConv3,
							@PWFrac3=MERD.WrittenFrac3,

							@PSObt=MERD.SubjectiveObt,
							@PSConv=MERD.SubjectiveConv,
							@PSFrac=MERD.SubjectiveFrac,

							@POObt=MERD.ObjectiveObt,
							@POConv=MERD.ObjectiveConv,
							@POFrac=MERD.ObjectiveConv,

							@PPObt=MERD.PracticalObt,
							@PPConv=MERD.PracticalConv,
							@PPFrac=MERD.PracticalFrac from [dbo].[Res_MEResultDetails] MERD Where MERD.MainExamId=@MainExamID and MERD.SubExamId=@SubExamID and MERD.SubjectID=@PairID and MERD.StudentIID=@StudentIID

							/* For pair total Update Marks Type Identification*/
							If(@DivExamType='W1')
							Begin
							SET @TWObt1=@ObtainMarks+@PWObt1;

							Set @TWConv1=dbo.ConvertMarks((@TDivExamFullMark*@TWObt1)/@TDivExamExamMark,@BodyCalculationRule)
		                    Set @TWFrac1=(@TDivExamFullMark*@TWObt1)/@TDivExamExamMark;

							if(@DBname='mmesc_new_2018')
	                    	BEGIN
							 Set @TWConv1=@DivConvertedMarks+ @PWConv1;
							 End
							--Set @TWFrac1=(@DivExamFullmarks*@ObtainMarks)/@DivExamExammarks + @PWFrac1;

							if(@TDivIsPassDepENDed=1)
										Begin
										 If(@TDivPassIspercentage=0)
										Begin

										If(@TWObt1>=@TDivPassMark)
										 SET @TWIsPass1=1
										ELSE
										SET @TWIsPass1=0
										End
										ELSE
										Begin
										If(((100*@TWObt1)/@TDivExamExamMark)>=@TDivPassMark)
										SET @TWIsPass1=1
										ELSE
										SET @TWIsPass1=0
										END
							END
							End

							else If(@DivExamType='W2')
							Begin
							SET @TWObt2=@ObtainMarks +@PWObt2 ;

							Set @TWConv2=dbo.ConvertMarks((@TDivExamFullMark*@TWObt2)/@TDivExamExamMark,@BodyCalculationRule)
		                    Set @TWFrac2=(@TDivExamFullMark*@TWObt2)/@TDivExamExamMark;

							if(@DBname='mmesc_new_2018')
	                    	BEGIN
							 Set @TWConv2=@DivConvertedMarks + @PWConv2;
							 End
							--Set @TWConv2=@DivConvertedMarks + @PWConv2;
							--Set @TWFrac2=(@DivExamFullmarks*@ObtainMarks)/@DivExamExammarks + @PWFrac2;

							if(@TDivIsPassDepENDed=1)
										Begin
										 If(@TDivPassIspercentage=0)
										Begin

										If(@TWObt2>=@TDivPassMark)
										 SET @TWIsPass2=1
										ELSE
										SET @TWIsPass2=0
										End
										ELSE
										Begin
										If(((100*@TWObt2)/@TDivExamExamMark)>=@TDivPassMark)
										SET @TWIsPass2=1
										ELSE
										SET @TWIsPass2=0
										END
							END
							End

							else If(@DivExamType='W3')
							Begin
							SET @TWObt3=@ObtainMarks + @PWObt3;

							Set @TWConv3=dbo.ConvertMarks((@TDivExamFullMark*@TWObt3)/@TDivExamExamMark,@BodyCalculationRule)
		                    Set @TWFrac3=(@TDivExamFullMark*@TWObt3)/@TDivExamExamMark;

							if(@DBname='mmesc_new_2018')
	                    	BEGIN
							Set @TWConv3=@DivConvertedMarks + @PWConv3;
							 End
							--Set @TWConv3=@DivConvertedMarks + @PWConv3;
							--Set @TWFrac3=(@DivExamFullmarks*@ObtainMarks)/@DivExamExammarks + @PWFrac3;

							if(@TDivIsPassDepENDed=1)
										Begin
										 If(@TDivPassIspercentage=0)
										Begin

										If(@TWObt3>=@TDivPassMark)
										 SET @TWIsPass3=1
										ELSE
										SET @TWIsPass3=0
										End
										ELSE
										Begin
										If(((100*@TWObt3)/@TDivExamExamMark)>=@TDivPassMark)
										SET @TWIsPass3=1
										ELSE
										SET @TWIsPass3=0
										END
							END
							End

							else If(@DivExamType='S')
							Begin
							SET @TSObt=@ObtainMarks + @PSObt;

							Set @TSConv=dbo.ConvertMarks((@TDivExamFullMark*@TSObt)/@TDivExamExamMark,@BodyCalculationRule)
		                    Set @TSFrac=(@TDivExamFullMark*@TSObt)/@TDivExamExamMark;

							
							

							if(@DBname='mmesc_new_2018')
	                    	BEGIN
							Set @TSConv=@DivConvertedMarks + @PSConv;
							 End
							

							if(@TDivIsPassDepENDed=1)
										Begin
										 If(@TDivPassIspercentage=0)
										Begin

										If(@TSObt>=@TDivPassMark)
										 SET @TSIsPass=1
										ELSE
										SET @TSIsPass=0
										End
										ELSE
										Begin
										If(((100*@TSObt)/@TDivExamExamMark)>=@TDivPassMark)
										SET @TSIsPass=1
										ELSE
										SET @TSIsPass=0
										END
							END
							End

							else If(@DivExamType='O')
							Begin

							SET @TOObt=@ObtainMarks + @POObt;

							Set @TOConv=dbo.ConvertMarks((@TDivExamFullMark*@TOObt)/@TDivExamExamMark,@BodyCalculationRule)
		                    Set @TOFrac=(@TDivExamFullMark*@TOObt)/@TDivExamExamMark;

							if(@DBname='mmesc_new_2018')
	                    	BEGIN
							  Set @TOConv=@DivConvertedMarks + @POConv;
							 End
							--Set @TOConv=@DivConvertedMarks + @POConv;
							--Set @TOFrac=(@DivExamFullmarks*@ObtainMarks)/@DivExamExammarks + @POFrac;

							if(@TDivIsPassDepENDed=1)
										Begin
										 If(@TDivPassIspercentage=0)
										Begin

										If(@TOObt>=@TDivPassMark)
										 SET @TOIsPass=1
										ELSE
										SET @TOIsPass=0
										End
										ELSE
										Begin
										If(((100*@TOObt)/@TDivExamExamMark)>=@TDivPassMark)
										SET @TOIsPass=1
										ELSE
										SET @TOIsPass=0
										END
							END
							End

							else If(@DivExamType='P')
							Begin
							SET @TPObt=@ObtainMarks + @PPObt;

							Set @TPConv=dbo.ConvertMarks((@TDivExamFullMark*@TPObt)/@TDivExamExamMark,@BodyCalculationRule)
		                    Set @TPFrac=(@TDivExamFullMark*@TPObt)/@TDivExamExamMark;

							if(@DBname='mmesc_new_2018')
	                    	BEGIN
							  	Set @TPConv=@DivConvertedMarks + @PPConv;
							 End

							--Set @TPConv=@DivConvertedMarks + @PPConv;
							--Set @TPFrac=(@DivExamFullmarks*@ObtainMarks)/@DivExamExammarks + @PPFrac;

							if(@TDivIsPassDepENDed=1)
										Begin
										 If(@TDivPassIspercentage=0)
										Begin

										If(@TPObt>=@TDivPassMark)
										 SET @TPIsPass=1
										ELSE
										SET @TPIsPass=0
										End
										ELSE
										Begin
										If(((100*@TPObt)/@TDivExamExamMark)>=@TDivPassMark)
										SET @TPIsPass=1
										ELSE
										SET @TPIsPass=0
										END
							END
							End

							----Print @TWConv1+@TWConv2+@TWConv3+@TSConv+@TOConv+@TPConv;

							SET @TSubExamTotalObt=@TWConv1+@TWConv2+@TWConv3+@TSConv+@TOConv+@TPConv;

							If(@DBname in ('btclisc_new_2018','sshs_new_2018') AND @ClassId <> 46)
								Begin
    								SET @TSubExamTotalObt=@TWConv2+@TWConv3+@TSConv+@TOConv+@TPConv;
								End
							SET @TSubExamTotalFrac=((@TSubExamTotalObt*@TSubExamFullMark)/@TSubExamExamMark)
							SET @TSubExamOriginalTotalObt=@TWObt1+@TWObt2+@TWObt3+@TSObt+@TOObt+@TPObt;


							/*End Uodate pair total Type Identification*/

							if(@TSubExamFullMark != @TSubExamExamMark)
							Begin
							SELECT @TSubExamTotalConv=dbo.ConvertMarks((@TSubExamTotalObt*@TSubExamFullMark)/@TSubExamExamMark,@BodyCalculationRule)
							End
							else 
							SET @TSubExamTotalConv=@TSubExamTotalObt

					

							if(@DBname='mmesc_new_2018')
									BEGIN
									-- set @TSubExamTotalConv=@TWConv1+@TWConv2+@TWConv3+@TSConv+@TOConv+@TPConv;
									set @TSubExamTotalConv=@STSubExamTotalConv + @SubExamTotalConv
									END

							If(@TSubIsPassDepENDed=1)
							Begin

							If(@TSubPassIspercentage=0)
							Begin
							If(@TSubExamTotalObt>=@TSubPassMark)
							SET @TSubExamIsPass=1
							ELSE
							SET @TSubExamIsPass=0
							End
							ELSE
							Begin
							If(((100*@TSubExamTotalObt)/@TSubExamExamMark)>=@TSubPassMark)
							SET @TSubExamIsPass=1
							ELSE
							SET @TSubExamIsPass=0
							End
							End

							IF(@DBname='mths_new_2018')
							BEGIN 
								If(@TSubIsPassDepENDed=1)
								Begin
								If(@TSubPassIspercentage=0)
									Begin
										If(@TSubExamTotalConv>=@TSubPassMark)
											SET @TSubExamIsPass=1
										ELSE
											SET @TSubExamIsPass=0
										End
								ELSE
									Begin
										If(((100*@TSubExamTotalConv)/@TSubExamExamMark)>=@TSubPassMark)
											SET @TSubExamIsPass=1
										ELSE
											SET @TSubExamIsPass=0
									End
								End
							END

							set @TSOPTotalObt=@TSObt + @TOObt + @TPObt
							set @TSOPTotalConv=@TSConv + @TOConv + @TPConv
							set @TSOPTotalFrac=@TSFrac + @TOFrac + @TPFrac

							IF(@TWIsPass1=0 or @TWIsPass2=0 or @TWIsPass3=0 or @TSIsPass=0 or @TOIsPass=0 or @TPIsPass=0)
								BEGIN
								set @TSubExamIsPass=0
								END


								
                        
						update [dbo].[Res_MEResultDetails] SET SubExamTotalObt=@TSubExamTotalObt,SubExamTotalConv=@TSubExamTotalConv,SubExamTotalFrac=@TSubExamTotalFrac,SubExamIsPass=@TSubExamIsPass,
						WrittenObt1=@TWObt1,WrittenConv1=@TWConv1,WrittenFrac1=@TWFrac1,WrittenIsPass1=@TWIsPass1,WrittenIsAbsent1=@TWIsAbs1,
						WrittenObt2=@TWObt2,WrittenConv2=@TWConv2,WrittenFrac2=@TWFrac2,WrittenIsPass2=@TWIsPass2,WrittenIsAbsent2=@TWIsAbs2,
						WrittenObt3=@TWObt3,WrittenConv3=@TWConv3,WrittenFrac3=@TWFrac3,WrittenIsPass3=@TWIsPass3,WrittenIsAbsent3=@TWIsAbs3,
						SubjectiveObt=@TSObt,SubjectiveConv=@TSConv,SubjectiveFrac=@TSFrac,SubjectiveIsPass=@TSIsPass,SubjectiveIsAbsent=@TSIsAbs,
						ObjectiveObt=@TOObt,ObjectiveConv=@TOConv,ObjectiveFrac=@TOFrac,ObjectiveIsPass=@TOIsPass,ObjectiveIsAbsent=@TOIsAbs,
						PracticalObt=@TPObt,PracticalConv=@TPConv,PracticalFrac=@TPFrac,PracticalIsPass=@TPIsPass,PracticalIsAbsent=@TPIsAbs,
						SOPTotalObt=@TSOPTotalObt,SOPTotalConv=@TSOPTotalConv,SOPTotalFrac=@TSOPTotalFrac,SubExamOriginalTotalObt=@TSubExamOriginalTotalObt
						where MainExamId=@MainExamID and SubExamId=@SubExamID and SubjectID=@PTotalSubjectID and StudentIID=@StudentIID
						END
        End
       /*End pair Total Insert*/

End
Else
BEGIN
--Print 'Update Here..............................:'
SELECT @WObt1=MERD.WrittenObt1, @WConv1=MERD.WrittenConv1,@WFrac1=MERD.WrittenFrac1,--@WIsAbs1 = MERD.WrittenIsAbsent1,
	@WObt2=MERD.WrittenObt2 ,@WConv2=MERD.WrittenConv2 ,@WFrac2=MERD.WrittenFrac2 , --@WIsAbs2 = MERD.WrittenIsAbsent2,
	@WObt3=MERD.WrittenObt3 ,@WConv3=MERD.WrittenConv3,@WFrac3=MERD.WrittenFrac3, --@WIsAbs3 = MERD.WrittenIsAbsent3,
	@SObt=MERD.SubjectiveObt,@SConv=MERD.SubjectiveConv,@SFrac=MERD.SubjectiveFrac, --@SIsAbs = MERD.SubjectiveIsAbsent,
	@OObt=MERD.ObjectiveObt,@OConv=MERD.ObjectiveConv,@OFrac=MERD.ObjectiveConv, --@OIsAbs = MERD.ObjectiveIsAbsent,
	@PObt=MERD.PracticalObt,@PConv=MERD.PracticalConv,@PFrac=MERD.PracticalFrac ,-- @PIsAbs  =  MERD.PracticalIsAbsent,
	@WIsPass1=MERD.WrittenIsPass1,@WIsPass2=MERD.WrittenIsPass2,@WIsPass3=MERD.WrittenIsPass3,
	@SIsPass=MERD.SubjectiveIsPass,@OIsPass=MERD.ObjectiveIsPass,@PIsPass=MERD.PracticalIsPass
	from [dbo].[Res_MEResultDetails] MERD 
		Where MERD.MainExamId=@MainExamID and MERD.SubExamId=@SubExamID and MERD.SubjectID=@SubjectID  AND MERD.StudentIID=@StudentIID
		
	
/* For Update Marks Type Identification*/
	If(@DivExamType='W1')
		Begin
			SET @WObt1=@ObtainMarks;
			Set @WConv1=@DivConvertedMarks;
			Set @WFrac1=(@DivExamFullmarks*@ObtainMarks)/@DivExamExammarks;
			SET @WIsAbs1 = @IsAbsent
			if(@DivIsPassDepENDed=1)
				Begin
				If(@DivPassIspercentage=0)
				Begin

				If(@ObtainMarks>=@DivPassMark)
				SET @WIsPass1=1
				ELSE
				SET @WIsPass1=0
				End
				ELSE
				Begin
				If(((100*@ObtainMarks)/@DivExamExammarks)>=@DivPassMark)
				SET @WIsPass1=1
				ELSE
				SET @WIsPass1=0
				END
				END
		End

	else If(@DivExamType='W2')
	Begin
		SET @WObt2=@ObtainMarks;
		Set @WConv2=@DivConvertedMarks;
		Set @WFrac2=(@DivExamFullmarks*@ObtainMarks)/@DivExamExammarks;
		SET @WIsAbs2 = @IsAbsent
		if(@DivIsPassDepENDed=1)
				Begin
				If(@DivPassIspercentage=0)
				Begin

				If(@ObtainMarks>=@DivPassMark)
				SET @WIsPass2=1
				ELSE
				SET @WIsPass2=0
				End
				ELSE
				Begin
				If(((100*@ObtainMarks)/@DivExamExammarks)>=@DivPassMark)
				SET @WIsPass2=1
				ELSE
				SET @WIsPass2=0
				END
				END
	End	

	else If(@DivExamType='W3')
	Begin
		SET @WObt3=@ObtainMarks;
		Set @WConv3=@DivConvertedMarks;
		Set @WFrac3=(@DivExamFullmarks*@ObtainMarks)/@DivExamExammarks;
		SET @WIsAbs3 = @IsAbsent
		if(@DivIsPassDepENDed=1)
				Begin
				If(@DivPassIspercentage=0)
				Begin

				If(@ObtainMarks>=@DivPassMark)
				SET @WIsPass3=1
				ELSE
				SET @WIsPass3=0
				End
				ELSE
				Begin
				If(((100*@ObtainMarks)/@DivExamExammarks)>=@DivPassMark)
				SET @WIsPass3=1
				ELSE
				SET @WIsPass3=0
				END
				END
	End

	else If(@DivExamType='S')
	Begin
		SET @SObt=@ObtainMarks;
		Set @SConv=@DivConvertedMarks;
		Set @SFrac=(@DivExamFullmarks*@ObtainMarks)/@DivExamExammarks;
		SET @SIsAbs = @IsAbsent
		if(@DivIsPassDepENDed=1)
				Begin
				If(@DivPassIspercentage=0)
				Begin

				If(@ObtainMarks>=@DivPassMark)
				SET @SIsPass=1
				ELSE
				SET @SIsPass=0
				End
				ELSE
				Begin
				If(((100*@ObtainMarks)/@DivExamExammarks)>=@DivPassMark)
				SET @SIsPass=1
				ELSE
				SET @SIsPass=0
				END
				END
	End

	else If(@DivExamType='O')
	Begin
		SET @OObt=@ObtainMarks;
		Set @OConv=@DivConvertedMarks;
		Set @OFrac=(@DivExamFullmarks*@ObtainMarks)/@DivExamExammarks;
		SET @OIsAbs = @IsAbsent
		if(@DivIsPassDepENDed=1)
				Begin
				If(@DivPassIspercentage=0)
				Begin

				If(@ObtainMarks>=@DivPassMark)
				SET @OIsPass=1
				ELSE
				SET @OIsPass=0
				End
				ELSE
				Begin
				If(((100*@ObtainMarks)/@DivExamExammarks)>=@DivPassMark)
				SET @OIsPass=1
				ELSE
				SET @OIsPass=0
				END
				END
	End

	else If(@DivExamType='P')
	Begin
		SET @PObt=@ObtainMarks;
		Set @PConv=@DivConvertedMarks;
		Set @PFrac=(@DivExamFullmarks*@ObtainMarks)/@DivExamExammarks;
		SET @PIsAbs = @IsAbsent
		if(@DivIsPassDepENDed=1)
				Begin
				If(@DivPassIspercentage=0)
				Begin

				If(@ObtainMarks>=@DivPassMark)
				SET @PIsPass=1
				ELSE
				SET @PIsPass=0
				End
				ELSE
				Begin
				If(((100*@ObtainMarks)/@DivExamExammarks)>=@DivPassMark)
				SET @PIsPass=1
				ELSE
				SET @PIsPass=0
				END
				END
	End

	SET @SubExamTotalObt=@WConv1+@WConv2+@WConv3+@SConv+@OConv+@PConv;
	If(@DBname in ('btclisc_new_2018','sshs_new_2018') AND @ClassId <> 46)
								Begin
    								SET @SubExamTotalObt=@WConv2+@WConv3+@SConv+@OConv+@PConv;
								End
	--PRINT (@SubExamTotalObt*@SubExamFullMark)
	--PRINT @SubExamExamMark

	SET @SubExamTotalFrac=((@SubExamTotalObt*@SubExamFullMark)/@SubExamExamMark);
	SET @SubExamOriginalTotalObt=@WObt1+@WObt2+@WObt3+@SObt+@OObt+@PObt;
	


/*End Type Identification*/


	if(@SubExamFullMark != @SubExamExamMark)
	Begin
	SELECT @SubExamTotalConv=dbo.ConvertMarks((@SubExamTotalObt*@SubExamFullMark)/@SubExamExamMark,@BodyCalculationRule)
	 If(@DBname in ('sos_new_2018') and @ClassId=9)
	 BEGIN
	  SELECT @SubExamTotalConv=dbo.ConvertMarks((@SubExamTotalObt* @SubExamFullMark  )/ @SubExamExamMark,@BodyCalculationRule)
	    print '@@@SubExamTotalObt>>>>>>>>>>>>>>>' print @SubExamTotalObt
	    print '@@SubExamFullMark>>>>>>>>>>>>>>>' print @SubExamFullMark
	  print '@@SubExamExamMarks>>>>>>>>>>>>>>>' print @SubExamExamMark
	  print '@@SubExamTotalConv>>>>>>>>>>>>>>>' print @SubExamTotalConv
	 END
	End
	else 
	SET @SubExamTotalConv=@SubExamTotalObt

If(@SubIsPassDepENDed=1)
Begin

	If(@SubPassIspercentage=0)
	Begin
	If(@SubExamTotalObt>=@SubPassMark)
		SET @SubExamIsPass=1
	ELSE
		SET @SubExamIsPass=0
	End
	ELSE
		Begin
			If(((100*@SubExamTotalObt)/@SubExamExamMark)>=@SubPassMark)
				SET @SubExamIsPass=1
			ELSE
				SET @SubExamIsPass=0
		End
End

IF(@DBname='mths_new_2018')
	BEGIN 
		If(@SubIsPassDepENDed=1)
	Begin

	If(@SubPassIspercentage=0)
	Begin
	If(@SubExamTotalConv>=@SubPassMark)
		SET @SubExamIsPass=1
	ELSE
		SET @SubExamIsPass=0
	End
	ELSE
		Begin
			If(((100*@SubExamTotalConv)/@SubExamExamMark)>=@SubPassMark)
				SET @SubExamIsPass=1
			ELSE
				SET @SubExamIsPass=0
		End
		End

	END


SET @SOPTotalObt=@SObt + @OObt + @PObt
SET @SOPTotalConv=@SConv + @OConv + @PConv
SET @SOPTotalFrac=@SFrac + @OFrac + @PFrac

IF(@WIsPass1=0 or @WIsPass2=0 or @WIsPass3=0 or @SIsPass=0 or @OIsPass=0 or @PIsPass=0)
	BEGIN
		set @SubExamIsPass=0	
	END

/*For Pair Selection*/
IF Exists(Select TOP 1 [SubID] from [#Res_SubjectSetup] SS where SS.IsPair=1 and (SS.FirstPairSubID=@SubjectID OR SS.SecondPairSubID=@SubjectID )) 
BEGIN
	SELECT @TWObt1=MERD.WrittenObt1,@TWConv1=MERD.WrittenConv1,@TWFrac1=MERD.WrittenFrac1,
	@TWObt2=MERD.WrittenObt2 ,@TWConv2=MERD.WrittenConv2 ,@TWFrac2=MERD.WrittenFrac2 ,
	@TWObt3=MERD.WrittenObt3 ,@TWConv3=MERD.WrittenConv3,@TWFrac3=MERD.WrittenFrac3,
	@TSObt=MERD.SubjectiveObt,@TSConv=MERD.SubjectiveConv,@TSFrac=MERD.SubjectiveFrac,
	@TOObt=MERD.ObjectiveObt,@TOConv=MERD.ObjectiveConv,@TOFrac=MERD.ObjectiveConv,
	@TPObt=MERD.PracticalObt,@TPConv=MERD.PracticalConv,@TPFrac=MERD.PracticalFrac,
	@TWIsPass1=MERD.WrittenIsPass1,@TWIsPass2=MERD.WrittenIsPass2,@TWIsPass3=MERD.WrittenIsPass3,
	@TSIsPass=MERD.SubjectiveIsPass,@TOIsPass=MERD.ObjectiveIsPass,@TPIsPass=MERD.PracticalIsPass
	from [dbo].[Res_MEResultDetails] MERD 
		Where MERD.MainExamId=@MainExamID and MERD.SubExamId=@SubExamID and MERD.SubjectID=@PTotalSubjectID  AND MERD.StudentIID=@StudentIID
		



Select @FirstPairID=SS.FirstPairSubID, @SecondPairID=SS.SecondPairSubID from [dbo].[Res_SubjectSetup] SS where SS.SubID=@PTotalSubjectID
if(@FirstPairID=@SubjectID)
	SET @PairID=@SecondPairID;
else
	SET  @PairID=@FirstPairID;

SELECT @PWObt1=MERD.WrittenObt1,
@PWConv1=MERD.WrittenConv1,
@PWFrac1=MERD.WrittenFrac1,

@PWObt2=MERD.WrittenObt2 ,
@PWConv2=MERD.WrittenConv2 ,
@PWFrac2=MERD.WrittenFrac2 ,

@PWObt3=MERD.WrittenObt3 ,
@PWConv3=MERD.WrittenConv3,
@PWFrac3=MERD.WrittenFrac3,

@PSObt=MERD.SubjectiveObt,
@PSConv=MERD.SubjectiveConv,
@PSFrac=MERD.SubjectiveFrac,

@POObt=MERD.ObjectiveObt,
@POConv=MERD.ObjectiveConv,
@POFrac=MERD.ObjectiveConv,

@PPObt=MERD.PracticalObt,
@PPConv=MERD.PracticalConv,
@PPFrac=MERD.PracticalFrac,
@STSubExamTotalConv=MERD.SubExamTotalConv from [dbo].[Res_MEResultDetails] MERD Where MERD.MainExamId=@MainExamID and MERD.SubExamId=@SubExamID and MERD.SubjectID=@PairID and MERD.StudentIID=@StudentIID

/* For pair total Update Marks Type Identification*/
If(@DivExamType='W1')
Begin
SET @TWObt1=@ObtainMarks+@PWObt1;

 Set @TWConv1=dbo.ConvertMarks((@TDivExamFullMark*@TWObt1)/@TDivExamExamMark,@BodyCalculationRule)
 Set @TWFrac1=(@TDivExamFullMark*@TWObt1)/@TDivExamExamMark;
 if(@DBname='mmesc_new_2018')
		BEGIN
			Set @TWConv1=@DivConvertedMarks+ @PWConv1;
		END
--Set @TWConv1=@DivConvertedMarks+ @PWConv1;
--Set @TWFrac1=(@DivExamFullmarks*@ObtainMarks)/@DivExamExammarks + @PWFrac1;

if(@TDivIsPassDepENDed=1)
			Begin
			 If(@TDivPassIspercentage=0)
			Begin

			If(@TWObt1>=@TDivPassMark)
			 SET @TWIsPass1=1
			ELSE
			SET @TWIsPass1=0
			End
			ELSE
			Begin
			If(((100*@TWObt1)/@TDivExamExamMark)>=@TDivPassMark)
			SET @TWIsPass1=1
			ELSE
			SET @TWIsPass1=0
			END
END
End

else If(@DivExamType='W2')
Begin
SET @TWObt2=@ObtainMarks +@PWObt2 ;

 Set @TWConv2=dbo.ConvertMarks((@TDivExamFullMark*@TWObt2)/@TDivExamExamMark,@BodyCalculationRule)
 Set @TWFrac2=(@TDivExamFullMark*@TWObt2)/@TDivExamExamMark;

  if(@DBname='mmesc_new_2018')
		BEGIN
		Set @TWConv2=@DivConvertedMarks + @PWConv2;
		END

--Set @TWConv2=@DivConvertedMarks + @PWConv2;
--Set @TWFrac2=(@DivExamFullmarks*@ObtainMarks)/@DivExamExammarks + @PWFrac2;

if(@TDivIsPassDepENDed=1)
			Begin
			 If(@TDivPassIspercentage=0)
			Begin

			If(@TWObt2>=@TDivPassMark)
			 SET @TWIsPass2=1
			ELSE
			SET @TWIsPass2=0
			End
			ELSE
			Begin
			If(((100*@TWObt2)/@TDivExamExamMark)>=@TDivPassMark)
			SET @TWIsPass2=1
			ELSE
			SET @TWIsPass2=0
			END
END
End

else If(@DivExamType='W3')
Begin
SET @TWObt3=@ObtainMarks + @PWObt3;

 Set @TWConv3=dbo.ConvertMarks((@TDivExamFullMark*@TWObt3)/@TDivExamExamMark,@BodyCalculationRule)
 Set @TWFrac3=(@TDivExamFullMark*@TWObt3)/@TDivExamExamMark;


   if(@DBname='mmesc_new_2018')
		BEGIN
		Set @TWConv3=@DivConvertedMarks + @PWConv3;
		END



--Set @TWConv3=@DivConvertedMarks + @PWConv3;
--Set @TWFrac3=(@DivExamFullmarks*@ObtainMarks)/@DivExamExammarks + @PWFrac3;

if(@TDivIsPassDepENDed=1)
			Begin
			 If(@TDivPassIspercentage=0)
			Begin

			If(@TWObt3>=@TDivPassMark)
			 SET @TWIsPass3=1
			ELSE
			SET @TWIsPass3=0
			End
			ELSE
			Begin
			If(((100*@TWObt3)/@TDivExamExamMark)>=@TDivPassMark)
			SET @TWIsPass3=1
			ELSE
			SET @TWIsPass3=0
			END
END
End

else If(@DivExamType='S')
Begin
SET @TSObt=@ObtainMarks + @PSObt;

 Set @TSConv=dbo.ConvertMarks((@TDivExamFullMark*@TSObt)/@TDivExamExamMark,@BodyCalculationRule)
 Set @TSFrac=(@TDivExamFullMark*@TSObt)/@TDivExamExamMark;


    if(@DBname='mmesc_new_2018')
		BEGIN
		 Set @TSConv=@DivConvertedMarks + @PSConv;
		END



--Set @TSConv=@DivConvertedMarks + @PSConv;
--Set @TSFrac=(@DivExamFullmarks*@ObtainMarks)/@DivExamExammarks + @PSFrac;

if(@TDivIsPassDepENDed=1)
			Begin
			 If(@TDivPassIspercentage=0)
			Begin

			If(@TSObt>=@TDivPassMark)
			 SET @TSIsPass=1
			ELSE
			SET @TSIsPass=0
			End
			ELSE
			Begin
			If(((100*@TSObt)/@TDivExamExamMark)>=@TDivPassMark)
			SET @TSIsPass=1
			ELSE
			SET @TSIsPass=0
			END
END
End

else If(@DivExamType='O')
Begin
SET @TOObt=@ObtainMarks + @POObt;

 Set @TOConv=dbo.ConvertMarks((@TDivExamFullMark*@TOObt)/@TDivExamExamMark,@BodyCalculationRule)
 Set @TOFrac=(@TDivExamFullMark*@TOObt)/@TDivExamExamMark;

   if(@DBname='mmesc_new_2018')
		BEGIN
		Set @TOConv=@DivConvertedMarks + @POConv;
		END


--Set @TOConv=@DivConvertedMarks + @POConv;
--Set @TOFrac=(@DivExamFullmarks*@ObtainMarks)/@DivExamExammarks + @POFrac;

if(@TDivIsPassDepENDed=1)
			Begin
			 If(@TDivPassIspercentage=0)
			Begin

			If(@TOObt>=@TDivPassMark)
			 SET @TOIsPass=1
			ELSE
			SET @TOIsPass=0
			End
			ELSE
			Begin
			If(((100*@TOObt)/@TDivExamExamMark)>=@TDivPassMark)
			SET @TOIsPass=1
			ELSE
			SET @TOIsPass=0
			END
END
End

else If(@DivExamType='P')
Begin
SET @TPObt=@ObtainMarks + @PPObt;

 Set @TPConv=dbo.ConvertMarks((@TDivExamFullMark*@TPObt)/@TDivExamExamMark,@BodyCalculationRule)
 Set @TPFrac=(@TDivExamFullMark*@TPObt)/@TDivExamExamMark;

 
   if(@DBname='mmesc_new_2018')
		BEGIN
		Set @TPConv=@DivConvertedMarks + @PPConv;
		END

--Set @TPConv=@DivConvertedMarks + @PPConv;
--Set @TPFrac=(@DivExamFullmarks*@ObtainMarks)/@DivExamExammarks + @PPFrac;

if(@TDivIsPassDepENDed=1)
			Begin
			 If(@TDivPassIspercentage=0)
			Begin

			If(@TPObt>=@TDivPassMark)
			 SET @TPIsPass=1
			ELSE
			SET @TPIsPass=0
			End
			ELSE
			Begin
			If(((100*@TPObt)/@TDivExamExamMark)>=@TDivPassMark)
			SET @TPIsPass=1
			ELSE
			SET @TPIsPass=0
			END
END
End

----Print @TWConv1+@TWConv2+@TWConv3+@TSConv+@TOConv+@TPConv;

SET @TSubExamTotalObt=@TWConv1+@TWConv2+@TWConv3+@TSConv+@TOConv+@TPConv;
If(@DBname in ('btclisc_new_2018','sshs_new_2018') AND @ClassId <> 46)
								Begin
    								SET @TSubExamTotalObt=@TWConv2+@TWConv3+@TSConv+@TOConv+@TPConv;
								End
SET @TSubExamTotalFrac=((@TSubExamTotalObt*@TSubExamFullMark)/@TSubExamExamMark)
SET @TSubExamOriginalTotalObt=@TWObt1+@TWObt2+@TWObt3+@TSObt+@TOObt+@TPObt;


/*End Uodate pair total Type Identification*/
--
if(@TSubExamFullMark != @TSubExamExamMark)
Begin
SELECT @TSubExamTotalConv=dbo.ConvertMarks((@TSubExamTotalObt*@TSubExamFullMark)/@TSubExamExamMark,@BodyCalculationRule)
End
else 
SET @TSubExamTotalConv=@TSubExamTotalObt


--if(@DBname='mmesc_new_db')
--			BEGIN
--			 set @TSubExamTotalConv=@TWConv1+@TWConv2+@TWConv3+@TSConv+@TOConv+@TPConv;
--			END


	if(@DBname='mmesc_new_2018')
									BEGIN
										--set @TSubExamTotalConv=@TWConv1+@TWConv2+@TWConv3+@TSConv+@TOConv+@TPConv;
										set @TSubExamTotalConv=@STSubExamTotalConv + @SubExamTotalConv
									END


If(@TSubIsPassDepENDed=1)
Begin

	If(@TSubPassIspercentage=0)
	Begin
	If(@TSubExamTotalObt>=@TSubPassMark)
	SET @TSubExamIsPass=1
	ELSE
	SET @TSubExamIsPass=0
	End
	ELSE
	Begin
	If(((100*@TSubExamTotalObt)/@TSubExamExamMark)>=@TSubPassMark)
	SET @TSubExamIsPass=1
	ELSE
	SET @TSubExamIsPass=0
	End
End
IF(@DBname='mths_new_2018')
	BEGIN 
		If(@TSubIsPassDepENDed=1)
		Begin
		If(@TSubPassIspercentage=0)
			Begin
				If(@TSubExamTotalConv>=@TSubPassMark)
				 SET @TSubExamIsPass=1
				ELSE
				 SET @TSubExamIsPass=0
				End
		ELSE
			Begin
				If(((100*@TSubExamTotalConv)/@TSubExamExamMark)>=@TSubPassMark)
				 SET @TSubExamIsPass=1
				ELSE
				 SET @TSubExamIsPass=0
			End
		End
	END


set @TSOPTotalObt=@TSObt + @TOObt + @TPObt
set @TSOPTotalConv=@TSConv + @TOConv + @TPConv
set @TSOPTotalFrac=@TSFrac + @TOFrac + @TPFrac

IF(@TWIsPass1=0 or @TWIsPass2=0 or @TWIsPass3=0 or @TSIsPass=0 or @TOIsPass=0 or @TPIsPass=0)
	BEGIN
	set @TSubExamIsPass=0
	END
END

/*End pair Selection*/

PRINT 'W2 Abs : ' PRINT @WIsAbs2

update [dbo].[Res_MEResultDetails] SET SubExamTotalObt=@SubExamTotalObt,SubExamTotalConv=@SubExamTotalConv,SubExamTotalFrac=@SubExamTotalFrac,SubExamIsPass=@SubExamIsPass,
WrittenObt1=@WObt1,WrittenConv1=@WConv1,WrittenFrac1=@WFrac1,WrittenIsPass1=@WIsPass1,WrittenIsAbsent1=@WIsAbs1,
WrittenObt2=@WObt2,WrittenConv2=@WConv2,WrittenFrac2=@WFrac2,WrittenIsPass2=@WIsPass2,WrittenIsAbsent2=@WIsAbs2,
WrittenObt3=@WObt3,WrittenConv3=@WConv3,WrittenFrac3=@WFrac3,WrittenIsPass3=@WIsPass3,WrittenIsAbsent3=@WIsAbs3,
SubjectiveObt=@SObt,SubjectiveConv=@SConv,SubjectiveFrac=@SFrac,SubjectiveIsPass=@SIsPass,SubjectiveIsAbsent=@SIsAbs,
ObjectiveObt=@OObt,ObjectiveConv=@OConv,ObjectiveFrac=@OFrac,ObjectiveIsPass=@OIsPass,ObjectiveIsAbsent=@OIsAbs,
PracticalObt=@PObt,PracticalConv=@PConv,PracticalFrac=@PFrac,PracticalIsPass=@PIsPass,PracticalIsAbsent=@PIsAbs,
SOPTotalObt=@SOPTotalObt,SOPTotalConv=@SOPTotalConv,SOPTotalFrac=@SOPTotalFrac,SubExamOriginalTotalObt=@SubExamOriginalTotalObt
where MainExamId=@MainExamID and SubExamId=@SubExamID and SubjectID=@SubjectID  and StudentIID=@StudentIID
IF Exists(Select TOP 1 [SubID] from [#Res_SubjectSetup] SS where SS.IsPair=1 and (SS.FirstPairSubID=@SubjectID OR SS.SecondPairSubID=@SubjectID) ) 
BEGIN
update [dbo].[Res_MEResultDetails] SET SubExamTotalObt=@TSubExamTotalObt,SubExamTotalConv=@TSubExamTotalConv,SubExamTotalFrac=@TSubExamTotalFrac,SubExamIsPass=@TSubExamIsPass,
WrittenObt1=@TWObt1,WrittenConv1=@TWConv1,WrittenFrac1=@TWFrac1,WrittenIsPass1=@TWIsPass1,WrittenIsAbsent1=@TWIsAbs1,
WrittenObt2=@TWObt2,WrittenConv2=@TWConv2,WrittenFrac2=@TWFrac2,WrittenIsPass2=@TWIsPass2,WrittenIsAbsent2=@TWIsAbs2,
WrittenObt3=@TWObt3,WrittenConv3=@TWConv3,WrittenFrac3=@TWFrac3,WrittenIsPass3=@TWIsPass3,WrittenIsAbsent3=@TWIsAbs3,
SubjectiveObt=@TSObt,SubjectiveConv=@TSConv,SubjectiveFrac=@TSFrac,SubjectiveIsPass=@TSIsPass,SubjectiveIsAbsent=@TSIsAbs,
ObjectiveObt=@TOObt,ObjectiveConv=@TOConv,ObjectiveFrac=@TOFrac,ObjectiveIsPass=@TOIsPass,ObjectiveIsAbsent=@TOIsAbs,
PracticalObt=@TPObt,PracticalConv=@TPConv,PracticalFrac=@TPFrac,PracticalIsPass=@TPIsPass,PracticalIsAbsent=@TPIsAbs,
SOPTotalObt=@TSOPTotalObt,SOPTotalConv=@TSOPTotalConv,SOPTotalFrac=@TSOPTotalFrac,SubExamOriginalTotalObt=@TSubExamOriginalTotalObt
where MainExamId=@MainExamID and SubExamId=@SubExamID and SubjectID=@PTotalSubjectID and StudentIID=@StudentIID
END
End --
Drop Table #Res_SubjectSetup
END


