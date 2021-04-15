/****** Object:  StoredProcedure [dbo].[GetAllSubject]    Script Date: 7/22/2017 4:07:49 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptGetStudentSeatCapacity]'))
BEGIN
DROP PROCEDURE  rptGetStudentSeatCapacity
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec rptGetStudentSeatCapacity 1,10,8,2,19,0,NULL,10,'2019/1/1','2019/1/1'
create proc [dbo].[rptGetStudentSeatCapacity]
(
	@SessionId INT,
	@BranchID INT,
	@ShiftID INT,
	@ClassId INT,
	@SectionId INT,
	@TypeId INT,
	@FromDate smalldatetime =NULL,
	@ToDate smalldatetime =NULL
	
)
AS
BEGIN
   IF(@TypeId=10)
	BEGIN  
Select SEC.SectionName,
       SEC.SectionId,
	   B.BranchName,
       C.ClassId,
       C.ClassName ,
	   S.SessionName, 
       count(*) TotalStudent,SEC.NoOfSeat SeatCapacity
       from Student_BasicInfo sb
Inner Join Ins_ClassInfo C on sb.ClassId= C.ClassId
inner join Ins_Section SEC on sb.SectionId = SEC.SectionId
Inner join Ins_Branch B on B.BranchId = sb.BranchId
Inner Join Ins_Session S on sb.SessionId = S.SessionId
 where sb.BranchID = @BranchID
group by SEC.SectionName,C.ClassName,SEC.NoOfSeat,sb.SectionId,SEC.SectionId, C.ClassId, B.BranchName,S.SessionName
 
  --union
  -- Select count(*)TotalStudent From Student_BasicInfo
	
end

If(@TypeId=11)
Begin
Select SEC.SectionName,
       SEC.SectionId,
	   B.BranchName,
       C.ClassId,
       C.ClassName ,
	   S.SessionName,
	   sb.StudentIID,
	   sb.FullName, 
       count(*) TotalStudent,SEC.NoOfSeat SeatCapacity
       from Student_BasicInfo sb
Inner Join Ins_ClassInfo C on sb.ClassId= C.ClassId
inner join Ins_Section SEC on sb.SectionId = SEC.SectionId
Inner join Ins_Branch B on B.BranchId = sb.BranchId
Inner Join Ins_Session S on sb.SessionId = S.SessionId
 where  sb.BranchID = @BranchID
group by SEC.SectionName,C.ClassName,SEC.NoOfSeat,sb.SectionId,SEC.SectionId, C.ClassId,
 B.BranchName,S.SessionName, sb.FullName,sb.StudentIID
End
END