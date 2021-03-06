/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ExcelFeesCollection]'))
BEGIN
DROP PROCEDURE  [ExcelFeesCollection]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Biplob
-- Create date: 
-- Description:	
-- =============================================
-- EXEC  [ExcelFeesCollection] 2,1,1,2,1,1,0,5,1,2019,'111811069'
-- EXEC  [ExcelFeesCollection] 2,null,null,null,null,null,null,null,1,2018,'1730006'

CREATE  PROCEDURE [dbo].[ExcelFeesCollection] 
    @BlockId INT,
	@VersionId INT =null,
	@SessionId INT=null,
	@BranchId INT=null,
	@ShiftId INT =null,
	@ClassId INT = null,
	@GroupId INT=null,
	@SectionId INT = null,
	@Month INT = null,
	@Year INT=null,
	@StudentInsID varchar(max)=null
	

AS
BEGIN
	IF(@BlockId=1)
	BEGIN
	select  sb.StudentInsID,sb.FullName,cast( sb.RollNo as int)RollNo ,sty.StudentTypeName,sum(fs.DueAmount) DueAmount,
	s.SessionName, v.VersionName, b.BranchName, sh.ShiftName, c.ClassName,g.GroupName, sc.SectionName 
	
	from dbo.Fees_Student fs
	join dbo.Student_BasicInfo sb on sb.StudentIID=fs.StudentIID 

	and sb.VersionID=@VersionId 
	and sb.SessionId=@SessionId
	and sb.BranchID=@BranchId  
	and sb.ShiftID=@ShiftId 
	and sb.ClassId=@ClassId 
	and sb.GroupId=@GroupId 
	and sb.SectionId=@SectionId
	and fs.MonthId <=@Month 
	and fs.Year=@Year 
	and fs.IsDeleted=0

	INNER JOIN dbo.Ins_Session s ON sb.SessionId = s.SessionId  
		INNER JOIN  dbo.Ins_Branch b ON sb.BranchID = b.BranchId 
		INNER JOIN  dbo.Ins_Version V ON sb.VersionID = V.VersionID 
		INNER JOIN dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId 
		INNER JOIN dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId 
		INNER JOIN  dbo.Ins_Group g ON sb.GroupId = g.GroupId
		INNER JOIN dbo.Ins_Section sc ON sc.SectionId = sb.SectionId 
		LEFT OUTER JOIN dbo.Ins_StudentType STY ON STY.StudentTypeId = SB.StudentTypeID
	
		group by 
			sb.StudentInsID,sb.FullName,sty.StudentTypeName,sb.RollNo,
			s.SessionName, v.VersionName, b.BranchName, sh.ShiftName, c.ClassName,g.GroupName,
			 sc.SectionName
				ORDER BY cast( sb.RollNo as int) 
	END
IF(@BlockId=2)
	BEGIN
		select sb.StudentIID,fs.FeesBookNo, sb.StudentInsID,sb.FullName,sb.RollNo ,
		sum(fs.DueAmount) TotalAmount,sum(fs.DueAmount) DueAmount
		,CAST( 1 as bit) Collection
	from dbo.Fees_Student fs
	join dbo.Student_BasicInfo sb on sb.StudentIID=fs.StudentIID 
	and fs.MonthId <=@Month
	and fs.Year=@Year
	and sb.StudentInsID=@StudentInsID 
	and fs.IsDeleted=0
	group by 
			sb.StudentIID,fs.FeesBookNo, sb.StudentInsID,sb.FullName,sb.RollNo
	END
END
