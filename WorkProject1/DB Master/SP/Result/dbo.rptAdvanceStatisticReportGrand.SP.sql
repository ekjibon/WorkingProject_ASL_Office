/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptAdvanceStatisticReportGrand]'))
BEGIN
DROP PROCEDURE  rptAdvanceStatisticReportGrand
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
CREATE PROC [dbo].[rptAdvanceStatisticReportGrand] 
(
@GrandExamIds NVARCHAR(MAX)=NULL,
@Where NVARCHAR(MAX),
@Grade VARCHAR(10) =NULL,
@GPFrom DECIMAL =0.00,
@GPTo DECIMAL =5.00,
@SubjectId Int=0,
@NoOfSubject Int =0,
@PassFail BIT=1,
@Block INT
)
AS
BEGIN
		BEGIN
		DECLARE @sql NVARCHAR(MAX)=NULL
		DECLARE @VERSION INT=0, @SESSION INT=0, @CLASS INT =0, @GROUP INT=0;
		CREATE TABLE #GRANDEXAM
		(
		GrandExamId INT,
		VersionID INT NULL,
		SessionId INT NULL,
		ClassId INT NULL,
		GroupId INT NULL
		)
		--INSERT INTO ##GRANDEXAM SELECT VersionId,SessionId,ClassId,GroupId FROM Res_MainExam WHERE MainExamId IN()  AND IsDeleted=0
			SET @sql = 'INSERT INTO #GRANDEXAM SELECT GrandExamId, VersionId,SessionId,ClassId,GroupId FROM Res_GrandExam '
				PRINT(@sql)
			 IF(@GrandExamIds IS NOT NULL and  @GrandExamIds <> '')
			 BEGIN
				SET @sql = @sql + ' WHERE '+ @GrandExamIds
			 END				 
				EXEC(@sql)
			END			
			create table #STUDENTLIST
			(
			 StudentIID bigint not null
			,VersionID int null
			,VersionName NVARCHAR(MAX) not null
			,SessionId int null
			,SessionName NVARCHAR(MAX) not null
			,BranchName NVARCHAR(MAX) not null
			,ShiftName NVARCHAR(MAX) not null
			,ClassId int null
			,ClassName NVARCHAR(MAX) not null
			,GroupId int null
			,GroupName NVARCHAR(MAX) not null
			,SectionName NVARCHAR(MAX) not null
			,StudentInsID NVARCHAR(MAX) not null
			,FullName varchar(MAX) null
			,RollNo int not null				
			)
			SET @sql = 'INSERT INTO #STUDENTLIST 
						SELECT SB.[StudentIID], SB.[VersionID],V.VersionName, SB.[SessionId], V.SessionName,V.BranchName,V.ShiftName,
 SB.[ClassId],V.ClassName, SB.[GroupId],V.GroupName,V.SectionName,
