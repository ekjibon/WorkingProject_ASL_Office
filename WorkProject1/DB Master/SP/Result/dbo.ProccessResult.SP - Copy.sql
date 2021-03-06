/****** Object:  StoredProcedure [dbo].[ProccessMarks]    Script Date: 7/22/2017 4:26:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ProccessResult]'))
BEGIN
DROP PROCEDURE  ProccessResult
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 --execute ProccessResult 1,2,1,7,0,136,15,0.00,0.00,0,0,0,143,144,145,gvhs_new_2018
Create PROCEDURE [dbo].[ProccessResult]  
   (@VersionId int,
	@SessionId int,
	@ShiftId int,
	@ClassId int,
    @GroupId int,
	@StudentIID int,
	@MainExamID int,
	@StudentTotalSubject int,
	@DeductMarks Decimal(8,2),
	@DeductGP Decimal(8,2),
	@4tIsFailImpact bit,
	@4tAttPassFail bit,
	@PairIsFailImpact bit,
	@SubjectId1 int ,
	@SubjectId2 int,
	@SubjectId3 int,
	@DBname VARCHAR(100)
	)
AS
BEGIN

--print '@@StudentTotalSubject>Divaert:' + CAST(  @StudentTotalSubject  AS VARCHAR)
--print '@@PairIsFailImpact:' print @PairIsFailImpact
--print '@@@DeductMarks:' print @DeductMarks

DECLARE @MainExamObtMark decimal(8,2)=0
, @MainExamConvertedMark decimal(8,2)=0
, @MainExamConvertedMarkFraction decimal(8,2)=0
, @MainExamIsPass bit=1
, @MainExamIsAbs bit=0
, @GPA decimal(4,2)=0
, @GPAWithOut4Sub decimal(4,2)=0
, @FailStudentGPA decimal(4,2)=0
, @TotalGP decimal(4,2)=0
, @TotalGPWithOut4Sub decimal(4,2)=0
, @GradeLetter Varchar(10)='F'
,@PTotalSubjectID int

PRINT 'fff'

IF(@DBname='zcpsc_new_2018' or @DBname='jusc_new_2018' or @DBname='jlhs_new_2018')
SET @PairIsFailImpact=1


-- PairSubject fail Calculation Rule
if(@PairIsFailImpact=1)
Begin
	DECLARE @SubjectID int, @rownumberPair int=1, @MaxCount int
	If Exists(Select TOP 1 MRS.SubjectID from [dbo].[Res_MainExamResultSubjectDetails] MRS Inner Join [dbo].[Res_SubjectSetup]  SE ON MRS.SubjectID=SE.SubID Where MRS.StudentIID=@StudentIID and se.SessionId=@SessionId AND MRS.MainExamId=@MainExamID And MRS.SubjectIsPass=0 and SE.SubjectType ='P'  and SE.IsDeleted=0 and SE.SessionId=@SessionId )
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
	Select SubjectID from [dbo].[Res_MainExamResultSubjectDetails] MRS Inner Join [dbo].[Res_SubjectSetup]  SE ON MRS.SubjectID=SE.SubID Where MRS.StudentIID=@StudentIID AND MRS.MainExamId=@MainExamID And MRS.SubjectIsPass=0 and SE.SubjectType ='P'  and SE.IsDeleted=0
	
	SELECT @MaxCount= COUNT(*) FROM #PairFailSubject
	--return error(pair subject not found) if @MaxCount is zero or null//check

	WHILE(@MaxCount>=@rownumberPair)
	BEGIN
		SELECT @SubjectID=SubjectId FROM  #PairFailSubject where Id=@rownumberPair
		Select TOP(1) @PTotalSubjectID=SS.SubID from [dbo].[Res_SubjectSetup] SS where SS.IsPair=1 and (SS.FirstPairSubID=@SubjectID OR SS.SecondPairSubID=@SubjectID) and SS.[SubjectType] = 'T' and SS.[IsDeleted]=0 and  ss.SessionId=@SessionId
		Update Res_MainExamResultSubjectDetails SET SubjectGP=0, SubjectGL='F',SubjectIsPass=0 where [SubjectID]=@PTotalSubjectID and [StudentIID]=@StudentIID and [MainExamId]=@MainExamID
		set @rownumberPair=@rownumberPair+1
	END
		DROP Table #PairFailSubject
	End
	
End


CREATE TABLE #Res_MainExamResultSubjectDetails(
	ResultSubjectDetailsId int IDENTITY(1,1) NOT NULL,
	SubjectID int NOT NULL,
	MainExamId int NOT NULL,
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

	Insert Into #Res_MainExamResultSubjectDetails
	SELECT S.SubjectID,
	S.MainExamId,
	S.SubjectObtMarks,
	S.SubjectConvertedMarks,
	S.SubjectConvertedMarksFraction,
	S.SubjectGP,
	S.SubjectGL,
	S.SubjectHighestMark,
	S.SubjectIsPass,
	S.SubjectIsAbsent,
	S.StudentIID FROM Res_MainExamResultSubjectDetails S 
	Where S.MainExamId=@MainExamID AND S.StudentIID=@StudentIID

	--DECLARE @MAXIDResult int=0
	--SELECT @MAXIDResult = COUNT(*) FROM #Res_MainExamResultSubjectDetails
	--Print @MAXIDResult


--/*mainExaMmarks Update*/

