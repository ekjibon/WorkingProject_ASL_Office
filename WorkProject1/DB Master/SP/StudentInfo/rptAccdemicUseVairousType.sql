/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AccdemicUseVairousType]'))
BEGIN
DROP PROCEDURE  AccdemicUseVairousType
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AccdemicUseVairousType] 
	@VersionId INT,
	@SessionId INT,
	@BranchID INT,
	@ShiftID INT ,
	@ClassId INT,
	@GroupId INT,
	@SectionId INT,
	@TypeId INT,  --1 With TC, 2 By Admission AT, 3 Testimonial, 4 Given TC
	@FromDate DateTime,
	@ToDate DateTime--,

AS
BEGIN
	if(@TypeId=1)
	BEGIN
	SELECT        dbo.Ins_Version.VersionName, dbo.Ins_Session.SessionName, dbo.Ins_Shift.ShiftName, dbo.Ins_ClassInfo.ClassName, dbo.Ins_Group.GroupName, dbo.Ins_Section.SectionName, dbo.Student_BasicInfo.RollNo, 
                         dbo.Student_BasicInfo.FullName, dbo.Student_BasicInfo.SMSNotificationNo, dbo.Student_BasicInfo.AddmissionEntryType, dbo.Student_BasicInfo.AdmissionDate, dbo.Ins_Branch.BranchName, 
                         dbo.Student_BasicInfo.StudentInsID
FROM            dbo.Ins_ClassInfo INNER JOIN
                         dbo.Ins_Version INNER JOIN
                         dbo.Student_BasicInfo ON dbo.Ins_Version.VersionId = dbo.Student_BasicInfo.VersionID INNER JOIN
                         dbo.Ins_Session ON dbo.Student_BasicInfo.SessionId = dbo.Ins_Session.SessionId INNER JOIN
                         dbo.Ins_Branch ON dbo.Student_BasicInfo.BranchID = dbo.Ins_Branch.BranchId INNER JOIN
                         dbo.Ins_Shift ON dbo.Student_BasicInfo.ShiftID = dbo.Ins_Shift.ShiftId ON dbo.Ins_ClassInfo.ClassId = dbo.Student_BasicInfo.ClassId INNER JOIN
                         dbo.Ins_Group ON dbo.Student_BasicInfo.GroupId = dbo.Ins_Group.GroupId INNER JOIN
                         dbo.Ins_Section ON dbo.Student_BasicInfo.SectionId = dbo.Ins_Section.SectionId
WHERE        (dbo.Student_BasicInfo.AddmissionEntryType = N'WT' and dbo.Student_BasicInfo.VersionID=@VersionId and dbo.Student_BasicInfo.SessionId=@SectionId and
dbo.Student_BasicInfo.ShiftID=@ShiftID and dbo.Student_BasicInfo.GroupId=@GroupId and dbo.Student_BasicInfo.SectionId=@SectionId) and dbo.Student_BasicInfo.AdmissionDate IN (@FromDate, @ToDate) 
	END
	if(@TypeId=2)
	BEGIN
	SELECT        dbo.Ins_Version.VersionName, dbo.Ins_Session.SessionName, dbo.Ins_Shift.ShiftName, dbo.Ins_ClassInfo.ClassName, dbo.Ins_Group.GroupName, dbo.Ins_Section.SectionName, dbo.Student_BasicInfo.RollNo, 
                         dbo.Student_BasicInfo.FullName, dbo.Student_BasicInfo.SMSNotificationNo, dbo.Student_BasicInfo.AddmissionEntryType, dbo.Student_BasicInfo.AdmissionDate, dbo.Ins_Branch.BranchName, 
                         dbo.Student_BasicInfo.StudentInsID
FROM            dbo.Ins_ClassInfo INNER JOIN
                         dbo.Ins_Version INNER JOIN
                         dbo.Student_BasicInfo ON dbo.Ins_Version.VersionId = dbo.Student_BasicInfo.VersionID INNER JOIN
                         dbo.Ins_Session ON dbo.Student_BasicInfo.SessionId = dbo.Ins_Session.SessionId INNER JOIN
                         dbo.Ins_Branch ON dbo.Student_BasicInfo.BranchID = dbo.Ins_Branch.BranchId INNER JOIN
                         dbo.Ins_Shift ON dbo.Student_BasicInfo.ShiftID = dbo.Ins_Shift.ShiftId ON dbo.Ins_ClassInfo.ClassId = dbo.Student_BasicInfo.ClassId INNER JOIN
                         dbo.Ins_Group ON dbo.Student_BasicInfo.GroupId = dbo.Ins_Group.GroupId INNER JOIN
                         dbo.Ins_Section ON dbo.Student_BasicInfo.SectionId = dbo.Ins_Section.SectionId
WHERE        (dbo.Student_BasicInfo.AddmissionEntryType = N'WT' and dbo.Student_BasicInfo.VersionID=@VersionId and dbo.Student_BasicInfo.SessionId=@SectionId and
dbo.Student_BasicInfo.ShiftID=@ShiftID and dbo.Student_BasicInfo.GroupId=@GroupId and dbo.Student_BasicInfo.SectionId=@SectionId) and dbo.Student_BasicInfo.AdmissionDate IN (@FromDate, @ToDate) 
	END
	
	



END	

--- GetInstutionSetup 1,5,1,1,5,0,108,144,3,113
