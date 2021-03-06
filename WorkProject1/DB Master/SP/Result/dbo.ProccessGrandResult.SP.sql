/****** Object:  StoredProcedure [dbo].[ProccessMarks]    Script Date: 7/22/2017 4:26:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ProccessGrandResult]'))
BEGIN
DROP PROCEDURE  ProccessGrandResult
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 --ProccessGrandResult 1 ,6 ,1 ,12 ,1 ,490 ,9 ,9 ,40.00 ,2.00 ,1 ,0 ,129 ,133 ,134 ,bpsc_new_2018
Create PROCEDURE [dbo].[ProccessGrandResult]  
	(@VersionId int,
	@SessionId int,
	@ShiftId int,
	@ClassId int,
    @GroupId int,
	@StudentIID int,
	@GrandExamID int,
	@StudentTotalSubject int,
	@DeductMarks Decimal(8,2),
	@DeductGP Decimal(8,2),
	@4tIsFailImpact bit,
	@PairIsFailImpact bit,
	@SubjectId1 int ,
	@SubjectId2 int,
	@SubjectId3 int,
	@DBname VARCHAR(100)
	)
AS
BEGIN
DECLARE @GrandExamObtMark decimal(8,2)=0
, @GrandExamConvertedMark decimal(8,2)=0
, @GrandExamConvertedMarkFraction decimal(8,2)=0
, @GrandExamIsPass bit=1
, @GrandExamIsAbs bit=0
, @GPA decimal(4,2)=0
, @GPAWithOut4Sub decimal(4,2)=0
, @FailStudentGPA decimal(4,2)=0
, @TotalGP decimal(4,2)=0
, @TotalGPWithOut4Sub decimal(4,2)=0
, @GradeLetter Varchar(10)='F'
,@MainExamId int
,@PTotalSubjectID int


-- PairSubject fail Calculation Rule
if(@PairIsFailImpact=1)
Begin

Print '@PairIsFailImpact>>>>>>>>>>>>>>>>>>>>>>>>>>>:'
	DECLARE @SubjectID int, @rownumberPair int=1, @MaxCount int
	If Exists(Select TOP 1 MRS.SubjectID from [dbo].[Res_GrandResultSubjectDetails] MRS Inner Join [dbo].[Res_SubjectSetup]  SE ON MRS.SubjectID=SE.SubID Where MRS.StudentIID=@StudentIID AND MRS.GrandExamId=@GrandExamID And MRS.SubjectIsPass=0 and SE.SubjectType ='P'  and SE.IsDeleted=0 )
	Begin
		CREATE Table #PairFailSubject
		(
		Id Int IDENTITY(1,1) not null,
		SubjectId Int not null

		)
		insert into #PairFailSubject
		(
		SubjectId
		)
	
		Select MRS.SubjectID from [dbo].[Res_GrandResultSubjectDetails] MRS Inner Join [dbo].[Res_SubjectSetup]  SE ON MRS.SubjectID=SE.SubID Where MRS.StudentIID=@StudentIID AND MRS.GrandExamId=@GrandExamID And MRS.SubjectIsPass=0 and SE.SubjectType ='P'  and SE.IsDeleted=0 
	
		SELECT @MaxCount= COUNT(*) FROM #PairFailSubject
		WHILE(@MaxCount>=@rownumberPair)
		BEGIN
			SELECT @SubjectID=SubjectId FROM  #PairFailSubject where Id=@rownumberPair
			Select TOP(1) @PTotalSubjectID=SS.SubID from [dbo].[Res_SubjectSetup] SS where SS.IsPair=1 and (SS.FirstPairSubID=@SubjectID OR SS.SecondPairSubID=@SubjectID) and SS.[SubjectType] = 'T' and SS.[IsDeleted]=0
			Update Res_GrandResultSubjectDetails SET SubjectGP=0, SubjectGL='F',SubjectIsPass=0 where [SubjectID]=@PTotalSubjectID and [StudentIID]=@StudentIID and [GrandExamId]=@GrandExamId
			set @rownumberPair=@rownumberPair+1
		END
		DROP Table #PairFailSubject
	End
	
End


CREATE TABLE #Res_GrandResultSubjectDetails(
	ResultSubjectDetailsId int IDENTITY(1,1) NOT NULL,
	SubjectID int NOT NULL,
	GrandExamId int NOT NULL,
	SubjectObtMarks decimal(8, 2) NOT NULL,
	SubjectConvertedMarks decimal(8, 2) NOT NULL,
	SubjectConvertedMarksFraction decimal(8, 2) NOT NULL,
	SubjectGP decimal(8, 2) NOT NULL,
	SubjectGL nvarchar(max) NULL,
	SubjectHighestMark decimal(8, 2) NOT NULL,
	SubjectIsPass bit NOT NULL,
	SubjectIsAbsent bit NOT NULL,
	StudentIID [bigint] NOT NULL DEFAULT ((0))
	)

	Insert Into #Res_GrandResultSubjectDetails
	SELECT S.SubjectID,
	S.GrandExamId,
	S.SubjectObtMarks,
	S.SubjectConvertedMarks,
	S.SubjectConvertedMarksFraction,
	S.SubjectGP,
	S.SubjectGL,
	S.SubjectHighestMark,
	S.SubjectIsPass,
	S.SubjectIsAbsent,
	S.StudentIID FROM Res_GrandResultSubjectDetails S 
	Where S.GrandExamId=@GrandExamID AND S.StudentIID=@StudentIID


--/*mainExaMmarks Update*/

