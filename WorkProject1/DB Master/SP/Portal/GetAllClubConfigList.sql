IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAllClubConfigList]'))
BEGIN
DROP PROCEDURE  GetAllClubConfigList
END
GO
/****** Object:  StoredProcedure [dbo].[GetAllClubConfigList]    Script Date: 5/10/2019 10:28:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[GetAllClubConfigList]
As
Begin
Select
       cc.Id, 
	eca.CategoryName,
	   cc.DayId,
	   cc.ClassId,
       cc.ClubId,
	   cc.BranchId,
	   cc.SessionId,
	     cc.FromTime,
	   cc.ToTime ,
	   cc.ShiftId,
      eca.ClubName,
	  B.BranchName,
	  sh.ShiftName,
	  cc.TermId,
	  rt.Name as TermName,
	  S.SessionName,
       case cc.DayId
	  when 1 then 'Saturday'
	  when 2 then 'Sunday'
	  when 3 then 'Monday'
	  when 4 then 'Tuesday'
	  when 5 then 'Wednesday'
	  when 6 then 'Thursday'
	  end DayName,
	  c.ClassName,
	  cc.SeatCapacity,
	  cc.NoOfClass,cc.Status,cc.Deadline
      From dbo.Ins_ECAClubConfig cc
	  Join dbo.Ins_ECAClub eca on eca.ClubId = cc.ClubId
	  Join dbo.Ins_Branch B on B.BranchId = cc.BranchId
	  Join dbo.Ins_Session S on S.SessionId = cc.SessionId
	  Join dbo.Ins_Shift sh on sh.ShiftId = cc.ShiftId
	  Join dbo.Res_Terms rt on rt.TermId = cc.TermId
	 
	  Join dbo.Ins_ClassInfo c on c.ClassId = cc.ClassId
	  where cc.IsDeleted=0 order by cc.Id desc
end
--- GetAllClubConfigList  
