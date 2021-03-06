/****** Object:  StoredProcedure [dbo].[rptGetGrandTab]    Script Date: 7/22/2017 4:39:59 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetGrandTab]'))
BEGIN
DROP PROCEDURE  rptGetGrandTab
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[rptGetGrandTab]  ---  EXEC rptGetGrandTab 1,4,1,1,4,0,10,3
	@VersionId INT,
	@SessionId INT,
	@BranchID INT,
	@ShiftID INT ,
	@ClassId INT,
	@GroupId INT,
	@SectionId INT,
	@GrandExamId INT
AS
BEGIN

SELECT  * INTO #tMainExam FROM Res_MainExam 
SELECT  * INTO #tGrandExam FROM Res_GrandExam 
SELECT 
		T.TabulationId,
		S.FullName ,
		S.StudentInsID,
		s.StudentIID,
		S.RollNo ,
		S.FullName,
		T.[MainExamId],
	   (CASE
			WHEN T.GrandExamId != NULL OR T.GrandExamId!=0 THEN (SELECT GrandExamName  FROM #tGrandExam WHERE GrandExamId=T.GrandExamId)
			ELSE (SELECT MainExamName  FROM #tMainExam WHERE MainExamId=T.MainExamId)
		END ) AS MExamName,
		 (CASE
			WHEN T.GrandExamId != NULL OR T.GrandExamId!=0 THEN 10
			ELSE (SELECT MainExamGrandShowOrder  FROM #tMainExam WHERE MainExamId=T.MainExamId)
		END ) AS MExamSerial,

		REPLACE (T.TotalMarks ,'.00','') AS TotalMarks ,
		T.IsPass,
		T.ExamSerial,
		T.ExamName ,
		ISNULL(Sub.[SubjectName] ,'') AS SubjectName,
		ISNULL(Sub.[ReportSerialNo], 200) AS ReportSerialNo
		,V.VersionName,
		B.BranchName,
		SH.ShiftName,
		SE.SessionName,
		C.ClassName,
		G.GroupName,
		SEC.SectionName

 FROM  [Res_Tabulation] T 
		--INNER JOIN Res_MainExam M ON M.MainExamId = T.MainExamId
		INNER JOIN Student_BasicInfo S  ON T.StudentId=S.StudentIID
		INNER JOIN Ins_Version V ON V.VersionId = T.VersionID
		INNER JOIN Ins_Branch B ON B.BranchId = T.BranchID
		INNER JOIN Ins_Shift SH ON SH.ShiftId = T.ShiftID
		INNER JOIN Ins_Session SE ON SE.SessionId = T.SessionId
		INNER JOIN Ins_ClassInfo C ON C.ClassId =T.ClassId
		INNER JOIN Ins_Group G ON G.GroupId = T.GroupId
		INNER JOIN Ins_Section SEC ON SEC.SectionId = T.SectionId
		LEFT JOIN Res_SubjectSetup Sub  ON Sub.[SubID] = T.[SubjectId]
		

		WHERE  T.VersionID = @VersionId 
				AND T.SessionId = @SessionId
				AND T.BranchID = @BranchID
				AND T.ShiftID = @ShiftID 
				AND T.ClassId = @ClassId
				AND T.GroupId = @GroupId
				AND T.SectionId = @SectionId 
				AND (T.MainExamId IN (SELECT MainExamId FROM Res_GrandExam WHERE GrandExamId=@GrandExamId) OR T.GrandExamId = @GrandExamId)
				--AND S.RollNo = 1
				--and s.FullName='Md. Hasan'
				--AND S.StudentIID =696
		ORDER BY S.RollNo,T.ExamSerial,T.TabulationId


--  EXEC rptGetGrandTab 1,4,5,2,24,0,55,10
END
