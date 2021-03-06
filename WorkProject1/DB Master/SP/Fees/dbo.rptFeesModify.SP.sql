/****** Object:  StoredProcedure [dbo].[GetStudentInfoByFilter]    Script Date: 7/22/2017 4:15:28 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptFeesModify]'))
BEGIN
DROP PROCEDURE  rptFeesModify
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].rptFeesModify -- Total 11 param

@Where varchar(MAX) = NULL
AS
BEGIN           
DECLARE @sql varchar(max)
SET @sql = '	 
     SELECT v.VersionName,s.SessionName ,b.BranchName ,sh.ShiftName ,c.ClassName ,g.GroupName ,sc.SectionName ,
			sb.StudentIID,sb.RollNo, sb.StudentInsID, sb.FullName, 
			M.PreviousAmount, (M.PreviousAmount-M.ChangeAmount) AS ModifiedAmount, M.ChangeAmount AS PresentAmount, FM.MonthName, Y.Year,			
			H.[FeesHeadId] , H.[HeadName], U.UserName, M.AddDate AS TIME			
			FROM Fees_FeesModifyLog M INNER JOIN		
			dbo.Student_BasicInfo sb ON sb.StudentIID = M.StudentId AND  M.UpdateType=''ModifyFeesHead''
			left outer join dbo.Ins_Version v on sb.VersionID=v.VersionId
			left outer join dbo.Ins_Session s ON sb.SessionId = s.SessionId
			left outer join dbo.Ins_Branch b ON sb.BranchID = b.BranchId
			left outer join dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId
			left outer join dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId
			left outer join dbo.Ins_Group g ON sb.GroupId = g.GroupId
			left outer join dbo.Ins_Section sc ON sb.SectionId = sc.SectionId
			INNER JOIN Fees_Head H ON H.FeesHeadId = M.HeadId
			INNER JOIN AspNetUsers U ON M.AddBy=U.UserName
			INNER JOIN Fees_FeesSessionYear Y on M.FeesSessionYearId=Y.FeesSessionYearId
			INNER JOIN [dbo].[Fees_FeesMonth] FM ON FM.FeesMonthId = Y.MonthId
		  '
		PRINT(@sql)
	 IF(@Where IS NOT NULL and  @Where <> '')
	 BEGIN
 SET @sql = @sql + ' WHERE '+ @Where
	 END
	 

	-- SET @sql = @sql + '  ORDER BY cast(sb.RollNo AS INT)'
	  EXEC(@sql)
END


	