/****** Object:  StoredProcedure [dbo].[GetStudentInfoByFilter]    Script Date: 7/22/2017 4:15:28 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptColleUserSummaryYearly]'))
BEGIN
DROP PROCEDURE  rptColleUserSummaryYearly
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].rptColleUserSummaryYearly -- Total 11 param

@Where varchar(MAX) = NULL,
@Sort varchar(MAX) = NULL
AS
BEGIN           
DECLARE @sql varchar(max)

SET @sql = '	
		 create table #StudentList
		(
		SL int null,
		VersionName varchar(50) null,
		SessionName varchar(50) null,
		BranchName varchar(50) null,
		ShiftName varchar(50) null,
		ClassName varchar(50) null,
		GroupName varchar(50) null,
		SectionName varchar(50) null,
		StudentIID  bigint null,
		RollNo int,
		StudentInsID varchar(50) null,
		FullName varchar(250) null,
		MonthId int null,
		[MonthName] varchar(20) null,
		[Year] int null,
		Amount decimal(18,2)null,
		PaymentDate date null,
		UserFullName varchar(160) null,
		EmpFullName varchar(160) null
		)
   insert into #StudentList(VersionName,SessionName,BranchName,ShiftName,ClassName,GroupName,SectionName,StudentIID,RollNo,StudentInsID,
   FullName,MonthId,[MonthName],[Year],Amount,PaymentDate,UserFullName,EmpFullName) 

		SELECT v.VersionName,s.SessionName ,b.BranchName ,sh.ShiftName ,c.ClassName ,g.GroupName ,sc.SectionName ,
		 sb.StudentIID,cast(sb.RollNo AS INT) RollNo, sb.StudentInsID, sb.FullName,
		CD.MonthId,FM.MonthName,CD.Year, CD.Amount,CAST ( CM.PaymentDate AS DATE) AS PaymentDate,
		U.FullName AS UserFullName, E.FullName AS EmpFullName
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
		 INNER JOIN [dbo].[AspNetUsers] U ON U.Id= CM.AddBy
		 LEFT JOIN [dbo].[Emp_BasicInfo] E ON E.EmpBasicInfoID = U.EmpId
		  '
		PRINT(@sql)
	 IF(@Where IS NOT NULL and  @Where <> '')
	 BEGIN
		SET @sql = @sql + ' WHERE '+ @Where
	 END
	  IF(@Sort IS NOT NULL and  @Sort <> '')
	 BEGIN
		SET @sql = @sql + ' ORDER BY '+ @Sort
	 END
		 SET @sql=@sql + '
		create table #StudentSL
		(
		SL int null,
		StudentIID bigint null,
		)
		insert into #StudentSL(SL,StudentIID)select  ROW_NUMBER() OVER(ORDER BY RollNo asc) AS Row, StudentIID from #StudentList group by StudentIID,RollNo
		update a set a.SL=b.SL  from #StudentList as a inner join #StudentSL as b on a.StudentIID=b.StudentIID
		select * from #StudentList Order by SL	 
		 '
	-- SET @sql = @sql + '  ORDER BY cast(sb.RollNo AS INT)'
	  EXEC(@sql)
END