select @MainExamObtMark=IsNull(Sum(MRS.SubjectObtMarks),0),@MainExamConvertedMark=Isnull(Sum(MRS.SubjectConvertedMarks),0), 
	@MainExamConvertedMarkFraction=IsNull(SUM(MRS.SubjectConvertedMarksFraction),0),@TotalGP=IsNull(Sum(MRS.SubjectGP),0) 
from [#Res_MainExamResultSubjectDetails] MRS Inner Join [dbo].[Res_SubjectSetup]  SSE ON MRS.SubjectID=SSE.SubID
 Where MRS.StudentIID=@StudentIID AND MRS.MainExamId=@MainExamID and isNull(SSE.SubjectType,'')!='P' and  SSE.NoEffectOnExam=0  and SSE.IsDeleted=0 and SSE.SessionId=@SessionId--saul

  IF(@DBname='whs_new_2018')
	BEGIN 
	select @MainExamObtMark=IsNull(Sum(MRS.SubjectObtMarks),0),@MainExamConvertedMark=Isnull(Sum(MRS.SubjectConvertedMarks),0), 
	@MainExamConvertedMarkFraction=IsNull(SUM(MRS.SubjectConvertedMarksFraction),0)
	from [#Res_MainExamResultSubjectDetails] MRS Inner Join [dbo].[Res_SubjectSetup]  SSE ON MRS.SubjectID=SSE.SubID
	Where MRS.StudentIID=@StudentIID AND MRS.MainExamId=@MainExamID and isNull(SSE.SubjectType,'')!='P' and     SSE.IsDeleted=0 and SSE.SessionId=@SessionId--saul
	END

  /*For Exceptional half No Effect Exam*/
  IF(@DBname='bafsk_new_2018')
	  BEGIN
	  If(@ClassID in (1,2,3,4,5,14,15,16,17))
		 BEGIN
			select @TotalGP=IsNull(Sum(MRS.SubjectGP),0) 
			 from [#Res_MainExamResultSubjectDetails] MRS Inner Join [dbo].[Res_SubjectSetup]  SSE ON MRS.SubjectID=SSE.SubID
			 Where MRS.StudentIID=@StudentIID AND MRS.MainExamId=@MainExamID and isNull(SSE.SubjectType,'')!='P' and SSE.IsDeleted=0 and SSE.SessionId=@SessionId--saul
		 END

	 END

 /*End half No Effect On Exam*/


 --print '@MainExamConvertedMark:' print @MainExamConvertedMark
 -- print '@@TotalGP:' print @TotalGP

 /* 4th Subject Obtain*/
 DECLARE @4thSubObtMark Decimal(8,2)=0
 , @4thSubConvertedMark Decimal(8,2)=0
 , @4thSubConvertedMarkFraction Decimal(8,2)=0
 , @4thSubGP Decimal(8,2)=0

select top(1) @4thSubObtMark=IsNull(MRS.SubjectObtMarks,0),@4thSubConvertedMark=Isnull(MRS.SubjectConvertedMarks,0),@4thSubConvertedMarkFraction=IsNull(MRS.SubjectConvertedMarksFraction,0),@4thSubGP=IsNull(MRS.SubjectGP,0)
from  [#Res_MainExamResultSubjectDetails] MRS Inner Join [dbo].[Res_StudentSubject]  SSE ON MRS.SubjectID=SSE.SubjectID AND  SSE.StudentID= MRS.StudentIID and sse.SessionId=@SessionId
Where  IsNull(SSE.SubjectType,'')!='P' and IsNull(SSE.SubjectType,'')='F' and SSE.IsDeleted=0 and MRS.StudentIID=@StudentIID 
Set @TotalGPWithOut4Sub=@TotalGP-@4thSubGP
 print  '4thSubGP : ' + CAST( @4thSubGP AS VARCHAR)
 print 'MainExamConvertedMark: ' + CAST(@MainExamConvertedMark AS VARCHAR)
	IF(@4thSubConvertedMark>=@DeductMarks)
	set @MainExamConvertedMark=@MainExamConvertedMark-@DeductMarks
	else
	set @MainExamConvertedMark=@MainExamConvertedMark-@4thSubConvertedMark

	IF(@4thSubObtMark>=@DeductMarks)
	set @MainExamObtMark=@MainExamObtMark-@DeductMarks
	else
	set @MainExamObtMark=@MainExamObtMark-@4thSubObtMark

	IF(@4thSubConvertedMarkFraction>=@DeductMarks)
	set @MainExamConvertedMarkFraction=@MainExamConvertedMarkFraction-@DeductMarks
	else
	set @MainExamConvertedMarkFraction=@MainExamConvertedMarkFraction-@4thSubConvertedMarkFraction

	IF(@4thSubGP>=@DeductGP)
	set @TotalGP=@TotalGP-@DeductGP
	else
	set @TotalGP=@TotalGP-@4thSubGP

print 'DeductMarks : ' + CAST(@DeductMarks  AS VARCHAR)
print 'DeductGP : ' + CAST( @DeductGP AS VARCHAR)

 /*End 4th Subject Obtain*/

--Select @StudentTotalSubject=Count(SS.ID) from [dbo].[Res_StudentSubject] SS inner join [dbo].[Res_SubjectSetup] SSE ON SS.SubjectID=SSE.SubID
--where SS.StudentID=@StudentIID and IsNull(SSE.SubjectType,'')!='P' and isNull(SS.SubjectType,'')!='F'  and  SSE.NoEffectOnExam=0  and SSE.IsDeleted=0 and SS.IsDeleted=0

set @GPA=@TotalGP/@StudentTotalSubject
Set @FailStudentGPA=@TotalGP/@StudentTotalSubject
Set @GPAWithOut4Sub=@TotalGPWithOut4Sub/@StudentTotalSubject

/*Fail Calculation*/
If Exists(Select TOP 1 MRS.SubjectID  from [#Res_MainExamResultSubjectDetails] MRS 
Inner Join [dbo].[Res_StudentSubject]  SSE ON MRS.SubjectID=SSE.SubjectID AND  SSE.StudentID=MRS.StudentIID 
Inner Join [dbo].[Res_SubjectSetup]  SE ON SE.SubID=MRS.SubjectID 
Where MRS.StudentIID=@StudentIID AND MRS.MainExamId=@MainExamID  and sse.SessionId=@SessionId
And MRS.SubjectIsPass=0 and SE.SubjectType!='P' and SSE.SubjectType !='F' and  SE.NoEffectOnExam=0  and SSE.IsDeleted=0 and SSE.SessionId=@SessionId ) --saul
Begin
	set @GPA=0
	Set @GPAWithOut4Sub=0
	set @MainExamIsPass=0
End

 /*For Exceptional half No Effect Exam*/
  IF(@DBname='bafsk_new_2018')
	  BEGIN
		 If(@ClassID in (1,2,3,4,5,14,15,16,17))
			 BEGIN
				If Exists(Select TOP 1 MRS.SubjectID  from [#Res_MainExamResultSubjectDetails] MRS Inner Join [dbo].[Res_StudentSubject]  SSE ON MRS.SubjectID=SSE.SubjectID AND  SSE.StudentID=MRS.StudentIID 
				Inner Join [dbo].[Res_SubjectSetup]  SE ON SE.SubID=MRS.SubjectID Where MRS.StudentIID=@StudentIID AND MRS.MainExamId=@MainExamID And MRS.SubjectIsPass=0 and SE.SubjectType!='P' and SSE.SubjectType !='F'  and SSE.IsDeleted=0 and SSE.SessionId=@SessionId )
				Begin
					set @GPA=0
					Set @GPAWithOut4Sub=0
					set @MainExamIsPass=0
				End
			 END

	 END

 /*End half No Effect On Exam*/

-- 4thSubject fail Calculation Rule
if(@4tIsFailImpact=1)
Begin
If Exists(Select TOP 1 MRS.SubjectID from [#Res_MainExamResultSubjectDetails] MRS 
Inner Join [dbo].[Res_StudentSubject]  SSE ON MRS.SubjectID=SSE.SubjectID AND  SSE.StudentID=MRS.StudentIID
 Where MRS.StudentIID=@StudentIID AND MRS.MainExamId=@MainExamID And MRS.SubjectIsPass=0 and SSE.SubjectType ='F'  and SSE.IsDeleted=0 and sse.SessionId=@SessionId)
Begin
set @GPA=0
Set @GPAWithOut4Sub=0
set @MainExamIsPass=0
End
End

IF(@4tAttPassFail=1)
BEGIN
	If Exists(Select TOP 1 MRS.SubjectID from [#Res_MainExamResultSubjectDetails] MRS 
		Inner Join [dbo].[Res_StudentSubject]  SSE ON MRS.SubjectID=SSE.SubjectID AND  SSE.StudentID=MRS.StudentIID
		 Where MRS.StudentIID=@StudentIID AND MRS.MainExamId=@MainExamID And MRS.SubjectIsPass=0 AND MRS.SubjectIsAbsent=1 
		 AND MRS.SubjectIsPass = 0 and SSE.SubjectType ='F'   and SSE.IsDeleted=0 and SSE.SessionId=@SessionId )

	BEGIN 
		SET	@GPA=0
		SET @GPAWithOut4Sub=0
		SET @MainExamIsPass=0
	END
END

/*When GPA Sum >5*/
IF(@GPA>5)
BEGIN
set @GPA=5
END

/*End Fail Calculation*/
 DECLARE @LGP decimal(8,2)=0
 SELECT top 1 @LGP=GP FROM [dbo].[Res_GradingSystem] GS Where GS.VersionID=@VersionID and GS.SessionID=@SessionID and GS.ClassID=@ClassID AND GP<=@GPA order by  GP desc
 SELECT @GradeLetter=GS.GL from [dbo].[Res_GradingSystem] GS Where  GS.VersionID=@VersionID and GS.SessionID=@SessionID and GS.ClassID=@ClassID and GS.GP=@LGP and GS.IsDeleted=0



 /*	For Merit Subject Marks*/

	DECLARE @SubjectMarks1 decimal(8,2)=0
	, @SubjectMarks2 decimal(8,2)=0
	, @SubjectMarks3 decimal(8,2)=0
	,@4thSubjectMarks decimal(8,2)=0

	
	Select @SubjectMarks1=Isnull(SubjectConvertedMarks,0) from #Res_MainExamResultSubjectDetails Where [MainExamId]=@MainExamID and [StudentIID]=@StudentIID and  [SubjectID]=@SubjectId1
	Select @SubjectMarks2=Isnull(SubjectConvertedMarks,0) from #Res_MainExamResultSubjectDetails  Where [MainExamId]=@MainExamID and [StudentIID]=@StudentIID and  [SubjectID]=@SubjectId2
	Select @SubjectMarks3=Isnull(SubjectConvertedMarks,0) from #Res_MainExamResultSubjectDetails  Where [MainExamId]=@MainExamID and [StudentIID]=@StudentIID and  [SubjectID]=@SubjectId3
	Select @4thSubjectMarks=Isnull(SubjectConvertedMarks,0) from #Res_MainExamResultSubjectDetails  
			Where [MainExamId]=@MainExamID and [StudentIID]=@StudentIID and  [SubjectID]= (SELECT TOP 1 SubjectID FROM Res_StudentSubject SS WHERE SS.StudentID= @StudentIID AND SS.SubjectType='F' and ss.SessionId=@SessionId)
	

	IF(@DBname='sos_new_2018')
	  BEGIN
		Select @4thSubjectMarks =  COUNT(StudentId)  FROM [dbo].[Att_StudentAttendance] 
		WHERE StudentId = @StudentIID AND ( CAST([InTime] AS DATE) BETWEEN CAST('2018-06-25' AS DATE) AND CAST('2018-11-26' AS DATE))
		GROUP BY StudentId
	  END

 /*	END Merit Subject Marks*/


Insert Into [dbo].[Res_MainExamResult]( [MainExamId],[SubExamId]
		     ,[StudentIID],[TotalMarks],[GPA],[GPAWithOut4Sub],[TotalConvertedMarks],[TotalConvertedMarksFraction]
			,[FailStudentGPA],[TotalGP],[TotalGPWithOut4Sub],[GradeLetter],[IsPass],[OverAllMerit],[SectionWiseMerit],[ShiftWiseMerit],[ClassWiseMerit],[TeacherComments],[Conduct],[Handwriting],[MyProperty]
			,MeritSubjectId1,MeritSubjectMarks1,MeritSubjectId2,MeritSubjectMarks2,MeritSubjectId3,MeritSubjectMarks3)
	values(	@MainExamID ,0,
	@StudentIID ,@MainExamObtMark,@GPA,@GPAWithOut4Sub,@MainExamConvertedMark,@MainExamConvertedMarkFraction,
	@FailStudentGPA,@TotalGP,@TotalGPWithOut4Sub,@GradeLetter,@MainExamIsPass,0,0,0,0,'NA','NA','NA',@4thSubjectMarks
	,@SubjectId1,@SubjectMarks1 ,@SubjectId2,@SubjectMarks2 ,@SubjectId3,@SubjectMarks3)


	DROP TABLE #Res_MainExamResultSubjectDetails
/*end Subjectmarks Update*/

END

