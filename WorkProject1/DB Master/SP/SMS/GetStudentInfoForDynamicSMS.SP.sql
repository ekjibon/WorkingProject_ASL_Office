IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetStudentInfoForDynamicSMS]'))
BEGIN
DROP PROCEDURE  GetStudentInfoForDynamicSMS
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [dbo].[GetStudentInfoForDynamicSMS] 1,  'SMSNotificationNo IS NOT NULL AND SB.IsDeleted = 0 ','aaa' ,null,null,null,null
Create PROCEDURE [dbo].[GetStudentInfoForDynamicSMS] -- Total 7 param
(
	@Block INT,
	@Where NVARCHAR(MAX)=NULL,
	@SmsBody NVARCHAR(MAX) = NULL,
	@FromDate VARCHAR(20) = NULL,
	@ToDate VARCHAR(20) = NULL,		
	@ExamID INT = NULL,
	@OverAllResult INT = NULL	
)
AS
BEGIN
			DECLARE @sql varchar(max)
			
			create table #StudentSms
			(
			 StudentIID bigint not null
			,StudentInsID NVARCHAR(MAX) not null
			,FullName varchar(MAX) null
			,RollNo int not null
			,DestinationNumber NVARCHAR(MAX) NULL
			,SmsBody NVARCHAR(MAX) NULL
			,NoOfSms int null
			,SmsLength int null
			,TotalSms int null			
			,IsSms BIT			
			)

			create table #StudentList
			(
			 StudentIID bigint not null,
			[SessionId] int not null
			,[BranchID] int not null
			,[ShiftID] int not null
			,[ClassId] int not null
			,[SectionId] int not null
			,SessionName Varchar(100) Null
			,BranchName Varchar(100) Null
			,ShiftName Varchar(100) Null
			,ClassName Varchar(100) Null
			,SectionName Varchar(100) Null
			,StudentTypeName Varchar(100) Null
			,HouseName Varchar(100) Null
			,[StudentInsID] NVARCHAR(160) not null
			,[FullName] varchar(200) null
			,[RollNo] int not null
			,DestinationNumber NVARCHAR(MAX) NULL
			,NoOfSMS INT NULL			
			,IsSms BIT			 
			)


			IF(@Block!=2)
			BEGIN
			SET @sql = 'INSERT INTO #StudentList 
							select  SB.[StudentIID], SB.[SessionId], SB.[BranchID], SB.[ShiftID], SB.[ClassId],  SB.[SectionId], 
