IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmpStudentList]'))
BEGIN
DROP PROCEDURE  GetEmpStudentList
END
GO
/****** Object:  StoredProcedure [dbo].[GetEmpMeetingList]    Script Date: 7/9/2019 11:12:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[GetEmpStudentList]
(
@EmpId int
)
As
Begin
 Select st.Id as RequestId,'TC' as RequestType,st.Reason,st.Description,st.LeaveDate,st.AddBy,st.AddDate,
 sb.FullName as StudentName,sb.StudentIID,sb.StudentInsID,cl.ClassName,st.Remarks,st.Status from Student_Request st 
 inner join Student_BasicInfo sb on sb.StudentIID=st.StudentId
 inner join Ins_ClassInfo cl on cl.ClassId=sb.ClassId 
 inner join Emp_ClassTeacher clst on sb.ClassId=clst.ClassId and sb.BranchID=clst.BranchId
 and sb.ShiftID=clst.ShiftId and sb.SectionId=clst.SectionId and sb.SessionId=clst.SessionId
 where st.RequestType=4 and st.IsDeleted=0 and clst.TeacherId=@EmpId
End

-- GetEmpStudentList 19