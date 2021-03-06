IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetECAStuClubList]'))
BEGIN
DROP PROCEDURE  GetECAStuClubList
END
GO
/****** Object:  StoredProcedure [dbo].[GetECAStuClubList]    Script Date: 5/11/2019 12:15:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[GetECAStuClubList]
(@Type INT,    --1=All ECA Changing List,2=Individual List,3=ECAClubChangingHistory 4=All ECA List
@TermId INT,
 @DayId INT,
 @ClubId INT,
 @StudentID INT)
as
Begin
if(@Type=1)
	Begin
	Select 
       sc.Id, 
	   sc.StudentId,
	   sb.StudentInsID,
	   sb.FullName,
	   sc.DayId,
	   case sc.DayId
	   when 2 then 'Sunday'
	   when 3 then 'Monday'
	   when 4 then 'Thuesday'
	   end DayName,
	   sc.TermId,
	  t.Name as TermName,
	   sc.Status,
	   sc.AddDate,
	   sc.ClubId,
	   ec.ClubName,
	   ec.CategoryName,
	   sc.NewClubId,
	   ecn.ClubName NewClubName,
	   sb.BranchID,
	   b.BranchName,
	   sb.ShiftID,
	   sh.ShiftName,
	   sb.ClassId,
	   c.ClassName,
	   sb.SessionId,
	   sch.Reason,
	   s.SessionName,

	    Case sc.ChoiceTypeId
	   When 1 then 'First Choice'
	   When 2 then 'Second Choice'
	   end Choice,
	   sc.ChoiceTypeId,

	   --ecc.ClubName ChangeClubName,
	   sec.SectionId,
	   sec.SectionName
	    from dbo.Stu_Clubs sc 
 Join dbo.Ins_ECAClub ec on sc.ClubId = ec.ClubId
 Join dbo.Student_BasicInfo sb on sc.StudentId=sb.StudentIID 
 left Join dbo.Ins_Branch b on sb.BranchID = b.BranchId
	Join dbo.Ins_Shift sh on sh.ShiftId = sb.ShiftID
	Join dbo.Ins_ClassInfo c on c.ClassId = sb.ClassId
	join dbo.Ins_Session s on s.SessionId = sb.SessionId
	join dbo.Res_Terms t on t.TermId = sc.TermId
	join dbo.Ins_Section sec on sec.SectionId = sb.SectionId
	left JOIN dbo.Ins_ECAClub ecn on sc.NewClubId = ecn.ClubId 
	left join dbo.Stu_ClubsHistory sch on sch.ToClubId = sc.NewClubId and sch.StudentId=sc.StudentId
	where sc.NewClubId !=0 and sc.Status = 'Pending' and sc.TermId = @TermId and sc.DayId = @DayId and sc.ClubId = @ClubId

	End
	if(@Type=2)
	Begin
	Select 
       sc.Id, 
	   sc.StudentId,
	   sb.StudentInsID,
	   sb.FullName,
	   sc.DayId,
	   case sc.DayId
	   when 2 then 'Sunday'
	   when 3 then 'Monday'
	   when 4 then 'Thuesday'
	   end DayName,
	    sc.TermId,
	    t.Name as TermName,
	   sc.Status,
	   Case sc.ChoiceTypeId
	   When 1 then 'First Choice'
	   When 2 then 'Second Choice'
	   end Choice,
	   sc.ChoiceTypeId,
	   sc.AddDate,
	   sc.ClubId,
	   ec.ClubName,
	   ec.CategoryName,
	   sc.NewClubId,
	   ecn.ClubName NewClubName,
	   sb.BranchID,
	   b.BranchName,
	   sb.ShiftID,
	   sh.ShiftName,
	   sb.ClassId,
	   c.ClassName,
	   sb.SessionId,
	   s.SessionName,


	   sec.SectionId,
	   sec.SectionName
	    from dbo.Stu_Clubs sc 
	Join dbo.Ins_ECAClub ec on sc.ClubId = ec.ClubId
	Join dbo.Student_BasicInfo sb on sc.StudentId=sb.StudentIID 
    left Join dbo.Ins_Branch b on sb.BranchID = b.BranchId
	Join dbo.Ins_Shift sh on sh.ShiftId = sb.ShiftID
	Join dbo.Ins_ClassInfo c on c.ClassId = sb.ClassId
	join dbo.Ins_Session s on s.SessionId = sb.SessionId
	join dbo.Res_Terms t on t.TermId = sc.TermId

	join dbo.Ins_Section sec on sec.SectionId = sb.SectionId
    left JOIN dbo.Ins_ECAClub ecn on sc.NewClubId = ecn.ClubId
	where sc.StudentId = @StudentID and (sc.Status='Approved' or sc.Status='Pending') Order By sc.ChoiceTypeId asc 
	End

	if(@Type=3)
	Begin
	Select sch.Id,
	sch.StudentId,
      sch.FromClubId,
	  sch.ToClubId,
	  sch.ChangingDate,
	  sch.Status,
	  eca.ClubName ChangedFrom,
	  ect.ClubName ChangedTo
	   From dbo.Stu_ClubsHistory sch
         join dbo.Student_BasicInfo sb on sb.StudentIID = sch.StudentId
		 join dbo.Ins_ECAClub eca on eca.ClubId = sch.FromClubId	
		 	 join dbo.Ins_ECAClub ect on ect.ClubId = sch.ToClubId
			 Where sch.StudentId = @StudentID
	End

	if(@Type=4)
	Begin
	Select 
       sc.Id, 
	   sc.StudentId,
	   sb.StudentInsID,
	   sb.FullName,
	   sc.DayId,
	   case sc.DayId
	   when 2 then 'Sunday'
	   when 3 then 'Monday'
	   when 4 then 'Thuesday'
	   end DayName,
	   sc.TermId,
	   case sc.TermId
	   when 1 then 'Autumn'
	   when 2 then 'Winter'
	   when 3 then 'Summer'
	   end TermName,
	   sc.Status,
	   sc.AddDate,
	   sc.ClubId,
	   ec.ClubName,
	   ec.CategoryName,
	   sc.NewClubId,
	   ecn.ClubName NewClubName,
	   sb.BranchID,
	   b.BranchName,
	   sb.ShiftID,
	   sh.ShiftName,
	   sb.ClassId,
	   c.ClassName,
	   sb.SessionId,
	   s.SessionName,
	t.Name as TermName,
	    Case sc.ChoiceTypeId
	   When 1 then 'First Choice'
	   When 2 then 'Second Choice'
	   end Choice,
	   sc.ChoiceTypeId,
	
	   --ecc.ClubName ChangeClubName,
	   sec.SectionId,
	   sec.SectionName
	    from dbo.Stu_Clubs sc 
 Join dbo.Ins_ECAClub ec on sc.ClubId = ec.ClubId
 Join dbo.Student_BasicInfo sb on sc.StudentId=sb.StudentIID 
 left Join dbo.Ins_Branch b on sb.BranchID = b.BranchId
	Join dbo.Ins_Shift sh on sh.ShiftId = sb.ShiftID
	Join dbo.Ins_ClassInfo c on c.ClassId = sb.ClassId
	join dbo.Ins_Session s on s.SessionId = sb.SessionId
	join dbo.Res_Terms t  on t.TermId = sc.TermId
	join dbo.Ins_Section sec on sec.SectionId = sb.SectionId
	left JOIN dbo.Ins_ECAClub ecn on sc.NewClubId = ecn.ClubId
	where  sc.Status = 'Approved' or sc.Status = 'Pending' order by sc.Id desc ,sc.ChoiceTypeId desc
	End
	
End
-- GetECAStuClubList 1,11,2,4,4307