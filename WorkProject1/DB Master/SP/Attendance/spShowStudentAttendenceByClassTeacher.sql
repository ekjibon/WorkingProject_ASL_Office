
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'spShowStudentAttendenceByClassTeacher'))
BEGIN
DROP PROCEDURE  spShowStudentAttendenceByClassTeacher
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE spShowStudentAttendenceByClassTeacher   
@UserId nvarchar(128)
,@FromDate DATETIME=NULL
--,@ToDate SMALLDATETIME=NULL

AS
IF @UserId IS NOT NULL
BEGIN
      select ct.* ,u.AccountBranchId ,sb.StudentIID, sb.FullName, sb.RollNo 
          ,[AttendId],[StudentId],[InTime] ,[OutTime] ,[IsPresent],[IsLeave] ,[LeaveId]
		,[IsAbsconding] ,[AbscondingPeriod],[IsLate],[LateTime] ,[IsEarlyOut],[EarlyOutTime], [EntryType]
		 ,sb.SessionId ,sb.BranchID ,sb.ClassId ,sb.ShiftID ,sb.SessionId ,sb.SectionId  
		  from [Emp_ClassTeacher] ct
		  left join Emp_BasicInfo eb on eb.EmpBasicInfoID = ct.TeacherId
          inner join AspNetUsers u on u.EmpId=ct.TeacherId
		  inner join  Student_BasicInfo sb on sb.BranchID=ct.BranchId
		  left join Att_StudentAttendance sa on sa.StudentId=sb.StudentIID
		  inner join Ins_Session i on i.SessionId=sb.SessionId
		  inner join Ins_Branch b on b.BranchId=sb.BranchID
		  inner join Ins_ClassInfo o on o.ClassId=sb.ClassId
		  inner join Ins_Shift s on s.ShiftId=sb.ShiftID
		  inner join Ins_Section se on se.SectionId=sb.SectionId
  
          where  u.Id=@UserId and sa.AddDate=@FromDate 
          --where u.Id='98122228-546d-4e0e-a34e-27b56da35dfb' and sa.AddDate= 2019-09-25
END