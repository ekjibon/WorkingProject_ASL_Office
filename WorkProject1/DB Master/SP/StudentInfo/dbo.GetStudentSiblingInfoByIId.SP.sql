/****** Object:  StoredProcedure [dbo].[GetStudentSiblingInfoByIId]    Script Date: 7/22/2017 4:20:48 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetStudentSiblingInfoByIId]'))
BEGIN
DROP PROCEDURE  GetStudentSiblingInfoByIId
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Biplob Hossen>
-- Create date: <05-04-2017>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetStudentSiblingInfoByIId]
	@StudentIID int
AS
BEGIN
	SELECT     sb.StudentIID as SiblingStudentIID , sb.StudentInsID, sb.FullName, v.VersionName, s.SessionName, b.BranchName, 
              sh.ShiftName, c.ClassName, g.GroupName, sc.SectionName, sb.RollNo,si.StudentIID
FROM               
                  dbo.Ins_Version v INNER JOIN
                  dbo.Student_BasicInfo sb ON v.VersionId = sb.VersionID INNER JOIN
                  dbo.Ins_Session s ON sb.SessionId = s.SessionId INNER JOIN
                  dbo.Ins_Branch b ON sb.BranchID = b.BranchId INNER JOIN
                  dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId INNER JOIN
                  dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId INNER JOIN
                  dbo.Ins_Group g ON sb.GroupId = g.GroupId  INNER JOIN
				  dbo.Ins_Section sc ON sc.SectionId = sb.SectionId INNER JOIN 
				  dbo.Student_SiblingInfo si ON si.SiblingStudentIID=sb.StudentIID where si.StudentIID=@StudentIID
END
