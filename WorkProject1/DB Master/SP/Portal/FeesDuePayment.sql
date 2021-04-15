IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FeesDuePayment]'))
BEGIN
DROP PROCEDURE  FeesDuePayment
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec FeesDuePayment 4556,1013

CREATE PROCEDURE [dbo].[FeesDuePayment] 
(
	@IID INT,
	@FeesSessionYearId INT
)
AS
BEGIN
	DECLARE @MonthId INT = 0 ,@Year INT  = 0
	SELECT @MonthId = MonthId ,@Year = Year FROM dbo.Fees_FeesSessionYear WHERE FeesSessionYearId = @FeesSessionYearId
	PRINT @MonthId
	PRINT @Year

	--SELECT  Distinct
		
	--		(SELECT   STUFF((SELECT ',' + SUBSTRING(FM.MonthName ,0,4) 
	--					  FROM dbo.Fees_Student FS 
	--						   INNER JOIN dbo.Fees_FeesMonth FM ON FM.FeesMonthId = FS.MonthId
	--						WHERE FS.StudentIID = SB.StudentIID AND FS.IsDeleted = 0 
	--							AND FS.HeadId = F.HeadId
	--							AND FS.DueAmount <> 0 AND datefromparts(FS.Year, FS.MonthId, 1) <= EOMONTH(datefromparts(@Year, @MonthId, 1))
	--							GROUP BY FS.MonthId,FM.MonthName,FS.IsPaid
	--					  FOR XML PATH('')) ,1,1,'')) AS DueMonth,
	--	 SUM(F.DueAmount) AS DueAmount

	--	,FH.HeadName
	--	,F.Year 
	--	,F.HeadId
	

	--	,sb.StudentIID, sb.StudentInsID, sb.FullName,Sb.RollNo
	--	,B.BranchName,C.ClassName,SC.SectionName,SH.ShiftName,S.SessionName
	--FROM               
 --       dbo.Student_BasicInfo sb
	--	INNER JOIN dbo.Ins_Session s ON sb.SessionId = s.SessionId
	--	INNER JOIN  dbo.Ins_Branch b ON sb.BranchID = b.BranchId
	--	INNER JOIN  dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId 
	--	INNER JOIN   dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId
		 
	--	INNER JOIN dbo.Ins_Section sc ON sc.SectionId = sb.SectionId 
	--	INNER JOIN dbo.Ins_StudentType stutype ON stutype.StudentTypeId = sb.StudentTypeId
	--	INNER JOIN dbo.Fees_Student F ON F.StudentIID = sb.StudentIID
	--	INNER JOIN dbo.Fees_Head FH ON FH.FeesHeadId = F.HeadId
	--	INNER JOIN [dbo].[Fees_FeesMonth] CM ON CM.FeesMonthId = F.MonthId
	--	LEFT OUTER JOIN Fees_ScholarshipMaster fs ON f.StudentIID=fs.StudentId and fs.IsDeleted=0   
	--	LEFT OUTER JOIN Fees_ScholarshipType fst ON fs.ScholarshipTypeId=fst.ScholarshipTypeId and fst.IsDeleted=0   
	--	WHERE 			
	--	F.StudentIID = @IID 
	--		AND	sb.IsDeleted=0  AND F.IsDeleted = 0			 
	--		AND F.DueAmount <> 0 AND  sb.[Status] = 'A' 
	--	AND datefromparts(F.Year, F.MonthId, 1) <= EOMONTH(datefromparts(@Year, @MonthId, 1))

	--	Group By  
	--	FH.HeadName,
	--	F.Year,
	--	F.HeadId,				
	--	SB.StudentIID, sb.StudentInsID, sb.FullName,Sb.RollNo
	--	,B.BranchName,C.ClassName,SC.SectionName,SH.ShiftName,S.SessionName
	--Order by F.HeadId ASC


 --END

 select sb.StudentIID, RTRIM(sb.StudentInsID) StudentInsID, sb.FullName,  s.SessionName, b.BranchName,sb.SMSNotificationNo, 
        sh.ShiftName, c.ClassName, sc.SectionName, sb.RollNo,
		m.[MonthName],F.FeesBookNo,f.FeesStudentId,F.[Year],

		((case when ((select top 1 fse.FeesHeadHasGroup from dbo.Fees_Setting fse)=1) then 
		(case when ((select top 1 FDG.GroupName from dbo.Fees_DisplayGroup FDG  join dbo.Fees_DisplayGroupDetails fdgd
on fdgd.GroupId=FDG.DisplayGroupId where FDG.IsDeleted=0 and fdgd.HeadId=f.HeadId) is not null)
then (select top 1 FDG.GroupName from dbo.Fees_DisplayGroup FDG  join dbo.Fees_DisplayGroupDetails fdgd
on fdgd.GroupId=FDG.DisplayGroupId where FDG.IsDeleted=0 and fdgd.HeadId=f.HeadId )
else h.HeadName  END ) ELSE h.HeadName END)  +' '+ '(' + SUBSTRING([MonthName], 1, 3) +'-'+CAST (right(F.Year,2) AS nvarchar(50)) + ')' ) as HeadName 
		,SUM( F.DueAmount)as DueAmount,SUM( F.InvoiceAmount)as InvoiceAmount,
		(SELECT Sum(SF.DueAmount) From dbo.Fees_Student SF INNER JOIN
		dbo.Fees_Head Hh On SF.HeadId=Hh.FeesHeadId INNER JOIN 
		dbo.Fees_FeesMonth Mm On Mm.FeesMonthId=SF.MonthId
		 where SF.StudentIID=sb.StudentIID AND  datefromparts(SF.Year,SF.MonthId, 1) <= EOMONTH(datefromparts(@Year, @MonthId, 1)) --AND	SF.MonthId<=@ToMoth
													 AND SF.DueAmount > 0 AND SF.IsDeleted =0) as TotalDue
		,	[dbo].fnIntegerToWords((SELECT Sum(SF.DueAmount) From dbo.Fees_Student SF INNER JOIN
		dbo.Fees_Head Hh On SF.HeadId=Hh.FeesHeadId INNER JOIN 
		dbo.Fees_FeesMonth Mm On Mm.FeesMonthId=SF.MonthId
		 where SF.StudentIID=sb.StudentIID AND   datefromparts(SF.Year,SF.MonthId, 1) <= EOMONTH(datefromparts(@Year, @MonthId, 1)) 
		 
		 AND SF.DueAmount > 0)) as InWord,
		 (SELECT   STUFF((SELECT ',' + SUBSTRING(FM.MonthName ,0,4) +'-'+cast(right(FS.Year,2) as nvarchar(10)) 
						  FROM dbo.Fees_Student FS 
							INNER JOIN dbo.Fees_FeesMonth FM ON FM.FeesMonthId = FS.MonthId
							WHERE FS.StudentIID = SB.StudentIID AND FS.IsDeleted = 0 
								AND FS.HeadId = F.HeadId
								AND FS.DueAmount <> 0 AND datefromparts(FS.Year, FS.MonthId, 1) <= EOMONTH(datefromparts(@Year, @MonthId, 1))
								
						  FOR XML PATH('')) ,1,1,'')) AS DueMonth,
		 datefromparts(F.Year,F.MonthId, 1) AS TempMonth INTO #TempDueRpt
		 from dbo.Fees_Student F
