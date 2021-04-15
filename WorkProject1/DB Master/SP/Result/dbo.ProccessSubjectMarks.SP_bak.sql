/****** Object:  StoredProcedure [dbo].[ProccessSubjectMarks]    Script Date: 7/22/2017 4:26:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ProccessSubjectMarks]'))
BEGIN
DROP PROCEDURE  ProccessSubjectMarks
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
--execute ProccessSubjectMarks 1,6,1,10,1,29

--execute ProccessSubjectMarks 


Create PROCEDURE [dbo].[ProccessSubjectMarks]  
	(@VersionId int,
	@SessionId int,
	@ShiftId int,
	@ClassId int,
    @GroupId int,
	@StudentIID int,
	@MainExamID int,
	@SubjectID int
	)
AS
BEGIN
DECLARE @SubjectObtMarks decimal(8,2)=0, 
@SubjectConvertedMarks decimal(8,2)=0,
 @SubjectConvertedMarksFraction decimal(8,2)=0,
 @SubjectIsPass bit=1 ,@SubjectIsAbsent bit =0,
 @SubjectFullMark  decimal(8,2)=0,
 @SubjectIsPassDepended bit=0,
  @SubjectPassIspercentage bit=0,
   @SubjectPassMark decimal(8,2)=0

DECLARE @GP decimal (10,2)
DECLARE @GL VARCHAR(5)
DECLARE @BodyCalculationRule VARCHAR(1)
DECLARE @TotalCalculatuonRule VARCHAR(1)
Select @BodyCalculationRule=MMS.BodyCalculationRule,@TotalCalculatuonRule=MMS.TotalCalculatuonRule from [dbo].[Res_MarksMigratedSetup] MMS Where MMS.VersionID=@VersionId and MMS.SessionID=@SessionId and MMS.ClassID=@ClassId and MMS.IsDeleted=0

select TOP 1 @SubjectFullMark=MMS.MainExamFullMarks, @SubjectIsPassDepended=MMS.MainExamIsPassDepend,@SubjectPassIspercentage=MMS.MainExamPassMarkIsPercent,@SubjectPassMark=MMS.MainExamPassMark from Qry_MarkSetup MMS WHERE MMS.MainExamId=@MainExamID AND MMS.MainExamSubjectID=@SubjectID
select @SubjectObtMarks=Sum(MERD.SubExamTotalConv),@SubjectConvertedMarks=Sum(MERD.SubExamTotalConv), @SubjectConvertedMarksFraction=SUM(MERD.SubExamTotalFrac) from [dbo].[Res_MEResultDetails] MERD Where MERD.MainExamId=@MainExamID AND MERD.StudentIID=@StudentIID AND MERD.SubjectID=@SubjectID


select @SubjectConvertedMarks=dbo.ConvertMarks(@SubjectConvertedMarks,@TotalCalculatuonRule)

If(@SubjectIsPassDepended=1)
	Begin
		If(@SubjectPassIspercentage=0)
			Begin
			If(@SubjectConvertedMarks>=@SubjectPassMark)
				 set @SubjectIsPass=1
				Else
				 set @SubjectIsPass=0
				End
			Else
				Begin
				If(((100*@SubjectConvertedMarks)/@SubjectFullMark)>=@SubjectPassMark)
				 set @SubjectIsPass=1
				Else
				 set @SubjectIsPass=0
				End
	End

SELECT @GP=dbo.GPCalculation(@VersionId,@SessionId, @ClassId,@SubjectConvertedMarks,@SubjectFullMark)
SELECT @GL=dbo.GLCalculation(@VersionId,@SessionId, @ClassId,@SubjectConvertedMarks,@SubjectFullMark)

If Exists(Select Top 1 *  from [dbo].[Res_MEResultDetails] MERD Where MERD.MainExamId=@MainExamID AND MERD.StudentIID=@StudentIID AND MERD.SubjectID=@SubjectID AND MERD.SubExamIsPass=0)
	BEGIN
		set @SubjectIsPass=0
		select @GP=GP, @GL=GL from [dbo].[Res_GradingSystem] where IsFailGrade=1
	END

If Exists(Select Top 1 *  from [dbo].[Res_MEResultDetails] MERD Where MERD.MainExamId=@MainExamID AND MERD.StudentIID=@StudentIID AND MERD.SubjectID=@SubjectID AND MERD.SubExamIsAbsent=1)
	BEGIN
		set @SubjectIsAbsent=1
		
	END

/* For Virtual */
DECLARE @VTotal1 decimal(8,2), @VTotal2 decimal(8,2)
DECLARE @VirtualIsPass1 bit=1
	DECLARE @VirtualIsPass2 bit=1