SessionName,BranchName ,ShiftName,ClassName,SectionName,StudentTypeName,HouseName,
SB.[StudentInsID], SB.[FullName], SB.[RollNo], SB.[SMSNotificationNo] AS DestinationNumber,0,0   FROM [dbo].[Student_BasicInfo] AS SB
	 left outer join dbo.Ins_Session s ON sb.SessionId = s.SessionId
	 left outer join dbo.Ins_Branch b ON sb.BranchID = b.BranchId
	 left outer join dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId
	 left outer join dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId
	 left outer join dbo.Ins_Section sc ON sc.SectionId = sb.SectionId
	 left outer join dbo.Ins_StudentType St ON St.StudentTypeId = sb.StudentTypeId
	 left outer join dbo.Ins_House H ON H.HouseId = sb.HouseId  '
				PRINT(@sql)
			 IF(@Where IS NOT NULL and  @Where <> '')
			 BEGIN
				SET @sql = @sql + ' WHERE '+ @Where
			 END
				 SET @sql = @sql + '  ORDER BY SB.[StudentIID], SB.[ClassId], SB.[SectionId], SB.RollNo'
				EXEC(@sql)

			END
	
	IF(@Block=1)
	BEGIN
		--Select 'Dear P T A K L O', REPLACE(REPLACE(REPLACE('Dear P T A K L O','P','p1'),'T','t2'),'j','J3')
		--SET @SmsBody='World Hello World Hello World [Birthday]'
		INSERT INTO #StudentSms
		SELECT S.StudentIID, S.StudentInsID, S.FullName, S.RollNo, S.DestinationNumber,
		REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@SmsBody,
		'[StudentName]',S.FullName),'[Roll]',S.RollNo),'[StudentID]',S.StudentInsID),
		'[Session]',S.SessionName),'[Branch]',S.BranchName),'[Shift]',S.ShiftName),'[Class]',S.ClassName),
		'[Section]',S.SectionName),'[StudentType]',S.StudentTypeName),'[HouseId]',
		s.HouseName	),'[His_Her]','His/Her'	),'[He_She]','He/She'	)		
		AS SmsBody, 
		0,0,0,0 FROM #Studentlist AS S
		
		UPDATE S SET NoOfSms=(SELECT [dbo].[SMSCounter](M.SmsBody) FROM #StudentSms AS M WHERE M.StudentIID=S.StudentIID),
		SmsLength= (SELECT LEN(M.SmsBody) FROM #StudentSms AS M WHERE M.StudentIID=S.StudentIID)		
		FROM #StudentSms AS S

		UPDATE S SET TotalSms=(SELECT SUM(NoOfSms) FROM #StudentSms AS M )	FROM #StudentSms AS S
		SELECT * FROM #StudentSms
	END

	IF(@Block=2)
	BEGIN
			create table #EmployeeSms
			(
			 EmpBasicInfoID bigint not null
			,EmpID NVARCHAR(160) not null
			,FullName varchar(200) null
			,DesignationName VARCHAR(50) null
			,DestinationNumber NVARCHAR(100) NULL
			,SmsBody NVARCHAR(MAX) not null
			,NoOfSms int null
			,SmsLength int null
			,TotalSms int not null			
			,IsSms BIT			
			)
			
			create table #EmployeeList
			(
			 [EmpBasicInfoID] bigint not null
			,[EmpID] NVARCHAR(100) not null			
			,[FullName] varchar(200) not null
			,DesignationName NVARCHAR(160) NULL
			,DestinationNumber NVARCHAR(100) NULL
			,SectionName NVARCHAR(100) NULL
			,BranchName NVARCHAR(100) NULL
			,ShiftName NVARCHAR(100) NULL
			,DepartmentName NVARCHAR(100) NULL
			,SubjectName NVARCHAR(100) NULL
			,CategoryName NVARCHAR(100) NULL
			,IsSms BIT
			--,SmsBody NVARCHAR(MAX) NULL
			)
			
			SET @sql ='INSERT INTO #EmployeeList SELECT [EmpBasicInfoID], [EmpID], [FullName],
						 (SELECT TOP 1 DesignationName FROM Emp_Designation WHERE DesignationID = [DesignationID]) AS DesignationName,
						 (SELECT TOP 1 SectionName FROM Emp_Section WHERE SectionID = EB.SectionID) AS SectionName,
						 (SELECT TOP 1 BranchName FROM Ins_Branch WHERE BranchID = EB.BranchID) AS BranchName,
						 (SELECT TOP 1 ShiftName FROM Emp_Shift WHERE ShiftID = EB.ShiftID) AS ShiftName,
						 (SELECT TOP 1 DepartmentName FROM Emp_Department WHERE DepartmentID = EB.DepartmentID) AS DepartmentName,
						 (SELECT TOP 1 SubjectName FROM Emp_Subject WHERE SubjectID = EB.SubjectID) AS SubjectName,
						 (SELECT TOP 1 CategoryName FROM Emp_Category WHERE CategoryID = EB.CategoryID) AS CategoryName,
							 [SMSNotificationNo], 0 FROM [dbo].[Emp_BasicInfo] AS EB'-- WHERE EB.IsDeleted=0 AND EB.Status='A' 

						 PRINT(@sql)
						 IF(@Where IS NOT NULL and  @Where <> '')
						 BEGIN
							SET @sql = @sql + ' WHERE '+ @Where
						 END
							EXEC(@sql)

								--SELECT *, REPLACE(@SmsBody,'[EmployeeName]',FullName) AS SmsBody  FROM #EmployeeList
								INSERT INTO #EmployeeSms
						SELECT S.EmpBasicInfoID, S.EmpID, S.FullName, S.DesignationName, S.DestinationNumber,
						REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE
(REPLACE(@SmsBody,'[EmployeeName]',s.FullName),'[EmployeeID]'
,s.EmpID),'[Designation]',ISNULL(s.DesignationName,'')),'[Version]',ISNULL(s.VersionName,'')),'[Section]',
ISNULL(S.SectionName,'')),'[Branch]',ISNULL(s.BranchName,'')),
'[Shift]',ISNULL(s.ShiftName,'')),'[Department]',ISNULL(s.DepartmentName,'')),'[Subject]',ISNULL(s.SubjectName,'')),'[He_She]','He/She'),'[His_Her]','His/Her'),'[Category]', ISNULL(s.CategoryName,'')) AS SmsBody, 
						0,0,0,0 FROM #EmployeeList AS S WHERE S.DestinationNumber IS NOT NULL
		
						UPDATE S SET NoOfSms=(SELECT [dbo].[SMSCounter](M.SmsBody) FROM #EmployeeSms AS M WHERE M.EmpBasicInfoID=S.EmpBasicInfoID),
						SmsLength= (SELECT LEN(M.SmsBody) FROM #EmployeeSms AS M WHERE M.EmpBasicInfoID=S.EmpBasicInfoID)		
						FROM #EmployeeSms AS S

						UPDATE S SET TotalSms=(SELECT SUM(NoOfSms) FROM #EmployeeSms AS M )	FROM #EmployeeSms AS S
						SELECT * FROM #EmployeeSms
						drop table #EmployeeList,#EmployeeSms
END
	END

	IF(@Block=3)--aBSENT
	BEGIN
		--SELECT *,REPLACE(@SmsBody,'[StudentName]',FullName) AS SmsBody 
		--FROM #Studentlist WHERE StudentIID NOT IN(SELECT StudentId  FROM [dbo].[Att_StudentAttendance] 
		--WHERE CAST(InTime AS DATE) BETWEEN  CAST(@FromDate AS DATE) AND  CAST(@ToDate AS DATE) AND IsPresent=1 AND IsLeave=0 )
			  declare @rc int=0;
			  declare @index int=1;
			   Create table #day
			   (
			   ID INT IDENTITY(1,1),
			   aDate date
			   )
			    insert into #day select distinct cast(CalendarDate as date) from [dbo].[Att_AcademicCalendar] 
				where DayType='Regular' and CAST(CalendarDate AS DATE)
				BETWEEN  CAST(@FromDate AS DATE) AND  CAST(@ToDate  AS DATE)   
				set @rc =@@ROWCOUNT

			create table #StudentAbsentSms
			(
			 StudentIID bigint not null
			,StudentInsID NVARCHAR(MAX) not null
			,FullName varchar(MAX) null
			,RollNo int not null
			,DestinationNumber NVARCHAR(MAX) NULL
			,SmsBody NVARCHAR(MAX) NULL
			,NoOfSms int null
			,SmsLength int null
			,TotalSms int null			
			,IsSms BIT null		
			,ADate Date null	
			)
		
		WHILE (@index <= @rc)
		 BEGIN

		INSERT INTO #StudentAbsentSms
		SELECT S.StudentIID, S.StudentInsID, S.FullName, S.RollNo, S.DestinationNumber,
		REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@SmsBody,'[StudentName]',S.FullName),'[Roll]',S.RollNo),'[StudentID]',S.StudentInsID),'[Version]',S.VersionName),'[Session]',S.SessionName),'[Branch]',ISNULL(S.BranchName,'')),'[Shift]',ISNULL(S.ShiftName,'')),'[Class]',ISNULL(S.ClassName,'')),'[Group]',ISNULL(S.GroupName,'')),'[Section]',ISNULL(S.SectionName,'')),'[StudentType]',ISNULL(S.StudentTypeName,'')),
		'[AttendanceDate]',(select top 1 convert(varchar(20),aDate,3) from #day where ID=@index ))
		AS SmsBody, 
		0,0,0,0,(select top 1 aDate from #day where ID=@index ) FROM #Studentlist AS S WHERE S.StudentIID NOT IN(SELECT StudentId  FROM [dbo].[Att_StudentAttendance] 
		WHERE CAST(InTime AS DATE) =(select top 1 aDate from #day where ID=@index ) AND IsPresent=1 AND IsLeave=0 )

			--select * from Student_BasicInfo where StudentIID not in 
			--(select  [StudentId] from [Att_StudentAttendance] where cast(InTime as date)=(select * from #day where ID=@index ))

			SET @index=@index+1;
		 END
		
		--	INSERT INTO #StudentAbsentSms
		--SELECT S.StudentIID, S.StudentInsID, S.FullName, S.RollNo, S.DestinationNumber,
		--REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@SmsBody,'[StudentName]',S.FullName),'[Roll]',S.RollNo),'[StudentID]',S.StudentInsID),'[Version]',S.VersionName),'[Session]',S.SessionName),'[Branch]',S.BranchName),'[Shift]',S.ShiftName),'[Class]',S.ClassName),'[Group]',S.GroupName),'[Section]',S.SectionName),'[StudentType]',S.StudentTypeName)	
		--AS SmsBody, 
		--0,0,0,0 FROM #Studentlist AS S WHERE S.StudentIID NOT IN(SELECT StudentId  FROM [dbo].[Att_StudentAttendance] 
		--WHERE CAST(InTime AS DATE) BETWEEN  CAST(@FromDate AS DATE) AND  CAST(@ToDate AS DATE) AND IsPresent=1 AND IsLeave=0 )

		
		UPDATE S SET NoOfSms=(SELECT [dbo].[SMSCounter](M.SmsBody) FROM #StudentAbsentSms AS M WHERE M.StudentIID=S.StudentIID and m.ADate=s.ADate),
		SmsLength= (SELECT LEN(M.SmsBody) FROM #StudentAbsentSms AS M WHERE M.StudentIID=S.StudentIID and m.ADate=s.ADate)		
		FROM #StudentAbsentSms AS S

		UPDATE S SET TotalSms=(SELECT SUM(NoOfSms) FROM #StudentAbsentSms AS M  )	FROM #StudentAbsentSms AS S
		SELECT * FROM #StudentAbsentSms
		DROP TABLE #StudentAbsentSms,#day

	END
	IF(@Block=4) --pERIOD
	BEGIN	
			create table #StudentSmsPeriod
			(
			 StudentIID bigint not null
			,StudentInsID NVARCHAR(MAX) not null
			,FullName varchar(MAX) null
			,RollNo int not null
			,DestinationNumber NVARCHAR(MAX) NULL
			,SmsBody NVARCHAR(MAX) NULL
			,NoOfSms int null
			,SmsLength int null
			,TotalSms int null			
			,IsSms BIT	
			,ADate Date null			
			)
			SELECT DISTINCT  [StudentId], [AttenTime] INTO #AP FROM [dbo].[Att_StudentPeriodAtten] 
			WHERE  CAST([AttenTime] AS DATE) BETWEEN  CAST(@FromDate AS DATE) AND  CAST(@ToDate AS DATE) AND IsDeleted=1
				
					INSERT INTO #StudentSmsPeriod
			SELECT DISTINCT S.StudentIID, S.StudentInsID, S.FullName, S.RollNo, S.DestinationNumber,
			REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@SmsBody,'[StudentName]',S.FullName),'[Roll]',S.RollNo),'[StudentID]',S.StudentInsID),'[Version]',S.VersionName),'[Session]',S.SessionName),'[Branch]',S.BranchName),'[Shift]',S.ShiftName),'[Class]',S.ClassName),'[Group]',S.GroupName),'[Section]',S.SectionName),'[StudentType]',S.StudentTypeName),
			'[Period]',([dbo].[SMSPeriod](A.StudentId,CAST(A.AttenTime AS DATE)))),'[AttendanceDate]',CAST(A.AttenTime AS DATE))
			AS SmsBody,
			0,0,0,0,A.AttenTime FROM #AP A INNER JOIN  #Studentlist S  ON A.StudentId=S.StudentIID
			
			
			UPDATE S SET NoOfSms=(SELECT [dbo].[SMSCounter](M.SmsBody) FROM #StudentSmsPeriod AS M WHERE M.StudentIID=S.StudentIID AND M.ADate=S.ADate),
			SmsLength= (SELECT LEN(M.SmsBody) FROM #StudentSmsPeriod AS M WHERE M.StudentIID=S.StudentIID AND M.ADate=S.ADate)		
			FROM #StudentSmsPeriod AS S

			UPDATE S SET TotalSms=(SELECT SUM(NoOfSms) FROM #StudentSms AS M )	FROM #StudentSmsPeriod AS S
			SELECT * FROM #StudentSmsPeriod
			drop table #StudentSmsPeriod,#AP

			--	SELECT DISTINCT A2.AttenId, 
			--		SUBSTRING(
			--			(
			--				SELECT ','+CAST(P.PeriodShortCode AS VARCHAR(15))  AS [text()]
			--				FROM dbo.[Att_AbscondingDetails] A1  RIGHT JOIN Rtn_ClassPeriod AS P ON A1.PeriodId=P.PeriodId
			--				WHERE A1.AttenId = A2.AttenId
			--				ORDER BY P.PeriodShortCode
			--				FOR XML PATH ('')
			--			), 2, 1000) [Periods]
			--	INTO #Period FROM dbo.[Att_AbscondingDetails] A2
			--	WHERE A2.AttenId IN (SELECT [AttendId]  FROM [dbo].[Att_StudentAttendance] 
			--WHERE CAST(InTime AS DATE) BETWEEN  CAST(@FromDate AS DATE) AND  CAST(@ToDate AS DATE) 			
			--AND IsPresent=1 AND IsLeave=0 AND IsAbsconding=1
			--AND [StudentId] IN (SELECT StudentIID FROM #Studentlist))
						
			----SELECT DISTINCT S.StudentIID,S.VersionID,S.SessionId,S.BranchID,S.ShiftID,S.ClassId,S.GroupId,S.SectionId,S.StudentInsID,
			----S.FullName,S.RollNo,S.DestinationNumber,
			---- REPLACE(REPLACE(@SmsBody,'[StudentName]',FullName),'[Period]',(SELECT TOP 1 P.Periods FROM #Period AS P WHERE P.AttenId=A.AttendId )) AS SmsBody 			
			----FROM #Studentlist S INNER JOIN Att_StudentAttendance A ON S.StudentIID=A.StudentId AND A.IsAbsconding=1 

			--INSERT INTO #StudentSms
			--SELECT DISTINCT S.StudentIID, S.StudentInsID, S.FullName, S.RollNo, S.DestinationNumber,
			--REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@SmsBody,'[StudentName]',S.FullName),'[Roll]',S.RollNo),'[StudentID]',S.StudentInsID),'[Version]',S.VersionName),'[Session]',S.SessionName),'[Branch]',S.BranchName),'[Shift]',S.ShiftName),'[Class]',S.ClassName),'[Group]',S.GroupName),'[Section]',S.SectionName),'[StudentType]',S.StudentTypeName),'[Period]',(SELECT TOP 1 P.Periods FROM #Period AS P WHERE P.AttenId=A.AttendId )),'[AbscondingDate]',CAST(A.InTime AS DATE))
			---- REPLACE(REPLACE(@SmsBody,'[StudentName]',FullName),'[Period]',(SELECT TOP 1 P.Periods FROM #Period AS P WHERE P.AttenId=A.AttendId )) 
			-- AS SmsBody,
			--0,0,0,0 FROM #Studentlist S INNER JOIN Att_StudentAttendance A ON S.StudentIID=A.StudentId AND A.IsAbsconding=1 
		
			--UPDATE S SET NoOfSms=(SELECT [dbo].[SMSCounter](M.SmsBody) FROM #StudentSms AS M WHERE M.StudentIID=S.StudentIID),
			--SmsLength= (SELECT LEN(M.SmsBody) FROM #StudentSms AS M WHERE M.StudentIID=S.StudentIID)		
			--FROM #StudentSms AS S

			--UPDATE S SET TotalSms=(SELECT SUM(NoOfSms) FROM #StudentSms AS M )	FROM #StudentSms AS S
			--SELECT * FROM #StudentSms
			
	END
	IF(@Block=7)
	BEGIN
		IF(@OverAllResult=1)
		BEGIN

			--SELECT *,REPLACE(REPLACE(@SmsBody,'[StudentName]',S.FullName),'[GPA]',R.GPA) AS SmsBody FROM #Studentlist AS S
			--INNER JOIN [Res_MainExamResult] AS R ON S.StudentIID=R.StudentIID AND R.IsPass=1 AND R.MainExamId=@ExamID

		INSERT INTO #StudentSms
		SELECT S.StudentIID, S.StudentInsID, S.FullName, S.RollNo, S.DestinationNumber,
		REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@SmsBody,'[StudentName]',S.FullName),'[Roll]',S.RollNo),'[StudentID]',S.StudentInsID),'[Version]',S.VersionName),'[Session]',S.SessionName),'[Branch]',S.BranchName),'[Shift]',S.ShiftName),'[Class]',S.ClassName),'[Group]',S.GroupName),'[Section]',S.SectionName),'[StudentType]',S.StudentTypeName),
		'[GPA]',R.GPA),'[TotalMark]',CAST(ROUND(R.TotalMarks,0) AS INT)),'[ExamName]',(SELECT TOP 1 MainExamName FROM Res_MainExam WHERE MainExamId=R.MainExamId)),'[Merit]',R.OverAllMerit),'[PassFail]','Pass')		
		AS SmsBody, 
		0,0,0,0 FROM #Studentlist AS S
		INNER JOIN [Res_MainExamResult] AS R ON S.StudentIID=R.StudentIID AND R.IsPass=1 AND R.MainExamId=@ExamID


		UPDATE S SET NoOfSms=(SELECT [dbo].[SMSCounter](M.SmsBody) FROM #StudentSms AS M WHERE M.StudentIID=S.StudentIID),
		SmsLength= (SELECT LEN(M.SmsBody) FROM #StudentSms AS M WHERE M.StudentIID=S.StudentIID)		
		FROM #StudentSms AS S

		UPDATE S SET TotalSms=(SELECT SUM(NoOfSms) FROM #StudentSms AS M )	FROM #StudentSms AS S
		SELECT * FROM #StudentSms

		END
		ELSE IF(@OverAllResult=2)
		BEGIN
			--SELECT *,REPLACE(REPLACE(@SmsBody,'[StudentName]',S.FullName),'[GPA]',R.GPA) AS SmsBody FROM #Studentlist AS S
			--INNER JOIN [Res_MainExamResult] AS R ON S.StudentIID=R.StudentIID AND R.IsPass=0 AND R.MainExamId=@ExamID

		INSERT INTO #StudentSms
		SELECT S.StudentIID, S.StudentInsID, S.FullName, S.RollNo, S.DestinationNumber,
		REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@SmsBody,'[StudentName]',S.FullName),'[Roll]',S.RollNo),'[StudentID]',S.StudentInsID),'[Version]',S.VersionName),'[Session]',S.SessionName),'[Branch]',S.BranchName),'[Shift]',S.ShiftName),'[Class]',S.ClassName),'[Group]',S.GroupName),'[Section]',S.SectionName),'[StudentType]',S.StudentTypeName),
		'[GPA]',R.GPA),'[TotalMark]',CAST(ROUND(R.TotalMarks,0) AS INT)),'[ExamName]',(SELECT TOP 1 MainExamName FROM Res_MainExam WHERE MainExamId=R.MainExamId)),'[Merit]',R.OverAllMerit),'[PassFail]','Fail')
		,'[FailSubjectName]',
		   STUFF (
        (SELECT   
                ',' +ss.ShortName  
        FROM dbo.Res_MainExamResultSubjectDetails mmss 
			  INNER JOIN  dbo.Res_SubjectSetup ss on ss.SubID=mmss.SubjectID
			  where mmss.StudentIID= s.StudentIID and mmss.SubjectIsPass=0 and mmss.MainExamId=30
			
        FOR XML PATH('')), 1, 1, ''
    )),'[FailSubjectMark]',
	STUFF (
        (SELECT   
                ',' +CONVERT(varchar, mmss.SubjectConvertedMarks)
        FROM dbo.Res_MainExamResultSubjectDetails mmss 
			  
			  where mmss.StudentIID= s.StudentIID and mmss.SubjectIsPass=0 and mmss.MainExamId=30
			 
        FOR XML PATH('')), 1, 1, '')	
		)		
		AS SmsBody, 
		0,0,0,0 FROM #Studentlist AS S
		INNER JOIN [Res_MainExamResult] AS R ON S.StudentIID=R.StudentIID AND R.IsPass=0 AND R.MainExamId=@ExamID
		
		UPDATE S SET NoOfSms=(SELECT [dbo].[SMSCounter](M.SmsBody) FROM #StudentSms AS M WHERE M.StudentIID=S.StudentIID),
		SmsLength= (SELECT LEN(M.SmsBody) FROM #StudentSms AS M WHERE M.StudentIID=S.StudentIID)		
		FROM #StudentSms AS S

		UPDATE S SET TotalSms=(SELECT SUM(NoOfSms) FROM #StudentSms AS M )	FROM #StudentSms AS S
		SELECT * FROM #StudentSms
		END
		
	END
	IF(@Block=8)
	BEGIN
		IF(@OverAllResult=1)
		BEGIN
			--SELECT *,REPLACE(REPLACE(@SmsBody,'[StudentName]',S.FullName),'[GPA]',R.GPA) AS SmsBody FROM #Studentlist AS S
			--INNER JOIN [dbo].[Res_GrandResult] AS R ON S.StudentIID=R.StudentIID AND R.IsPass=1 AND R.GrandExamId=@ExamID

			INSERT INTO #StudentSms
		SELECT S.StudentIID, S.StudentInsID, S.FullName, S.RollNo, S.DestinationNumber,
		REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@SmsBody,'[StudentName]',S.FullName),'[Roll]',S.RollNo),'[StudentID]',S.StudentInsID),'[Version]',S.VersionName),'[Session]',S.SessionName),'[Branch]',S.BranchName),'[Shift]',S.ShiftName),'[Class]',S.ClassName),'[Group]',S.GroupName),'[Section]',S.SectionName),'[StudentType]',S.StudentTypeName),
		'[GPA]',R.GPA),'[TotalMark]',CAST(ROUND(R.TotalMarks,0) AS INT)),'[ExamName]',(SELECT TOP 1 MainExamName FROM Res_MainExam WHERE MainExamId=R.GrandExamId)),'[Merit]',R.OverAllMerit),'[PassFail]','Pass')			
		AS SmsBody, 
		0,0,0,0 FROM #Studentlist AS S
		INNER JOIN [dbo].[Res_GrandResult] AS R ON S.StudentIID=R.StudentIID AND R.IsPass=1 AND R.GrandExamId=@ExamID	


		UPDATE S SET NoOfSms=(SELECT [dbo].[SMSCounter](M.SmsBody) FROM #StudentSms AS M WHERE M.StudentIID=S.StudentIID),
		SmsLength= (SELECT LEN(M.SmsBody) FROM #StudentSms AS M WHERE M.StudentIID=S.StudentIID)		
		FROM #StudentSms AS S


		UPDATE S SET TotalSms=(SELECT SUM(NoOfSms) FROM #StudentSms AS M )	FROM #StudentSms AS S
		SELECT * FROM #StudentSms
		END
		ELSE IF(@OverAllResult=2)
		BEGIN
			--SELECT *,REPLACE(REPLACE(@SmsBody,'[StudentName]',S.FullName),'[GPA]',R.GPA) AS SmsBody FROM #Studentlist AS S
			--INNER JOIN [dbo].[Res_GrandResult] AS R ON S.StudentIID=R.StudentIID AND R.IsPass=0 AND R.GrandExamId=@ExamID

				INSERT INTO #StudentSms
		SELECT S.StudentIID, S.StudentInsID, S.FullName, S.RollNo, S.DestinationNumber,
		REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@SmsBody,'[StudentName]',S.FullName),'[Roll]',S.RollNo),'[StudentID]',S.StudentInsID),'[Version]',S.VersionName),'[Session]',S.SessionName),'[Branch]',S.BranchName),'[Shift]',S.ShiftName),'[Class]',S.ClassName),'[Group]',S.GroupName),'[Section]',S.SectionName),'[StudentType]',S.StudentTypeName),
		'[GPA]',R.GPA),'[TotalMark]',CAST(ROUND(R.TotalMarks,0) AS INT)),'[ExamName]',(SELECT TOP 1 MainExamName FROM Res_MainExam WHERE MainExamId=R.GrandExamId)),'[Merit]',R.OverAllMerit),'[PassFail]','Fail')
		,'[GR_FailSubjectName]',
		   STUFF (
        (SELECT   
                ',' +ss.ShortName  
        FROM dbo.Res_GrandResultSubjectDetails mmss 
			  INNER JOIN  dbo.Res_SubjectSetup ss on ss.SubID=mmss.SubjectID
			  where mmss.StudentIID= s.StudentIID and mmss.SubjectIsPass=0 and mmss.MainExamId=30
			
        FOR XML PATH('')), 1, 1, ''
    )),'[GR_FailSubjectMark]',
	STUFF (
        (SELECT   
                ',' +CONVERT(varchar, mmss.SubjectConvertedMarks)
        FROM dbo.Res_GrandResultSubjectDetails mmss 
			  where mmss.StudentIID= s.StudentIID and mmss.SubjectIsPass=0 and mmss.MainExamId=30
        FOR XML PATH('')), 1, 1, '')	
		)	AS SmsBody, 
		0,0,0,0 FROM #Studentlist AS S
		INNER JOIN [dbo].[Res_GrandResult] AS R ON S.StudentIID=R.StudentIID AND R.IsPass=0 AND R.GrandExamId=@ExamID
		
		UPDATE S SET NoOfSms=(SELECT [dbo].[SMSCounter](M.SmsBody) FROM #StudentSms AS M WHERE M.StudentIID=S.StudentIID),
		SmsLength= (SELECT LEN(M.SmsBody) FROM #StudentSms AS M WHERE M.StudentIID=S.StudentIID)		
		FROM #StudentSms AS S

		UPDATE S SET TotalSms=(SELECT SUM(NoOfSms) FROM #StudentSms AS M )	FROM #StudentSms AS S
		SELECT * FROM #StudentSms
		END
		
	END
	IF(@Block=9) --pERIOD
	BEGIN	
			create table #StudentSmsAbosconding
			(
			 StudentIID bigint not null
			,StudentInsID NVARCHAR(MAX) not null
			,FullName varchar(MAX) null
			,RollNo int not null
			,DestinationNumber NVARCHAR(MAX) NULL
			,SmsBody NVARCHAR(MAX) NULL
			,NoOfSms int null
			,SmsLength int null
			,TotalSms int null			
			,IsSms BIT	
			,ADate Date null			
			)
			SELECT  [StudentId], [InTime],AbscondingPeriod INTO #APP FROM [dbo].[Att_StudentAttendance] asd where IsAbsconding=1 
			
			and  CAST([asd].InTime AS DATE) BETWEEN  CAST(@FromDate AS DATE) AND  CAST(@ToDate AS DATE) AND asd.IsDeleted=0
					INSERT INTO #StudentSmsAbosconding
			SELECT DISTINCT S.StudentIID, S.StudentInsID, S.FullName, S.RollNo, S.DestinationNumber,
			REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@SmsBody,'[StudentName]',S.FullName),'[Roll]',S.RollNo),'[StudentID]',S.StudentInsID),'[Version]',S.VersionName),'[Session]',S.SessionName),'[Branch]',S.BranchName),'[Shift]',S.ShiftName),'[Class]',S.ClassName),'[Group]',S.GroupName),'[Section]',S.SectionName),'[StudentType]',S.StudentTypeName),
			'[AbscondingPeriod]',a.AbscondingPeriod),'[AbscondingDate]',FORMAT( Convert(date, A.InTime, 103),'dd/MM/yyyy'))
			AS SmsBody,
			0,0,0,0,A.InTime FROM #APP A INNER JOIN  #Studentlist S  ON A.StudentId=S.StudentIID
			
			UPDATE S SET NoOfSms=(SELECT [dbo].[SMSCounter](M.SmsBody) FROM #StudentSmsAbosconding AS M WHERE M.StudentIID=S.StudentIID AND M.ADate=S.ADate),
			SmsLength= (SELECT LEN(M.SmsBody) FROM #StudentSmsAbosconding AS M WHERE M.StudentIID=S.StudentIID AND M.ADate=S.ADate)		
			FROM #StudentSmsAbosconding AS S

			UPDATE S SET TotalSms=(SELECT SUM(NoOfSms) FROM #StudentSms AS M )	FROM #StudentSmsAbosconding AS S
			SELECT * FROM #StudentSmsAbosconding
			drop table #StudentSmsPeriod,#AP

	END
	DROP TABLE #StudentSms,#StudentList


--EXEC GetStudentInfoForStaticSMS
GO


--Dear Parents,
--2nd Term Exam result published. Your child [StudentName] got GPA [GPA],Report card is given. Please inform if any query.
-- Regards;
-- Headmaster, 
--Tap Bidyut School
