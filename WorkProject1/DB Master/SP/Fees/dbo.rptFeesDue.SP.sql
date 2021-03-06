/****** Object:  StoredProcedure [dbo].[GetStudentInfoByFilter]    Script Date: 7/22/2017 4:15:28 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptFeesDue]'))
BEGIN
DROP PROCEDURE  rptFeesDue
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
---[dbo].rptStudentCollection ' SB.VersionID  IN (1)    AND  SB.SessionId  IN (10)   AND CAST( cm.PaymentDate AS DATE) = CAST(''4/6/2019 12:00:00 AM'' AS Date)'
Create PROCEDURE [dbo].rptFeesDue -- Total 11 param
@Where varchar(MAX) = NULL
AS
BEGIN           
DECLARE @sql varchar(max)
create table #studentlist
(
 SessionName varchar(max)
 ,BranchName varchar(max)
 ,ShiftName varchar(max)
 ,ClassName varchar(max)
 ,SectionName varchar(max)
,[StudentIID] int not null
,[RollNo] int not null
,[StudentInsID] int not null
 ,FullName varchar(max)
 ,Year int
 ,DueAmount decimal
 ,InvoiceAmount decimal
 ,ToMonth varchar(max)
 ,FromMonth varchar(max)
  ,HeadName varchar(max)
  ,Remarks varchar(max)
  ,MonthName varchar(max)
)

IF(@Where IS NOT NULL)
SET @Where =  @Where + ' AND fs.IsCompleted=0'
ELSE
SET @Where =  @Where + ' fs.IsCompleted=0'


SET @sql = '	
   insert into #studentlist
		SELECT s.SessionName ,b.BranchName ,sh.ShiftName ,c.ClassName ,sc.SectionName,
		 sb.StudentIID,cast(sb.RollNo AS INT) RollNo, sb.StudentInsID, sb.FullName
		,fs.Year, SUM(fs.DueAmount) DueAmount,SUM(fs.InvoiceAmount) InvoiceAmount,
		(select top 1 fm.MonthName
					  from Fees_Student fs
					  INNER JOIN Fees_FeesMonth fm on fm.FeesMonthId=fs.MonthId
					  where (DueAmount<>0 AND StudentIID=sb.StudentIID)) ToMonth,
		(select top 1  fm.MonthName
					  from Fees_Student fs
					  INNER JOIN Fees_FeesMonth fm on fm.FeesMonthId=fs.MonthId
					  where (DueAmount<>0 AND StudentIID=sb.StudentIID)
					  order by FeesStudentId desc) FromMonth,fh.HeadName,fs.Remarks,FM.MonthName
					  
		FROM Fees_Student fs 
		INNER JOIN 
		dbo.Student_BasicInfo sb ON sb.StudentIID = fs.StudentIID
		
		 left outer join dbo.Ins_Session s ON sb.SessionId = s.SessionId
		 left outer join dbo.Ins_Branch b ON sb.BranchID = b.BranchId
		 left outer join dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId
		 left outer join dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId
		 left outer join dbo.Fees_Head fh on fh.FeesHeadId = fs.HeadId
		 left outer join dbo.Ins_Section sc ON sc.SectionId = sb.SectionId
		 left outer join dbo.Fees_FeesMonth FM ON FM.FeesMonthId = fs.MonthId
		
		  '
		PRINT(@sql)
	 IF(@Where IS NOT NULL and  @Where <> '')
	 BEGIN
 SET @sql = @sql + ' WHERE  '+ @Where
	 END
	 SET @sql=@sql + '
	  group by s.SessionName ,b.BranchName ,sh.ShiftName ,c.ClassName ,sc.SectionName,
		 sb.StudentIID,sb.RollNo , sb.StudentInsID, sb.FullName, 
		fs.Year,fh.HeadName,fs.Remarks,FM.MonthName

	Order By CAST( SB.RollNo AS INT) ASC
	select * from #StudentList 	  Order By CAST( RollNo AS INT) ASC
	 '

	-- SET @sql = @sql + '  ORDER BY cast(sb.RollNo AS INT)'
	  EXEC(@sql)
END


	--- EXEC rptStudentCollection '   SB.VersionID  IN (1)    AND  SB.SessionId  IN (1)   AND cm.PaymentDate = CAST('5/9/2018 12:00:00 AM' AS Date)'
	----,(select StudentTypeName from Ins_StudentType where StudentTypeId=sb.StudentTypeID) as StudentTypeName