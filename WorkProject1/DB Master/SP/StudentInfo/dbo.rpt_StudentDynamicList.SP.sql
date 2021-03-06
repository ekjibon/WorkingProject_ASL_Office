/****** Object:  StoredProcedure [dbo].[rpt_StudentDynamicList]    Script Date: 7/22/2017 4:39:00 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rpt_StudentDynamicList]'))
BEGIN
DROP PROCEDURE  rpt_StudentDynamicList
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[rpt_StudentDynamicList]
	
	@WhereClause VARCHAR(MAX) = NULL,
	@SortOrder	VARCHAR(MAX) = NULL
AS
BEGIN
 DECLARE @sql varchar(max)
	
 SET @sql='	SELECT        
                         sb.RollNo,
						 sb.StudentInsID, 
						 sb.FullName, 
						 sb.NameBangla, 
						 sb.FatherName, 
                         sb.MotherName, 
						 sb.DateOfBirth, 
						 sb.Age, 
						 sb.Gender, 
						 sb.Nationality, 
						 sb.Religion, 
                         sb.BloodGroup, 
						 sb.Remarks, 
						 sb.[Status], 
						 (SELECT StudentTypeName FROM Ins_StudentType WHERE StudentTypeId=sb.StudentTypeID)  AS StudentTypeName,
						 (SELECT HouseName FROM Ins_House WHERE HouseId=sb.HouseID)  AS HouseName,
						 
						 sb.RegiNo, 
                         sb.SMSNotificationNo, 
						 sb.Quota, 
						 sb.AdmissionDate, 
						 dbo.Student_Image.Photo, 
						 dbo.Ins_Version.VersionName, 
						 dbo.Ins_Branch.BranchName, 
                         dbo.Ins_ClassInfo.ClassName, 
						 dbo.Ins_Session.SessionName, 
						 dbo.Ins_Section.SectionName, 
						 dbo.Ins_Group.GroupName
					FROM            
						 dbo.Student_BasicInfo sb  INNER JOIN
                         dbo.Ins_Version ON sb.VersionID = dbo.Ins_Version.VersionId INNER JOIN
                         dbo.Ins_Session ON sb.SessionId = dbo.Ins_Session.SessionId INNER JOIN
                         dbo.Ins_Section ON sb.SectionId = dbo.Ins_Section.SectionId INNER JOIN
                         dbo.Ins_Branch ON sb.BranchID = dbo.Ins_Branch.BranchId INNER JOIN
                         dbo.Ins_ClassInfo ON sb.ClassId = dbo.Ins_ClassInfo.ClassId INNER JOIN
                         dbo.Ins_Group ON sb.GroupId = dbo.Ins_Group.GroupId INNER JOIN
                         dbo.Student_Image ON sb.StudentIID = dbo.Student_Image.StudentIID
					WHERE 
							
						 ' + @WhereClause
						 
			IF @SortOrder <> ''	
				SET @sql = @sql + ' ORDER BY  ' + @SortOrder 
				--print @sql	
		EXEC ( @sql	 )
						  
END

-- exec rpt_StudentDynamicList 'sb.VersionID = 2002 AND sb.SessionId = 2012',  'RollNo,Religion'
