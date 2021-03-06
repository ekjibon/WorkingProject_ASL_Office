IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetStuECAAttendanceList]'))
BEGIN
DROP PROCEDURE  GetStuECAAttendanceList
END
GO
/****** Object:  StoredProcedure [dbo].[GetStuECAAttendanceList]    Script Date: 5/10/2019 10:20:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[GetStuECAAttendanceList]
(
 @TermId INT = 0,
 @DayId INT = 0,
 @ClubId INT =0,
 @ClassId INT =0
)
As
Begin
         if(@TermId = 0) set @TermId = null
         if(@DayId = 0) set @DayId = null
         if(@ClubId = 0) set @ClubId = null
         if(@ClassId = 0) set @ClassId = null
Select 
       sc.Id, 
	   sc.StudentId,
	   sc.TermId,
	   sc.DayId,
	   sb.StudentInsID,
	   sb.FullName,
       sc.AddDate,
	   sc.ClubId,
	   ec.ClubName,
	   sb.ClassId,
	   c.ClassName,
	   sb.SessionId,
	   s.SessionName,
	
	   sec.SectionId,
	 sec.SectionName
	    from dbo.Stu_Clubs sc 
		Join dbo.Student_BasicInfo sb on sc.StudentId=sb.StudentIID
		inner join dbo.Ins_ECAClubConfig ecc on ecc.ClubId = sc.ClubId and sc.ClubId = sb.ECAClubId

  left outer Join dbo.Ins_ECAClub ec on   ec.ClubId = ecc.ClubId

	left Join dbo.Ins_Branch b on sb.BranchID = b.BranchId
	Join dbo.Ins_Shift sh on sh.ShiftId = sb.ShiftID
	Join dbo.Ins_ClassInfo c on c.ClassId = sb.ClassId
	join dbo.Ins_Session s on s.SessionId = sb.SessionId
	
	join dbo.Ins_Section sec on sec.SectionId = sb.SectionId
	

	where  sc.Status ='Approved' and ecc.TermId =@TermId  and  sb.ClassId = @ClassId and sb.ECAClubId = @ClubId  and  sc.StudentId=sb.StudentIID
end 

--- GetStuECAAttendanceList 8,0,1004,19
--- GetStuECAAttendanceList 0,0,0,0