SB.[StudentInsID], SB.[FullName], SB.[RollNo] FROM [dbo].[Student_BasicInfo] AS SB
Join dbo.view_CommonTableNames v on v.VersionId=sb.VersionID and v.SessionId=sb.SessionId and v.BranchId=sb.BranchID and v.ShiftId=sb.ShiftID
and v.ClassId=sb.ClassId and v.GroupId=sb.GroupId and v.SectionId=sb.SectionId  '
				PRINT(@sql)
			 IF(@Where IS NOT NULL and  @Where <> '')
			 BEGIN
				SET @sql = @sql + ' WHERE '+ @Where
			 END
				 SET @sql = @sql + '  ORDER BY SB.[StudentIID], SB.[ClassId], SB.[GroupId], SB.[SectionId], SB.RollNo'
				EXEC(@sql)

			SELECT * INTO #STUDENTLISTf FROM #STUDENTLIST WHERE VersionID IN(SELECT VersionID FROM #GRANDEXAM)
			 AND SessionId IN(SELECT SessionId FROM #GRANDEXAM)
			 AND ClassId IN (SELECT ClassId FROM #GRANDEXAM)	 AND GroupId IN (SELECT GroupId FROM #GRANDEXAM)	
			 IF(@Block=1)
			 BEGIN
				 IF(@Grade IS NOT NULL and  @Grade <> '')
				 BEGIN
					SELECT S.StudentInsID,S.FullName,S.RollNo,S.VersionName,S.SessionName,S.BranchName,S.ShiftName,S.ClassName,S.GroupName,S.SectionName,
					R.GPA, R.GradeLetter FROM dbo.Res_GrandResult  AS R INNER JOIN #STUDENTLISTf AS S ON R.StudentIID=S.StudentIID
					WHERE R.GradeLetter=@Grade AND R.IsPass=@PassFail AND R.GrandExamId IN(SELECT GrandExamId FROM #GRANDEXAM)
					order by s.RollNo
				 END
				 ELSE
				 BEGIN
					SELECT S.StudentInsID,S.FullName,S.RollNo,S.RollNo,S.VersionName,S.SessionName,S.ClassName,S.GroupName,S.SectionName,
					R.GPA, R.GradeLetter FROM Res_GrandResult AS R INNER JOIN #STUDENTLISTf AS S ON R.StudentIID=S.StudentIID
					WHERE R.IsPass=@PassFail AND R.GPA  BETWEEN @GPFrom  AND @GPTo AND R.GrandExamId IN(SELECT GrandExamId FROM #GRANDEXAM)
					order by s.RollNo
				 END
			 END
			 IF(@Block=2)
			 BEGIN
				Declare @Subjectname Varchar(50)=null
				Select  @Subjectname=SubjectName From Res_SubjectSetup Where SubID=@SubjectId AND IsDeleted=0
				 IF(@Grade IS NOT NULL and  @Grade <> '')
				 BEGIN					
					SELECT distinct S.StudentInsID,S.FullName,S.RollNo,S.RollNo,S.VersionName,S.SessionName,S.ClassName,S.GroupName,S.SectionName,
					R.SubjectGP, R.SubjectGL, @Subjectname AS SubjectName FROM dbo.Res_GrandResultSubjectDetails AS R INNER JOIN #STUDENTLISTf AS S ON R.StudentIID=S.StudentIID
					WHERE R.SubjectIsPass=@PassFail AND R.SubjectGL=@Grade AND R.SubjectID=@SubjectId
					AND R.GrandExamId IN(SELECT GrandExamId FROM #GRANDEXAM)
					order by s.RollNo
				 END
				 ELSE
				 BEGIN
					SELECT distinct S.StudentInsID,S.FullName,S.RollNo,S.RollNo,S.VersionName,S.SessionName,S.ClassName,S.GroupName,S.SectionName,
					R.SubjectGP, R.SubjectGL, @Subjectname AS SubjectName FROM Res_GrandResultSubjectDetails AS R INNER JOIN #STUDENTLISTf AS S ON R.StudentIID=S.StudentIID
					WHERE R.SubjectIsPass=@PassFail AND R.SubjectGP BETWEEN @GPFrom AND @GPTo AND R.SubjectID=@SubjectId
					AND R.GrandExamId IN(SELECT GrandExamId FROM #GRANDEXAM)
					order by s.RollNo
				 END				
			 END
			 IF(@Block=3)
			 BEGIN
				SELECT S.StudentID,S.SubjectID INTO #SFS FROM Res_StudentSubject AS S 
				WHERE S.StudentID IN(SELECT StudentIID FROM #STUDENTLISTf) AND S.SubjectType='F'

				SELECT distinct S.StudentInsID,S.FullName,S.RollNo,S.RollNo,S.VersionName,S.SessionName,S.ClassName,S.GroupName,S.SectionName,
					R.SubjectGP, R.SubjectGL,(Select  SubjectName From Res_SubjectSetup Where SubID=F.SubjectID AND IsDeleted=0) AS SubjectName
					FROM Res_GrandResultSubjectDetails AS R INNER JOIN #STUDENTLISTf AS S ON R.StudentIID=S.StudentIID
					INNER JOIN #SFS AS F ON R.StudentIID=F.StudentID AND R.SubjectID=F.SubjectID
					WHERE R.SubjectIsPass=0	AND R.GrandExamId IN(SELECT GrandExamId FROM #GRANDEXAM)
					order by s.RollNo
					DROP TABLE #SFS
			 END
			 IF(@Block=4)
			 BEGIN
				SELECT distinct S.StudentInsID,S.FullName,S.RollNo,S.RollNo,S.VersionName,S.SessionName,S.ClassName,S.GroupName,S.SectionName,
					R.SubjectGP, R.SubjectGL, (Select  SubjectName From Res_SubjectSetup Where SubID=R.SubjectID AND IsDeleted=0) AS SubjectName
					FROM Res_GrandResultSubjectDetails AS R INNER JOIN #STUDENTLISTf AS S ON R.StudentIID=S.StudentIID
					WHERE R.SubjectIsPass=@PassFail AND R.SubjectID=@SubjectId AND R.GrandExamId IN(SELECT GrandExamId FROM #GRANDEXAM)
					order by s.RollNo
			 END
			 IF(@Block=5)
			 BEGIN
			 SELECT Id INTO #FS FROM dbo.Res_GrandResultSubjectDetails WHERE StudentIID IN(SELECT StudentIID FROM #STUDENTLISTf)
			 AND GrandExamId IN(SELECT GrandExamId FROM #GRANDEXAM) AND SubjectIsPass=0 
			 SELECT StudentIID,count(StudentIID) as nos
			into #NoOfFailSubject FROM dbo.Res_GrandResultSubjectDetails where SubjectIsPass=0 AND Id IN(SELECT Id FROM #FS)
			GROUP BY StudentIID
			HAVING COUNT(StudentIID) = @NoOfSubject;

			SELECT StudentInsID, FullName, RollNo, S.RollNo,S.VersionName,S.SessionName,S.ClassName,S.GroupName,S.SectionName FROM #STUDENTLISTf AS S WHERE StudentIID IN(SELECT StudentIID FROM #NoOfFailSubject)
			order by S.RollNo
			 DROP TABLE #FS,#NoOfFailSubject

			END

			DROP TABLE #GRANDEXAM,#STUDENTLIST,#STUDENTLISTf

END
