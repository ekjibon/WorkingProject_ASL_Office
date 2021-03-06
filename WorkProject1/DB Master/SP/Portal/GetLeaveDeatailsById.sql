IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetLeaveDeatailsById]'))
BEGIN
DROP PROCEDURE  GetLeaveDeatailsById
END
GO
/****** Object:  StoredProcedure [dbo].[GetLeaveDeatailsById]    Script Date: 4/7/2019 7:01:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	
	Create Procedure [dbo].[GetLeaveDeatailsById] --[dbo].[GetLeaveDeatailsById] 970,1124
	(
	 @StudentId INT,
	 @LeaveId BigINT
	)
	As 
	Begin
	select s.LeaveId,
	s.FromDate,
	s.Description,
	s.ToDate,
	s.Duration,
	s.RequestOn,
	s.[Status],
	u.FullName,
	s.UpdateDate,
	s.[File],
	lt.TypeName  
	LeaveType,
	s.UpdateBy,
	s.UpdateDate
	from Att_StudentLeave s
	Left JOIN dbo.AspNetUsers u ON u.Id= s.UpdateBy 
		  Left JOIN dbo.Att_LeaveTypes lt ON lt.LeaveId= S.LeaveTypeId
	where s.StudentIId=@StudentId and s.IsDeleted=0 and s.LeaveId = @LeaveId
	order by  s.LeaveId Desc
	End
	