select @GrandExamObtMark=IsNull(Sum(MRS.SubjectObtMarks),0),@GrandExamConvertedMark=Isnull(Sum(MRS.SubjectConvertedMarks),0), @GrandExamConvertedMarkFraction=IsNull(SUM(MRS.SubjectConvertedMarksFraction),0),@TotalGP=IsNull(Sum(MRS.SubjectGP),0) 
from [dbo].[#Res_GrandResultSubjectDetails] MRS Inner Join [dbo].[Res_SubjectSetup]  SSE ON MRS.SubjectID=SSE.SubID
 Where MRS.StudentIID=@StudentIID AND MRS.GrandExamId=@GrandExamID and isNull(SSE.SubjectType,'')!='P' and  SSE.NoEffectOnExam=0  and SSE.IsDeleted=0


  /*For Exceptional half No Effect Exam*/
   IF(@DBname='whs_new_2018')
	BEGIN 
	select @GrandExamObtMark=IsNull(Sum(MRS.SubjectObtMarks),0),
	@GrandExamConvertedMark=Isnull(Sum(MRS.SubjectConvertedMarks),0), 
	@GrandExamConvertedMarkFraction=IsNull(SUM(MRS.SubjectConvertedMarksFraction),0)
	--,	@TotalGP=IsNull(Sum(MRS.SubjectGP),0) 
		from [dbo].[#Res_GrandResultSubjectDetails] MRS Inner Join [dbo].[Res_SubjectSetup]  SSE ON MRS.SubjectID=SSE.SubID
		 Where MRS.StudentIID=@StudentIID AND MRS.GrandExamId=@GrandExamID and isNull(SSE.SubjectType,'')!='P'  and SSE.IsDeleted=0
	END


  If(@DBname='bafsk_new_2018')
		BEGIN
		 If(@ClassID in (1,2,3,4,5,14,15,16,17))
			 BEGIN
				select @TotalGP=IsNull(Sum(MRS.SubjectGP),0) 
				 from [dbo].[#Res_GrandResultSubjectDetails] MRS Inner Join [dbo].[Res_SubjectSetup]  SSE ON MRS.SubjectID=SSE.SubID
				 Where MRS.StudentIID=@StudentIID AND MRS.GrandExamId=@GrandExamID and isNull(SSE.SubjectType,'')!='P' and SSE.IsDeleted=0
			 END

		 END

 /*End half No Effect On Exam*/



 /* 4th Subject Obtain*/
 DECLARE @4thSubObtMark Decimal(8,2)=0
 , @4thSubConvertedMark Decimal(8,2)=0
 , @4thSubConvertedMarkFraction Decimal(8,2)=0
 , @4thSubGP Decimal(8,2)=0

select top(1) @4thSubObtMark=IsNull(MRS.SubjectObtMarks,0),@4thSubConvertedMark=Isnull(MRS.SubjectConvertedMarks,0),@4thSubConvertedMarkFraction=IsNull(MRS.SubjectConvertedMarksFraction,0),@4thSubGP=IsNull(MRS.SubjectGP,0)
from [dbo].[#Res_GrandResultSubjectDetails] MRS Inner Join [dbo].[Res_StudentSubject]  SSE ON MRS.SubjectID=SSE.SubjectID AND  SSE.StudentID= MRS.StudentIID
Where  IsNull(SSE.SubjectType,'')!='P' and IsNull(SSE.SubjectType,'')='F' and SSE.IsDeleted=0 and MRS.StudentIID=@StudentIID
Set @TotalGPWithOut4Sub=@TotalGP-@4thSubGP
--Select top(1) @DeductMarks=IsNull(FSR.DeductMarks,0),@DeductGP=IsNull(FSR.DeductGP,0), @4tIsFailImpact=FSR.IsFailImpact From [dbo].[Res_FouthSubjectRules] FSR Where FSR.VersionID=@VersionId and FSR.SessionID=@SessionId and FSR.ClassID=@ClassId and FSR.GroupID=@GroupId and FSR.[IsDeleted]=0


if((Select DB_name())='eusc_new_2018')
BEGIN
declare @MainExamId1 int, @MainExamId2 int, @4thSubjectID int, @4thSubConvertedMark1 decimal(8,2),@4thSubConvertedMark2 decimal(8,2)
select top(1) @MainExamId1=MainExamId from Res_GrandSetup  where GrandExamId=@GrandExamID and IsDeleted=0
select top(1) @MainExamId2=MainExamId from Res_GrandSetup  where GrandExamId=@GrandExamID and MainExamId<>@MainExamId1 and IsDeleted=0


select top(1) @4thSubConvertedMark1=Isnull(MRS.SubjectConvertedMarks,0)
from [dbo].[Res_MainExamResultSubjectDetails] MRS Inner Join [dbo].[Res_StudentSubject]  SSE ON MRS.SubjectID=SSE.SubjectID AND  SSE.StudentID= MRS.StudentIID and MRS.MainExamId=@MainExamId1
Where  IsNull(SSE.SubjectType,'')!='P' and IsNull(SSE.SubjectType,'')='F' and SSE.IsDeleted=0 and MRS.StudentIID=@StudentIID

select top(1) @4thSubConvertedMark2=Isnull(MRS.SubjectConvertedMarks,0)
from [dbo].[Res_MainExamResultSubjectDetails] MRS Inner Join [dbo].[Res_StudentSubject]  SSE ON MRS.SubjectID=SSE.SubjectID AND  SSE.StudentID= MRS.StudentIID and MRS.MainExamId=@MainExamId2
Where  IsNull(SSE.SubjectType,'')!='P' and IsNull(SSE.SubjectType,'')='F' and SSE.IsDeleted=0 and MRS.StudentIID=@StudentIID

If(@ClassId in(9))
BEGIN
If(@4thSubConvertedMark1>=40)
Begin
set @DeductMarks=40
END

else
begin
set @DeductMarks=@4thSubConvertedMark1
end

If(@4thSubConvertedMark2>=40)
Begin
set @DeductMarks=@DeductMarks + 40
END

else
begin
set @DeductMarks=@DeductMarks + @4thSubConvertedMark2
end
END

END






IF(@4thSubConvertedMark>=@DeductMarks)
set @GrandExamConvertedMark=@GrandExamConvertedMark-@DeductMarks
else
set @GrandExamConvertedMark=@GrandExamConvertedMark-@4thSubConvertedMark

IF(@4thSubObtMark>=@DeductMarks)
set @GrandExamObtMark=@GrandExamObtMark-@DeductMarks
else
set @GrandExamObtMark=@GrandExamObtMark-@4thSubObtMark

IF(@4thSubConvertedMarkFraction>=@DeductMarks)
set @GrandExamConvertedMarkFraction=@GrandExamConvertedMarkFraction-@DeductMarks
else
set @GrandExamConvertedMarkFraction=@GrandExamConvertedMarkFraction-@4thSubConvertedMarkFraction

IF(@4thSubGP>=@DeductGP)
set @TotalGP=@TotalGP-@DeductGP
else
set @TotalGP=@TotalGP-@4thSubGP
 /*End 4th Subject Obtain*/

 if((Select DB_name()) in ('bzs_new_2018'))
 Begin
 Select @GrandExamConvertedMarkFraction=Sum(MR.TotalConvertedMarks)/2 From Res_MainExamResult MR 
	Inner Join  Res_MainExam ME on ME.MainExamId=MR.MainExamId  where  ME.SessionId=@SessionId and MR.StudentIID=@StudentIID

	Select @GrandExamConvertedMark=dbo.ConvertMarks(Sum(MR.TotalConvertedMarks)/2,'R') From Res_MainExamResult MR 
	Inner Join  Res_MainExam ME on ME.MainExamId=MR.MainExamId  where  ME.SessionId=@SessionId and MR.StudentIID=@StudentIID
 End

  if((Select DB_name()) in ('jusc_new_2018'))
 Begin

 declare @MainExamId11 int, @MainExamId22 int, @Mark1 decimal(8,2),@Mark2 decimal(8,2)
select top(1) @MainExamId11=MainExamId from Res_GrandSetup  where GrandExamId=@GrandExamID and IsDeleted=0 and IsPassDependet=0
select top(1) @MainExamId22=MainExamId from Res_GrandSetup  where GrandExamId=@GrandExamID and MainExamId<>@MainExamId11 and IsDeleted=0 and IsPassDependet=1

	Select top(1) @Mark1=MR.TotalConvertedMarks*0.3 From Res_MainExamResult MR 
	Inner Join  Res_MainExam ME on ME.MainExamId=MR.MainExamId  where  ME.SessionId=@SessionId and MR.StudentIID=@StudentIID and MR.MainExamId=@MainExamId11

	Select top(1) @Mark2=MR.TotalConvertedMarks*0.7 From Res_MainExamResult MR 
	Inner Join  Res_MainExam ME on ME.MainExamId=MR.MainExamId  where  ME.SessionId=@SessionId and MR.StudentIID=@StudentIID and MR.MainExamId=@MainExamId22

	set @GrandExamConvertedMark=dbo.ConvertMarks(@Mark1 + @Mark2,'O')
	set @GrandExamConvertedMarkFraction=@Mark1 + @Mark2
 End


set @GPA=@TotalGP/@StudentTotalSubject
Set @FailStudentGPA=@TotalGP/@StudentTotalSubject
Set @GPAWithOut4Sub=@TotalGPWithOut4Sub/@StudentTotalSubject


 --if((Select DB_name()) in ('bksppsc_new_2018'))
 --Begin
 --If(@ClassId in (8,9,11))
 --  Begin
	--	 Select @GPA=Sum(MR.GPA)/2 From Res_MainExamResult MR 
	--		Inner Join  Res_MainExam ME on ME.MainExamId=MR.MainExamId  where  ME.SessionId=@SessionId and MR.StudentIID=@StudentIID and ME.MainExamIsGrand=1

	--		Select @FailStudentGPA=Sum(MR.FailStudentGPA)/2 From Res_MainExamResult MR 
	--		Inner Join  Res_MainExam ME on ME.MainExamId=MR.MainExamId  where  ME.SessionId=@SessionId and MR.StudentIID=@StudentIID and ME.MainExamIsGrand=1

	--		Select @GPAWithOut4Sub=Sum(MR.GPAWithOut4Sub)/2 From Res_MainExamResult MR 
	--		Inner Join  Res_MainExam ME on ME.MainExamId=MR.MainExamId  where  ME.SessionId=@SessionId and MR.StudentIID=@StudentIID and ME.MainExamIsGrand=1
	--END
 --End


/*Fail Calculation*/
If Exists(Select TOP 1 MRS.SubjectID  from [dbo].[#Res_GrandResultSubjectDetails] MRS Inner Join [dbo].[Res_StudentSubject]  SSE ON MRS.SubjectID=SSE.SubjectID AND  SSE.StudentID=MRS.StudentIID 
Inner Join [dbo].[Res_SubjectSetup]  SE ON SE.SubID=MRS.SubjectID Where MRS.StudentIID=@StudentIID AND MRS.GrandExamId=@GrandExamID And MRS.SubjectIsPass=0 and SE.SubjectType!='P' and SSE.SubjectType !='F' and  SE.NoEffectOnExam=0  and SSE.IsDeleted=0 )
Begin
set @GPA=0
Set @GPAWithOut4Sub=0
set @GrandExamIsPass=0
Print '@@genaral>>>>>>>>>>>>>>>>>>>>>>>>>>>:' print @GrandExamIsPass
End


/*For Exceptional half No Effect Exam*/
  IF(@DBname='bafsk_new_2018')
	  BEGIN
		 If(@ClassID in (1,2,3,4,5,14,15,16,17))
			 BEGIN
				If Exists(Select TOP 1 MRS.SubjectID  from [dbo].[#Res_GrandResultSubjectDetails] MRS Inner Join [dbo].[Res_StudentSubject]  SSE ON MRS.SubjectID=SSE.SubjectID AND  SSE.StudentID=MRS.StudentIID 
				Inner Join [dbo].[Res_SubjectSetup]  SE ON SE.SubID=MRS.SubjectID Where MRS.StudentIID=@StudentIID AND MRS.GrandExamId=@GrandExamID And MRS.SubjectIsPass=0 and SE.SubjectType!='P' and SSE.SubjectType !='F'  and SSE.IsDeleted=0 )
				Begin
					set @GPA=0
					Set @GPAWithOut4Sub=0
					set @GrandExamIsPass=0
				End
			 END

	 END

	 IF(@DBname='whs_new_2018')
	  BEGIN
		
				If Exists(Select TOP 1 MRS.SubjectID  from [dbo].[#Res_GrandResultSubjectDetails] MRS Inner Join [dbo].[Res_StudentSubject]  SSE ON MRS.SubjectID=SSE.SubjectID AND  SSE.StudentID=MRS.StudentIID 
				Inner Join [dbo].[Res_SubjectSetup]  SE ON SE.SubID=MRS.SubjectID Where MRS.StudentIID=@StudentIID AND MRS.GrandExamId=@GrandExamID And MRS.SubjectIsPass=0 and SE.SubjectType!='P' and SSE.SubjectType !='F'  and SSE.IsDeleted=0 )
				Begin
					set @GPA=0
					Set @GPAWithOut4Sub=0
					set @GrandExamIsPass=0
				End
			
	 END

 /*End half No Effect On Exam*/

-- 4thSubject fail Calculation Rule
if(@4tIsFailImpact=1)
Begin
Print '@@4tIsFailImpact>>>>>>>>>>>>>>>>>>>>>>>>>>>:'
If Exists(Select TOP 1 MRS.SubjectID from [dbo].[#Res_GrandResultSubjectDetails] MRS Inner Join [dbo].[Res_StudentSubject]  SSE ON MRS.SubjectID=SSE.SubjectID AND  SSE.StudentID=MRS.StudentIID Where MRS.StudentIID=@StudentIID AND MRS.GrandExamID=@GrandExamID And MRS.SubjectIsPass=0 and SSE.SubjectType ='F'  and SSE.IsDeleted=0 )
Begin
set @GPA=0
Set @GPAWithOut4Sub=0
set @GrandExamIsPass=0
End
End


/*When GPA Sum >5*/
IF(@GPA>5)
BEGIN
set @GPA=5
END

/*MainExam PassDepent*/
If EXISTS (Select [MainExamId] From  [dbo].[Res_GrandSetup] where [GrandExamId]=@GrandExamID and [IsPassDependet]=1)
BEGIN
Print '@@MainExam PassDepent>>>>>>>>>>>>>>>>>>>>>>>>>>>:'
	DECLARE @MaiExamPasDepentCount Int=0, @RowNumber int=1, @MainExamIsPass bit =1
	Create Table #MainExamPassDepent
	(
	id int IDENTITY(1,1) not null,
	MainExamId int not null
	)
	Insert Into #MainExamPassDepent
	Select[MainExamId] From  [dbo].[Res_GrandSetup] where [GrandExamId]=@GrandExamID and [IsPassDependet]=1
	SELECT @MaiExamPasDepentCount = COUNT(*) FROM #MainExamPassDepent
	while(@MaiExamPasDepentCount>=@RowNumber)
		BEGIN
			Select @MainExamId=MainExamId FROM #MainExamPassDepent Where id=@RowNumber
			select @MainExamIsPass=IsPass From [dbo].[Res_MainExamResult] Where [MainExamId]=@MainExamId and [StudentIID]=@StudentIID
			IF(@MainExamIsPass=0)
			BEGIN
				set @GPA=0
				Set @GPAWithOut4Sub=0
				set @GrandExamIsPass=0
			END
			Print '@MainExamIsPass' print @MainExamIsPass
			Print '@@StudentIID' print @StudentIID
			Print '@@GPA' print @GPA
			Print '@@GrandExamIsPass' print @GrandExamIsPass
			set @RowNumber=@RowNumber+1
	   END
	DROP Table #MainExamPassDepent
END


/*End Fail Calculation*/
 DECLARE @LGP decimal(8,2)=0
 SELECT top 1 @LGP=GP FROM [dbo].[Res_GradingSystem] GS Where GS.VersionID=@VersionID and GS.SessionID=@SessionID and GS.ClassID=@ClassID AND GP<=@GPA order by  GP desc
 SELECT @GradeLetter=GS.GL from [dbo].[Res_GradingSystem] GS Where  GS.VersionID=@VersionID and GS.SessionID=@SessionID and GS.ClassID=@ClassID and GS.GP=@LGP and GS.IsDeleted=0



 /*	For Merit Subject Marks*/

	DECLARE @SubjectMarks1 decimal(8,2)=0
	, @SubjectMarks2 decimal(8,2)=0
	, @SubjectMarks3 decimal(8,2)=0, @TotalIsFraction bit =0

	
	select @TotalIsFraction=TotalIsFraction From Res_GrandMeritListConfig where VersionId=@VersionId and SessionId=@SessionId and ClassId=@ClassId and GroupId=@GroupId  

	If (@TotalIsFraction=0)
	BEGIN
	Select @SubjectMarks1=Isnull(SubjectConvertedMarks,0) from #Res_GrandResultSubjectDetails Where [GrandExamId]=@GrandExamID and [StudentIID]=@StudentIID and  [SubjectID]=@SubjectId1
	Select @SubjectMarks2=Isnull(SubjectConvertedMarks,0) from #Res_GrandResultSubjectDetails  Where [GrandExamId]=@GrandExamID and [StudentIID]=@StudentIID and  [SubjectID]=@SubjectId2
	Select @SubjectMarks3=Isnull(SubjectConvertedMarks,0) from #Res_GrandResultSubjectDetails  Where [GrandExamId]=@GrandExamID and [StudentIID]=@StudentIID and  [SubjectID]=@SubjectId3
	END
	Else
	BEGIN
	Select @SubjectMarks1=Isnull(SubjectConvertedMarksFraction,0) from #Res_GrandResultSubjectDetails Where [GrandExamId]=@GrandExamID and [StudentIID]=@StudentIID and  [SubjectID]=@SubjectId1
	Select @SubjectMarks2=Isnull(SubjectConvertedMarksFraction,0) from #Res_GrandResultSubjectDetails  Where [GrandExamId]=@GrandExamID and [StudentIID]=@StudentIID and  [SubjectID]=@SubjectId2
	Select @SubjectMarks3=Isnull(SubjectConvertedMarksFraction,0) from #Res_GrandResultSubjectDetails  Where [GrandExamId]=@GrandExamID and [StudentIID]=@StudentIID and  [SubjectID]=@SubjectId3
	END
	
	DECLARE @Atten INT =0

	IF(@DBname='sos_new_2018')
	  BEGIN
		Select @Atten =  COUNT(StudentId)  FROM [dbo].[Att_StudentAttendance] 
		WHERE StudentId = @StudentIID AND ( CAST([InTime] AS DATE) BETWEEN CAST('2018-06-25' AS DATE) AND CAST('2018-11-26' AS DATE))
		GROUP BY StudentId
	  END

 /*	END Merit Subject Marks*/


Insert Into [dbo].[Res_GrandResult]( [GrandExamId],[GrandSubExamId]
		     ,[StudentIID],[TotalMarks],[GPA],[GPAWithOut4Sub],[TotalConvertedMarks],[TotalConvertedMarksFraction]
			,[FailStudentGPA],[TotalGP],[TotalGPWithOut4Sub],[GradeLetter],[IsPass],[OverAllMerit],[SectionWiseMerit],[ShiftWiseMerit],[ClassWiseMerit],[TeacherComments],[Conduct],[Handwriting],[MyProperty]
			,MeritSubjectId1,MeritSubjectMarks1,MeritSubjectId2,MeritSubjectMarks2,MeritSubjectId3,MeritSubjectMarks3)
	values(	@GrandExamID ,0,
	@StudentIID ,@GrandExamObtMark,@GPA,@GPAWithOut4Sub,@GrandExamConvertedMark,@GrandExamConvertedMarkFraction,
	@FailStudentGPA,@TotalGP,@TotalGPWithOut4Sub,@GradeLetter,@GrandExamIsPass,0,0,0,0,'NA','NA','NA',@Atten
	,@SubjectId1,@SubjectMarks1 ,@SubjectId2,@SubjectMarks2 ,@SubjectId3,@SubjectMarks3)


	DROP TABLE #Res_GrandResultSubjectDetails
/*end Subjectmarks Update*/

END

