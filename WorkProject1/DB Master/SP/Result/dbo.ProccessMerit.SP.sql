/****** Object:  StoredProcedure [dbo].[ProccessMerit]    Script Date: 7/22/2017 4:12:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ProccessMerit]'))
BEGIN
DROP PROCEDURE  ProccessMerit
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Biplob>
-- Create date: <19/9/2017>
-- Description:	<Description,,>
-- =============================================
--execute [dbo].[ProccessMerit] 6,7,0,7
CREATE PROCEDURE ProccessMerit
	@SessionId int ,
	@ClassId int ,
	@GroupId INT ,
	@MainexamId1 int
AS
BEGIN
	DECLARE @MainexamId2 int=0, @MainExamName Varchar(200),@DBname VARCHAR(100), @ClassName Varchar(200),@classId2 int , @meritPersentage decimal(10,2)=45

	select @MainExamName=M.MainExamName from [dbo].[Res_MainExam] M where M.MainExamId=@MainexamId1
	select @className=ClassName from [dbo].[Ins_ClassInfo] where ClassId=@ClassId and IsDeleted=0 
	select @classId2=ClassId from [dbo].[Ins_ClassInfo] where ClassName=@className and ClassId<>@ClassId and IsDeleted=0

	select @MainexamId2=M.MainExamId from [dbo].[Res_MainExam] M where M.MainExamName=@MainExamName And M.MainExamId!=@MainexamId1 and M.SessionId=@SessionId and M.GroupId=@GroupId and M.ClassId=@classId2

	 set @DBname=(select DB_Name())
	 If(@DBname <>'ccpc_new_db')
		    Begin
				SELECT M.ResultId, 
					  SB.StudentIID,
					  SB.VersionID,
					  SB.ClassId,
					  SB.ShiftID,
					  SB.SectionId,
					  M.MainExamId,
					  M.TotalConvertedMarks,
					  M.TotalConvertedMarksFraction,
					  M.GPA, 
					   
					  --CASE 
       --               WHEN @DBname in ('glhs_new_db','glhs_new_db_GRtest') THEN M.TotalGP 
       --               ELSE M.GPAWithOut4Sub
       --               END as GPAWithOut4Sub ,
	   M.GPAWithOut4Sub as GPAWithOut4Sub,
					  SB.FullName,
					 Cast(SB.RollNo as int) as RollNo, 
					  M.MeritSubjectMarks1,
					  M.MeritSubjectMarks2, 
					  M.MeritSubjectMarks3,
					  M.IsPass,
					  M.TotalGP
					  FROM  dbo.Student_BasicInfo SB INNER JOIN  dbo.Res_MainExamResult M ON SB.StudentIID = M.StudentIID
					  where (M.MainExamId=@MainexamId1 OR M.MainExamId=@MainexamId2) and M.IsPass=1
              End 
     Else
	 BEGIN
			   ------...........................................................
		DECLARE @DW1 bit=0, @DW2 bit=0, @DW3 bit=0, @DS bit=0, @DO bit=0, @DP bit=0, @DSubExam1 bit=0, @DSubExam2 bit=0,  @DSubExam3 bit=0, @CountStudent int, @currentStudent int=1, @StudentIID int

		CREATE TABLE #Res_MainExamResult(
	
		[ResultId] [bigint] IDENTITY(1,1) NOT NULL,
		[MainExamId] [int] NOT NULL,
		[SubExamId] [int] NOT NULL,
		[StudentIID] [bigint] NOT NULL,
		[TotalMarks] [decimal](8, 2) NOT NULL,
		[GPA] [decimal](8, 2) NOT NULL,
		[GPAWithOut4Sub] [decimal](8, 2) NOT NULL,
		[GradeLetter] [nvarchar](max) NULL,
		[IsPass] [bit] NOT NULL,
		[OverAllMerit] [int] NOT NULL,
		[SectionWiseMerit] [int] NOT NULL,
		[ShiftWiseMerit] [int] NOT NULL,
		[ClassWiseMerit] [int] NOT NULL,
		[TeacherComments] [nvarchar](max) NULL,
		[Conduct] [nvarchar](max) NULL,
		[Handwriting] [nvarchar](max) NULL,
		[MyProperty] [int] NOT NULL,
		[TotalConvertedMarks] [decimal](8, 2) NOT NULL,
		[TotalConvertedMarksFraction] [decimal](8, 2) NOT NULL,
		[FailStudentGPA] [decimal](8, 2) NOT NULL,
		[TotalGP] [decimal](8, 2) NOT NULL,
		[TotalGPWithOut4Sub] [decimal](8, 2) NOT NULL,
		[MeritSubjectId1] [int] NOT NULL,
		[MeritSubjectMarks1] [decimal](10, 2) NOT NULL,
		[MeritSubjectId2] [int] NOT NULL,
		[MeritSubjectMarks2] [decimal](10, 2) NOT NULL,
		[MeritSubjectId3] [int] NOT NULL,
		[MeritSubjectMarks3] [decimal](10, 2) NOT NULL
		)
		Insert Into #Res_MainExamResult
	
		SELECT 
		[MainExamId] ,
		[SubExamId] ,
		[StudentIID] ,
		[TotalMarks] ,
		[GPA] ,
		[GPAWithOut4Sub] ,
		[GradeLetter] ,
		[IsPass] ,
		[OverAllMerit] ,
		[SectionWiseMerit] ,
		[ShiftWiseMerit] ,
		[ClassWiseMerit] ,
		[TeacherComments] ,
		[Conduct] ,
		[Handwriting] ,
		[MyProperty] ,
		[TotalConvertedMarks],
		[TotalConvertedMarksFraction] ,
		[FailStudentGPA] ,
		[TotalGP] ,
		[TotalGPWithOut4Sub] ,
		[MeritSubjectId1] ,
		[MeritSubjectMarks1] ,
		[MeritSubjectId2] ,
		[MeritSubjectMarks2],
		[MeritSubjectId3] ,
		[MeritSubjectMarks3]
		from Res_MainExamResult  where MainExamId in (@MainexamId1,@MainexamId2)  and IsPass=1

		select @CountStudent=COUNT(*) FROM #Res_MainExamResult
		Print '@CountStudent---------:' Print @CountStudent
		Print '@@MainexamId1---------:' Print @MainexamId1
		Print '@@MainexamId2---------:' Print @MainexamId2
		WHILE (@currentStudent <= @CountStudent)
		 BEGIN
			   DECLARE @SubjectCount int, @CorrentSubject int=1
			   SELECT  @StudentIID =StudentIID FROM #Res_MainExamResult WHERE ResultId = @currentStudent
			   Print '@@@StudentIID---------:' Print @StudentIID
			   CREATE TABLE #Res_MainExamResultSubjectDetails(
									[SLId] int IDENTITY(1,1) NOT NULL,
									[SubjectID] [int] NOT NULL,
									SubjectConvertedMarksFraction decimal(8,2)
									)
									Insert into #Res_MainExamResultSubjectDetails
									(
									[SubjectID],
									SubjectConvertedMarksFraction
									)
									SELECT MRS.[SubjectID],MRS.SubjectConvertedMarksFraction 
									 from [dbo].[Res_MainExamResultSubjectDetails] MRS
									 Inner Join [dbo].[Res_StudentSubject]  SSE ON MRS.SubjectID=SSE.SubjectID AND  SSE.StudentID=MRS.StudentIID 
									 Inner Join [dbo].[Res_SubjectSetup]  SE ON SE.SubID=MRS.SubjectID Where MRS.StudentIID=@StudentIID AND MRS.MainExamId in (@MainexamId1,@MainexamId2) And MRS.SubjectIsPass=1 and SE.SubjectType!='P' and SSE.SubjectType !='F' and  SE.NoEffectOnExam=0  and SSE.IsDeleted=0 
									--from Res_MainExamResultSubjectDetails where  StudentIID=@StudentIID and MainExamId in (@MainexamId1,@MainexamId2)

									Select @SubjectCount=COUNT(*) FROM #Res_MainExamResultSubjectDetails

									Print '@SubjectCount>>>>>>>>>>:' Print @SubjectCount
									WHILE (@CorrentSubject <= @SubjectCount)
										BEGIN
											DECLARE @SubjectFullmark decimal(8,2), @SubjectIspassDepend bit=0, @SubjectId int, @Obtain decimal(10,2), @subExamCount int, @CurrentSubExam int=1
											select @SubjectId= SubjectID,@Obtain=SubjectConvertedMarksFraction  FROM #Res_MainExamResultSubjectDetails where [SLId]=@CorrentSubject
											SELECT @SubjectFullmark=[MainExamFullMarks], @SubjectIspassDepend=[MainExamIsPassDepend] from [dbo].[Qry_MarkSetup] where MainExamId in (@MainexamId1,@MainexamId2) and [MainExamSubjectID]=@SubjectId
								
											If(@SubjectIspassDepend=1)
											BEGIN
											 If(@meritPersentage>((100*@Obtain)/@SubjectFullmark))
											 BEGIN
											 delete from #Res_MainExamResult where [StudentIID]=@StudentIID
											 END
											END
											CREATE TABLE #Res_MEResultDetails(
											[MarksDetailsID] [int] IDENTITY(1,1) NOT NULL,
											[SubjectID] [int] NOT NULL,
											[MainExamId] [int] NOT NULL,
											[StudentIID] [bigint] NOT NULL,
											[SubExamId] [int] NOT NULL,
											[SubExamTotalObt] [decimal](8, 2) NOT NULL,
											[SubExamTotalConv] [decimal](8, 2) NOT NULL,
											[SubExamTotalFrac] [decimal](8, 2) NOT NULL,
											[SubExamIsPass] [bit] NOT NULL,
											[SubExamIsAbsent] [bit] NOT NULL,
											[WrittenObt1] [float] NOT NULL,
											[WrittenConv1] [float] NOT NULL,
											[WrittenFrac1] [float] NOT NULL,
											[WrittenIsPass1] [bit] NOT NULL,
											[WrittenIsAbsent1] [bit] NOT NULL,
											[WrittenObt2] [decimal](8, 2) NOT NULL,
											[WrittenConv2] [decimal](8, 2) NOT NULL,
											[WrittenFrac2] [decimal](8, 2) NOT NULL,
											[WrittenIsPass2] [bit] NOT NULL,
											[WrittenIsAbsent2] [bit] NOT NULL,
											[WrittenObt3] [decimal](8, 2) NOT NULL,
											[WrittenConv3] [decimal](8, 2) NOT NULL,
											[WrittenFrac3] [decimal](8, 2) NOT NULL,
											[WrittenIsPass3] [bit] NOT NULL,
											[WrittenIsAbsent3] [bit] NOT NULL,
											[SubjectiveObt] [decimal](8, 2) NOT NULL,
											[SubjectiveConv] [decimal](8, 2) NOT NULL,
											[SubjectiveFrac] [decimal](8, 2) NOT NULL,
											[SubjectiveIsPass] [bit] NOT NULL,
											[SubjectiveIsAbsent] [bit] NOT NULL,
											[ObjectiveObt] [decimal](8, 2) NOT NULL,
											[ObjectiveConv] [decimal](8, 2) NOT NULL,
											[ObjectiveFrac] [decimal](8, 2) NOT NULL,
											[ObjectiveIsPass] [bit] NOT NULL,
											[ObjectiveIsAbsent] [bit] NOT NULL,
											[PracticalObt] [decimal](8, 2) NOT NULL,
											[PracticalConv] [decimal](8, 2) NOT NULL,
											[PracticalFrac] [decimal](8, 2) NOT NULL,
											[PracticalIsPass] [bit] NOT NULL,
											[PracticalIsAbsent] [bit] NOT NULL,
											[ResultSubjectDetailsId] [bigint] NOT NULL,
											[SOPTotalObt] [decimal](18, 2) NOT NULL,
											[SOPTotalConv] [decimal](18, 2) NOT NULL,
											[SOPTotalFrac] [decimal](18, 2) NOT NULL,
											[SubExamOriginalTotalObt] [decimal](8, 2) NOT NULL
											)
											Insert Into #Res_MEResultDetails
												select	[SubjectID],
													[MainExamId],
													[StudentIID],
													[SubExamId],
													[SubExamTotalObt],
													[SubExamTotalConv],
													[SubExamTotalFrac] ,
													[SubExamIsPass],
													[SubExamIsAbsent],
													[WrittenObt1],
													[WrittenConv1],
													[WrittenFrac1],
													[WrittenIsPass1],
													[WrittenIsAbsent1],
													[WrittenObt2],
													[WrittenConv2],
													[WrittenFrac2],
													[WrittenIsPass2],
													[WrittenIsAbsent2],
													[WrittenObt3],
													[WrittenConv3],
													[WrittenFrac3],
													[WrittenIsPass3],
													[WrittenIsAbsent3],
													[SubjectiveObt],
													[SubjectiveConv] ,
													[SubjectiveFrac] ,
													[SubjectiveIsPass] ,
													[SubjectiveIsAbsent] ,
													[ObjectiveObt] ,
													[ObjectiveConv] ,
													[ObjectiveFrac] ,
													[ObjectiveIsPass] ,
													[ObjectiveIsAbsent] ,
													[PracticalObt],
													[PracticalConv],
													[PracticalFrac] ,
													[PracticalIsPass] ,
													[PracticalIsAbsent] ,
													[ResultSubjectDetailsId] ,
													[SOPTotalObt] ,
													[SOPTotalConv] ,
													[SOPTotalFrac] ,
													[SubExamOriginalTotalObt] 
													from Res_MEResultDetails where MainExamId in (@MainexamId1,@MainexamId2) and SubjectID=@SubjectId and [StudentIID]=@StudentIID

													Select @subExamCount= Count(*) from #Res_MEResultDetails
												
													Print '@@subExamCount>>>>>>>>>>:' Print @subExamCount
													While(@CurrentSubExam <= @subExamCount)
													BEGIN
																DECLARE @SubExamId int, @Fullmark_W1 decimal(10,2), @Fullmark_W2 decimal(10,2),  @Fullmark_W3 decimal(10,2), @Fullmark_S decimal(10,2), @Fullmark_O decimal(10,2), @Fullmark_P decimal(10,2)
																,@isDependent_W1 bit =0 ,@isDependent_W2 bit =0, @isDependent_W3 bit =0, @isDependent_S bit =0, @isDependent_O bit =0,@isDependent_P bit =0
																,@Obtain_W1 decimal(10,2),@Obtain_W2 decimal(10,2),@Obtain_W3 decimal(10,2),@Obtain_S decimal(10,2),@Obtain_O decimal(10,2),@Obtain_P decimal(10,2)

																select @SubExamId=[SubExamId],@Obtain_W1=WrittenObt1,@Obtain_W2=WrittenObt2,@Obtain_W3=WrittenObt3,@Obtain_S=SubjectiveObt ,@Obtain_O=ObjectiveObt
																,@Obtain_P=PracticalObt from #Res_MEResultDetails where [MarksDetailsID]=@CurrentSubExam

																/*Written-1 Merit check*/
																Select @Fullmark_W1=[DividedExamFullMarks], @isDependent_W1=[DividedExamIsPassDepend] from [dbo].[Qry_MarkSetup] where MainExamId in (@MainexamId1,@MainexamId2) and [MainExamSubjectID]=@SubjectId and [SubExamId]=@SubExamId and [DividedExamType]='W1'
																If(@isDependent_W1=1)
																BEGIN
																	 If(@meritPersentage>((100*@Obtain_W1)/@Fullmark_W1))
																	 BEGIN
																	 delete from #Res_MainExamResult where [StudentIID]=@StudentIID
																	 END
																END
																/*End Written-1 Merit check*/

																/*Written-2 Merit check*/
																Select @Fullmark_W2=[DividedExamFullMarks], @isDependent_W2=[DividedExamIsPassDepend] from [dbo].[Qry_MarkSetup] where MainExamId in (@MainexamId1,@MainexamId2) and [MainExamSubjectID]=@SubjectId and [SubExamId]=@SubExamId and [DividedExamType]='W2'
																If(@isDependent_W2=1)
																BEGIN
																	 If(@meritPersentage>((100*@Obtain_W2)/@Fullmark_W2))
																	 BEGIN
																	 delete from #Res_MainExamResult where [StudentIID]=@StudentIID
																	 END
																END
																/*End Written-2 Merit check*/

																/*Written-3 Merit check*/
																Select @Fullmark_W3=[DividedExamFullMarks], @isDependent_W3=[DividedExamIsPassDepend] from [dbo].[Qry_MarkSetup] where MainExamId in (@MainexamId1,@MainexamId2) and [MainExamSubjectID]=@SubjectId and [SubExamId]=@SubExamId and [DividedExamType]='W3'
																If(@isDependent_W3=1)
																BEGIN
																	 If(@meritPersentage>((100*@Obtain_W3)/@Fullmark_W3))
																	 BEGIN
																	 delete from #Res_MainExamResult where [StudentIID]=@StudentIID
																	 END
																END
																/*End Written-3 Merit check*/


																/*Written-S Merit check*/
																Select @Fullmark_S=[DividedExamFullMarks], @isDependent_S=[DividedExamIsPassDepend] from [dbo].[Qry_MarkSetup] where MainExamId in (@MainexamId1,@MainexamId2) and [MainExamSubjectID]=@SubjectId and [SubExamId]=@SubExamId and [DividedExamType]='S'
																If(@isDependent_S=1)
																BEGIN
																	 If(@meritPersentage>((100*@Obtain_S)/@Fullmark_S))
																	 BEGIN
																	 delete from #Res_MainExamResult where [StudentIID]=@StudentIID
																	 END
																END
																/*End Written-S Merit check*/


																/*Written-O Merit check*/
																Select @Fullmark_O=[DividedExamFullMarks], @isDependent_O=[DividedExamIsPassDepend] from [dbo].[Qry_MarkSetup] where MainExamId in (@MainexamId1,@MainexamId2) and [MainExamSubjectID]=@SubjectId and [SubExamId]=@SubExamId and [DividedExamType]='O'
																If(@isDependent_O=1)
																BEGIN
																	 If(@meritPersentage>((100*@Obtain_O)/@Fullmark_O))
																	 BEGIN
																	 delete from #Res_MainExamResult where [StudentIID]=@StudentIID
																	 END
																END
																/*End Written-O Merit check*/


																/*Written-P Merit check*/
																Select @Fullmark_P=[DividedExamFullMarks], @isDependent_P=[DividedExamIsPassDepend] from [dbo].[Qry_MarkSetup] where MainExamId in (@MainexamId1,@MainexamId2) and [MainExamSubjectID]=@SubjectId and [SubExamId]=@SubExamId and [DividedExamType]='P'
																If(@isDependent_P=1)
																BEGIN
																	 If(@meritPersentage>((100*@Obtain_P)/@Fullmark_P))
																	 BEGIN
																	 delete from #Res_MainExamResult where [StudentIID]=@StudentIID
																	 END
																END
																/*End Written-P Merit check*/
																Set @CurrentSubExam=@CurrentSubExam + 1
													END

												Drop Table	#Res_MEResultDetails
											SET @CorrentSubject = @CorrentSubject + 1
									END
				  Drop Table #Res_MainExamResultSubjectDetails
				  SET @currentStudent = @currentStudent + 1
			END
		----------------------------------------------------------------------------------
	      SELECT M.ResultId, 
	      SB.StudentIID,
		  SB.VersionID,
		  SB.ClassId,
		  SB.ShiftID,
		  SB.SectionId,
		  M.MainExamId,
		  M.TotalConvertedMarks,
		  M.TotalConvertedMarksFraction,
		  M.GPA, 
          M.GPAWithOut4Sub,
		  SB.FullName,
		  Cast(SB.RollNo as int), 
		  M.MeritSubjectMarks1,
		  M.MeritSubjectMarks2, 
          M.MeritSubjectMarks3,
		  M.IsPass
          FROM  dbo.Student_BasicInfo SB INNER JOIN  dbo.#Res_MainExamResult M ON SB.StudentIID = M.StudentIID
		  where (M.MainExamId=@MainexamId1 OR M.MainExamId=@MainexamId2) and M.IsPass=1
           Drop Table #Res_MainExamResult
		   End
END
GO