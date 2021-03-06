IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetClassWiseResult]'))
BEGIN
DROP PROCEDURE  rptGetClassWiseResult
END
GO
/****** Object:  StoredProcedure [dbo].[ClassWiseResultProcess]    Script Date: 5/21/2019 3:41:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC rptGetClassWiseResult 11,29,11,4969
Create Procedure [dbo].[rptGetClassWiseResult]  
	@TermId INT ,
	@ClassId INT ,
	@SessionId INT ,
	@StuIds VARCHAR(1000)
AS
BEGIN
IF 1=0 BEGIN
    SET FMTONLY OFF
END

	SELECT value  INTO #StuId
		FROM STRING_SPLIT(@StuIds, ',')  

		DECLARE @MainExamId INT,@startdate DATETIME,@endDate DATETIME ,@WorkingDays INT
	SELECT  @startdate=startDate ,@endDate=endDate FROM dbo.Res_Terms WHERE TermId=@TermId
	SELECT TOP 1 @MainExamId= MainExamId FROM dbo.Res_MainExam WHERE ClassId=@ClassId and SessionId=@SessionId and TermId=@TermId AND IsDeleted = 0
	PRINT 'HI' + CAST(@MainExamId AS VARCHAR(MAX))



	SELECT dbo.GetStudentTotalSub(SB.StudentIID,@MainExamId) AS SubTotalMark,sb.StudentIID,sr.MainExamId,mms.TermId,sb.ClassId, SB.StudentInsID,SB.FullName,Sb.RollNo,cl.ClassName+' ('+sect.SectionName+')' AS ClassName,ses.SessionName, t.Name TermName,ss.SubjectName,
		SR.SubjectConvertedMarks,SR.SubjectConvertedMarksFraction ,SR.SubjectID, SR.SubjectObtMarks,sr.SubjectGL--,SR.SubExamIsPass
		,MER.TotalWithECA,MER.TotalWithECAPercent,MER.TotalWithOutECA,MER.TotalWithOutECAPercent, MER.GPA,MER.GradeLetter,Mer.GLWithOutECA, t.startDate,t.endDate,
		acs.[Name] AssesmentName,ascs.Comments,ascs.Grade,ss.ReportSerialNo,ss.IsCompulsory,ss.IsECA,ss.IsICT,
		crc.TeacherComments,crc.HeadTeacherComments,crc.ReportGLComments, ss.SubID,t.startDate,t.endDate,
		--(SELECT FullName FROM Emp_BasicInfo INNER JOIN Res_AssignSubjectsToTeacher ON   WHERE Emp_BasicInfo.EmpBasicInfoID=TeacherID) ASEMPFullName 
		emp.FullName as EMPFullName,
		((SELECT  COUNT(*) FROM dbo.Res_MainExamMarkSetup R 
		INNER JOIN dbo.Res_StudentSubject SS ON SS.SubjectID = R.MainExamSubjectID AND SS.TermId = @TermId
		INNER JOIN dbo.Res_SubjectSetup SP ON SP.SubID = SS.SubjectID AND SP.ClassId=SS.ClassId
		WHERE SS.StudentID =  SR.StudentIID AND R.IsDeleted = 0 AND R.MainExamId = @MainExamId AND SP.IsECA=0)*100)SubTotalMarkWithOutECA
	FROM Res_MainExamResultSubjectDetails SR 
		INNER JOIN Student_BasicInfo SB ON SB.StudentIID = SR.StudentIID 
		INNER JOIN dbo.Ins_ClassInfo CL ON CL.ClassId = SB.ClassId 
		INNER JOIN dbo.Res_MainExam M ON M.MainExamId = SR.MainExamId
		INNER JOIN dbo.Res_MainExamMarkSetup MMS on MMS.MainExamId=sr.MainExamId and MMS.MainExamSubjectID=SR.SubjectID
		INNER JOIN dbo.Res_Terms T ON T.TermId = MMS.TermId and t.IsDeleted=0
		INNER JOIN dbo.Res_SubjectSetup ss on ss.SubID=sr.SubjectID
		INNER JOIN dbo.Ins_Session ses on ses.SessionId =SB.SessionId
		INNER JOIN dbo.Ins_Section sect on sect.SectionId =SB.SectionId
		LEFT JOIN dbo.Res_MainExamResult MER on MER.StudentIID=SR.StudentIID and MER.MainExamId=Sr.MainExamId 
		left JOIN  dbo.Res_AssessmentClassSetUp acs on acs.MainExamId=sr.MainExamId and acs.TermId=t.TermId 
		left JOIN dbo.Res_AssessmentClassStudent ascs on acs.Id=ascs.AssesmentClassId
		left JOIN dbo.Res_ClassResultComments crc on crc.StudentId=ascs.StudentId and crc.MainExamId=ascs.MainExamId
		--Left JOIN dbo.Att_StudentAttendance ast on ast.StudentId=sb.StudentIID and (CAST(ast.InTime AS DATE) BETWEEN CAST(t.startDate AS DATE) AND CAST(t.endDate AS DATE))
		LEFT JOIN dbo.Emp_ClassTeacher ECT on ECT.SessionId = SB.SessionId AND ECT.SectionId = SB.SectionId AND ECT.ClassId = SB.ClassId AND ECT.BranchId = SB.BranchID AND ECT.ShiftId = SB.ShiftID
		Left JOIN dbo.Emp_BasicInfo emp on emp.EmpBasicInfoID=ECT.TeacherID
	WHERE  MMS.TermId=@TermId and sb.ClassId=@ClassId and SB.StudentIID IN (SELECT * FROM #StuId) 
	ORDER BY ss.ReportSerialNo

	CREATE TABLE #att 
	(
	StudentId INT,
	Tpresent INT,
	Tworking INT,
	TPersentage DECIMAL
	)
	SELECT @WorkingDays = COUNT(*)  FROM Att_AcademicCalendar WHERE DayType= 'Regular' AND CAST(CalendarDate  AS DATE) BETWEEN CAST( @startdate AS DATE) AND CAST( @endDate AS DATE) 
	
	INSERT INTO #att  
		SELECT StudentId, COUNT(*),100,(COUNT(*)*100)/100 FROM dbo.Att_StudentAttendance WHERE IsPresent=1 and StudentId IN (SELECT * FROM #StuId) 
				 AND CAST(InTime  AS DATE) BETWEEN CAST( @startdate AS DATE) AND CAST( @endDate AS DATE) GROUP BY StudentId

		SELECT DISTINCT ascs.StudentId,  acs.[Name] AssesmentName,acs.[Order], ascs.Comments,ascs.Grade,
			crc.TeacherComments,crc.HeadTeacherComments,crc.ReportGLComments, att.Tworking AttworkingDays ,att.TPersentage AttPersentage,att.Tpresent AttPresent
		FROM  dbo.Res_AssessmentClassSetUp acs
			left JOIN dbo.Res_AssessmentClassStudent ascs ON acs.Id=ascs.AssesmentClassId
			left JOIN Student_BasicInfo SB ON SB.StudentIID = ascs.StudentId 
			left JOIN dbo.Res_ClassResultComments crc ON crc.StudentId=ascs.StudentId and crc.MainExamId=ascs.MainExamId
			Left JOIN #att att on att.StudentId=SB.StudentIID
		WHERE  acs.TermId=@TermId  and acs.MainExamId=@MainExamId and SB.StudentIID IN (SELECT * FROM #StuId)

		SELECT asst.StudentId,asst.SubjectId, ass.[Name] AssesmentName,asst.Comments
		FROM dbo.Res_AssessmentStudent asst
			INNER JOIN dbo.Res_AssessmentSubSetup ass on ass.Id=asst.AssessmentId
		WHERE asst.StudentId IN (SELECT * FROM #StuId)  and asst.MainExamId =@MainExamId
		ORDER BY asst.StudentId,asst.SubjectId
	DROP TABLE #att
END
