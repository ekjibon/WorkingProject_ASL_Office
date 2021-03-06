/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[vwStudentBasic]'))
BEGIN
DROP VIEW  vwStudentBasic
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwStudentBasic]
AS
SELECT          dbo.Student_BasicInfo.StudentIID, 
				dbo.Student_BasicInfo.StudentInsID, 
				dbo.Student_BasicInfo.RollNo, 
				dbo.Student_BasicInfo.RegiNo, 
				dbo.Student_BasicInfo.FullName, 
				dbo.Student_BasicInfo.FatherName, 
                dbo.Student_BasicInfo.MotherName, 
				dbo.Student_BasicInfo.SMSNotificationNo,
				dbo.Ins_Version.VersionName,
				dbo.Ins_Branch.BranchName,
				dbo.Ins_ClassInfo.ClassId, 
			    dbo.Ins_ClassInfo.ClassName, 
				dbo.Ins_Group.GroupName, 
                dbo.Ins_Section.SectionName,
				dbo.Ins_Session.SessionId, 
				dbo.Ins_Session.SessionName,
				dbo.Ins_Shift.ShiftId, 
				dbo.Ins_Shift.ShiftName,
				H.HouseName,
				ST.StudentTypeName

FROM            dbo.Ins_Section RIGHT OUTER JOIN dbo.Ins_Group 
				RIGHT OUTER JOIN dbo.Ins_ClassInfo 
				INNER JOIN dbo.Student_BasicInfo 
				INNER JOIN dbo.Ins_Version ON dbo.Student_BasicInfo.VersionID = dbo.Ins_Version.VersionId 
				INNER JOIN dbo.Ins_Branch ON dbo.Student_BasicInfo.BranchID = dbo.Ins_Branch.BranchId 
				INNER JOIN dbo.Ins_Session ON dbo.Student_BasicInfo.SessionId = dbo.Ins_Session.SessionId ON dbo.Ins_ClassInfo.ClassId = dbo.Student_BasicInfo.ClassId 
				LEFT OUTER JOIN dbo.Ins_Shift ON dbo.Student_BasicInfo.ShiftID = dbo.Ins_Shift.ShiftId ON dbo.Ins_Group.GroupId = dbo.Student_BasicInfo.GroupId ON dbo.Ins_Section.SectionId = dbo.Student_BasicInfo.SectionId
				LEFT JOIN Ins_House H ON H.HouseId = Student_BasicInfo.HouseID
				LEFT JOIN Ins_StudentType ST ON ST.StudentTypeId = Student_BasicInfo.StudentTypeID


GO