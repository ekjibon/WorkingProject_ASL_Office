IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetTermWiseResult]'))
BEGIN
DROP PROCEDURE  rptGetTermWiseResult
END
GO
/****** Object:  StoredProcedure [dbo].[ClassWiseResultProcess]    Script Date: 5/21/2019 3:41:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--TermId=29&SessionId=11&ClassId=19&StuId=4414&MainExamId=1061&BranchID=8
-- EXEC  [dbo].[rptGetTermWiseResult]  1,30,20,11,4435,1062
Create Procedure [dbo].[rptGetTermWiseResult]  
    @Block INT ,
	@TermId INT ,
	@ClassId INT ,
	@SessionId INT ,
	@StuIds VARCHAR(1000),
	@MainExamId INT = 0
AS
BEGIN
IF 1=0 BEGIN
    SET FMTONLY OFF
END
SELECT value  INTO #StuId
FROM STRING_SPLIT(@StuIds, ',')  
Declare @startdate datetime,@endDate datetime ,@WorkingDays decimal
select  @startdate=startDate ,@endDate=endDate from dbo.Res_Terms where TermId=@TermId

	Create table #att (
	StudentId int,
	Tpresent int,
	Tworking int,
	TPersentage decimal
	)

IF(@Block=1) -- FOR Teacher Portal
BEGIN


SELECT @WorkingDays = COUNT(*)  FROM Att_AcademicCalendar WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @startdate AS DATE) AND CAST( @endDate AS DATE) 
INSERT into #att  
	SELECT  StudentId, COUNT(*),@WorkingDays,(COUNT(*)*@WorkingDays)/100 from dbo.Att_StudentAttendance where IsPresent=1 and StudentId IN (SELECT * FROM #StuId) 
			 AND CAST(InTime  AS DATE) BETWEEN CAST( @startdate AS DATE) AND CAST( @endDate AS DATE) group by StudentId


	SELECT DISTINCT sb.StudentIID
		,sb.ClassId, SB.StudentInsID,SB.FullName,Sb.RollNo,cl.ClassName+' ('+sect.SectionName+')' AS ClassName,ses.SessionName, t.Name TermName,ss.SubjectName,
		   --,SR.SubExamIsPass
		   T.startDate,t.endDate,
		   acs.Name AssesmentName,ascs.Comments,ss.ReportSerialNo,ss.IsCompulsory,ss.IsECA,ss.IsICT,
			crc.TeacherComments,crc.HeadTeacherComments,ss.SubID,t.startDate,t.endDate,att.Tworking AttworkingDays ,att.TPersentage AttPersentage,att.Tpresent AttPresent
			, ss.ReportSerialNo,acs.[Order] as AssesmentOrder
FROM  Student_BasicInfo SB  
	INNER JOIN dbo.Ins_ClassInfo CL ON CL.ClassId = SB.ClassId 
	INNER JOIN dbo.Res_MainExam M ON M.MainExamId = @MainExamId
	INNER JOIN dbo.Res_Terms T ON T.TermId = M.TermId
	INNER JOIN dbo.Res_SubjectSetup ss on ss.ClassId=CL.ClassId AND ss.SessionId = SB.SessionId
	INNER JOIN dbo.Ins_Session ses on ses.SessionId =SB.SessionId
	INNER JOIN dbo.Ins_Section sect on sect.SectionId =SB.SectionId
	INNER JOIN #att att on att.StudentId=SB.StudentIID
	INNER JOIN  dbo.Res_AssessmentSubSetup acs on acs.MainExamId=@MainExamId and acs.TermId=t.TermId and acs.IsDeleted=0  and acs.SubjectId=ss.SubID 
	and acs.Name is not null
	INNER JOIN dbo.Res_AssessmentStudent ascs on acs.Id=ascs.AssessmentId and ascs.IsDeleted=0 and ascs.StudentId=SB.StudentIID and ascs.SubjectId=ss.SubID 
	INNER JOIN dbo.Res_ClassResultComments crc on crc.StudentId=ascs.StudentId and crc.MainExamId=ascs.MainExamId and crc.TermId=@TermId
	INNER JOIN dbo.Att_StudentAttendance ast on ast.StudentId=sb.StudentIID and (CAST(ast.InTime AS DATE) BETWEEN CAST(t.startDate AS DATE) AND CAST(t.endDate AS DATE))

	WHERE M.TermId=@TermId and  sb.ClassId=@ClassId and SB.StudentIID IN (SELECT * FROM #StuId) AND ss.IsDeleted = 0
	--order by ss.ReportSerialNo ASC
	order by ss.ReportSerialNo,acs.[Order] ASC

	SELECT Distinct ascs.StudentId,  acs.Name AssesmentName,acs.[Order], ascs.Comments,ascs.Grade,
	crc.TeacherComments,crc.HeadTeacherComments,crc.ReportGLComments,crc.FailSubComments
	 from    dbo.Res_AssessmentClassSetUp acs
	INNER JOIN dbo.Res_AssessmentClassStudent ascs on acs.Id=ascs.AssesmentClassId
	INNER JOIN dbo.Res_ClassResultComments crc on crc.StudentId=ascs.StudentId and crc.MainExamId=ascs.MainExamId and crc.TermId=@TermId
	WHERE  acs.TermId=@TermId  and acs.MainExamId=@MainExamId and ascs.StudentId IN (SELECT * FROM #StuId)
	ORDER by acs.[Order]
	

	SELECT DISTINCT  asst.StudentId,asst.SubjectId, ass.Name AssesmentName,asst.Comments 
	from dbo.Res_AssessmentStudent asst
	INNER JOIN dbo.Res_AssessmentSubSetup ass on ass.Id= asst.AssessmentId
	WHERE asst.StudentId IN (SELECT * FROM #StuId)  and asst.MainExamId =@MainExamId
	ORDER BY asst.StudentId,asst.SubjectId
	

END
IF(@Block=2) -- FOR Teacher Portal Without PG To KAG Report 
BEGIN



		SELECT @WorkingDays = COUNT(*)  FROM Att_AcademicCalendar WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @startdate AS DATE) AND CAST( @endDate AS DATE) 
		insert into #att  
		select StudentId, COUNT(*),@WorkingDays,(COUNT(*)*@WorkingDays)/100 from dbo.Att_StudentAttendance where IsPresent=1 and StudentId IN (SELECT * FROM #StuId) 
		 AND CAST(InTime  AS DATE) BETWEEN CAST( @startdate AS DATE) AND CAST( @endDate AS DATE) group by StudentId

		
		SELECT DISTINCT SR.SubjectID, sb.StudentIID,sr.MainExamId,mms.TermId,sb.ClassId, SB.StudentInsID,SB.FullName,Sb.RollNo,cl.ClassName+' ('+sect.SectionName+')' AS ClassName,ses.SessionName, t.Name TermName,ss.SubjectName,
		SR.SubjectConvertedMarks,SR.SubjectConvertedMarksFraction , SR.SubjectObtMarks,sr.SubjectGL--,SR.SubExamIsPass
		, MER.TotalWithECA,MER.TotalWithECAPercent,MER.TotalWithOutECA,MER.TotalWithOutECAPercent, MER.GPA,MER.GradeLetter,Mer.GLWithOutECA, t.startDate,t.endDate,
		 acs.Name AssesmentName,ascs.Comments,ss.ReportSerialNo,ss.IsCompulsory,ss.IsECA,ss.IsICT,
		crc.TeacherComments,crc.HeadTeacherComments,ss.SubID,t.startDate,t.endDate,att.Tworking AttworkingDays ,att.TPersentage AttPersentage,att.Tpresent AttPresent
		, ss.ReportSerialNo,acs.[Order] as AssesmentOrder
		FROM Res_MainExamResultSubjectDetails SR 
		INNER JOIN Student_BasicInfo SB ON SB.StudentIID = SR.StudentIID 
		INNER JOIN dbo.Ins_ClassInfo CL ON CL.ClassId = SB.ClassId 
		INNER JOIN dbo.Res_MainExam M ON M.MainExamId = SR.MainExamId
		INNER JOIN dbo.Res_MainExamMarkSetup MMS on MMS.MainExamId=sr.MainExamId and MMS.MainExamSubjectID=SR.SubjectID
		INNER JOIN dbo.Res_Terms T ON T.TermId = MMS.TermId
		INNER JOIN dbo.Res_SubjectSetup ss on ss.SubID=sr.SubjectID
		INNER JOIN dbo.Ins_Session ses on ses.SessionId =SB.SessionId
		INNER JOIN dbo.Ins_Section sect on sect.SectionId =SB.SectionId
		Left JOIN #att att on att.StudentId=sr.StudentIID
		LEFT JOIN dbo.Res_MainExamResult MER on MER.StudentIID=SR.StudentIID and MER.MainExamId=Sr.MainExamId 
		left JOIN  dbo.Res_AssessmentSubSetup acs on acs.MainExamId=sr.MainExamId and acs.TermId=t.TermId and acs.IsDeleted=0  and acs.SubjectId=sr.SubjectID 
		and acs.Name is not null
		INNER JOIN dbo.Res_AssessmentStudent ascs on acs.Id=ascs.AssessmentId and ascs.IsDeleted=0 and ascs.StudentId=sr.StudentIID and ascs.SubjectId=sr.SubjectID 
		left JOIN dbo.Res_ClassResultComments crc on crc.StudentId=ascs.StudentId and crc.MainExamId=ascs.MainExamId and crc.TermId=@TermId
		Left JOIN dbo.Att_StudentAttendance ast on ast.StudentId=sb.StudentIID and (CAST(ast.InTime AS DATE) BETWEEN CAST(t.startDate AS DATE) AND CAST(t.endDate AS DATE))

		--INNer JOIN dbo.Res_AssignSubjectsToTeacher ast on ast.SubjectID=ss.SubID
		WHERE MMS.TermId=@TermId  AND sb.ClassId=@ClassId and SB.StudentIID IN (SELECT * FROM #StuId) AND ss.IsDeleted = 0
		order by ss.ReportSerialNo

		select distinct ascs.StudentId,  acs.Name AssesmentName,acs.[Order], ascs.Comments,ascs.Grade,
		crc.TeacherComments,crc.HeadTeacherComments,crc.ReportGLComments,crc.FailSubComments
		 from    dbo.Res_AssessmentClassSetUp acs
		left JOIN dbo.Res_AssessmentClassStudent ascs on acs.Id=ascs.AssesmentClassId
		left JOIN dbo.Res_ClassResultComments crc on crc.StudentId=ascs.StudentId and crc.MainExamId=ascs.MainExamId and crc.TermId=@TermId
		where  acs.TermId=@TermId  and acs.MainExamId=@MainExamId and ascs.StudentId IN (SELECT * FROM #StuId)
		Order by acs.[Order]
			SELECT  asst.StudentId,asst.SubjectId, ass.Name AssesmentName,asst.Comments,ass.[Order] 
				from dbo.Res_AssessmentStudent asst
				INNER JOIN dbo.Res_AssessmentSubSetup ass on ass.Id=asst.AssessmentId
			WHERE asst.StudentId IN (SELECT * FROM #StuId)  and asst.MainExamId =@MainExamId
			order by asst.StudentId,asst.SubjectId
END



IF(@Block=3) -- FOR Student Portal  PG To KAG Report  EXEC  [dbo].[rptGetTermWiseResult]   3,30,20,11,4435,1062
BEGIN


SELECT @WorkingDays = COUNT(*)  FROM Att_AcademicCalendar WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @startdate AS DATE) AND CAST( @endDate AS DATE) 
INSERT into #att  
	SELECT  StudentId, COUNT(*),@WorkingDays,(COUNT(*)*@WorkingDays)/100 from dbo.Att_StudentAttendance where IsPresent=1 and StudentId IN (SELECT * FROM #StuId) 
			 AND CAST(InTime  AS DATE) BETWEEN CAST( @startdate AS DATE) AND CAST( @endDate AS DATE) group by StudentId

SELECT DISTINCT sb.StudentIID
		,sb.ClassId, SB.StudentInsID,SB.FullName,Sb.RollNo,cl.ClassName+' ('+sect.SectionName+')' AS ClassName,ses.SessionName, t.Name TermName,ss.SubjectName,
		   --,SR.SubExamIsPass
		   T.startDate,t.endDate,
		   acs.Name AssesmentName,ascs.Comments,ss.ReportSerialNo,ss.IsCompulsory,ss.IsECA,ss.IsICT,
			crc.TeacherComments,crc.HeadTeacherComments,ss.SubID,t.startDate,t.endDate,att.Tworking AttworkingDays ,att.TPersentage AttPersentage,att.Tpresent AttPresent
			, ss.ReportSerialNo,acs.[Order] as AssesmentOrder
FROM  Student_BasicInfo SB  
	INNER JOIN dbo.Ins_ClassInfo CL ON CL.ClassId = SB.ClassId 
	INNER JOIN dbo.Res_MainExam M ON M.MainExamId = @MainExamId
	INNER JOIN dbo.Res_Terms T ON T.TermId = M.TermId
	INNER JOIN dbo.Res_SubjectSetup ss on ss.ClassId=CL.ClassId AND ss.SessionId = SB.SessionId
	INNER JOIN dbo.Ins_Session ses on ses.SessionId =SB.SessionId
	INNER JOIN dbo.Ins_Section sect on sect.SectionId =SB.SectionId
	INNER JOIN #att att on att.StudentId=SB.StudentIID
	INNER JOIN  dbo.Res_AssessmentSubSetup acs on acs.MainExamId=@MainExamId and acs.TermId=t.TermId and acs.IsDeleted=0  and acs.SubjectId=ss.SubID 
	and acs.Name is not null
	INNER JOIN dbo.Res_AssessmentStudent ascs on acs.Id=ascs.AssessmentId and ascs.IsDeleted=0 and ascs.StudentId=SB.StudentIID and ascs.SubjectId=ss.SubID 
	INNER JOIN dbo.Res_ClassResultComments crc on crc.StudentId=ascs.StudentId and crc.MainExamId=ascs.MainExamId and crc.TermId=@TermId
	INNER JOIN dbo.Att_StudentAttendance ast on ast.StudentId=sb.StudentIID and (CAST(ast.InTime AS DATE) BETWEEN CAST(t.startDate AS DATE) AND CAST(t.endDate AS DATE))

	WHERE M.TermId=@TermId and   sb.ClassId=@ClassId and SB.StudentIID =@StuIds AND ss.IsDeleted = 0
	AND SB.StudentIID IN( select StudentIID from Res_MainExamResult where  MainExamId=@MainExamId and StudentIID=@StuIds and IsPublished=1)
	order by ss.ReportSerialNo,acs.[Order] ASC


			SELECT Distinct ascs.StudentId,  acs.Name AssesmentName,acs.[Order], ascs.Comments,ascs.Grade,
	crc.TeacherComments,crc.HeadTeacherComments,crc.ReportGLComments,crc.FailSubComments
	 from    dbo.Res_AssessmentClassSetUp acs
	INNER JOIN dbo.Res_AssessmentClassStudent ascs on acs.Id=ascs.AssesmentClassId
	INNER JOIN dbo.Res_ClassResultComments crc on crc.StudentId=ascs.StudentId and crc.MainExamId=ascs.MainExamId and crc.TermId=@TermId
	WHERE  acs.TermId=@TermId  and acs.MainExamId=@MainExamId and ascs.StudentId = @StuIds
	AND ascs.StudentId IN( select StudentIID from Res_MainExamResult where  MainExamId=@MainExamId and StudentIID=@StuIds and IsPublished=1)
	ORDER by acs.[Order]
	

	SELECT DISTINCT  asst.StudentId,asst.SubjectId, ass.Name AssesmentName,asst.Comments 
	from dbo.Res_AssessmentStudent asst
	INNER JOIN dbo.Res_AssessmentSubSetup ass on ass.Id= asst.AssessmentId
	WHERE asst.StudentId = @StuIds  and asst.MainExamId =@MainExamId
	AND asst.StudentId IN( select StudentIID from Res_MainExamResult where  MainExamId=@MainExamId and StudentIID=@StuIds and IsPublished=1)
	ORDER BY asst.StudentId,asst.SubjectId


END
IF(@Block=4) -- FOR Student Portal Without PG To KAG Report  EXEC  [dbo].[rptGetTermWiseResult]  4,19,22,11,4556,0
BEGIN



		SELECT @WorkingDays = COUNT(*)  FROM Att_AcademicCalendar WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @startdate AS DATE) AND CAST( @endDate AS DATE) 
		insert into #att  
		select StudentId, COUNT(*),@WorkingDays,(COUNT(*)*@WorkingDays)/100 from dbo.Att_StudentAttendance where IsPresent=1 and StudentId IN (SELECT * FROM #StuId) 
		 AND CAST(InTime  AS DATE) BETWEEN CAST( @startdate AS DATE) AND CAST( @endDate AS DATE) group by StudentId

		
		SELECT DISTINCT SR.SubjectID, sb.StudentIID,sr.MainExamId,mms.TermId,sb.ClassId, SB.StudentInsID,SB.FullName,Sb.RollNo,cl.ClassName+' ('+sect.SectionName+')' AS ClassName,ses.SessionName, t.Name TermName,ss.SubjectName,
		SR.SubjectConvertedMarks,SR.SubjectConvertedMarksFraction , SR.SubjectObtMarks,sr.SubjectGL--,SR.SubExamIsPass
		, MER.TotalWithECA,MER.TotalWithECAPercent,MER.TotalWithOutECA,MER.TotalWithOutECAPercent, MER.GPA,MER.IsPublished,MER.GradeLetter,Mer.GLWithOutECA, t.startDate,t.endDate,
		 acs.Name AssesmentName,ascs.Comments,ss.ReportSerialNo,ss.IsCompulsory,ss.IsECA,ss.IsICT,
		crc.TeacherComments,crc.HeadTeacherComments,ss.SubID,t.startDate,t.endDate,att.Tworking AttworkingDays ,att.TPersentage AttPersentage,att.Tpresent AttPresent
		, ss.ReportSerialNo,acs.[Order] as AssesmentOrder
		FROM Res_MainExamResultSubjectDetails SR 
		INNER JOIN Student_BasicInfo SB ON SB.StudentIID = SR.StudentIID 
		INNER JOIN dbo.Ins_ClassInfo CL ON CL.ClassId = SB.ClassId 
		INNER JOIN dbo.Res_MainExam M ON M.MainExamId = SR.MainExamId
		INNER JOIN dbo.Res_MainExamMarkSetup MMS on MMS.MainExamId=sr.MainExamId and MMS.MainExamSubjectID=SR.SubjectID
		INNER JOIN dbo.Res_Terms T ON T.TermId = MMS.TermId
		INNER JOIN dbo.Res_SubjectSetup ss on ss.SubID=sr.SubjectID
		INNER JOIN dbo.Ins_Session ses on ses.SessionId =SB.SessionId
		INNER JOIN dbo.Ins_Section sect on sect.SectionId =SB.SectionId
		Left JOIN #att att on att.StudentId=sr.StudentIID
		LEFT JOIN dbo.Res_MainExamResult MER on MER.StudentIID=SR.StudentIID and MER.MainExamId=Sr.MainExamId 
		left JOIN  dbo.Res_AssessmentSubSetup acs on acs.MainExamId=sr.MainExamId and acs.TermId=t.TermId and acs.IsDeleted=0  and acs.SubjectId=sr.SubjectID 
		and acs.Name is not null
		INNER JOIN dbo.Res_AssessmentStudent ascs on acs.Id=ascs.AssessmentId and ascs.IsDeleted=0 and ascs.StudentId=sr.StudentIID and ascs.SubjectId=sr.SubjectID 
		left JOIN dbo.Res_ClassResultComments crc on crc.StudentId=ascs.StudentId and crc.MainExamId=ascs.MainExamId and crc.TermId=@TermId
		Left JOIN dbo.Att_StudentAttendance ast on ast.StudentId=sb.StudentIID and (CAST(ast.InTime AS DATE) BETWEEN CAST(t.startDate AS DATE) AND CAST(t.endDate AS DATE))

		--INNer JOIN dbo.Res_AssignSubjectsToTeacher ast on ast.SubjectID=ss.SubID
		WHERE MMS.TermId=@TermId  AND sb.ClassId=@ClassId and SB.StudentIID IN (SELECT * FROM #StuId) AND ss.IsDeleted = 0 AND MER.IsPublished = 1
		order by ss.ReportSerialNo

		select distinct ascs.StudentId,  acs.Name AssesmentName,acs.[Order], ascs.Comments,ascs.Grade,
		crc.TeacherComments,crc.HeadTeacherComments,crc.ReportGLComments,crc.FailSubComments
		 from    dbo.Res_AssessmentClassSetUp acs
		left JOIN dbo.Res_AssessmentClassStudent ascs on acs.Id=ascs.AssesmentClassId
		left JOIN dbo.Res_ClassResultComments crc on crc.StudentId=ascs.StudentId and crc.MainExamId=ascs.MainExamId and crc.TermId=@TermId
		where  acs.TermId=@TermId  and acs.MainExamId=@MainExamId and ascs.StudentId IN (SELECT * FROM #StuId)
		AND ascs.StudentId IN( select StudentIID from Res_MainExamResult where  MainExamId=@MainExamId and StudentIID=@StuIds and IsPublished=1)
		Order by acs.[Order]
			SELECT  asst.StudentId,asst.SubjectId, ass.Name AssesmentName,asst.Comments,ass.[Order] 
				from dbo.Res_AssessmentStudent asst
				INNER JOIN dbo.Res_AssessmentSubSetup ass on ass.Id=asst.AssessmentId
			WHERE asst.StudentId IN (SELECT * FROM #StuId)  and asst.MainExamId =@MainExamId
			AND asst.StudentId IN( select StudentIID from Res_MainExamResult where  MainExamId=@MainExamId and StudentIID=@StuIds and IsPublished=1)
			order by asst.StudentId,asst.SubjectId




END
END


--EXEC  [dbo].[rptGetTermWiseResult]  4,19,22,11,4556,1037