/****** Object:  StoredProcedure [dbo].[ProccessMainExam]    Script Date: 7/22/2017 4:28:51 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ProccessSubjectAndResult]'))
BEGIN
DROP PROCEDURE  ProccessSubjectAndResult
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO --- [ProccessSubjectAndResult] 1,2,1,7,0,35 
create PROCEDURE [dbo].[ProccessSubjectAndResult] 
	@VersionId int ,
	@SessionId int ,
	@ShiftId	INT ,
	@ClassId int ,
	@GroupId int ,
	@MainExamId int
AS
BEGIN
 DECLARE  @StudentIID INT, @MarkSetupId int, @SubjectID int, @ResultId BIGINT,@COUNTResult INT=1, @MAXIDResult INT , @ResultSLID int=1

 DECLARE @DBname VARCHAR(100)
 set @DBname=(select DB_Name())

 CREATE TABLE #TempResult(
    [Result] [int] IDENTITY(1,1) NOT NULL,
	[StudentIID] [bigint] NOT NULL,
	[MainExamID] [int] NOT NULL
)
 INSERT INTO #TempResult
   SELECT M.[StudentIID],[MainExamID] From  Res_MainExamResultSubjectDetails M INNER JOIN [dbo].[Student_BasicInfo] S ON S.[StudentIID] = M.[StudentIID]
       where [MainExamID]=@MainExamId AND S.ShiftId = @ShiftId 
	   GROUP BY M.[StudentIID],[MainExamID] ORDER BY StudentIID
SELECT @MAXIDResult = COUNT(*) FROM #TempResult
--return error if @MAXIDResult is zero or null//check
set @ResultSLID=@MAXIDResult/2
--return error if @ResultSLID is zero or null//check
/*Commun Field*/
 DECLARE @aStudentIID int=1
,@StudentTotalSubject int=1
,@DeductMarks Decimal(8,2)=0
,@DeductGP Decimal(8,2)=0
,@4tIsFailImpact bit=0
,@4tAttPassFail bit=0
,@PairIsFailImpact bit=0
,@SubjectId1 int=0
,@SubjectId2 int=0
,@SubjectId3 int=0

if (@DBname='zcpsc_new_db')
BEGIN
	set @PairIsFailImpact=1
END

 SELECT TOP 1 @aStudentIID=StudentIID FROM #TempResult  where Result=@ResultSLID ---order by StudentIID DESC
 Print '@StudentIID'  Print @aStudentIID

Select @StudentTotalSubject=Count(SS.ID) from [dbo].[Res_StudentSubject] SS inner join [dbo].[Res_SubjectSetup] SSE ON SS.SubjectID=SSE.SubID
where SS.StudentID=@aStudentIID and IsNull(SSE.SubjectType,'')!='P' and isNull(SS.SubjectType,'')!='F'  and  SSE.NoEffectOnExam=0  and SSE.IsDeleted=0 and SS.IsDeleted=0 AND SSE.GroupId=@GroupId and SSE.SessionId=@SessionId

print '@StudentTotalSubject' print @StudentTotalSubject
IF(@DBname='bafsk_new_db')
	BEGIN
	If(@ClassID in (1,2,3,4,5,14,15,16,17))
		 BEGIN
			 Select @StudentTotalSubject=Count(SS.ID) from [dbo].[Res_StudentSubject] SS inner join [dbo].[Res_SubjectSetup] SSE ON SS.SubjectID=SSE.SubID
			 where SS.StudentID=@aStudentIID and IsNull(SSE.SubjectType,'')!='P' and isNull(SS.SubjectType,'')!='F'  and SSE.IsDeleted=0 and SS.IsDeleted=0 and SSE.SessionId=@SessionId
		 END
	 END

Select top(1) @DeductMarks=IsNull(FSR.DeductMarks,0),@DeductGP=IsNull(FSR.DeductGP,0), @4tIsFailImpact=FSR.IsFailImpact , @4tAttPassFail = FSR.AttendancePassFailimpact From [dbo].[Res_FouthSubjectRules] FSR 
Where FSR.VersionID=@VersionId and FSR.SessionID=@SessionId and FSR.ClassID=@ClassId and FSR.GroupID=@GroupId and FSR.[IsDeleted]=0

Select  @SubjectId1=Isnull(MC.SubjectId1,0),@SubjectId2=Isnull(MC.SubjectId2,0) ,@SubjectId3=Isnull(MC.SubjectId3,0)  From [dbo].[Res_MeritListConfig] MC  Where  MC.VersionID=@VersionID and MC.SessionID=@SessionID and MC.ClassID=@ClassID and MC.GroupId=@GroupId  and MC.IsDeleted=0
--select *  From [dbo].[Res_FouthSubjectRules]
/*End Common Field*/


 WHILE (@COUNTResult <= @MAXIDResult)
	BEGIN
	SELECT  @StudentIID =StudentIID
		 FROM #TempResult WHERE Result = @COUNTResult
		 print 'Calingggg------' 
		 PRINT 'ProccessResult ' + CAST( @VersionId AS VARCHAR)+','+  CAST( @SessionId AS VARCHAR)+','+ CAST( @ShiftId AS VARCHAR)+ ','+ CAST( @ClassId AS VARCHAR)+','+  CAST( @GroupId AS VARCHAR)+','+ CAST( @StudentIID AS VARCHAR)+  CAST( @MainExamId AS VARCHAR)+','+ CAST(  @StudentTotalSubject AS VARCHAR) +','+ CAST(  @DeductMarks AS VARCHAR)+','+ CAST( @DeductGP AS VARCHAR)+','+ CAST(  @4tIsFailImpact AS VARCHAR)+','+ CAST( @4tAttPassFail AS VARCHAR)+','+ CAST(  @PairIsFailImpact AS VARCHAR)+','+ CAST(  @SubjectId1 AS VARCHAR)+','+ CAST(  @SubjectId2 AS VARCHAR)+','+ CAST( @SubjectId3 AS VARCHAR)+','+ CAST(  @DBname AS VARCHAR)
		  Exec  ProccessResult @VersionId,@SessionId,@ShiftId,@ClassId,@GroupId,@StudentIID,@MainExamId,@StudentTotalSubject,@DeductMarks,@DeductGP,@4tIsFailImpact,@4tAttPassFail,@PairIsFailImpact,@SubjectId1,@SubjectId2,@SubjectId3,@DBname

	
	   SET @COUNTResult = @COUNTResult + 1

	END

/*For Main Result*/

END