INNER JOIN  dbo.Student_BasicInfo sb on SB.StudentIID=F.StudentIID AND
sb.StudentIID  IN (SELECT * FROM [dbo].StringSplit(@IID,',')) AND 
			sb.IsDeleted=0
INNER JOIN dbo.Ins_Session s ON sb.SessionId = s.SessionId INNER JOIN
     
        dbo.Ins_Branch b ON sb.BranchID = b.BranchId INNER JOIN
        dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId INNER JOIN
        dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId INNER JOIN
      
		dbo.Ins_Section sc ON sc.SectionId = sb.SectionId INNER JOIN
		dbo.Fees_Head H On F.HeadId=H.FeesHeadId INNER JOIN 
		dbo.Fees_FeesMonth M On M.FeesMonthId=F.MonthId
		where 
			sb.IsDeleted=0 AND F.IsDeleted =0
		GROUP BY 
		sb.StudentIID, sb.StudentInsID , sb.FullName, s.SessionName, b.BranchName, F.Year,sb.SMSNotificationNo, 
        sh.ShiftName, c.ClassName, sc.SectionName, sb.RollNo,H.HeadName,f.HeadId, M.[MonthName],F.FeesBookNo,f.FeesStudentId,F.Year,F.MonthId
		Having sum(F.DueAmount)>0 
		  ORDER BY CAST(sb.RollNo AS INT)  ASC
		  SELECT * FROM #TempDueRpt sb WHERE sb.TempMonth  <= EOMONTH(datefromparts(@Year, @MonthId, 1))
		  	  ORDER BY CAST(sb.RollNo AS INT)  ASC

 DROP TABLE   #TempDueRpt


END