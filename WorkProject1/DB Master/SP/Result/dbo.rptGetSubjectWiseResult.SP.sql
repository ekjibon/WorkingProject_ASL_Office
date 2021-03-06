/****** Object:  StoredProcedure [dbo].[rptGetSubjectWiseResult]    Script Date: 12/10/2018 3:06:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetSubjectWiseResult]'))
BEGIN
DROP PROCEDURE  [rptGetSubjectWiseResult]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- EXEC rptGetSubjectWiseResult 1064,85,'4523',8,88
CREATE PROCEDURE [dbo].[rptGetSubjectWiseResult]  
	@MainExamId INT ,
	@SubjectId INT,
	@StuIds VARCHAR(1000),
	@BranchId INT,
	@SectionId INT
AS
BEGIN
IF 1=0 BEGIN
    SET FMTONLY OFF
END

	SELECT value  INTO #StuId
	FROM STRING_SPLIT(@StuIds, ',')  
DECLARE @ClassId INT=0;
SET @ClassId=(SELECT ClassId FROM Res_MainExam WHERE MainExamId=@MainExamId)

IF(@ClassId=31 AND @MainExamId=1054)
	BEGIN
	SELECT TOP 1 SB.StudentInsID,SB.FullName,SB.BranchID,sb.SessionId,sb.ClassId,SR.SubjectID, Sb.RollNo,s.IsMidYear,cl.ClassName+' ('+sest.SectionName+')' AS ClassName, 
					t.Name TermName,t.TermId, ss.SubjectName,S.SubExamId, '' SubExamName,ses.SessionName,
					0 SubExamTotalObt,0 SubExamTotalConv ,0 SubExamExamMarks
					,(SELECT TOP(1) SubExamExamMarks FROM Res_SubExamMarkSetup SEM 
							INNER JOIN Res_SubExam RS ON RS.SubExamId = SEM.SubExamId AND SEM.IsDeleted =0 AND RS.IsMidYear =1 AND RS.MainExamId = @MainExamId AND RS.SectionId=@SectionId AND RS.IsDeleted = 0 
							INNER JOIN dbo.Res_SubjectSetup ss on ss.SubID=RS.SubjectID AND ss.SubID = @SubjectId) AS SubExamMidMark
					,sms.SubExamFullMarks, SR.SubExamIsAbsent--,SR.SubExamIsPass
					,(SELECT TOP(1) COUNT(*) FROM dbo.Res_SubExam WHERE MainExamId=sr.MainExamId and SubjectId=SR.SubjectID  and IsDeleted=0 and  IsMidYear=0  and IsFinal=0 AND SectionId = SB.SectionId)  TotalSubexam,
					mrssd.SubjectGL as GL,
					swc.Comments
					, '' ExamDate
					,(SELECT TOP(1) ExamDate FROM dbo.Res_SubExam rse WHERE rse.MainExamId=sr.MainExamId and rse.SubjectId=@SubjectId and (rse.IsMidYear=1 or rse.IsFinal=1) ) MidExamDate,
					(SELECT SUM(SubExamTotalConv) FROM dbo.Res_MERSubExamResult msr WHERE msr.SubjectID=@SubjectId and msr.MainExamId=@MainExamId  and msr.studentIID=sb.StudentIID
						GROUP BY SubjectID ,StudentIID) as TotalConv
			,emp.FullName as TeacherName
			,(ROUND((mrssd.SubjectConvertedMarks),0)) AS SubConvertedMark
			,mrssd.SubjectConvertedMarksFraction, mrssd.WinterMarks,mrssd.AutumnMarks,mrssd.SubjectHighestMark,
			mrssd.MidYearSubObtMarks,mrssd.MidYearSubConvtMarks,mrssd.FinalYearSubObtMarks2,mrssd.FinalYearSubConvtMarks2
			,CASE WHEN sb.ClassId=30 THEN 30 ELSE 40 END MockPercent
			,CASE WHEN sb.ClassId=26 AND (SR.SubjectID=54 OR SR.SubjectID=55) THEN 20 
				  WHEN sb.ClassId=27 AND SB.BranchID=8 and (SR.SubjectID=32 OR SR.SubjectID=33) THEN 20
				  ELSE 60 END FinalPercent
			,CASE WHEN sb.ClassId=28 AND SR.SubjectID=48  THEN 35 
				  WHEN sb.ClassId=27 AND SB.BranchID=9 and SR.SubjectID=36  THEN 35
				  ELSE 10 END WinterPercent
	FROM Res_MERSubExamResult SR 
			INNER JOIN Student_BasicInfo SB ON SB.StudentIID = SR.StudentIID 
			INNER JOIN dbo.Ins_ClassInfo CL ON CL.ClassId = SB.ClassId 
			INNER JOIN dbo.Res_MainExam M ON M.MainExamId = SR.MainExamId
			INNER JOIN Res_SubExam S ON S.SubExamId = SR.SubExamId AND S.SectionId = @SectionId
			INNER JOIN dbo.Res_MainExamMarkSetup MMS on MMS.MainExamId=sr.MainExamId and MMS.MainExamSubjectID=SR.SubjectID 
			INNER JOIN dbo.Res_Terms T ON T.TermId = M.TermId
			INNER JOIN dbo.Res_SubExamMarkSetup SMS on SMS.MainExamMarkSetupId=MMS.Id and sms.SubExamId=s.SubExamId
			INNER JOIN dbo.Res_SubjectSetup ss on ss.SubID=sr.SubjectID
			INNER JOIN dbo.Ins_Session ses on ses.SessionId =SB.SessionId
			INNER JOIN dbo.Ins_Section sest on sest.SectionId =SB.SectionId
			left JOIN dbo.Res_AssignSubjectsToTeacher astt on astt.SubjectID =sr.SubjectID AND astt.SectionID = @SectionId  AND astt.BranchID = @BranchId AND astt.MainExamID = @MainExamId AND Astt.IsDeleted = 0
			INNER JOIN dbo.Emp_BasicInfo emp on emp.EmpBasicInfoID =astt.TeacherID 
			left JOIN dbo.Res_SubjectWiseComment swc on swc.StudentId=sb.StudentIID and swc.SubjectId=sr.SubjectID and swc.StudentId=sr.StudentIID and swc.MainExamId=sr.MainExamId
			left JOIN dbo.Res_MainExamResultSubjectDetails mrssd on mrssd.StudentIID=SR.StudentIID and mrssd.SubjectID=sr.SubjectID and mrssd.MainExamId=sr.MainExamId
			--INNer JOIN dbo.Res_AssignSubjectsToTeacher ast on ast.SubjectID=ss.SubID
	WHERE SB.StudentIID IN (SELECT * FROM #StuId) and ss.SubID = @SubjectId and M.MainExamId =@MainExamId
			and MMS.IsDeleted=0 and SMS.IsDeleted=0 and s.IsMidYear=0 and s.IsFinal=1
	END
ELSE
	BEGIN
		SELECT Distinct SB.StudentInsID,SB.FullName,SB.BranchID,sb.SessionId,sb.ClassId,SR.SubjectID, Sb.RollNo,s.IsMidYear,cl.ClassName+' ('+sest.SectionName+')' AS ClassName, 
						t.Name TermName,t.TermId, ss.SubjectName,S.SubExamId, S.SubExamName,ses.SessionName,
						SR.SubExamTotalObt,SR.SubExamTotalConv ,sms.SubExamExamMarks
						,(SELECT TOP(1) SubExamExamMarks FROM Res_SubExamMarkSetup SEM 
								INNER JOIN Res_SubExam RS ON RS.SubExamId = SEM.SubExamId AND SEM.IsDeleted =0 AND RS.IsMidYear =1 AND RS.MainExamId = @MainExamId AND RS.SectionId=@SectionId AND RS.IsDeleted = 0 
								INNER JOIN dbo.Res_SubjectSetup ss on ss.SubID=RS.SubjectID AND ss.SubID = @SubjectId) AS SubExamMidMark
						,sms.SubExamFullMarks, SR.SubExamIsAbsent--,SR.SubExamIsPass
						,(SELECT TOP(1) COUNT(*) FROM dbo.Res_SubExam WHERE MainExamId=sr.MainExamId and SubjectId=SR.SubjectID  and IsDeleted=0 and  IsMidYear=0  and IsFinal=0 AND SectionId = SB.SectionId)  TotalSubexam,
						mrssd.SubjectGL as GL,
						swc.Comments
						,CONVERT(NVARCHAR(20), CAST(S.ExamDate AS DATE),104)  ExamDate
						,(SELECT TOP(1) CONVERT(NVARCHAR(20), CAST(ExamDate AS DATE),104) ExamDate FROM dbo.Res_SubExam rse WHERE rse.MainExamId=sr.MainExamId and rse.SubjectId=@SubjectId and (rse.IsMidYear=1 or rse.IsFinal=1) ) MidExamDate,
						(SELECT SUM(SubExamTotalConv) FROM dbo.Res_MERSubExamResult msr WHERE msr.SubjectID=@SubjectId and msr.MainExamId=@MainExamId  and msr.studentIID=sb.StudentIID
							GROUP BY SubjectID ,StudentIID) as TotalConv
				,emp.FullName as TeacherName
				,(ROUND((mrssd.SubjectConvertedMarks),0)) AS SubConvertedMark
				,mrssd.SubjectConvertedMarksFraction, mrssd.WinterMarks,mrssd.AutumnMarks,mrssd.SubjectHighestMark,
				mrssd.MidYearSubObtMarks,mrssd.MidYearSubConvtMarks,mrssd.FinalYearSubObtMarks2,mrssd.FinalYearSubConvtMarks2
				,CASE WHEN sb.ClassId=30 THEN 30 ELSE 40 END MockPercent
				,CASE WHEN sb.ClassId=26 AND (SR.SubjectID=54 OR SR.SubjectID=55) THEN 20 
					  WHEN sb.ClassId=27 AND SB.BranchID=8 and (SR.SubjectID=32 OR SR.SubjectID=33) THEN 20
					  ELSE 60 END FinalPercent
				,CASE WHEN sb.ClassId=28 AND SR.SubjectID=48  THEN 35 
					  WHEN sb.ClassId=27 AND SR.SubjectID=36  THEN 35
					  ELSE 10 END WinterPercent
		FROM Res_MERSubExamResult SR 
				INNER JOIN Student_BasicInfo SB ON SB.StudentIID = SR.StudentIID 
				INNER JOIN dbo.Ins_ClassInfo CL ON CL.ClassId = SB.ClassId 
				INNER JOIN dbo.Res_MainExam M ON M.MainExamId = SR.MainExamId
				INNER JOIN Res_SubExam S ON S.SubExamId = SR.SubExamId AND S.SectionId = @SectionId
				INNER JOIN dbo.Res_MainExamMarkSetup MMS on MMS.MainExamId=sr.MainExamId and MMS.MainExamSubjectID=SR.SubjectID 
				INNER JOIN dbo.Res_Terms T ON T.TermId = M.TermId
				INNER JOIN dbo.Res_SubExamMarkSetup SMS on SMS.MainExamMarkSetupId=MMS.Id and sms.SubExamId=s.SubExamId
				INNER JOIN dbo.Res_SubjectSetup ss on ss.SubID=sr.SubjectID
				INNER JOIN dbo.Ins_Session ses on ses.SessionId =SB.SessionId
				INNER JOIN dbo.Ins_Section sest on sest.SectionId =SB.SectionId
				left JOIN dbo.Res_AssignSubjectsToTeacher astt on astt.SubjectID =sr.SubjectID AND astt.SectionID = @SectionId  AND astt.BranchID = @BranchId AND astt.MainExamID = @MainExamId AND Astt.IsDeleted = 0
				INNER JOIN dbo.Emp_BasicInfo emp on emp.EmpBasicInfoID =astt.TeacherID 
				left JOIN dbo.Res_SubjectWiseComment swc on swc.StudentId=sb.StudentIID and swc.SubjectId=sr.SubjectID and swc.StudentId=sr.StudentIID and swc.MainExamId=sr.MainExamId
				left JOIN dbo.Res_MainExamResultSubjectDetails mrssd on mrssd.StudentIID=SR.StudentIID and mrssd.SubjectID=sr.SubjectID and mrssd.MainExamId=sr.MainExamId
				--INNer JOIN dbo.Res_AssignSubjectsToTeacher ast on ast.SubjectID=ss.SubID
		WHERE SB.StudentIID IN (SELECT * FROM #StuId) and ss.SubID = @SubjectId and M.MainExamId =@MainExamId
				and MMS.IsDeleted=0 and SMS.IsDeleted=0 and s.IsMidYear=0 and s.IsFinal=0
	END

	

	SELECT asst.StudentId, ass.Name AssesmentName,asst.Comments,ass.[ORDER] as ReportORDER FROM dbo.Res_AssessmentStudent asst
			INNER JOIN dbo.Res_AssessmentSubSetup ass on ass.Id=asst.AssessmentId
	WHERE asst.StudentId IN (SELECT * FROM #StuId) and asst.SubjectId = @SubjectId and asst.MainExamId =@MainExamId
	ORDER by asst.StudentId
END
/*

SELECT * FROM Res_MainExamResultSubjectDetails WHERE StudentIID = 5097 AND MainExamId = 1050

*/