/****** Object:  StoredProcedure [dbo].[GetStudentInfoByFilter]    Script Date: 7/22/2017 4:15:28 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptStudentCollection]'))
BEGIN
DROP PROCEDURE  rptStudentCollection
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].rptStudentCollection -- Total 11 param

@Where varchar(MAX) = NULL
AS
BEGIN           
DECLARE @sql varchar(max)



SET @sql = '	
		 
		SELECT v.VersionName,s.SessionName ,b.BranchName ,sh.ShiftName ,c.ClassName ,g.GroupName ,sc.SectionName ,
		 sb.StudentIID,cast(sb.RollNo AS INT) RollNo, sb.StudentInsID, sb.FullName,
		CD.MonthId,FM.MonthName,CD.Year, CD.Amount
		FROM Fees_CollectionMaster CM 
		INNER JOIN Fees_CollectionDetails CD ON CM.Id= CD.MasterID
		INNER JOIN 
		dbo.Student_BasicInfo sb ON sb.StudentIID = CM.StudentIID
		 left outer join dbo.Ins_Version v on sb.VersionID=v.VersionId
		 left outer join dbo.Ins_Session s ON sb.SessionId = s.SessionId
		 left outer join dbo.Ins_Branch b ON sb.BranchID = b.BranchId
		 left outer join dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId
		 left outer join dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId
		 left outer join dbo.Ins_Group g ON sb.GroupId = g.GroupId
		 left outer join dbo.Ins_Section sc ON sc.SectionId = sb.SectionId
		 INNER JOIN [dbo].[Fees_FeesMonth] FM ON FM.FeesMonthId = CD.MonthId
		  '
		PRINT(@sql)
	 IF(@Where IS NOT NULL and  @Where <> '')
	 BEGIN
 SET @sql = @sql + ' WHERE '+ @Where
	 END
	 

	-- SET @sql = @sql + '  ORDER BY cast(sb.RollNo AS INT)'
	  EXEC(@sql)
END

	--- EXEC rptStudentCollection ''
