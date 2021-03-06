/****** Object:  StoredProcedure [dbo].[ProccessMerit]    Script Date: 7/22/2017 4:12:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ProccessGrandMerit]'))
BEGIN
DROP PROCEDURE  ProccessGrandMerit
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
--execute [dbo].[ProccessGrandMerit] 1,1,0,2
CREATE PROCEDURE ProccessGrandMerit
	@SessionId int ,
	@ClassId int ,
	@GroupId INT ,
	@GrandexamId1 int
AS
BEGIN
	DECLARE @GrandexamId2 int=0, @GrandExamName Varchar(200),@MainexamId1 int=0,@MainexamId2 int=0, @MainExamName Varchar(200), @SubjectIsmainExam bit=0, @className Varchar(200), @classId2 Varchar(200)

	select @GrandExamName=G.GrandExamName from [dbo].[Res_GrandExam] G where G.GrandExamId=@GrandexamId1
	select @className=ClassName from [dbo].[Ins_ClassInfo] where ClassId=@ClassId and IsDeleted=0
	select @classId2=ClassId from [dbo].[Ins_ClassInfo] where ClassName=@className and ClassId<>@ClassId and IsDeleted=0
	
	select @GrandexamId2=G.GrandExamId from [dbo].[Res_GrandExam] G where G.GrandExamName=@GrandExamName And G.GrandExamId!=@GrandExamId1 and G.SessionId=@SessionId and G.GroupId=@GroupId and G.ClassID=@classId2
	
	select @MainexamId1=MainExamId,@SubjectIsmainExam=SubjectIsMainExam FROM [dbo].[Res_GrandMeritListConfig] where [SessionId]=@SessionId  and [ClassId]=@ClassId and [GroupId]=@GroupId

	select @MainExamName=M.MainExamName from [dbo].[Res_MainExam] M where M.MainExamId=@MainexamId1

	select @MainexamId2=M.MainExamId from [dbo].[Res_MainExam] M where M.MainExamName=@MainExamName And M.MainExamId!=@MainexamId1 and M.SessionId=@SessionId and M.GroupId=@GroupId and M.ClassID=@classId2

	IF((select DB_NAME())!='zcpsc_new_db')
		BEGIN
		 IF((select DB_NAME())!='scpsc_new_db')
			 BEGIN
			  SELECT G.Id, 
				  SB.StudentIID,
				  SB.VersionID,
				  SB.ClassId,
				  SB.ShiftID,
				  SB.SectionId,
				  G.GrandExamId,
				  G.TotalConvertedMarks,
				  G.TotalConvertedMarksFraction,
				  G.GPA, 
				 
				  G.GPAWithOut4Sub as GPAWithOut4Sub,
				  g.TotalGP,
				  SB.FullName,
				  SB.RollNo, 

				  CASE  
				  WHEN @SubjectIsmainExam=0 THEN  IsNull(G.MeritSubjectMarks1,0)
				  ELSE  IsNull(G.MeritSubjectMarks1,0)
				  END as MeritSubjectMarks1,

		 
				  CASE  
				  WHEN @SubjectIsmainExam=0 THEN IsNull( G.MeritSubjectMarks2,0)
				  ELSE  IsNull(G.MeritSubjectMarks2,0)
				  END as MeritSubjectMarks2,

				  CASE  
				  WHEN @SubjectIsmainExam=0 THEN  IsNull(G.MeritSubjectMarks3,0)
				  ELSE  IsNull(G.MeritSubjectMarks3,0)
				  END as MeritSubjectMarks3,

				  G.IsPass,
				 IsNull(M.TotalConvertedMarks,0) as MainTotalConvertedMarks,
				 IsNull( M.TotalConvertedMarksFraction,0) as MainTotalConvertedMarksFraction,
				 IsNull( M.GPA,0) as MainGPA, 
				 IsNull( M.GPAWithOut4Sub,0) as MainGPAWithOut4Sub,
				G.MyProperty
				  FROM  dbo.Student_BasicInfo SB INNER JOIN  dbo.Res_GrandResult G ON SB.StudentIID = G.StudentIID left Outer JOIN [dbo].[Res_MainExamResult] M ON M.StudentIID = G.StudentIID AND (M.MainexamId=@MainexamId1 OR M.MainexamId=@MainexamId2)
				  where (G.GrandExamId=@GrandexamId1 OR G.GrandExamId=@GrandExamId2) and G.IsPass=1
			 END
			 ELSE
				 BEGIN
				 DECLARE @TotalmainExam int=1
				 SELECT @TotalmainExam=Count(MainExamId) from Res_GrandSetup where GrandExamId =@GrandexamId1

				  SELECT G.Id, 
				  SB.StudentIID,
				  SB.VersionID,
				  SB.ClassId,
				  SB.ShiftID,
				  SB.SectionId,
				  G.GrandExamId,
				  G.TotalConvertedMarks,
				  G.TotalConvertedMarksFraction,
				  G.GPA, 
				  G.GPAWithOut4Sub,
				  SB.FullName,
				  SB.RollNo, 

				  CASE  
				  WHEN @SubjectIsmainExam=0 THEN  IsNull(G.MeritSubjectMarks1,0)
				  ELSE  IsNull(M.MeritSubjectMarks1,0)
				  END as MeritSubjectMarks1,

		 
				  CASE  
				  WHEN @SubjectIsmainExam=0 THEN IsNull( G.MeritSubjectMarks2,0)
				  ELSE  IsNull(M.MeritSubjectMarks2,0)
				  END as MeritSubjectMarks2,

				  CASE  
				  WHEN @SubjectIsmainExam=0 THEN  IsNull(G.MeritSubjectMarks3,0)
				  ELSE  IsNull(M.MeritSubjectMarks3,0)
				  END as MeritSubjectMarks3,

				  G.IsPass,
				 IsNull(M.TotalConvertedMarks,0) as MainTotalConvertedMarks,
				 IsNull( M.TotalConvertedMarksFraction,0) as MainTotalConvertedMarksFraction,
				 IsNull( M.GPA,0) as MainGPA, 
				 IsNull( M.GPAWithOut4Sub,0) as MainGPAWithOut4Sub,
				 IsNull(L.NumberOfExam,2) as NumberOfExam

				  FROM  dbo.Student_BasicInfo SB INNER JOIN  dbo.Res_GrandResult G ON SB.StudentIID = G.StudentIID 
				  left Outer JOIN [dbo].[Res_MainExamResult] M ON M.StudentIID = G.StudentIID AND (M.MainexamId=@MainexamId1 OR M.MainexamId=@MainexamId2)
				  left Outer JOIN Res_MainExamLeaveStudent L ON G.StudentIID=L.StudentIID
				  where (G.GrandExamId=@GrandexamId1 OR G.GrandExamId=@GrandExamId2) and G.IsPass=1 and G.StudentIID not in (Select ML.StudentIID FROM Res_MainExamLeaveStudent ML where (ML.GrandExamId=@GrandexamId1 OR ML.GrandExamId=@GrandExamId2) and ML.IsDeleted=0 GROUP BY ML.StudentIID)
				 END
		END
	Else
	BEGIN	

	CREATE Table  #Res_GrandResult 
	(Id [bigint] IDENTITY(1,1) NOT NULL,
	StudentIID int,
	[OverAllMerit] [int] NOT NULL,
	[SectionWiseMerit] [int] NOT NULL,
	[ShiftWiseMerit] [int] NOT NULL,
	[ClassWiseMerit] [int] NOT NULL
	)
	Insert Into #Res_GrandResult 
	SELECT G.StudentIID,
    G.[OverAllMerit],
	G.[SectionWiseMerit],
	G.[ShiftWiseMerit],
	G.[ClassWiseMerit] 
	From dbo.Res_GrandResult G Where (G.GrandExamId=@GrandexamId1 OR G.GrandExamId=@GrandExamId2) and  G.IsPass=1


	CREATE TABLE [dbo].[#Res_MainExamResult](
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
	[MeritSubjectId1] [int] NOT NULL ,
	[MeritSubjectMarks1] [decimal](10, 2) NOT NULL ,
	[MeritSubjectId2] [int] NOT NULL ,
	[MeritSubjectMarks2] [decimal](10, 2) NOT NULL ,
	[MeritSubjectId3] [int] NOT NULL ,
	[MeritSubjectMarks3] [decimal](10, 2) NOT NULL
	)

	Insert Into #Res_MainExamResult
	SELECT 
	M.[MainExamId] ,
	m.[SubExamId] ,
	m.[StudentIID],
	m.[TotalMarks] ,
	m.[GPA] ,
	m.[GPAWithOut4Sub] ,
	m.[GradeLetter],
	m.[IsPass] [bit] ,
	m.[OverAllMerit] ,
	m.[SectionWiseMerit] ,
	m.[ShiftWiseMerit] ,
	m.[ClassWiseMerit] ,
	m.[TeacherComments] ,
	m.[Conduct] ,
	m.[Handwriting] ,
	m.[MyProperty] ,
	m.[TotalConvertedMarks] ,
	m.[TotalConvertedMarksFraction] ,
	m.[FailStudentGPA] ,
	m.[TotalGP] ,
	m.[TotalGPWithOut4Sub] ,
	m.[MeritSubjectId1] ,
	m.[MeritSubjectMarks1] ,
	m.[MeritSubjectId2] ,
	m.[MeritSubjectMarks2] ,
	m.[MeritSubjectId3] ,
	m.[MeritSubjectMarks3]  FROM Res_MainExamResult M inner join #Res_GrandResult  G ON M.StudentIID=G.StudentIID


	DECLARE @TotalStudent int=0, @CourrentStudent int=1, @RStudentIID int
	SELECT @TotalStudent = COUNT(*) FROM #Res_GrandResult
	While(@CourrentStudent<=@TotalStudent)
		BEGIN
		  SELECT @RStudentIID=StudentIID FROM  #Res_GrandResult where Id=@CourrentStudent
		 -- IF EXISTS (SELECT M.StudentIID From Res_MainExamResult M INNER JOIN dbo.Student_BasicInfo SB  ON M.StudentIID = SB.StudentIID  where M.IsPass=0 and SB.SessionId=@SessionId and M.StudentIID=@RStudentIID)
		  IF EXISTS (SELECT Top (1) M.StudentIID From #Res_MainExamResult M  where M.IsPass=0 and M.StudentIID=@RStudentIID)
		  BEGIN
		   Delete From #Res_MainExamResult where StudentIID=@RStudentIID
		  END
		set @CourrentStudent=@CourrentStudent +1
		END
		PRINT '>>>'
	SELECT G.Id, 
	      SB.StudentIID,
		  SB.VersionID,
		  SB.ClassId,
		  SB.ShiftID,
		  SB.SectionId,
		  G.GrandExamId,
		  G.TotalConvertedMarks,
		  G.TotalConvertedMarksFraction,
		  G.GPA, 
          G.GPAWithOut4Sub,
		  SB.FullName,
		  SB.RollNo, 

		  CASE  
		  WHEN @SubjectIsmainExam=0 THEN  IsNull(G.MeritSubjectMarks1,0)
		  ELSE  IsNull(G.MeritSubjectMarks1,0)
		  END as MeritSubjectMarks1,

		 
		  CASE  
		  WHEN @SubjectIsmainExam=0 THEN IsNull( G.MeritSubjectMarks2,0)
		  ELSE  IsNull(G.MeritSubjectMarks2,0)
		  END as MeritSubjectMarks2,

          CASE  
		  WHEN @SubjectIsmainExam=0 THEN  IsNull(G.MeritSubjectMarks3,0)
		  ELSE  IsNull(G.MeritSubjectMarks3,0)
		  END as MeritSubjectMarks3,

		  G.IsPass,
		 IsNull(G.TotalConvertedMarks,0) as MainTotalConvertedMarks,
		 IsNull( G.TotalConvertedMarksFraction,0) as MainTotalConvertedMarksFraction,
		 IsNull( G.GPA,0) as MainGPA, 
         IsNull(G.GPAWithOut4Sub,0) as MainGPAWithOut4Sub
          FROM  dbo.Student_BasicInfo SB 
		  INNER JOIN  dbo.Res_GrandResult G ON SB.StudentIID = G.StudentIID 
		  Inner JOIN #Res_MainExamResult M ON M.StudentIID = G.StudentIID 
		  where (G.GrandExamId=@GrandexamId1 OR G.GrandExamId=@GrandExamId2) and G.IsPass=1 and M.IsPass=1 GROUP BY 
		  G.Id, 
	      SB.StudentIID,
		  SB.VersionID,
		  SB.ClassId,
		  SB.ShiftID,
		  SB.SectionId,
		  G.GrandExamId,
		  G.TotalConvertedMarks,
		  G.TotalConvertedMarksFraction,
		  G.GPA, 
          G.GPAWithOut4Sub,
		  SB.FullName,
		  SB.RollNo, 

		   G.MeritSubjectMarks1,
           G.MeritSubjectMarks2,
		   G.MeritSubjectMarks3,
       
		  G.IsPass,
		 IsNull(G.TotalConvertedMarks,0),
		 IsNull( G.TotalConvertedMarksFraction,0),
		 IsNull( G.GPA,0), 
         IsNull(G.GPAWithOut4Sub,0) 
	END
END