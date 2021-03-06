/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetMainExamMerit]'))
BEGIN
DROP PROCEDURE  rptGetMainExamMerit
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kawsar
-- Create date: 
-- Description:	
-- =============================================
--execute [dbo].[rptGetMainExamMerit] 1,3,1,1
CREATE PROCEDURE [dbo].[rptGetMainExamMerit] 
	@VersionId int,
	@SessionId int,
	@ShiftId int,
	@ClassId int,
    @GroupId int,
	@SectionId INT,
	@MainExamId int,
	@Type INT

AS
BEGIN
DECLARE @OrderBy VARCHAR(500),@ClassName VARCHAR(100)
		DECLARE @MId INT , @M1 INT 
		--SELECT @MId = MainExamId FROM Res_MainMeritListConfig
		--WHERE [ClassId]= @ClassId
		--AND [GroupId] = @GroupId
		--AND IsDeleted = 0

		--SELECT @M1 = MainExamId FROM Res_MainSetup

		--WHERE [ClassId]= @ClassId
		--AND [GroupId] = @GroupId
		--AND IsDeleted = 0 AND MainExamId <> @MId
		PRINT @MId PRINT @M1
	
SELECT @ClassId= ClassId FROM	Res_MainExam WHERE MainExamId = @MainExamId
SELECT @ClassName = ClassName FROM Ins_ClassInfo WHERE ClassId= @ClassId
--PRINT @ClassName
--PRINT @VersionId
--SELECT ClassId  FROM Ins_ClassInfo WHERE ClassName= @ClassName
		CREATE TABLE #GID
		(
			MainId INT
		)
		IF(@Type =1)
		BEGIN 
		
			INSERT INTO #GID
		 SELECT MainExamId FROM Res_MainExam WHERE ClassId IN  (	SELECT ClassId  FROM Ins_ClassInfo WHERE ClassName= @ClassName)
		END
		ELSE 
		BEGIN 
		INSERT INTO #GID
			SELECT MainExamId  FROM Res_MainExam WHERE MainExamId= @MainExamId
		END
		--SELECT * FROM #GID

		IF(@Type=1) ---  Version Wise
		BEGIN
			SELECT SV.VersionName,Sv.SessionName,SV.BranchName,SV.ShiftName,SV.ClassName,Sv.GroupName,SV.SectionName,
			 S.RollNo ,S.StudentInsID,S.FullName,R.OverAllMerit,R.ClassWiseMerit,R.SectionWiseMerit,R.ShiftWiseMerit,
			R.TotalMarks,R.TotalConvertedMarks,R.TotalConvertedMarksFraction,R.GPA,R.TotalGP,
			R.GPAWithOut4Sub as GPAWithOut4Sub
			,S.SectionId ,MR.GPA AS MGPA,MR.TotalMarks AS MTotalMarks,MR.GPAWithOut4Sub AS MGPAWithOut4Sub
			,R.MeritSubjectMarks1 AS MeritSubjectMarks1
			,R.MeritSubjectMarks2 AS MeritSubjectMarks2
			,R.MeritSubjectMarks3 AS MeritSubjectMarks3
			,R.MyProperty AS ForthSub
			,R.MyProperty
			,(select MainExamName from dbo.Res_MainExam where MainExamId=@MId) as MainExamName
			INTO #tempV
			FROM [dbo].[Res_MainExamResult] R INNER JOIN Student_BasicInfo S ON S.StudentIID = R.StudentIID
			INNER JOIN vwStudentBasic SV ON SV.StudentIID = S.StudentIID
			LEFT JOIN Res_MainExamResult MR ON MR.MainExamId = @MId AND MR.StudentIID = S.StudentIID
			WHERE
			R.MainExamId IN (SELECT MainId FROM #GID) 
			AND S.GroupId = @GroupId
			AND R.GPA!=0
			AND R.IsPass = 1
			SELECT *, @Type AS ReportType FROM #tempV  ORDER BY #tempV.OverAllMerit
			DROP TABLE #tempV
		END
		IF(@Type=2) ---  Class Wise
		BEGIN
			SELECT SV.VersionName,Sv.SessionName,SV.BranchName,SV.ShiftName,SV.ClassName,Sv.GroupName,SV.SectionName,
			 S.RollNo ,S.StudentInsID,S.FullName,R.OverAllMerit,R.ClassWiseMerit,R.SectionWiseMerit,R.ShiftWiseMerit,
			R.TotalMarks,R.TotalConvertedMarks,R.TotalConvertedMarksFraction,R.GPA,R.TotalGP,
			R.GPAWithOut4Sub as GPAWithOut4Sub
			,S.SectionId ,MR.GPA AS MGPA,MR.TotalMarks AS MTotalMarks ,MR.GPAWithOut4Sub AS MGPAWithOut4Sub
			,R.MeritSubjectMarks1 AS MeritSubjectMarks1
			,R.MeritSubjectMarks2 AS MeritSubjectMarks2
			,R.MeritSubjectMarks3 AS MeritSubjectMarks3
			,R.MyProperty AS ForthSub
			,R.MyProperty
			,(select MainExamName from dbo.Res_MainExam where MainExamId=@MId) as MainExamName
			INTO #tempC
			FROM [dbo].[Res_MainExamResult] R INNER JOIN Student_BasicInfo S ON S.StudentIID = R.StudentIID
			INNER JOIN vwStudentBasic SV ON SV.StudentIID = S.StudentIID
			LEFT JOIN Res_MainExamResult MR ON MR.MainExamId = @MId AND MR.StudentIID = S.StudentIID
			WHERE R.MainExamId = @MainExamId
			AND S.VersionID = @VersionId
			AND S.ClassId = @ClassId
			AND S.GroupId = @GroupId
			AND R.GPA!=0

			SELECT *, @Type AS ReportType FROM #tempC  ORDER BY #tempC.OverAllMerit
			DROP TABLE #tempC
		END
		IF(@Type=3) ---  Shift Wise
		BEGIN
			SELECT SV.VersionName,Sv.SessionName,SV.BranchName,SV.ShiftName,SV.ClassName,Sv.GroupName,SV.SectionName,
			 S.RollNo ,S.StudentInsID,S.FullName,R.OverAllMerit,R.ClassWiseMerit,R.SectionWiseMerit,R.ShiftWiseMerit,
			R.TotalMarks,R.TotalConvertedMarks,R.TotalConvertedMarksFraction,R.GPA,R.TotalGP,
			R.GPAWithOut4Sub as GPAWithOut4Sub
			,S.SectionId ,MR.GPA AS MGPA,MR.TotalMarks AS MTotalMarks,MR.GPAWithOut4Sub AS MGPAWithOut4Sub
			,R.MeritSubjectMarks1 AS MeritSubjectMarks1
			,R.MeritSubjectMarks2 AS MeritSubjectMarks2
			,R.MeritSubjectMarks3 AS MeritSubjectMarks3
			,R.MyProperty AS ForthSub
			,R.MyProperty
			,M1.TotalMarks AS M1TotalMarks
			,M1.TotalConvertedMarks AS M1TotalConvertedMarks
			,M1.TotalConvertedMarksFraction AS M1TotalConvertedMarksFraction
			,(select MainExamName from dbo.Res_MainExam where MainExamId=@MId) as MainExamName
			INTO #tempS
			FROM [dbo].[Res_MainExamResult] R INNER JOIN Student_BasicInfo S ON S.StudentIID = R.StudentIID
			INNER JOIN vwStudentBasic SV ON SV.StudentIID = S.StudentIID
			LEFT JOIN Res_MainExamResult MR ON MR.MainExamId = @MId AND MR.StudentIID = S.StudentIID
			LEFT JOIN Res_MainExamResult M1 ON M1.MainExamId = @M1 AND M1.StudentIID = S.StudentIID
			WHERE R.MainExamId = @MainExamId
			AND S.VersionID = @VersionId
			AND S.ClassId = @ClassId
			AND S.GroupId = @GroupId
			AND S.ShiftID = @ShiftId
			AND R.GPA!=0

			SELECT *, @Type AS ReportType FROM #tempS  ORDER BY #tempS.OverAllMerit
			DROP TABLE #tempS
		END
		
		IF(@Type=4) ---  Section Wise
		BEGIN
			SELECT SV.VersionName,Sv.SessionName,SV.BranchName,SV.ShiftName,SV.ClassName,Sv.GroupName,SV.SectionName,
			 S.RollNo ,S.StudentInsID,S.FullName,R.OverAllMerit,R.ClassWiseMerit,R.SectionWiseMerit,R.ShiftWiseMerit,
			R.TotalMarks,R.TotalConvertedMarks,R.TotalConvertedMarksFraction,R.GPA,R.TotalGP,
			R.GPAWithOut4Sub as GPAWithOut4Sub
			,S.SectionId ,MR.GPA AS MGPA,MR.TotalMarks AS MTotalMarks,MR.GPAWithOut4Sub AS MGPAWithOut4Sub
			,R.MeritSubjectMarks1 AS MeritSubjectMarks1
			,R.MeritSubjectMarks2 AS MeritSubjectMarks2
			,R.MeritSubjectMarks3 AS MeritSubjectMarks3
			,R.MyProperty AS ForthSub
			,R.MyProperty
			,(select MainExamName from dbo.Res_MainExam where MainExamId=@MId) as MainExamName
			INTO #tempSE
			FROM [dbo].[Res_MainExamResult] R INNER JOIN Student_BasicInfo S ON S.StudentIID = R.StudentIID
			INNER JOIN vwStudentBasic SV ON SV.StudentIID = S.StudentIID
			LEFT JOIN Res_MainExamResult MR ON MR.MainExamId = @MId AND MR.StudentIID = S.StudentIID
			WHERE R.MainExamId = @MainExamId
			AND S.VersionID = @VersionId
			AND S.ClassId = @ClassId
			AND S.GroupId = @GroupId
			AND S.ShiftID = @ShiftId
			AND S.SectionId = @SectionId
			AND R.GPA!=0

			SELECT *, @Type AS ReportType FROM #tempSE  ORDER BY #tempSE.OverAllMerit
			DROP TABLE #tempSE
		END

END
---  execute [dbo].[rptGetMainExamMerit] 1,3,1,1