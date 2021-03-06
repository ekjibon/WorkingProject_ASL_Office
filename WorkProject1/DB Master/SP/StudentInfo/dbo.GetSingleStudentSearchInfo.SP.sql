/****** Object:  StoredProcedure [dbo].[GetSingleStudentSearchInfo]    Script Date: 7/22/2017 4:15:28 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetSingleStudentSearchInfo]'))
BEGIN
DROP PROCEDURE  GetSingleStudentSearchInfo
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[GetSingleStudentSearchInfo]

@StudentInsID varchar(50) =  NULL
AS
BEGIN
	

SELECT        
		sb.StudentIID, sb.StudentInsID, sb.FullName, sb.SMSNotificationNo, v.VersionName, s.SessionName, b.BranchName, sb.Status,
        sh.ShiftName, c.ClassName, g.GroupName, sc.SectionName, sb.RollNo,sb.FatherName,sb.MotherName
	FROM               
        dbo.Ins_Version v INNER JOIN
        dbo.Student_BasicInfo sb ON v.VersionId = sb.VersionID INNER JOIN
        dbo.Ins_Session s ON sb.SessionId = s.SessionId INNER JOIN
        dbo.Ins_Branch b ON sb.BranchID = b.BranchId INNER JOIN
        dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId INNER JOIN
        dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId INNER JOIN
        dbo.Ins_Group g ON sb.GroupId = g.GroupId  LEFT OUTER JOIN
		dbo.Ins_Section sc ON sc.SectionId = sb.SectionId
		WHERE 
			
			sb.StudentInsID = @StudentInsID

			-- exec GetSingleStudentSearchInfo '16M01A046'
			
END
