/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptCollectionHeadSummaryDaily]'))
BEGIN
DROP PROCEDURE  [rptCollectionHeadSummaryDaily]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shahin
-- Create date: March 19, 2018
-- Description:	
-- =============================================


CREATE  PROCEDURE [dbo].[rptCollectionHeadSummaryDaily] 
(
  
	@Where varchar(MAX) = NULL,
	@sortby varchar(MAX) = NULL
)	
AS
BEGIN
		DECLARE @sql varchar(max)     
		SET @sql = 'select s.SessionName, v.VersionName, b.BranchName, sh.ShiftName, c.ClassName,g.GroupName, sc.SectionName,  D.PaymentDate, fcd.HeadId,fh.HeadName, SUM(fcd.ReceiveAmount) Amount 
from dbo.Fees_CollectionMaster D 
inner join dbo.Fees_CollectionDetails fcd on fcd.MasterID=D.Id
INNER JOIN dbo.Fees_Head fh on fh.FeesHeadId =fcd.HeadId
join dbo.Student_BasicInfo sb on sb.StudentIID=D.StudentIID and sb.Status=''A'' and sb.IsDeleted=0 
INNER JOIN dbo.Ins_Session s ON sb.SessionId = s.SessionId  
		INNER JOIN  dbo.Ins_Branch b ON sb.BranchID = b.BranchId 
		INNER JOIN  dbo.Ins_Version V ON sb.VersionID = V.VersionID 
		INNER JOIN dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId 
		INNER JOIN dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId 
		INNER JOIN  dbo.Ins_Group g ON sb.GroupId = g.GroupId
		INNER JOIN dbo.Ins_Section sc ON sc.SectionId = sb.SectionId'
		  IF(@Where IS NOT NULL AND  @Where <> '')
	 BEGIN
	 SET @sql = @sql + ' where '+ @Where
	 END
 SET @sql = @sql + 'group by fcd.HeadId,fh.HeadName,D.PaymentDate,s.SessionName, v.VersionName, 
b.BranchName, sh.ShiftName, c.ClassName,g.GroupName, sc.SectionName
'

 IF(@sortby IS NOT NULL AND  @sortby <> '')
	 BEGIN
	 SET @sql = @sql + ' Order by '+ @sortby
	 END
	EXEC(@sql)

END


select sb.FullName,sb.RollNo,d.PaymentDate,d.BankCollectionDate, s.SessionName,
 v.VersionName, b.BranchName, sh.ShiftName, c.ClassName,g.GroupName, sc.SectionName,  D.PaymentDate, fcd.HeadId,fh.HeadName, SUM(fcd.ReceiveAmount) Amount 
from dbo.Fees_CollectionMaster D 
inner join dbo.Fees_CollectionDetails fcd on fcd.MasterID=d.Id
INNER JOIN dbo.Fees_Head fh on fh.FeesHeadId =fcd.HeadId
join dbo.Student_BasicInfo sb on sb.StudentIID=d.StudentIID 

INNER JOIN dbo.Ins_Session s ON sb.SessionId = s.SessionId  
		INNER JOIN  dbo.Ins_Branch b ON sb.BranchID = b.BranchId 
		INNER JOIN  dbo.Ins_Version V ON sb.VersionID = V.VersionID 
		INNER JOIN dbo.Ins_Shift sh ON sb.ShiftID = sh.ShiftId 
		INNER JOIN dbo.Ins_ClassInfo c ON sb.ClassId = c.ClassId 
		INNER JOIN  dbo.Ins_Group g ON sb.GroupId = g.GroupId
		INNER JOIN dbo.Ins_Section sc ON sc.SectionId = sb.SectionId 
		where    SB.VersionID  IN (1)    AND  SB.SessionId  IN (1)    AND  SB.BranchID  IN (2)  
  AND  SB.ShiftID  IN (1)    AND  SB.ClassId  IN (1)    AND  SB.SectionId  IN (5)    
  AND  SB.GroupId  IN (0)   AND   Convert(varchar,D.PaymentDate,103) =Convert(varchar,'15/05/2018',103)
group by fcd.HeadId,fh.HeadName,d.PaymentDate,s.SessionName,sb.SectionId,sb.BranchID, v.VersionName,sb.VersionId, 
b.BranchName, sh.ShiftName, c.ClassName,g.GroupName, sc.SectionName,sb.FullName,sb.RollNo,d.PaymentDate,d.BankCollectionDate

--[dbo].[rptCollectionHeadSummaryDaily]    'SB.VersionID  IN (1)    AND  SB.SessionId  IN (1)    AND  SB.BranchID  IN (2)    AND  SB.ShiftID  IN (1)    AND  SB.ClassId  IN (1)    AND  SB.SectionId  IN (5)    AND  SB.GroupId  IN (0)   AND  Convert(varchar,D.PaymentDate,103) = Convert(varchar,''15/05/2018'',103)',''






		   
