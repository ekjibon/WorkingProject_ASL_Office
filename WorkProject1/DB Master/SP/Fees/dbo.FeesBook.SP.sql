/****** Object:  StoredProcedure [dbo].[GetStudentInfoForResult]    Script Date: 7/22/2017 4:19:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FeesBook]'))
BEGIN
DROP PROCEDURE  FeesBook
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FeesBook] -- Total 10 param
	@Block INT = 0,
	@SessionId INT = NULL,
	@BranchID INT = NULL,
	@ShiftID INT = NULL,
	@ClassId INT = NULL,
	@SectionId INT = NULL,
	@StuIds VARCHAR(1000) = NULL,
	@FromMoth INT = Null,
	@ToMoth INT = Null,
	@Year INT = NULL -- Add by Khaled
	
	
AS
BEGIN

 IF(@Block=1) -- View Student Due
 --   execute FeesBook 1,11,8,null,19,null,null,8,9,2019
 --   execute FeesBook 1,1,1,2,1,4,0,11,10519
 BEGIN
	IF (@StuIds is null)
	BEGIN
	 SELECT        
		sb.StudentIID, RTRIM(sb.StudentInsID) StudentInsID, sb.FullName, s.SessionName, b.BranchName, 
        sh.ShiftName, c.ClassName,  sc.SectionName,stutype.StudentTypeName, sb.RollNo, sum(F.DueAmount) as DueAmount
		,SUM(F.InvoiceAmount) as InvoiceAmount ,datefromparts(F.[Year],F.MonthId, 1) AS TempMonth  INTO #temp
		
	FROM               
        dbo.Student_BasicInfo sb INNER JOIN
		dbo.Fees_Student F ON F.StudentIID = sb.StudentIID INNER JOIN
        dbo.Ins_Session s ON sb.SessionId = s.SessionId INNER JOIN
        dbo.Ins_Branch b ON sb.BranchID = b.BranchId INNER JOIN
        dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId INNER JOIN
        dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId INNER JOIN
		dbo.Ins_Section sc ON sc.SectionId = sb.SectionId INNER JOIN
		dbo.Ins_StudentType stutype ON stutype.StudentTypeId = sb.StudentTypeId 
		WHERE 			
			sb.SessionId = @SessionId AND 
			sb.BranchID = @BranchID AND
			sb.ShiftID = ISNULL(@ShiftID,sb.ShiftID) AND
			sb.ClassId = @ClassId AND
			sb.SectionId =ISNULL(@SectionId,sb.SectionId) AND 
			sb.IsDeleted=0 
			
		Group By sb.StudentIID, sb.StudentInsID, sb.FullName,  s.SessionName, b.BranchName, 
        sh.ShiftName, c.ClassName,  sc.SectionName,stutype.StudentTypeName, sb.RollNo, F.[Year],F.MonthId
				ORDER BY CAST(sb.RollNo AS INT)  ASC
		
		SELECT SUM(sb.InvoiceAmount) AS InvoiceAmount,sb.StudentIID, sb.StudentInsID, sb.FullName,  sb.SessionName, sb.BranchName,SUM(sb.DueAmount)AS DueAmount, 
        sb.ShiftName, sb.ClassName,  sb.SectionName,sb.StudentTypeName, sb.RollNo FROM   #temp sb WHERE TempMonth<= EOMONTH(datefromparts(@Year, @ToMoth, 1))
				GROUP BY sb.StudentIID, sb.StudentInsID, sb.FullName,  sb.SessionName, sb.BranchName, 
        sb.ShiftName, sb.ClassName,  sb.SectionName,sb.StudentTypeName, sb.RollNo
		ORDER BY CAST(sb.RollNo AS INT)  ASC
	DROP TABLE   #temp
		
	END
	ELSE
	BEGIN
	SELECT        
		sb.StudentIID, sb.StudentInsID, sb.FullName,  s.SessionName, b.BranchName, 
        sh.ShiftName, c.ClassName,  sc.SectionName, sb.RollNo, sum(F.DueAmount) as DueAmount,SUM(f.InvoiceAmount) as InvoiceAmount
	FROM               
      
        dbo.Student_BasicInfo sb  INNER JOIN
        dbo.Ins_Session s ON sb.SessionId = s.SessionId INNER JOIN
        dbo.Ins_Branch b ON sb.BranchID = b.BranchId INNER JOIN
        dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId INNER JOIN
        dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId INNER JOIN
     
		dbo.Ins_Section sc ON sc.SectionId = sb.SectionId INNER JOIN
		dbo.Ins_StudentType stutype ON stutype.StudentTypeId = sb.StudentTypeId INNER JOIN
		dbo.Fees_Student F ON F.StudentIID = sb.StudentIID
		WHERE 			
			sb.StudentIID  IN (SELECT * FROM [dbo].StringSplit(@StuIds,',')) AND
			sb.IsDeleted=0
		Group By sb.StudentIID, sb.StudentInsID, sb.FullName, s.SessionName, b.BranchName, 
        sh.ShiftName, c.ClassName, sc.SectionName, sb.RollNo,stutype.StudentTypeName
		ORDER BY CAST(sb.RollNo AS INT)  ASC
	END
 END

 IF(@Block=2) -- rpt Fees Book
 BEGIN
 
 --   execute FeesBook 2,null,null,null,null,null,'5116',08,01,2020
 select sb.StudentIID, RTRIM(sb.StudentInsID) StudentInsID, sb.FullName,  s.SessionName, b.BranchName, 
        sh.ShiftName, c.ClassName, sc.SectionName, sb.RollNo,
		m.[MonthName],F.FeesBookNo,f.FeesStudentId,F.Year,

		((case when ((select top 1 fse.FeesHeadHasGroup from dbo.Fees_Setting fse)=1) then 
		(case when ((select top 1 FDG.GroupName from dbo.Fees_DisplayGroup FDG  join dbo.Fees_DisplayGroupDetails fdgd
on fdgd.GroupId=FDG.DisplayGroupId where FDG.IsDeleted=0 and fdgd.HeadId=f.HeadId) is not null)
then (select top 1 FDG.GroupName from dbo.Fees_DisplayGroup FDG  join dbo.Fees_DisplayGroupDetails fdgd
on fdgd.GroupId=FDG.DisplayGroupId where FDG.IsDeleted=0 and fdgd.HeadId=f.HeadId )
else h.HeadName  END ) ELSE h.HeadName END)  + '(' + SUBSTRING([MonthName], 1, 3) + ')' ) as HeadName 
		,SUM( F.DueAmount)as DueAmount,SUM( F.InvoiceAmount)as InvoiceAmount,
		(SELECT Sum(SF.DueAmount) From dbo.Fees_Student SF INNER JOIN
		dbo.Fees_Head Hh On SF.HeadId=Hh.FeesHeadId INNER JOIN 
		dbo.Fees_FeesMonth Mm On Mm.FeesMonthId=SF.MonthId
		 where SF.StudentIID=sb.StudentIID AND  datefromparts(SF.Year,SF.MonthId, 1) <= EOMONTH(datefromparts(@Year, @ToMoth, 1)) --AND	SF.MonthId<=@ToMoth
													 AND SF.DueAmount > 0) as TotalDue
		,	[dbo].fnIntegerToWords((SELECT Sum(SF.DueAmount) From dbo.Fees_Student SF INNER JOIN
		dbo.Fees_Head Hh On SF.HeadId=Hh.FeesHeadId INNER JOIN 
		dbo.Fees_FeesMonth Mm On Mm.FeesMonthId=SF.MonthId
		 where SF.StudentIID=sb.StudentIID AND   datefromparts(SF.Year,SF.MonthId, 1) <= EOMONTH(datefromparts(@Year, @ToMoth, 1)) 
		 
		 AND SF.DueAmount > 0)) as InWord,
		 datefromparts(F.Year,F.MonthId, 1) AS TempMonth INTO #TempDueRpt
		 from dbo.Fees_Student F
INNER JOIN  dbo.Student_BasicInfo sb on SB.StudentIID=F.StudentIID AND
sb.StudentIID  IN (SELECT * FROM [dbo].StringSplit(@StuIds,',')) AND 
			sb.IsDeleted=0
INNER JOIN dbo.Ins_Session s ON sb.SessionId = s.SessionId INNER JOIN
     
        dbo.Ins_Branch b ON sb.BranchID = b.BranchId INNER JOIN
        dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId INNER JOIN
        dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId INNER JOIN
      
		dbo.Ins_Section sc ON sc.SectionId = sb.SectionId INNER JOIN
		dbo.Fees_Head H On F.HeadId=H.FeesHeadId INNER JOIN 
		dbo.Fees_FeesMonth M On M.FeesMonthId=F.MonthId
		where 
			sb.IsDeleted=0 
		GROUP BY 
		sb.StudentIID, sb.StudentInsID , sb.FullName, s.SessionName, b.BranchName, F.Year,
        sh.ShiftName, c.ClassName, sc.SectionName, sb.RollNo,H.HeadName,f.HeadId, M.[MonthName],F.FeesBookNo,f.FeesStudentId,F.Year,F.MonthId
		Having sum(F.DueAmount)>0 
		  ORDER BY CAST(sb.RollNo AS INT)  ASC
		  SELECT * FROM #TempDueRpt sb WHERE sb.TempMonth  <= EOMONTH(datefromparts(@Year, @ToMoth, 1))
		  	  ORDER BY CAST(sb.RollNo AS INT)  ASC

 DROP TABLE   #TempDueRpt

-- If(@FromMoth=@ToMoth)
-- BEGIN
--	select sb.StudentIID, RTRIM(sb.StudentInsID) StudentInsID, sb.FullName,  s.SessionName, b.BranchName, 
--        sh.ShiftName, c.ClassName, sc.SectionName, sb.RollNo,
--		m.[MonthName],F.FeesBookNo,f.FeesStudentId,

--		((case when ((select top 1 fse.FeesHeadHasGroup from dbo.Fees_Setting fse)=1) then 
--		(case when ((select top 1 FDG.GroupName from dbo.Fees_DisplayGroup FDG  join dbo.Fees_DisplayGroupDetails fdgd
--on fdgd.GroupId=FDG.DisplayGroupId where FDG.IsDeleted=0 and fdgd.HeadId=f.HeadId) is not null)
--then (select top 1 FDG.GroupName from dbo.Fees_DisplayGroup FDG  join dbo.Fees_DisplayGroupDetails fdgd
--on fdgd.GroupId=FDG.DisplayGroupId where FDG.IsDeleted=0 and fdgd.HeadId=f.HeadId )
--else h.HeadName  END ) ELSE h.HeadName END)  + '(' + SUBSTRING([MonthName], 1, 3) + ')' ) as HeadName 
--		,SUM( F.DueAmount)as DueAmount,SUM( F.InvoiceAmount)as InvoiceAmount,
--		(SELECT Sum(SF.DueAmount) From dbo.Fees_Student SF INNER JOIN
--		dbo.Fees_Head Hh On SF.HeadId=Hh.FeesHeadId INNER JOIN 
--		dbo.Fees_FeesMonth Mm On Mm.FeesMonthId=SF.MonthId
--		 where SF.StudentIID=sb.StudentIID AND   SF.MonthId<=@ToMoth AND SF.DueAmount > 0) as TotalDue
--		,	[dbo].fnIntegerToWords((SELECT Sum(SF.DueAmount) From dbo.Fees_Student SF INNER JOIN
--		dbo.Fees_Head Hh On SF.HeadId=Hh.FeesHeadId INNER JOIN 
--		dbo.Fees_FeesMonth Mm On Mm.FeesMonthId=SF.MonthId
--		 where SF.StudentIID=sb.StudentIID AND   SF.MonthId<=@ToMoth AND SF.DueAmount > 0)) as InWord
--		 from dbo.Fees_Student F
--INNER JOIN  dbo.Student_BasicInfo sb on SB.StudentIID=F.StudentIID AND
--sb.StudentIID  IN (SELECT * FROM [dbo].StringSplit(@StuIds,',')) AND F.MonthId<=@ToMoth AND
--			sb.IsDeleted=0
--INNER JOIN dbo.Ins_Session s ON sb.SessionId = s.SessionId INNER JOIN
     
--        dbo.Ins_Branch b ON sb.BranchID = b.BranchId INNER JOIN
--        dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId INNER JOIN
--        dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId INNER JOIN
      
--		dbo.Ins_Section sc ON sc.SectionId = sb.SectionId INNER JOIN
--		dbo.Fees_Head H On F.HeadId=H.FeesHeadId INNER JOIN 
--		dbo.Fees_FeesMonth M On M.FeesMonthId=F.MonthId
--		where 
--			sb.IsDeleted=0 
--		GROUP BY 
--		sb.StudentIID, sb.StudentInsID , sb.FullName, s.SessionName, b.BranchName, 
--        sh.ShiftName, c.ClassName, sc.SectionName, sb.RollNo,H.HeadName,f.HeadId, M.[MonthName],F.FeesBookNo,f.FeesStudentId
--		Having sum(F.DueAmount)>0 
--		  ORDER BY CAST(sb.RollNo AS INT)  ASC
-- END
-- ELSE
-- BEGIN
--select sum(q.DueAmount) DueAmount, sum(q.InvoiceAmount) InvoiceAmount, 
--			q.StudentIID,q.StudentInsID, q.FullName,  q.SessionName, q.BranchName, q.FeesStudentId,
--        q.ShiftName, q.ClassName,  q.SectionName, q.RollNo,q.HeadName ,q.[MonthName],q.[Year],q.FeesBookNo from(

--SELECT        
--		sb.StudentIID, RTRIM(sb.StudentInsID) StudentInsID, sb.FullName,  s.SessionName, b.BranchName, f.FeesBookNo,f.FeesStudentId,
--        sh.ShiftName, c.ClassName, sc.SectionName, sb.RollNo,		(case when ((select top 1 fse.FeesHeadHasGroup from dbo.Fees_Setting fse)=1) then 
--		(case when ((select top 1 FDG.GroupName from dbo.Fees_DisplayGroup FDG  join dbo.Fees_DisplayGroupDetails fdgd
--on fdgd.GroupId=FDG.DisplayGroupId where FDG.IsDeleted=0 and fdgd.HeadId=f.HeadId) is not null)
--then (select top 1 FDG.GroupName from dbo.Fees_DisplayGroup FDG  join dbo.Fees_DisplayGroupDetails fdgd
--on fdgd.GroupId=FDG.DisplayGroupId where FDG.IsDeleted=0 and fdgd.HeadId=f.HeadId )
--else h.HeadName  END ) ELSE h.HeadName END) HeadName  ,
--Sum(f.DueAmount) DueAmount,SUM( F.InvoiceAmount)as InvoiceAmount,(SUBSTRING(DATENAME(month, STR(F.Year, 4) + REPLACE(STR(@FromMoth, 2), ' ', '0') + '01'),1,3)+'/'+ SUBSTRING(CONVERT(varchar(20),f.Year),3,4) +' - '+
-- SUBSTRING(DATENAME(month, STR(F.Year, 4) + REPLACE(STR(@ToMoth, 2), ' ', '0') + '01'),1,3)+'/'+ SUBSTRING(CONVERT(varchar(20),f.Year),3,4)) AS MonthName
--	,F.Year
--	FROM               
      
--        dbo.Student_BasicInfo sb INNER JOIN
--        dbo.Ins_Session s ON sb.SessionId = s.SessionId INNER JOIN
--        dbo.Ins_Branch b ON sb.BranchID = b.BranchId INNER JOIN
--        dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId INNER JOIN
--        dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId INNER JOIN
 
--		dbo.Ins_Section sc ON sc.SectionId = sb.SectionId INNER JOIN
--		dbo.Fees_Student F ON F.StudentIID = sb.StudentIID INNER JOIN
--		dbo.Fees_Head H On F.HeadId=H.FeesHeadId INNER JOIN 
--		dbo.Fees_FeesMonth M On M.FeesMonthId=F.MonthId
--		WHERE 
--		    (F.MonthId>=@FromMoth AND F.MonthId<=@ToMoth) AND
--			sb.IsDeleted=0 AND
--			 f.DueAmount >0 and
--			sb.StudentIID  IN (SELECT * FROM [dbo].StringSplit(@StuIds,',')) 

--			group by f.HeadId,
--			sb.StudentIID,sb.StudentInsID, sb.FullName,  s.SessionName, b.BranchName, 
--        sh.ShiftName, c.ClassName,  sc.SectionName, sb.RollNo,H.HeadName ,f.Year,f.FeesBookNo,f.FeesStudentId
		    
--union
--SELECT        
--		sb.StudentIID, RTRIM(sb.StudentInsID) StudentInsID, sb.FullName,  s.SessionName, b.BranchName, f.FeesBookNo,f.FeesStudentId,
--        sh.ShiftName, c.ClassName,  sc.SectionName, sb.RollNo,	(case when ((select top 1 fse.FeesHeadHasGroup from dbo.Fees_Setting fse)=1) then 
--		(case when ((select top 1 FDG.GroupName from dbo.Fees_DisplayGroup FDG  join dbo.Fees_DisplayGroupDetails fdgd
--on fdgd.GroupId=FDG.DisplayGroupId where FDG.IsDeleted=0 and fdgd.HeadId=f.HeadId) is not null)
--then (select top 1 FDG.GroupName from dbo.Fees_DisplayGroup FDG  join dbo.Fees_DisplayGroupDetails fdgd
--on fdgd.GroupId=FDG.DisplayGroupId where FDG.IsDeleted=0 and fdgd.HeadId=f.HeadId )
--else h.HeadName  END ) ELSE h.HeadName END)  +'(Due)' ,
--Sum(f.DueAmount) DueAmount, SUM( F.InvoiceAmount)as InvoiceAmount,(SUBSTRING(DATENAME(month, STR(F.Year, 4) + REPLACE(STR(@FromMoth, 2), ' ', '0') + '01'),1,3)+' - '+
-- SUBSTRING(DATENAME(month, STR(F.Year, 4) + REPLACE(STR(@ToMoth, 2), ' ', '0') + '01'),1,3)) AS MonthName
--	,F.Year
--	FROM               
     
--        dbo.Student_BasicInfo sb  INNER JOIN
--        dbo.Ins_Session s ON sb.SessionId = s.SessionId INNER JOIN
--        dbo.Ins_Branch b ON sb.BranchID = b.BranchId INNER JOIN
--        dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId INNER JOIN
--        dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId INNER JOIN
     
--		dbo.Ins_Section sc ON sc.SectionId = sb.SectionId INNER JOIN
--		dbo.Fees_Student F ON F.StudentIID = sb.StudentIID INNER JOIN
--		dbo.Fees_Head H On F.HeadId=H.FeesHeadId INNER JOIN 
--		dbo.Fees_FeesMonth M On M.FeesMonthId=F.MonthId
--		WHERE 
--		    (F.MonthId<@FromMoth ) AND
--			sb.IsDeleted=0 AND
--			 f.DueAmount >0 and
--			sb.StudentIID  IN (SELECT * FROM [dbo].StringSplit(@StuIds,',')) 

--			group by f.HeadId,
--			sb.StudentIID,sb.StudentInsID, sb.FullName, s.SessionName, b.BranchName, 
--        sh.ShiftName, c.ClassName,  sc.SectionName, sb.RollNo,H.HeadName ,f.Year,f.FeesBookNo,f.FeesStudentId
		 
--			 ) as q
--			 where q.DueAmount > 0
-- Group by 
--			q.StudentIID,q.StudentInsID, q.FullName,  q.SessionName, q.BranchName, 
--        q.ShiftName, q.ClassName, q.SectionName, q.RollNo,q.HeadName ,q.Year,q.MonthName,q.FeesBookNo,q.FeesStudentId,q.FeesBookNo
--		having SUM(q.DueAmount) > 0
--		order by CAST( q.RollNo as int)
-- END
END

 IF(@Block=3) -- rpt Fees Storage
 --   execute FeesBook 3,1,1,2,1,1,0,5,'143,147,149,150,151,152,153,154,1064',1,2
 BEGIN

select
  Sum(DueAmount) DueAmount, HeadName,StudentInsID,	StudentIID,  FullName,  SessionName, BranchName, 
        ShiftName, ClassName, SectionName, RollNo,Year,MonthName,FeesBookNo
from(

SELECT   (case when ((select top 1 fse.FeesHeadHasGroup from dbo.Fees_Setting fse)=1) then 
		(case when ((select FDG.GroupName from dbo.Fees_DisplayGroup FDG  join dbo.Fees_DisplayGroupDetails fdgd
on fdgd.GroupId=FDG.DisplayGroupId where FDG.IsDeleted=0 and fdgd.HeadId=f.HeadId) is not null)
then (select top 1 FDG.GroupName from dbo.Fees_DisplayGroup FDG  join dbo.Fees_DisplayGroupDetails fdgd
on fdgd.GroupId=FDG.DisplayGroupId where FDG.IsDeleted=0 and fdgd.HeadId=f.HeadId )
else h.HeadName  END ) ELSE h.HeadName END) HeadName ,       
		sb.StudentIID, RTRIM(sb.StudentInsID) StudentInsID, sb.FullName, s.SessionName, b.BranchName, 
        sh.ShiftName, c.ClassName,  sc.SectionName, sb.RollNo,f.FeesBookNo,
		
Sum(f.TotalAmount) DueAmount,
(SUBSTRING(DATENAME(month, STR(F.Year, 4) + REPLACE(STR(@FromMoth, 2), ' ', '0') + '01'),1,3)+'/'+ SUBSTRING(CONVERT(varchar(20),f.Year),3,4) +' - '+
 SUBSTRING(DATENAME(month, STR(F.Year, 4) + REPLACE(STR(@ToMoth, 2), ' ', '0') + '01'),1,3)+'/'+ SUBSTRING(CONVERT(varchar(20),f.Year),3,4)) AS MonthName
	,F.Year
	FROM               
        dbo.Student_BasicInfo sb INNER JOIN
        dbo.Ins_Session s ON sb.SessionId = s.SessionId INNER JOIN
        dbo.Ins_Branch b ON sb.BranchID = b.BranchId INNER JOIN
        dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId INNER JOIN
        dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId INNER JOIN
		dbo.Ins_Section sc ON sc.SectionId = sb.SectionId INNER JOIN
		dbo.Fees_Student F ON F.StudentIID = sb.StudentIID INNER JOIN
		dbo.Fees_Head H On F.HeadId=H.FeesHeadId INNER JOIN 
		dbo.Fees_FeesMonth M On M.FeesMonthId=F.MonthId
		WHERE 
		    (F.MonthId>=@FromMoth AND F.MonthId<=@ToMoth) AND
			sb.IsDeleted=0 AND
			sb.StudentIID  IN (SELECT * FROM [dbo].StringSplit(@StuIds,',')) 
			group by f.HeadId, HeadName,sb.StudentInsID,	sb.StudentIID,  sb.FullName, s.SessionName, b.BranchName, 
        sh.ShiftName, c.ClassName,sc.SectionName, sb.RollNo,F.Year,f.FeesBookNo
		) as q
		group by  HeadName,StudentInsID,	StudentIID,  FullName, SessionName, BranchName, 
        ShiftName, ClassName,  SectionName, RollNo,Year,MonthName,FeesBookNo
		    
END


 -- execute FeesBook 6,1,1,2,1,5,'3610',1,6
 IF(@Block=4)
 BEGIN
select sum(q.DueAmount) DueAmount, 
			q.StudentIID,q.StudentInsID, q.FullName, q.SessionName, q.BranchName, 
        q.ShiftName, q.ClassName,  q.SectionName, q.RollNo,q.HeadName ,q.MonthName,  q.MonthId,q.Year,q.FeesBookNo from  (
 SELECT        
		sb.StudentIID, RTRIM(sb.StudentInsID) StudentInsID, sb.FullName,  s.SessionName, b.BranchName, 
        sh.ShiftName, c.ClassName, sc.SectionName, sb.RollNo,
		(case when ((select top 1 fse.FeesHeadHasGroup from dbo.Fees_Setting fse)=1) then 
		(case when ((select top 1 FDG.GroupName from dbo.Fees_DisplayGroup FDG  join dbo.Fees_DisplayGroupDetails fdgd
on fdgd.GroupId=FDG.DisplayGroupId where FDG.IsDeleted=0 and fdgd.HeadId=f.HeadId) is not null)
then (select top 1 FDG.GroupName from dbo.Fees_DisplayGroup FDG  join dbo.Fees_DisplayGroupDetails fdgd
on fdgd.GroupId=FDG.DisplayGroupId where FDG.IsDeleted=0 and fdgd.HeadId=f.HeadId )
else h.HeadName  END ) ELSE h.HeadName END) HeadName 
 ,F.FeesBookNo, F.DueAmount,
		(SELECT Sum(SF.DueAmount) From dbo.Fees_Student SF INNER JOIN
		dbo.Fees_Head Hh On SF.HeadId=Hh.FeesHeadId INNER JOIN 
		dbo.Fees_FeesMonth Mm On Mm.FeesMonthId=SF.MonthId
		 where SF.StudentIID=sb.StudentIID AND  (SF.MonthId>=@FromMoth AND SF.MonthId<=@ToMoth ) ) as TotalDue,
		[dbo].fnIntegerToWords((SELECT Sum(SF.DueAmount) From dbo.Fees_Student SF INNER JOIN
		dbo.Fees_Head Hh On SF.HeadId=Hh.FeesHeadId INNER JOIN 
		dbo.Fees_FeesMonth Mm On Mm.FeesMonthId=SF.MonthId
		 where SF.StudentIID=sb.StudentIID AND  (SF.MonthId>=@FromMoth AND SF.MonthId<=@ToMoth))) as InWord,
		(SUBSTRING(M.MonthName,1,3)+'/'+ SUBSTRING(CONVERT(varchar(20),f.Year),3,4)) AS MonthName
		,M.FeesMonthId AS MonthId,F.Year
	FROM               
     
        dbo.Student_BasicInfo sb  INNER JOIN
        dbo.Ins_Session s ON sb.SessionId = s.SessionId INNER JOIN
        dbo.Ins_Branch b ON sb.BranchID = b.BranchId INNER JOIN
        dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId INNER JOIN
        dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId INNER JOIN
      
		dbo.Ins_Section sc ON sc.SectionId = sb.SectionId INNER JOIN
		dbo.Fees_Student F ON F.StudentIID = sb.StudentIID INNER JOIN
		dbo.Fees_Head H On F.HeadId=H.FeesHeadId INNER JOIN 
		dbo.Fees_FeesMonth M On M.FeesMonthId=F.MonthId
		WHERE 
		    (F.MonthId>=@FromMoth AND F.MonthId<=@ToMoth) AND
			sb.IsDeleted=0 AND
			 f.DueAmount > 0 AND
			sb.StudentIID  IN (SELECT * FROM [dbo].StringSplit(@StuIds,',')) 
union 
 SELECT        
		sb.StudentIID, RTRIM(sb.StudentInsID) StudentInsID, sb.FullName, s.SessionName, b.BranchName, 
        sh.ShiftName, c.ClassName, sc.SectionName, sb.RollNo, 

		(case when ((select top 1 fse.FeesHeadHasGroup from dbo.Fees_Setting fse)=1) then 
		(case when ((select top 1 FDG.GroupName from dbo.Fees_DisplayGroup FDG  join dbo.Fees_DisplayGroupDetails fdgd
on fdgd.GroupId=FDG.DisplayGroupId where FDG.IsDeleted=0 and fdgd.HeadId=f.HeadId) is not null)
then (select top 1 FDG.GroupName from dbo.Fees_DisplayGroup FDG  join dbo.Fees_DisplayGroupDetails fdgd
on fdgd.GroupId=FDG.DisplayGroupId where FDG.IsDeleted=0 and fdgd.HeadId=f.HeadId )+'(Due)'
else h.HeadName+'(Due)'  END ) ELSE h.HeadName+'(Due)' END) HeadName ,

F.FeesBookNo, 
		(SELECT Sum(SF.DueAmount) From dbo.Fees_Student SF INNER JOIN
		dbo.Fees_Head Hh On SF.HeadId=Hh.FeesHeadId INNER JOIN 
		dbo.Fees_FeesMonth Mm On Mm.FeesMonthId=SF.MonthId
		 where SF.StudentIID=sb.StudentIID AND  (SF.MonthId<@FromMoth ) and SF.HeadId=f.HeadId) As DueAmount,
		(SELECT Sum(SF.DueAmount) From dbo.Fees_Student SF INNER JOIN
		dbo.Fees_Head Hh On SF.HeadId=Hh.FeesHeadId INNER JOIN 
		dbo.Fees_FeesMonth Mm On Mm.FeesMonthId=SF.MonthId
		 where SF.StudentIID=sb.StudentIID AND  (SF.MonthId<@FromMoth )) as TotalDue,
		[dbo].fnIntegerToWords((SELECT Sum(SF.DueAmount) From dbo.Fees_Student SF INNER JOIN
		dbo.Fees_Head Hh On SF.HeadId=Hh.FeesHeadId INNER JOIN 
		dbo.Fees_FeesMonth Mm On Mm.FeesMonthId=SF.MonthId
		 where SF.StudentIID=sb.StudentIID AND  (SF.MonthId<@FromMoth ))) as InWord,
				(SUBSTRING(M.MonthName,1,3)+'/'+ SUBSTRING(CONVERT(varchar(20),f.Year),3,4)) AS MonthName
		,M.FeesMonthId AS MonthId,F.Year
	FROM               
      
        dbo.Student_BasicInfo sb  INNER JOIN
        dbo.Ins_Session s ON sb.SessionId = s.SessionId INNER JOIN
        dbo.Ins_Branch b ON sb.BranchID = b.BranchId INNER JOIN
        dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId INNER JOIN
        dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId INNER JOIN
       
		dbo.Ins_Section sc ON sc.SectionId = sb.SectionId INNER JOIN
		dbo.Fees_Student F ON F.StudentIID = sb.StudentIID INNER JOIN
		dbo.Fees_Head H On F.HeadId=H.FeesHeadId INNER JOIN 
		dbo.Fees_FeesMonth M On M.FeesMonthId=F.MonthId
		WHERE 
		    F.MonthId=@FromMoth  AND
			sb.IsDeleted=0 AND
			 f.DueAmount > 0 AND
			sb.StudentIID  IN (SELECT * FROM [dbo].StringSplit(@StuIds,',')) 
			--group by sb.StudentIID, sb.StudentInsID , sb.FullName, v.VersionName, s.SessionName, b.BranchName, 
   --     sh.ShiftName, c.ClassName, g.GroupName, sc.SectionName, sb.RollNo,H.HeadName,M.[MonthName],M.FeesMonthId ,F.Year,F.FeesBookNo
) as q
where q.DueAmount > 0
 Group by 
			q.StudentIID,q.StudentInsID, q.FullName, q.SessionName, q.BranchName, 
        q.ShiftName, q.ClassName, q.SectionName, q.RollNo,q.HeadName ,q.Year,q.MonthName,q.MonthId,q.FeesBookNo
		having SUM(q.DueAmount) > 0
		order by CAST( q.RollNo as int)
 END
  IF(@Block=5)
 BEGIN

select sum(q.DueAmount) DueAmount, 
			q.StudentIID,q.StudentInsID, q.FullName,  q.SessionName, q.BranchName, 
        q.ShiftName, q.ClassName,  q.SectionName, q.RollNo,q.HeadName ,q.MonthName,  q.MonthId,q.Year,q.FeesBookNo from  (
 SELECT        
		sb.StudentIID, RTRIM(sb.StudentInsID) StudentInsID, sb.FullName,  s.SessionName, b.BranchName, 
        sh.ShiftName, c.ClassName,  sc.SectionName, sb.RollNo,
		(case when ((select top 1 fse.FeesHeadHasGroup from dbo.Fees_Setting fse)=1) then 
		(case when ((select top 1 FDG.GroupName from dbo.Fees_DisplayGroup FDG  join dbo.Fees_DisplayGroupDetails fdgd
on fdgd.GroupId=FDG.DisplayGroupId where FDG.IsDeleted=0 and fdgd.HeadId=f.HeadId) is not null)
then (select top 1 FDG.GroupName from dbo.Fees_DisplayGroup FDG  join dbo.Fees_DisplayGroupDetails fdgd
on fdgd.GroupId=FDG.DisplayGroupId where FDG.IsDeleted=0 and fdgd.HeadId=f.HeadId )
else h.HeadName  END ) ELSE h.HeadName END) HeadName 
 ,F.FeesBookNo, F.DueAmount,
		(SELECT Sum(SF.DueAmount) From dbo.Fees_Student SF INNER JOIN
		dbo.Fees_Head Hh On SF.HeadId=Hh.FeesHeadId INNER JOIN 
		dbo.Fees_FeesMonth Mm On Mm.FeesMonthId=SF.MonthId
		 where SF.StudentIID=sb.StudentIID AND  (SF.MonthId>=@FromMoth AND SF.MonthId<=@ToMoth ) ) as TotalDue,
		[dbo].fnIntegerToWords((SELECT Sum(SF.DueAmount) From dbo.Fees_Student SF INNER JOIN
		dbo.Fees_Head Hh On SF.HeadId=Hh.FeesHeadId INNER JOIN 
		dbo.Fees_FeesMonth Mm On Mm.FeesMonthId=SF.MonthId
		 where SF.StudentIID=sb.StudentIID AND  (SF.MonthId>=@FromMoth AND SF.MonthId<=@ToMoth))) as InWord,
		(SUBSTRING(M.MonthName,1,3)+'/'+ SUBSTRING(CONVERT(varchar(20),f.Year),3,4)) AS MonthName
		,M.FeesMonthId AS MonthId,F.Year
	FROM               
     
        dbo.Student_BasicInfo sb INNER JOIN
        dbo.Ins_Session s ON sb.SessionId = s.SessionId INNER JOIN
        dbo.Ins_Branch b ON sb.BranchID = b.BranchId INNER JOIN
        dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId INNER JOIN
        dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId INNER JOIN
		dbo.Ins_Section sc ON sc.SectionId = sb.SectionId INNER JOIN
		dbo.Fees_Student F ON F.StudentIID = sb.StudentIID INNER JOIN
		dbo.Fees_Head H On F.HeadId=H.FeesHeadId INNER JOIN 
		dbo.Fees_FeesMonth M On M.FeesMonthId=F.MonthId
		WHERE 
		    (F.MonthId>=@FromMoth AND F.MonthId<=@ToMoth) AND
			sb.IsDeleted=0 AND
			 f.DueAmount > 0 AND
			sb.StudentIID  IN (SELECT * FROM [dbo].StringSplit(@StuIds,',')) 

) as q

 Group by 
			q.StudentIID,q.StudentInsID, q.FullName,  q.SessionName, q.BranchName, 
        q.ShiftName, q.ClassName, q.SectionName, q.RollNo,q.HeadName ,q.Year,q.MonthName,q.MonthId,q.FeesBookNo
	
		order by CAST( q.RollNo as int)

 END
 IF(@Block=6) --execute FeesBook 6,null,null,null,null,null,'5085',null,null
  BEGIN
	
	SELECT        
		sb.StudentIID, sb.StudentInsID, sb.FullName,  s.SessionName, b.BranchName, 
        sh.ShiftName, c.ClassName,  sc.SectionName, sb.RollNo, sum(F.DueAmount) as DueAmount,SUM(f.InvoiceAmount) as InvoiceAmount,f.FeesBookNo
	FROM               
      
        dbo.Student_BasicInfo sb  INNER JOIN
        dbo.Ins_Session s ON sb.SessionId = s.SessionId INNER JOIN
        dbo.Ins_Branch b ON sb.BranchID = b.BranchId INNER JOIN
        dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId INNER JOIN
        dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId INNER JOIN
     
		dbo.Ins_Section sc ON sc.SectionId = sb.SectionId INNER JOIN
		dbo.Ins_StudentType stutype ON stutype.StudentTypeId = sb.StudentTypeId INNER JOIN
		dbo.Fees_Student F ON F.StudentIID = sb.StudentIID
		WHERE 			
			sb.StudentIID  IN (SELECT * FROM [dbo].StringSplit(@StuIds,',')) AND
			sb.IsDeleted=0
		Group By sb.StudentIID, sb.StudentInsID, sb.FullName, s.SessionName, b.BranchName, 
        sh.ShiftName, c.ClassName, sc.SectionName, sb.RollNo,stutype.StudentTypeName,f.FeesBookNo
		ORDER BY CAST(sb.RollNo AS INT)  ASC


 END
  IF(@Block=7) --execute FeesBook 7,1,1,2,1,5,'13712',1,6
  BEGIN
	
	SELECT        
		sb.StudentIID
		,F.TotalAmount
		,FCD.Amount
	    ,[dbo].[fnIntegerToWords](F.TotalAmount) AS TotalAmountWords
		,FH.HeadName
		--,(SELECT FS.DueAmount FROM dbo.Fees_Student FS WHERE FS.ProcessType = 'L' AND ProcessId = F.ProcessId) AS LatePayAmount
		,sb.StudentInsID, sb.FullName,
	  s.SessionName, b.BranchName, 
        sh.ShiftName, c.ClassName,  sc.SectionName, sb.RollNo
	FROM               
      
        dbo.Student_BasicInfo sb  INNER JOIN
        dbo.Ins_Session s ON sb.SessionId = s.SessionId INNER JOIN
        dbo.Ins_Branch b ON sb.BranchID = b.BranchId INNER JOIN
        dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId INNER JOIN
        dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId INNER JOIN
     
		dbo.Ins_Section sc ON sc.SectionId = sb.SectionId INNER JOIN
		dbo.Ins_StudentType stutype ON stutype.StudentTypeId = sb.StudentTypeId 
		INNER JOIN dbo.Fees_CollectionMaster F ON F.StudentIID = sb.StudentIID
		LEFT OUTER JOIN dbo.Fees_CollectionDetails FCD ON FCD.MasterID = F.Id
		LEFT OUTER JOIN dbo.Fees_Head FH ON FH.FeesHeadId = FCD.HeadId
		--INNER JOIN dbo.Fees_HeadAmountConfig FHA ON FHA.HeadId = F.HeadId AND FHA.ProcessId = F.ProcessId
		--LEFT OUTER JOIN dbo.Fees_AutomatedFeesConfig FA ON FA.FeesSessionYearId = F.FeesSessionYearId
		WHERE 			
			sb.StudentIID  IN (@StuIds) AND
			sb.IsDeleted=0
			--AND F.IsCompleted = 0
		Group By sb.StudentIID, sb.StudentInsID, sb.FullName, s.SessionName, b.BranchName, FH.HeadName,
        sh.ShiftName, c.ClassName, sc.SectionName, sb.RollNo,stutype.StudentTypeName,F.TotalAmount,FCD.Amount
		ORDER BY CAST(sb.RollNo AS INT)  ASC


 END


  IF(@Block=8) -- View Student Due
 --   execute FeesBook 1,11,8,null,19,null,null,7,9
 --   execute FeesBook 1,1,1,2,1,4,0,11,10519
 BEGIN
	IF (@StuIds is null)
	BEGIN
	 SELECT        
		 sb.StudentIID, RTRIM(sb.StudentInsID) StudentInsID, sb.FullName, s.SessionName, b.BranchName, 
        sh.ShiftName, c.ClassName,  sc.SectionName,stutype.StudentTypeName, sb.RollNo, 
		sum(F.DueAmount) as DueAmount
		,SUM(F.InvoiceAmount) as InvoiceAmount, datefromparts(F.Year,F.MonthId, 1) AS TempMonth INTO #TempDefaulter
	
	FROM               
        dbo.Student_BasicInfo sb INNER JOIN
		dbo.Fees_Student F ON F.StudentIID = sb.StudentIID INNER JOIN
        dbo.Ins_Session s ON sb.SessionId = s.SessionId INNER JOIN
        dbo.Ins_Branch b ON sb.BranchID = b.BranchId INNER JOIN
        dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId INNER JOIN
        dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId INNER JOIN
		dbo.Ins_Section sc ON sc.SectionId = sb.SectionId INNER JOIN
		dbo.Ins_StudentType stutype ON stutype.StudentTypeId = sb.StudentTypeId 
		WHERE 			
			sb.SessionId = @SessionId AND 
			sb.BranchID = @BranchID AND
			sb.ShiftID = ISNULL(@ShiftID,sb.ShiftID) AND
			sb.ClassId = @ClassId AND
			sb.SectionId =ISNULL(@SectionId,sb.SectionId) AND 
			F.IsPaid = 0 AND
			sb.IsDeleted=0
		Group By sb.StudentIID, sb.StudentInsID, sb.FullName,  s.SessionName, b.BranchName, F.Year,F.MonthId,
        sh.ShiftName, c.ClassName,  sc.SectionName,stutype.StudentTypeName, sb.RollNo
		ORDER BY CAST(sb.RollNo AS INT)  ASC
		SELECT sb.StudentIID, sb.StudentInsID, sb.FullName,  sb.SessionName, sb.BranchName,
        sb.ShiftName, sb.ClassName,  sb.SectionName,sb.StudentTypeName, sb.RollNo,SUM(sb.InvoiceAmount) AS InvoiceAmount,SUM(sb.DueAmount) AS DueAmount
		FROM #TempDefaulter sb WHERE sb.TempMonth <= EOMONTH(datefromparts(@Year, @ToMoth, 1))
		   GROUP BY  sb.StudentIID, sb.StudentInsID, sb.FullName,  sb.SessionName, sb.BranchName,
        sb.ShiftName, sb.ClassName,  sb.SectionName,sb.StudentTypeName, sb.RollNo
			DROP TABLE #TempDefaulter
	END
		ELSE
	BEGIN
	SELECT        
		sb.StudentIID, sb.StudentInsID, sb.FullName,  s.SessionName, b.BranchName, 
        sh.ShiftName, c.ClassName,  sc.SectionName, sb.RollNo, sum(F.DueAmount) as DueAmount,SUM(f.InvoiceAmount) as InvoiceAmount,f.FeesBookNo
	FROM               
      
        dbo.Student_BasicInfo sb  INNER JOIN
        dbo.Ins_Session s ON sb.SessionId = s.SessionId INNER JOIN
        dbo.Ins_Branch b ON sb.BranchID = b.BranchId INNER JOIN
        dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId INNER JOIN
        dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId INNER JOIN
     
		dbo.Ins_Section sc ON sc.SectionId = sb.SectionId INNER JOIN
		dbo.Ins_StudentType stutype ON stutype.StudentTypeId = sb.StudentTypeId INNER JOIN
		dbo.Fees_Student F ON F.StudentIID = sb.StudentIID
		WHERE 			
			sb.StudentIID  IN (SELECT * FROM [dbo].StringSplit(@StuIds,',')) AND
			sb.IsDeleted=0 AND F.IsPaid = 0 
		Group By sb.StudentIID, sb.StudentInsID, sb.FullName, s.SessionName, b.BranchName, 
        sh.ShiftName, c.ClassName, sc.SectionName, sb.RollNo,stutype.StudentTypeName,f.FeesBookNo
		ORDER BY CAST(sb.RollNo AS INT)  ASC
	END
 END


END
--select* from dbo.Fees_Student where StudentIID=3606

