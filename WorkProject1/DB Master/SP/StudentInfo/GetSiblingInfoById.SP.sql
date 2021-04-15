/****** Object:  StoredProcedure [dbo].[GetStudentInfoByInsId]    Script Date: 7/22/2017 4:18:12 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetSiblingInfoById]'))
BEGIN
DROP PROCEDURE  GetSiblingInfoById
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Evan>
-- Create date: <01-02-2018>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetSiblingInfoById] -- exec GetSiblingInfoById '111811001'
	@StudentIID int
AS
BEGIN
	SELECT      dbo.Student_SiblingInfo.SiblingStudentIID,
				dbo.Student_BasicInfo.StudentInsID as StudentInsID,
				dbo.Student_BasicInfo.FullName,
				dbo.Student_BasicInfo.RollNo,
				dbo.Ins_Branch.BranchName,
				dbo.Ins_Shift.ShiftName, 
				dbo.Ins_Version.VersionName,
				dbo.Ins_ClassInfo.ClassName,
				dbo.Ins_Section.SectionName, 
                dbo.Ins_Group.GroupName,
				dbo.Ins_Session.SessionName

FROM            dbo.Ins_Section INNER JOIN
                         dbo.Student_SiblingInfo INNER JOIN
                         dbo.Student_BasicInfo ON dbo.Student_SiblingInfo.SiblingStudentIID = dbo.Student_BasicInfo.StudentIID INNER JOIN
                         dbo.Ins_Branch ON dbo.Student_BasicInfo.BranchID = dbo.Ins_Branch.BranchId INNER JOIN
                         dbo.Ins_Version ON dbo.Student_BasicInfo.VersionID = dbo.Ins_Version.VersionId INNER JOIN
                         dbo.Ins_Session ON dbo.Student_BasicInfo.SessionId = dbo.Ins_Session.SessionId INNER JOIN
                         dbo.Ins_Shift ON dbo.Student_BasicInfo.ShiftID = dbo.Ins_Shift.ShiftId INNER JOIN
                         dbo.Ins_ClassInfo ON dbo.Student_BasicInfo.ClassId = dbo.Ins_ClassInfo.ClassId INNER JOIN
                         dbo.Ins_Group ON dbo.Student_BasicInfo.GroupId = dbo.Ins_Group.GroupId ON dbo.Ins_Section.SectionId = dbo.Student_BasicInfo.SectionId 
						 

						 where Student_SiblingInfo.StudentIID=@StudentIID and Student_SiblingInfo.IsDeleted='false'
END