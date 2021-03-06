/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetGrandExamMerit]'))
BEGIN
DROP PROCEDURE  rptGetGrandExamMerit
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
--execute [dbo].[rptGetGrandExamMerit] 1,6,1,39,0,40,6,4
CREATE PROCEDURE [dbo].[rptGetGrandExamMerit] 
	@VersionId int,
	@SessionId int,
	@ShiftId int,
	@ClassId int,
    @GroupId int,
	@SectionId INT,
	@GrandExamId int,
	@Type INT
AS
BEGIN
	DECLARE @OrderBy VARCHAR(500),@ClassName VARCHAR(100), @Sql varchar(max),@WhereClause varchar(max)
		DECLARE @M1 INT , @M2 INT 
		SELECT @M1 = MainExamId FROM Res_GrandMeritListConfig
		WHERE [ClassId]= @ClassId
		AND [GroupId] = @GroupId
		AND IsDeleted = 0
		---print m cast(@MId as varchar)
		SELECT @M2 = MainExamId FROM Res_GrandSetup

		WHERE [ClassId]= @ClassId
		AND [GroupId] = @GroupId
		AND IsDeleted = 0 AND MainExamId <> @M1
 --       select top(1) @M1=MainExamId from Res_GrandSetup  where GrandExamId=@GrandExamID  and IsDeleted=0 and IsPassDependet=1
	--select top(1) @M2=MainExamId from Res_GrandSetup  where GrandExamId=@GrandExamID and IsDeleted=0 and IsPassDependet=0 and MainExamId<>@M1
	
