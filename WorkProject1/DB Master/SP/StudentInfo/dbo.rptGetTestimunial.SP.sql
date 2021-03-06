/****** Object:  StoredProcedure [dbo].[GetStudentInfoByFilter]    Script Date: 7/22/2017 4:15:28 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetTestimunial]'))
BEGIN
DROP PROCEDURE  rptGetTestimunial
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
--GetStudentSearch 'SB.VersionID  IN (1,2)  AND   SB.SessionId  IN (6,4) '
CREATE PROCEDURE [dbo].[rptGetTestimunial]  ---  EXEC [rptGetTestimunial] '13,14'
	
@StudentIID VARCHAR(1000)
AS
BEGIN
DECLARE @sql varchar(max)
			 --SET @Sql  ='SELECT * FROM [dbo].[Student_BasicInfo] as sb  WHERE sb.StudentIID IN (' + @StudentIID + ')'
			 --EXEC(@Sql)	

		SET @Sql  ='SELECT sb.StudentIID, sb.StudentInsID, sb.FullName, v.VersionName, s.SessionName, b.BranchName,
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
		WHERE sb.StudentIID IN (' + @StudentIID + ')' --IN (13,14) 
		 EXEC(@Sql)	
END
