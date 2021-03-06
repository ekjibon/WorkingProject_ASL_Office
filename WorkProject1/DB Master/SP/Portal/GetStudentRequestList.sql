IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetStudentRequestList]'))
BEGIN
DROP PROCEDURE  GetStudentRequestList
END
GO
/****** Object:  StoredProcedure [dbo].[GetStudentRequestList]    Script Date: 4/23/2019 11:05:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[GetStudentRequestList]
(
 @StudentIID Int,
 @Type Int  -- Type 1 Individual RequestList,2 All RequestList,
              -- Type 3 For Meeting List For Admin,4 For Tailor List, Type 5 Meeting List By Student Id For Portal 
)
 AS
 If(@Type=1)
 Begin
 Select  sr.Id,
 sr.Status,sr.NOCType,sr.TravelDesination,sr.TravelFrom,sr.TravelTo,sr.Description,sr.LeaveDate,sr.LeaveTypeId,sr.StudentId,
         sr.RequestOn,sr.FromDate,sr.ToDate,
        sr.AddDate,sr.Reason,sr.Time,
		sr.Date,
		sr.Remarks,
		sr.CategoryId,
		sr.RequestType as ReqID,
		cd.Text,
	    sb.StudentIID,
		Case sr.RequestType
		When  1 THen 'For Meeting'
		When  2 THen 'For Tailor/TuckShop'
		When  3 THen 'For NOC'
		When  4 THen 'For TC'
		When  5 THen 'For Leave'
		end RequestTypeName
  ,sb.FullName RequestedBy
 From dbo.Student_Request  sr
 Inner Join dbo.Student_BasicInfo sb on sr.StudentId = sb.StudentIID
 Left join Common_DropDownConfig cd on sr.CategoryId = cd.Value and cd.Type='EmpDept'
 where sr.StudentId=@StudentIID  and  sr.IsDeleted = 0
 order by sr.Id desc
  
 End
  If(@Type=2)
   Begin
 Select sr.Id,
 sr.Status,sr.Remarks,
        sr.AddDate ,
		sr.Date,
		sr.LeaveTypeId,
		sr.RequestType,
		sr.Description,
		sr.Reason,
		sr.FromDate,
		sr.ToDate,
		sr.TravelDesination,
		sr."File",
	    sb.StudentIID,
	    sb.FatherName,
		sb.MotherName,

		Case sr.RequestType
		When  1 THen 'For Meeting'
		When  2 THen 'For Tailor/TuckShop'
		When  3 THen 'For NOC'
		When  4 THen 'For TC'
		When  5 THen 'For Leave'
		end RequestTypeName
  ,sb.FullName RequestedBy
 From dbo.Student_Request  sr
 Inner Join dbo.Student_BasicInfo sb on sr.StudentId = sb.StudentIID 
 where sr.RequestType = 2 or sr.RequestType = 3 or sr.RequestType = 4 or sr.RequestType = 5
 order by Id desc

 End

  If(@Type=3)
   Begin
 Select sr.Id,
 sr.Status,
        sr.AddDate ,
		sr.Date,
		sr.MeetingIssue,
		sr.CategoryId,
		sr.Reason,
			sr.Remarks,
		sr.Time,
		sr.RequestType as ReqID,
		cd.Text,
		sb.StudentInsID,
		sb.FatherName,
		sb.MotherName,
	    sb.StudentIID,
		
		Case sr.RequestType
		When  1 THen 'For Meeting'
		When  2 THen 'For Tailor/TuckShop'
		When  3 THen 'For NOC'
		When  4 THen 'For TC'
		When  5 THen 'For Leave'
		end RequestType
  ,sb.FullName RequestedBy
 From dbo.Student_Request  sr
 Inner Join dbo.Student_BasicInfo sb on sr.StudentId = sb.StudentIID
 Inner join Common_DropDownConfig cd on sr.CategoryId = cd.Value and cd.Type='EmpDept'
 where sr.RequestType = 1 and sr.IsDeleted=0
 order by Id desc
 End
   If(@Type=4)
   Begin
 Select sr.Id,
 sr.Status,
        sr.AddDate ,
		sr.Date,
	    sb.StudentIID,
	    sb.FatherName,
		sb.MotherName,
		Case sr.RequestType
		When  1 THen 'For Meeting'
		When  2 THen 'For Tailor/TuckShop'
		When  3 THen 'For NOC'
		When  4 THen 'For TC'
		When  5 THen 'For Leave'
		end RequestType
  ,sb.FullName+' - ' +sb.StudentInsID RequestedBy
 From dbo.Student_Request  sr
 Inner Join dbo.Student_BasicInfo sb on sr.StudentId = sb.StudentIID
 where sr.RequestType = 2 and sr.IsDeleted=0
 order by Id desc
 End
  If(@Type=5)
   Begin
 Select sr.Id,
 sr.Status,
        sr.AddDate ,
		sr.Date,
		sr.MeetingIssue,
		sr.CategoryId,
		sr.Reason,
			sr.Remarks,
		
		sr.Time,
		sr.Description,
		
		sr.RequestType as ReqID,
		cd.Text,
		sb.StudentInsID,
		sb.FatherName,
		sb.MotherName,
	    sb.StudentIID,
		
		Case sr.RequestType
		When  1 THen 'For Meeting'
		When  2 THen 'For Tailor/TuckShop'
		When  3 THen 'For NOC'
		When  4 THen 'For TC'
		When  5 THen 'For Leave'
		end RequestType
  ,sb.FullName RequestedBy
 From dbo.Student_Request  sr
 Inner Join dbo.Student_BasicInfo sb on sr.StudentId = sb.StudentIID and sr.StudentId = @StudentIID
 Inner join Common_DropDownConfig cd on sr.CategoryId = cd.Value and cd.Type='EmpDept'
 where sr.RequestType = 1 and sr.IsDeleted=0 
 order by Id desc
 End
 --- GetStudentRequestList 3606,2