If Exists (select * from [dbo].[Res_VirtualExamSetup] VES where VES.VersionId=@VersionId and VES.SessionId=@SessionId and VES.ClassId=@ClassId and VES.GroupId=@GroupId and VES.MainExamID=@MainExamID and VES.SubjectID=@SubjectID)
BEGIN
	DECLARE @VSubExamID int,@DivExamTypeVirtual1 varchar(80),@DivExamTypeVirtual2 varchar(80)

	DECLARE MYCURSOR CURSOR FOR  
	SELECT [SubExamID],[DivExamTypeVirtual1],[DivExamTypeVirtual2] from [dbo].[Res_VirtualExamSetup] VES where VES.VersionId=@VersionId and VES.SessionId=@SessionId and VES.ClassId=@ClassId and VES.GroupId=@GroupId and VES.MainExamID=@MainExamID and VES.SubjectID=@SubjectID
 
	OPEN MYCURSOR   
	FETCH NEXT FROM MYCURSOR INTO @VSubExamID, @DivExamTypeVirtual1,@DivExamTypeVirtual2   
	DECLARE @VirExamFullMark1 decimal(10,2),@VirExamFullMark2 decimal(8,2)
	SET @VTotal1 =0
	SET @VTotal2 =0
	SET @VirExamFullMark1=0
	SET @VirExamFullMark2=0

	WHILE @@FETCH_STATUS = 0   
	BEGIN  
		DECLARE @getmarks1 decimal(8,2),@getmarks2 decimal(8,2), @getExamFullMark1 decimal(8,2),@getExamFullMark2 decimal(8,2)
		set @getmarks1 =0
		set @getmarks2 =0
		set @getExamFullMark1=0
		set @getExamFullMark2=0
		If(@DivExamTypeVirtual1='W1')
		select @getmarks1=IsNull(RMED.[WrittenConv1],0) from [dbo].[Res_MEResultDetails] RMED where RMED.MainExamId=@MainExamID and RMED.SubjectID=@SubjectID and RMED.SubExamId=@VSubExamID and RMED.StudentIID=@StudentIID
		If(@DivExamTypeVirtual1='W2')
		select @getmarks1=IsNull(RMED.[WrittenConv2],0) from [dbo].[Res_MEResultDetails] RMED where RMED.MainExamId=@MainExamID and RMED.SubjectID=@SubjectID and RMED.SubExamId=@VSubExamID and RMED.StudentIID=@StudentIID
		If(@DivExamTypeVirtual1='W3')
		select @getmarks1=IsNull(RMED.[WrittenConv3],0) from [dbo].[Res_MEResultDetails] RMED where RMED.MainExamId=@MainExamID and RMED.SubjectID=@SubjectID and RMED.SubExamId=@VSubExamID and RMED.StudentIID=@StudentIID
		If(@DivExamTypeVirtual1='S')
		select @getmarks1=IsNull(RMED.SubjectiveConv,0) from [dbo].[Res_MEResultDetails] RMED where RMED.MainExamId=@MainExamID and RMED.SubjectID=@SubjectID and RMED.SubExamId=@VSubExamID and RMED.StudentIID=@StudentIID
		If(@DivExamTypeVirtual1='O')
		select @getmarks1=IsNull(RMED.ObjectiveConv,0) from [dbo].[Res_MEResultDetails] RMED where RMED.MainExamId=@MainExamID and RMED.SubjectID=@SubjectID and RMED.SubExamId=@VSubExamID and RMED.StudentIID=@StudentIID
		If(@DivExamTypeVirtual1='P')
		select @getmarks1=IsNull(RMED.PracticalConv,0) from [dbo].[Res_MEResultDetails] RMED where RMED.MainExamId=@MainExamID and RMED.SubjectID=@SubjectID and RMED.SubExamId=@VSubExamID and RMED.StudentIID=@StudentIID
		SET @VTotal1 = @VTotal1 +@getmarks1

		Select @getExamFullMark1=QMS.[DividedExamFullMarks] from [dbo].[Qry_MarkSetup] AS QMS where QMS.[MainExamId]=@MainExamID and QMS.[MainExamSubjectID]=@SubjectID and QMS.[SubExamId]=@VSubExamID and QMS.DividedExamType=@DivExamTypeVirtual1
		SET @VirExamFullMark1= @VirExamFullMark1 + @getExamFullMark1


		If(@DivExamTypeVirtual2='W1')
		select @getmarks2=IsNull(RMED.[WrittenConv1],0) from [dbo].[Res_MEResultDetails] RMED where RMED.MainExamId=@MainExamID and RMED.SubjectID=@SubjectID and RMED.SubExamId=@VSubExamID and RMED.StudentIID=@StudentIID
		If(@DivExamTypeVirtual2='W2')
		select @getmarks2=IsNull(RMED.[WrittenConv2],0) from [dbo].[Res_MEResultDetails] RMED where RMED.MainExamId=@MainExamID and RMED.SubjectID=@SubjectID and RMED.SubExamId=@VSubExamID and RMED.StudentIID=@StudentIID
		If(@DivExamTypeVirtual2='W3')
		select @getmarks2=IsNull(RMED.[WrittenConv3],0) from [dbo].[Res_MEResultDetails] RMED where RMED.MainExamId=@MainExamID and RMED.SubjectID=@SubjectID and RMED.SubExamId=@VSubExamID and RMED.StudentIID=@StudentIID
		If(@DivExamTypeVirtual2='S')
		select @getmarks2=IsNull(RMED.SubjectiveConv,0) from [dbo].[Res_MEResultDetails] RMED where RMED.MainExamId=@MainExamID and RMED.SubjectID=@SubjectID and RMED.SubExamId=@VSubExamID and RMED.StudentIID=@StudentIID
		If(@DivExamTypeVirtual2='O')
		select @getmarks2=IsNull(RMED.ObjectiveConv,0) from [dbo].[Res_MEResultDetails] RMED where RMED.MainExamId=@MainExamID and RMED.SubjectID=@SubjectID and RMED.SubExamId=@VSubExamID and RMED.StudentIID=@StudentIID
		If(@DivExamTypeVirtual2='P')

		select @getmarks2=IsNull(RMED.PracticalConv,0) from [dbo].[Res_MEResultDetails] RMED where RMED.MainExamId=@MainExamID and RMED.SubjectID=@SubjectID and RMED.SubExamId=@VSubExamID and RMED.StudentIID=@StudentIID
		SET @VTotal2 = @VTotal2 +@getmarks2

		Select @getExamFullMark2=QMS.[DividedExamFullMarks] from [dbo].[Qry_MarkSetup] AS QMS where QMS.[MainExamId]=@MainExamID and QMS.[MainExamSubjectID]=@SubjectID and QMS.[SubExamId]=@VSubExamID and QMS.DividedExamType=@DivExamTypeVirtual2
		SET @VirExamFullMark2= @VirExamFullMark2 + @getExamFullMark2


		FETCH NEXT FROM MYCURSOR INTO @VSubExamID, @DivExamTypeVirtual1,@DivExamTypeVirtual2 
	END   

	CLOSE MYCURSOR   
	DEALLOCATE MYCURSOR

	DECLARE @VirtualPassMark1 decimal(8,2)
	DECLARE @VirtualPassMark2 decimal(8,2)
	
	DECLARE @VirtualPassIsPercent1 bit=0
	DECLARE @VirtualPassIsPercent2 bit=0
	
	

	select Top(1) @VirtualPassMark1=VES.VirtualPassMark1, @VirtualPassMark2=VES.VirtualPassMark2,@VirtualPassIsPercent1=VES.VirtualPassMarkIsPercent1 ,@VirtualPassIsPercent2=VES.VirtualPassMarkIsPercent2 from [dbo].[Res_VirtualExamSetup] VES where VES.VersionId=@VersionId and VES.SessionId=@SessionId and VES.ClassId=@ClassId and VES.GroupId=@GroupId and VES.MainExamID=@MainExamID and VES.SubjectID=@SubjectID
	if(@VirtualPassIsPercent1=1)
		BEGIN
			if(@VirtualPassMark1>(@VTotal1*100)/@VirExamFullMark1)
			BEGIN
				set @VirtualIsPass1=0
				set @SubjectIsPass=0
				select @GP=GP, @GL=GL from [dbo].[Res_GradingSystem] where IsFailGrade=1

	
			End
		END
	ELSE
		BEGIN
			if(@VirtualPassMark1>@VTotal1)
			BEGIN
				set @VirtualIsPass1=0
				set @SubjectIsPass=0
				select @GP=GP, @GL=GL from [dbo].[Res_GradingSystem] where IsFailGrade=1

	
			End
		END

     if(@VirtualPassIsPercent2=1)
	 BEGIN
	 if(@VirtualPassMark2>(@VTotal2*100)/@VirExamFullMark2)
		BEGIN
			set @VirtualIsPass2=0
			set @SubjectIsPass=0
			select @GP=GP, @GL=GL from [dbo].[Res_GradingSystem] where IsFailGrade=1
	
		End
	 END
 ELSE
	 BEGIN
		if(@VirtualPassMark2>@VTotal2)
		BEGIN
			set @VirtualIsPass2=0
			set @SubjectIsPass=0
			select @GP=GP, @GL=GL from [dbo].[Res_GradingSystem] where IsFailGrade=1
	
		End
	END

End

/* End Virtual */

   Insert Into [dbo].[Res_MainExamResultSubjectDetails]( [ResultId],[SubjectID],[MainExamId],[SubjectObtMarks],[SubjectConvertedMarks],[SubjectConvertedMarksFraction]
		,[SubjectGP],[SubjectGL],[SubjectHighestMark],[SubjectIsPass],[SubjectIsAbsent],VirtualConvertedMarks1,[VirtualIsPass1],[VirtualConvertedMarks2],VirtualIsPass2,[StudentIID])
		values(0,@SubjectID,@MainExamID,@SubjectObtMarks,@SubjectConvertedMarks,@SubjectConvertedMarksFraction,@GP,@GL,0,@SubjectIsPass,@SubjectIsAbsent,@VTotal1,@VirtualIsPass1,@VTotal2,@VirtualIsPass2,@StudentIID)


END

