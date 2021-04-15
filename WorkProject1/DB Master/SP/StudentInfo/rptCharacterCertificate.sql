
-- =============================================
-- Author:		<Maruf Billah>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Alter PROCEDURE rptGetCharacterCertificate -- EXEC [rptGetCharacterCertificate] 1,3,3,6,11,1,30
	@VersionId INT =null,
	@SessionId INT =null,
	@BranchId INT =null,
	@ShiftId INT =null,
	@ClassId INT =null,
	@GroupId INT =null,
	@SectionId INT =null
AS
BEGIN
	SELECT        dbo.Student_BasicInfo.StudentIID, dbo.Student_BasicInfo.StudentInsID, dbo.Student_BasicInfo.RollNo, dbo.Student_BasicInfo.RegiNo, dbo.Student_BasicInfo.FullName, dbo.Student_BasicInfo.FatherName, 
                         dbo.Student_BasicInfo.MotherName, dbo.Student_BasicInfo.SMSNotificationNo, dbo.Ins_Version.VersionName, dbo.Ins_Branch.BranchName, dbo.Ins_ClassInfo.ClassName, dbo.Ins_Group.GroupName, 
                         dbo.Ins_Section.SectionName, dbo.Ins_Session.SessionName, dbo.Ins_Shift.ShiftName, dbo.Student_BasicInfo.DateOfBirth
FROM            dbo.Ins_Section RIGHT OUTER JOIN
                         dbo.Ins_Group RIGHT OUTER JOIN
                         dbo.Ins_ClassInfo INNER JOIN
                         dbo.Student_BasicInfo INNER JOIN
                         dbo.Ins_Version ON dbo.Student_BasicInfo.VersionID = dbo.Ins_Version.VersionId INNER JOIN
                         dbo.Ins_Branch ON dbo.Student_BasicInfo.BranchID = dbo.Ins_Branch.BranchId INNER JOIN
                         dbo.Ins_Session ON dbo.Student_BasicInfo.SessionId = dbo.Ins_Session.SessionId ON dbo.Ins_ClassInfo.ClassId = dbo.Student_BasicInfo.ClassId LEFT OUTER JOIN
                         dbo.Ins_Shift ON dbo.Student_BasicInfo.ShiftID = dbo.Ins_Shift.ShiftId ON dbo.Ins_Group.GroupId = dbo.Student_BasicInfo.GroupId ON dbo.Ins_Section.SectionId = dbo.Student_BasicInfo.SectionId

						 WHERE Student_BasicInfo.VersionID = @VersionId AND Student_BasicInfo.SessionId = @SessionId AND Student_BasicInfo.BranchID = @BranchId AND Student_BasicInfo.ShiftID = @ShiftId 
						AND Student_BasicInfo.ClassId = @ClassId AND Student_BasicInfo.GroupId = @GroupId AND Student_BasicInfo.SectionId = @SectionId
END
GO