SELECT @ClassId= ClassId FROM	Res_GrandExam WHERE GrandExamId = @GrandExamId
SELECT @ClassName = ClassName FROM Ins_ClassInfo WHERE ClassId= @ClassId
--PRINT @ClassName
--PRINT @VersionId
--SELECT ClassId  FROM Ins_ClassInfo WHERE ClassName= @ClassName
		CREATE TABLE #GID
		(
			GrandId INT
		)
		IF(@Type =1)
		BEGIN 
		
			INSERT INTO #GID
		 SELECT GrandExamId FROM Res_GrandExam WHERE ClassId IN  (	SELECT ClassId  FROM Ins_ClassInfo WHERE ClassName= @ClassName)
		END
		ELSE 
		BEGIN 
		INSERT INTO #GID
			SELECT GrandExamId  FROM Res_GrandExam WHERE GrandExamId= @GrandExamId
		END
		--SELECT * FROM #GID
		
			PRINT @M1 PRINT @M2
		IF(@Type=1) ---  Version Wise
		BEGIN
			SELECT SV.VersionName,Sv.SessionName,SV.BranchName,SV.ShiftName,SV.ClassName,Sv.GroupName,SV.SectionName,
			 S.RollNo ,S.StudentInsID,S.FullName,R.OverAllMerit,R.ClassWiseMerit,R.SectionWiseMerit,R.ShiftWiseMerit,
			R.TotalMarks,R.TotalConvertedMarks,R.TotalConvertedMarksFraction,R.GPA,R.GradeLetter, R.TotalGP,
			R.GPAWithOut4Sub as GPAWithOut4Sub
			,S.SectionId ,MR.GPA AS MGPA,MR.TotalMarks AS MTotalMarks
			,MR.GPAWithOut4Sub AS MGPAWithOut4Sub
			,R.MeritSubjectMarks1 AS MeritSubjectMarks1
			,R.MeritSubjectMarks2 AS MeritSubjectMarks2
			,R.MeritSubjectMarks3 AS MeritSubjectMarks3
			,M1.TotalMarks AS M1TotalMarks
			,M1.TotalConvertedMarks AS M1TotalConvertedMarks
			,M1.TotalConvertedMarksFraction AS M1TotalConvertedMarksFraction
			,R.MyProperty
			INTO #tempV
			FROM [dbo].[Res_GrandResult] R INNER JOIN Student_BasicInfo S ON S.StudentIID = R.StudentIID
			INNER JOIN vwStudentBasic SV ON SV.StudentIID = S.StudentIID
			 JOIN Res_MainExamResult MR ON MR.MainExamId = @M1 AND MR.StudentIID = S.StudentIID
			LEFT JOIN Res_MainExamResult M1 ON M1.MainExamId = @M2 AND M1.StudentIID = S.StudentIID
			WHERE
			R.GrandExamId IN (SELECT GrandId FROM #GID) 
			AND S.GroupId = @GroupId
			AND R.GPA!=0
			AND R.IsPass = 1
			SELECT * FROM #tempV  ORDER BY #tempV.OverAllMerit
			DROP TABLE #tempV
		END
		IF(@Type=2) ---  Class Wise
		BEGIN
			SELECT SV.VersionName,Sv.SessionName,SV.BranchName,SV.ShiftName,SV.ClassName,Sv.GroupName,SV.SectionName,
			 S.RollNo ,S.StudentInsID,S.FullName,R.OverAllMerit,R.ClassWiseMerit,R.SectionWiseMerit,R.ShiftWiseMerit,
			R.TotalMarks,R.TotalConvertedMarks,R.TotalConvertedMarksFraction,R.GPA ,R.GradeLetter,R.TotalGP,
			R.GPAWithOut4Sub as GPAWithOut4Sub
			,S.SectionId ,MR.GPA AS MGPA,MR.TotalMarks AS MTotalMarks ,MR.GPAWithOut4Sub AS MGPAWithOut4Sub
			,R.MeritSubjectMarks1 AS MeritSubjectMarks1
			,R.MeritSubjectMarks2 AS MeritSubjectMarks2
			,R.MeritSubjectMarks3 AS MeritSubjectMarks3
			,M1.TotalMarks AS M1TotalMarks
			,M1.TotalConvertedMarks AS M1TotalConvertedMarks
			,M1.TotalConvertedMarksFraction AS M1TotalConvertedMarksFraction
			,R.MyProperty
			INTO #tempC
			FROM [dbo].[Res_GrandResult] R INNER JOIN Student_BasicInfo S ON S.StudentIID = R.StudentIID
			INNER JOIN vwStudentBasic SV ON SV.StudentIID = S.StudentIID
			LEFT JOIN Res_MainExamResult MR ON MR.MainExamId = @M1 AND MR.StudentIID = S.StudentIID
			LEFT JOIN Res_MainExamResult M1 ON M1.MainExamId = @M2 AND M1.StudentIID = S.StudentIID
			WHERE R.GrandExamId = @GrandExamId
			AND S.VersionID = @VersionId
			AND S.ClassId = @ClassId
			AND S.GroupId = @GroupId
			AND R.GPA!=0

			SELECT * FROM #tempC  ORDER BY #tempC.OverAllMerit
			DROP TABLE #tempC
		END
		IF(@Type=3) ---  Shift Wise
		BEGIN
			SELECT SV.VersionName,Sv.SessionName,SV.BranchName,SV.ShiftName,SV.ClassName,Sv.GroupName,SV.SectionName,
			 S.RollNo ,S.StudentInsID,S.FullName,R.OverAllMerit,R.ClassWiseMerit,R.SectionWiseMerit,R.ShiftWiseMerit,
			R.TotalMarks,R.TotalConvertedMarks,R.TotalConvertedMarksFraction,R.GPA ,R.GradeLetter,R.TotalGP,
			R.GPAWithOut4Sub as GPAWithOut4Sub
			,S.SectionId ,MR.GPA AS MGPA,MR.TotalConvertedMarks AS MTotalMarks,MR.GPAWithOut4Sub AS MGPAWithOut4Sub
			,R.MeritSubjectMarks1 AS MeritSubjectMarks1
			,R.MeritSubjectMarks2 AS MeritSubjectMarks2
			,R.MeritSubjectMarks3 AS MeritSubjectMarks3
			,M1.TotalMarks AS M1TotalMarks
			,M1.TotalConvertedMarks AS M1TotalConvertedMarks
			,M1.TotalConvertedMarksFraction AS M1TotalConvertedMarksFraction
			,R.MyProperty
			INTO #tempS
			FROM [dbo].[Res_GrandResult] R INNER JOIN Student_BasicInfo S ON S.StudentIID = R.StudentIID
			INNER JOIN vwStudentBasic SV ON SV.StudentIID = S.StudentIID
			LEFT JOIN Res_MainExamResult MR ON MR.MainExamId = @M1 AND MR.StudentIID = S.StudentIID
			LEFT JOIN Res_MainExamResult M1 ON M1.MainExamId = @M2 AND M1.StudentIID = S.StudentIID
			WHERE R.GrandExamId = @GrandExamId
			AND S.VersionID = @VersionId
			AND S.ClassId = @ClassId
			AND S.GroupId = @GroupId
			AND S.ShiftID = @ShiftId
			AND R.GPA!=0

			SELECT * FROM #tempS  ORDER BY #tempS.OverAllMerit
			DROP TABLE #tempS
		END
		
		IF(@Type=4) ---  Section Wise
		BEGIN
			SELECT SV.VersionName,Sv.SessionName,SV.BranchName,SV.ShiftName,SV.ClassName,Sv.GroupName,SV.SectionName,
			 S.RollNo ,S.StudentInsID,S.FullName,R.OverAllMerit,R.ClassWiseMerit,R.SectionWiseMerit,R.ShiftWiseMerit,
			R.TotalMarks,R.TotalConvertedMarks,R.TotalConvertedMarksFraction,R.GPA ,R.GradeLetter,R.TotalGP,
			R.GPAWithOut4Sub as GPAWithOut4Sub
			,S.SectionId ,MR.GPA AS MGPA,MR.TotalConvertedMarks AS MTotalMarks,MR.GPAWithOut4Sub AS MGPAWithOut4Sub
			,R.MeritSubjectMarks1 AS MeritSubjectMarks1
			,R.MeritSubjectMarks2 AS MeritSubjectMarks2
			,R.MeritSubjectMarks3 AS MeritSubjectMarks3
			,M1.TotalMarks AS M1TotalMarks
			,M1.TotalConvertedMarks AS M1TotalConvertedMarks
			,M1.TotalConvertedMarksFraction AS M1TotalConvertedMarksFraction
			,R.MyProperty
			INTO #tempSE
			FROM [dbo].[Res_GrandResult] R INNER JOIN Student_BasicInfo S ON S.StudentIID = R.StudentIID
			INNER JOIN vwStudentBasic SV ON SV.StudentIID = S.StudentIID
			LEFT JOIN Res_MainExamResult MR ON MR.MainExamId = @M1 AND MR.StudentIID = S.StudentIID
				LEFT JOIN Res_MainExamResult M1 ON M1.MainExamId = @M2 AND M1.StudentIID = S.StudentIID
			WHERE R.GrandExamId = @GrandExamId
			AND S.VersionID = @VersionId
			AND S.ClassId = @ClassId
			AND S.GroupId = @GroupId
			AND S.ShiftID = @ShiftId
			AND S.SectionId = @SectionId
			AND R.GPA!=0
			

			SELECT * FROM #tempSE  ORDER BY #tempSE.OverAllMerit
			DROP TABLE #tempSE
		END

END

---  EXEC rptGetGrandExamMerit 4,'1','1','1'