/****** Object:  StoredProcedure [dbo].[rptGetTabulation]    Script Date: 7/22/2017 4:39:59 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetTabulation]'))
BEGIN
DROP PROCEDURE  rptGetTabulation
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[rptGetTabulation]  ---  EXEC rptGetTabulation 1,6,1,1,6,0,19,4
	@VersionId INT,
	@SessionId INT,
	@BranchID INT,
	@ShiftID INT ,
	@ClassId INT,
	@GroupId INT,
	@SectionId INT,
	@MainExamId INT
AS
BEGIN

SELECT 
		T.TabulationId,
		S.FullName ,
		S.StudentIID,
		S.StudentInsID,
		CAST( S.RollNo as int) RollNo ,
		S.FullName,
		T.[MainExamId],
		REPLACE (T.TotalMarks ,'.00','') AS TotalMarks ,
		T.IsPass,
		T.ExamSerial,
		T.ExamName,
		ISNULL(Sub.[SubjectName] ,'') AS SubjectName,
		ISNULL(Sub.[ReportSerialNo], 200) AS ReportSerialNo
		,V.VersionName,
		B.BranchName,
		SH.ShiftName,
		SE.SessionName,
		C.ClassName,
		G.GroupName,
		SEC.SectionName,
		M.MainExamName
 FROM  [Res_Tabulation] T 
		INNER JOIN Student_BasicInfo S  ON S.StudentIID=T.StudentId
		INNER JOIN Res_MainExam M  ON M.MainExamId=T.MainExamId
		INNER JOIN Ins_Version V ON V.VersionId = T.VersionID
		INNER JOIN Ins_Branch B ON B.BranchId = T.BranchID
		INNER JOIN Ins_Shift SH ON SH.ShiftId = T.ShiftID
		INNER JOIN Ins_Session SE ON SE.SessionId = T.SessionId
		INNER JOIN Ins_ClassInfo C ON C.ClassId =T.ClassId
		INNER JOIN Ins_Group G ON G.GroupId = T.GroupId
		INNER JOIN Ins_Section SEC ON SEC.SectionId = T.SectionId
		LEFT JOIN Res_SubjectSetup Sub  ON Sub.[SubID] = T.[SubjectId]

		WHERE   
				T.VersionID = @VersionId 
				AND T.SessionId = @SessionId
				AND T.BranchID = @BranchID
				AND T.ShiftID = @ShiftID 
				AND T.ClassId = @ClassId
				AND T.GroupId = @GroupId
				AND T.SectionId = @SectionId 
				AND T.MainExamId = @MainExamId
				--AND s.RollNo=8 AND T.ExamName = 'CW'

		ORDER BY CAST( S.RollNo as int) 


--  EXEC rptGetTabulation 1,2,1,2,1,0,6,1
END


