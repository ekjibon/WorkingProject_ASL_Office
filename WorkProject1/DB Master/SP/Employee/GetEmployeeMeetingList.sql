/****** Object:  StoredProcedure [dbo].[SP_GetEmpAllInfo]    Script Date: 11/18/2017 6:37:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmployeeMeetingList]'))
BEGIN
DROP PROCEDURE  GetEmployeeMeetingList
END -- GetEmployeeMeetingList 3
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEmployeeMeetingList] 
@EmpId varchar(MAX)
AS
BEGIN
IF NOT EXISTS (SELECT * FROM Emp_ClassTeacher ct where ct.TeacherId=@EmpId)
 BEGIN
 print 'aa'
 SELECT sr.Id as RequestId,sr.StudentId,sr.Status,
	'ParrentMeeting' RequestType,
	CONVERT(nvarchar(30), sr.[Date], 106)
	 as MeetingDate,
	sr.Reason,
CAST(sr.[Time] as datetime)
	  as MeetingTime,
	sr.Description,sr.RequestOn, sb.FullName as StudentName,cl.ClassName,@EmpId TeacherId
	 from Student_Request sr inner join Common_DropDownConfig cd on cd.Value=sr.CategoryId and cd.Type='EmpDept'
	  inner join Emp_MeetingConfig em on em.EmpCategoryId=cd.Value 
	  inner join Student_BasicInfo sb on sb.StudentIID=sr.StudentId
	  inner join Ins_ClassInfo cl on cl.ClassId=sb.ClassId
	  where sr.RequestType=1 and em.FirstEmpId=@EmpId

 END
 ELSE
 BEGIN
 SELECT sr.Id as RequestId,sr.StudentId,sr.[Status],
	'ParrentMeeting' RequestType,
	CONVERT(nvarchar(30), sr.[Date], 106)
	 as MeetingDate,
	sr.Reason,
	CAST(sr.[Time] as datetime)
	  as MeetingTime,
	sr.Description,sr.RequestOn, sb.FullName as StudentName,cl.ClassName,ec.TeacherId
	 from Student_Request sr inner join Student_BasicInfo sb on sr.StudentId=sb.StudentIID
inner join Emp_ClassTeacher ec on ec.ClassId=sb.ClassId and ec.SessionId=sb.SessionId and ec.BranchId=sb.BranchID
and ec.ShiftId=sb.ShiftID and ec.SectionId=sb.SectionId inner join Emp_MeetingConfig em on em.FirstEmpId=ec.TeacherId
inner join Common_DropDownConfig cd on cd.Value=em.EmpCategoryId and cd.Type='EmpDept'
inner join Ins_ClassInfo cl on cl.ClassId=sb.ClassId
where sr.RequestType=1 and sr.IsDeleted=0 and CategoryId=5 and ec.TeacherId=@EmpId

 END

END

--select * from Emp_MeetingConfig