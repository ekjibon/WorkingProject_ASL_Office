/****** Object:  StoredProcedure [dbo].[ProccessMainExam]    Script Date: 7/22/2017 4:28:51 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ProccessGrandSubjectAndResult]'))
BEGIN
DROP PROCEDURE  ProccessGrandSubjectAndResult
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO --- [ProccessGrandSubjectAndResult] 1,6,1,12,1,9
create PROCEDURE [dbo].[ProccessGrandSubjectAndResult] 
	@VersionId int ,
	@SessionId int ,
	@ShiftId	INT ,
	@ClassId int ,
	@GroupId int ,
	@GrandExamId int
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
   SELECT M.[StudentIID],[GrandExamID] From  Res_GrandResultSubjectDetails M INNER JOIN [dbo].[Student_BasicInfo] S ON S.[StudentIID] = M.[StudentIID]
       where [GrandExamID]=@GrandExamId AND S.ShiftId = @ShiftId 
	   GROUP BY M.[StudentIID],[GrandExamID] ORDER BY StudentIID
	   
SELECT @MAXIDResult = COUNT(*) FROM #TempResult
set @ResultSLID=@MAXIDResult/2
/*Commun Field*/
 DECLARE @aStudentIID int=1
,@StudentTotalSubject int=1
,@DeductMarks Decimal(8,2)=0
,@DeductGP Decimal(8,2)=0
,@4tIsFailImpact bit=0
,@PairIsFailImpact bit=0
,@SubjectId1 int=0
,@SubjectId2 int=0
,@SubjectId3 int=0

if (@DBname='zcpsc_new_2018')
BEGIN
set @PairIsFailImpact=1
END

 SELECT TOP 1 @aStudentIID=StudentIID FROM #TempResult where Result=@ResultSLID order by StudentIID DESC
 Print '@aStudentIID'  Print @aStudentIID

Select @StudentTotalSubject=Count(SS.ID) from [dbo].[Res_StudentSubject] SS inner join [dbo].[Res_SubjectSetup] SSE ON SS.SubjectID=SSE.SubID
where SS.StudentID=@aStudentIID and IsNull(SSE.SubjectType,'')!='P' and isNull(SS.SubjectType,'')!='F'  and  SSE.NoEffectOnExam=0  and SSE.IsDeleted=0 and SS.IsDeleted=0

print '@StudentTotalSubject:' 

If(@DBname='bafsk_new_2018')
BEGIN
 If(@ClassID in (1,2,3,4,5,14,15,16,17))
	 BEGIN
	
		 Select @StudentTotalSubject=Count(SS.ID) from [dbo].[Res_StudentSubject] SS inner join [dbo].[Res_SubjectSetup] SSE ON SS.SubjectID=SSE.SubID
         where SS.StudentID=@aStudentIID and IsNull(SSE.SubjectType,'')!='P' and isNull(SS.SubjectType,'')!='F'  and SSE.IsDeleted=0 and SS.IsDeleted=0
		-- PRINT @StudentTotalSubject
	 END
END

If(@DBname='whs_new_2018')
BEGIN
 
		 Select @StudentTotalSubject=Count(SS.ID) from [dbo].[Res_StudentSubject] SS inner join [dbo].[Res_SubjectSetup] SSE ON SS.SubjectID=SSE.SubID
         where SS.StudentID=@aStudentIID and IsNull(SSE.SubjectType,'')!='P' and isNull(SS.SubjectType,'')!='F'  and SSE.IsDeleted=0 and SS.IsDeleted=0
	
END
PRINT 'Student Total Sub : ' + CAST( @StudentTotalSubject AS VARCHAR)

Select top(1) @DeductMarks=IsNull(FSR.DeductMarks,0),@DeductGP=IsNull(FSR.DeductGP,0), @4tIsFailImpact=FSR.IsFailImpact From [dbo].[Res_FouthSubjectRules] FSR 
Where FSR.VersionID=@VersionId and FSR.SessionID=@SessionId and FSR.ClassID=@ClassId and FSR.GroupID=@GroupId and FSR.[IsDeleted]=0

Select  @SubjectId1=Isnull(MC.SubjectId1,0),@SubjectId2=Isnull(MC.SubjectId2,0) ,@SubjectId3=Isnull(MC.SubjectId3,0)  From [dbo].[Res_GrandMeritListConfig] MC  Where  MC.VersionID=@VersionID and MC.SessionID=@SessionID and MC.ClassID=@ClassID  and MC.GroupId=@GroupId and MC.IsDeleted=0

/*End Common Field*/


 WHILE (@COUNTResult <= @MAXIDResult)
	BEGIN
	SELECT  @StudentIID =StudentIID
		 FROM #TempResult WHERE Result = @COUNTResult
		   Print '  Exec  ProccessGrandResult '+convert(varchar(500),@VersionId)+' ,'+convert(varchar(500),@SessionId)+' ,'
		   +convert(varchar(500),@ShiftId)+' ,'+convert(varchar(500),@ClassId)+' ,'+convert(varchar(500),@GroupId)+' ,'
		   +convert(varchar(500),@StudentIID)+' ,'+convert(varchar(500),@GrandExamId)+' ,'+convert(varchar(500),@StudentTotalSubject)+' ,'
		   +convert(varchar(500),@DeductMarks)+' ,'+convert(varchar(500),@DeductGP)+' ,'+convert(varchar(500),@4tIsFailImpact)+' ,'+convert(varchar(500),@PairIsFailImpact)
		   +' ,'+convert(varchar(500),@SubjectId1)+' ,'+convert(varchar(500),@SubjectId2)+' ,'+convert(varchar(500),@SubjectId3)+' ,'
		   +convert(varchar(500),@DBname)
		  Exec  ProccessGrandResult @VersionId,@SessionId,@ShiftId,@ClassId,@GroupId,@StudentIID,@GrandExamId,@StudentTotalSubject,@DeductMarks,@DeductGP,@4tIsFailImpact,@PairIsFailImpact,@SubjectId1,@SubjectId2,@SubjectId3,@DBname

	
	   SET @COUNTResult = @COUNTResult + 1

	END

/*For Main Result*/

END
