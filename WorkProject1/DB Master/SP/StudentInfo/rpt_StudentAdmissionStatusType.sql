USE [TEST_DB]
GO

/****** Object:  StoredProcedure [dbo].[rpt_StudentAdmissionStatusType]    Script Date: 9/3/2018 7:02:57 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER procedure [dbo].[rpt_StudentAdmissionStatusType]
@dateStart smalldatetime,
@dateEnd smalldatetime,            --exec  [rpt_StudentAdmissionStatusType] '','2018-06-30 00:00:00.000','GN'
@admissionEntryType varchar(50) = NULL --exec  [rpt_StudentAdmissionStatusType] '2018-05-02 18:00:00.000','2018-08-30 00:00:00.000','GN'

as 

select 
sb.StudentInsID,
sb.FullName,
sb.RollNo,
sb.SMSNotificationNo,
sb.AdmissionDate ,
sb.AddmissionEntryType,
V.VersionName,
C.ClassName,
G.GroupName,
SEC.SectionName,(
case when sb.AddmissionEntryType='GN' then 'General'
when sb.AddmissionEntryType='AT' then 'Admission Test'
when  sb.AddmissionEntryType='WT' then 'With TC'
end ) as AddmissionEntryType
from Student_BasicInfo sb
 LEFT OUTER JOIN Ins_Version V on V.VersionId=sb.VersionID 
 LEFT OUTER JOIN Ins_ClassInfo C on C.ClassId=sb.ClassId 
 LEFT OUTER JOIN Ins_Group G on G.GroupId=sb.GroupId 
 LEFT OUTER JOIN Ins_Section SEC on SEC.SectionId=sb.SectionId 

 where (sb.AdmissionDate between @dateStart+1 and @dateEnd+1) AND sb.AddmissionEntryType= COALESCE(@admissionEntryType, AddmissionEntryType) 

 order by AdmissionDate

GO


