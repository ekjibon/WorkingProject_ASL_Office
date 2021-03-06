/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GPA_Calculation]'))
BEGIN
DROP FUNCTION  GPA_Calculation
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Biplob>
-- Create date: <01-Jun-2017,>
-- Description:	<For Latter grade ad GP  Calculation>
-- =============================================
CREATE FUNCTION [dbo].[GPA_Calculation]
(
	@VersionID int,
	@SessionID int,
	@ClassID int,
	@GroupId int,
	@StudentIID int,
	@MainExamID int
)
RETURNS  real
AS
BEGIN


DECLARE @StudentTotalSubject int=1
DECLARE @GPA decimal(4,2)=0
DECLARE @GPAWithOut4Sub decimal(4,2)=0
DECLARE @FailStudentGPA decimal(4,2)=0
DECLARE @TotalGP decimal(4,2)=0
DECLARE @TotalGPWithOut4Sub decimal(4,2)=0


select TOP 1 @TotalGP=IsNull(Sum(MRS.SubjectGP),0) 
from [dbo].[Res_MainExamResultSubjectDetails] MRS Inner Join [dbo].[Res_SubjectSetup]  SSE ON MRS.SubjectID=SSE.SubID
 Where MRS.StudentIID=@StudentIID AND MRS.MainExamId=@MainExamID and isNull(SSE.SubjectType,'')!='P' and  SSE.NoEffectOnExam=0  and SSE.IsDeleted=0 and sse.SessionId=@SessionID

 /* 4th Subject Obtain*/
 DECLARE @4thSubGP Decimal(8,2)=0
 DECLARE @DeductMarks Decimal(8,2)=0
 DECLARE @DeductGP Decimal(8,2)=0
 DECLARE @4tIsFailImpact bit=0
 DECLARE @PairIsFailImpact bit=0
 
  

select top(1) @4thSubGP=IsNull(MRS.SubjectGP,0)
from [dbo].[Res_MainExamResultSubjectDetails] MRS Inner Join [dbo].[Res_StudentSubject]  SSE ON MRS.SubjectID=SSE.SubjectID 
Where  IsNull(SSE.SubjectType,'')!='P' and IsNull(SSE.SubjectType,'') ='F' and SSE.IsDeleted=0 and MRS.StudentIID=@StudentIID and sse.SessionId=@SessionID
--Set @TotalGPWithOut4Sub=@TotalGP-@4thSubGP
	return @GPA
Select top(1) @DeductGP=IsNull(FSR.DeductGP,0), @4tIsFailImpact=FSR.IsFailImpact From [dbo].[Res_FouthSubjectRules] FSR Where FSR.VersionID=@VersionId and FSR.SessionID=@SessionId and FSR.ClassID=@ClassId and FSR.GroupID=@GroupId and FSR.[IsDeleted]=0

IF(@4thSubGP>=@DeductGP)
set @TotalGP=@TotalGP-@DeductGP
else
set @TotalGP=@TotalGP-@4thSubGP

 /*End 4th Subject Obtain*/

Select @StudentTotalSubject=Count(SS.ID) from [dbo].[Res_StudentSubject] SS inner join [dbo].[Res_SubjectSetup] SSE ON SS.SubjectID=SSE.SubID
where SS.StudentID=@StudentIID and IsNull(SSE.SubjectType,'')!='P' and isNull(SS.SubjectType,'')!='F'  and  SSE.NoEffectOnExam=0  and SSE.IsDeleted=0 and SS.IsDeleted=0 and sse.SessionId=@SessionID

set @GPA=@TotalGP/@StudentTotalSubject
--Set @FailStudentGPA=@TotalGP/@StudentTotalSubject
--Set @GPAWithOut4Sub=@TotalGPWithOut4Sub/@StudentTotalSubject

/*Fail Calculation*/
If Exists(Select TOP 1 MRS.StudentIID  from [dbo].[Res_MainExamResultSubjectDetails] MRS Inner Join [dbo].[Res_SubjectSetup]  SSE ON MRS.SubjectID=SSE.SubID 
Where MRS.StudentIID=@StudentIID AND MRS.MainExamId=@MainExamID And MRS.SubjectIsPass=0 
and SSE.SubjectType!='P' and SSE.SubjectType !='F' and  SSE.NoEffectOnExam=0  and SSE.IsDeleted=0 and sse.SessionId=@SessionID )
Begin
set @GPA=0
End

-- 4thSubject fail Calculation Rule
if(@4tIsFailImpact=1)
Begin
If Exists(Select TOP 1 MRS.StudentIID from [dbo].[Res_MainExamResultSubjectDetails] MRS Inner Join [dbo].[Res_SubjectSetup]  SSE ON MRS.SubjectID=SSE.SubID 
Where MRS.StudentIID=@StudentIID AND MRS.MainExamId=@MainExamID And MRS.SubjectIsPass=0 and SSE.SubjectType ='F'  and SSE.IsDeleted=0 and sse.SessionId=@SessionID)
Begin
set @GPA=0
End
End

-- PairSubject fail Calculation Rule
if(@PairIsFailImpact=1)
Begin
If Exists(Select TOP 1 MRS.StudentIID from [dbo].[Res_MainExamResultSubjectDetails] MRS Inner Join [dbo].[Res_SubjectSetup]  SSE ON MRS.SubjectID=SSE.SubID 
Where MRS.StudentIID=@StudentIID AND MRS.MainExamId=@MainExamID And MRS.SubjectIsPass=0 and SSE.SubjectType ='P'  and SSE.IsDeleted=0 and sse.SessionId=@SessionID)
Begin
set @GPA=0
End
End

/*When GPA Sum >5*/
IF(@GPA>5)
BEGIN
set @GPA=5
END

/*End Fail Calculation*/

	return @GPA 
END
GO

