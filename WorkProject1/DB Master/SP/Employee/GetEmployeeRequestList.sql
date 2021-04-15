IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmployeeRequestList]'))
BEGIN
DROP PROCEDURE  GetEmployeeRequestList
END
GO
/****** Object:  StoredProcedure [dbo].[GetStudentRequestList]    Script Date: 4/23/2019 11:05:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[GetEmployeeRequestList]
(
 @EmpID Int = 0,
 @Type Int =0  -- Type 1 Individual RequestList,2 All RequestList,
              -- Type 3 For Meeting List For Admin,4 For Tailor List, Type 5 Meeting List By Student Id For Portal 
)
 AS
 If(@Type=1)   -- [GetEmployeeRequestList] 24,2
 Begin
 Select  sr.Id,
 sr.Status,sr.NOCType,sr.TravelDesination,sr.TravelFrom,sr.TravelTo,sr.Description,sr.LeaveDate,sr.LeaveCategoryId,EB.EmpId,
         sr.RequestOn,sr.FromDate,sr.ToDate,
        sr.AddDate,sr.Reason,sr.Time,
		sr.Date,
		sr.Remarks,
		sr.CategoryId,
		sr.RequestType as ReqID,
		cd.Text,
	    EB.EmpBasicInfoID,
		Case sr.RequestType
		When  1 THen 'For Meeting'
		When  2 THen 'For Tailor/TuckShop'
		When  3 THen 'For NOC'
		When  4 THen 'For TC'
		When  5 THen 'For Leave'
		When  6 THen 'For Release Letter'
		end RequestTypeName
  ,EB.FullName RequestedBy
 From [dbo].[Emp_Request]  sr
 Inner Join dbo.Emp_BasicInfo EB on sr.EmpId = EB.EmpBasicInfoID
 Left join Common_DropDownConfig cd on sr.CategoryId = cd.Value and cd.Type='EmpDept'
 where sr.EmpId=@EmpID  and  sr.IsDeleted = 0 
 order by sr.Id desc
  
 End
  If(@Type=2)      -- Type 2 All RequestList,
   Begin
 Select empr.Id,
 empr.Status,
        empr.* ,cd.Text as MeetingPearson,empr.Reason,
		empr.RequestType as ReqID,
	    EB.EmpBasicInfoID,
		Case empr.RequestType
		When  1 THen 'For Meeting'
		When  2 THen 'For Tailor/TuckShop'
		When  3 THen 'For NOC'
		When  4 THen 'For TC'
		When  5 THen 'For Leave'
		When  6 THen 'For Release Letter'
		end RequestTypeName
  ,EB.FullName RequestedBy, LC.CategoryName
 From dbo.Emp_Request  empr
 Inner Join dbo.Emp_BasicInfo EB on empr.EmpId = EB.EmpBasicInfoID and EB.EmpBasicInfoID = @EmpID
 left Outer join Common_DropDownConfig cd on empr.CategoryId = cd.Value and cd.Type='EmpDept' 
 INNER JOIN HR_LeaveCategory LC ON LC.Id = empr.LeaveCategoryId --SELECT * FROM HR_LeaveCategory
  where empr.IsDeleted=0
 order by empr.Id desc

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
		When  6 THen 'For Release Letter'
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
	    sb.StudentIID,
		Case sr.RequestType
		When  1 THen 'For Meeting'
		When  2 THen 'For Tailor/TuckShop'
		When  3 THen 'For NOC'
		When  4 THen 'For TC'
		When  5 THen 'For Leave'
		When  6 THen 'For Release Letter'
		end RequestType
  ,sb.FullName+' - ' +sb.StudentInsID RequestedBy
 From dbo.Student_Request  sr
 Inner Join dbo.Student_BasicInfo sb on sr.StudentId = sb.StudentIID
 where sr.RequestType = 2 and sr.IsDeleted=0
 order by Id desc
 End
  If(@Type=5) -- [GetEmployeeRequestList] 15,5
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
		sr.LeaveTypeCategory,
		sr.RequestType as ReqID,
		sr.Duration,
		sb.EmpBasicInfoID,
		sb.FatherName,
		sb.MotherName,
	    sb.EmpID,
		CAST((CASE WHEN sr.[File] IS NULL THEN 0 ELSE 1 END) AS BIT) AS IsFile,
		Case sr.RequestType
		When  1 THen 'For Meeting'
		When  2 THen 'For Tailor/TuckShop'
		When  3 THen 'For NOC'
		When  4 THen 'For TC'
		When  5 THen 'For Leave'
		When  6 THen 'For Release Letter'
		end RequestType
  ,sb.FullName RequestedBy,sr.FromDate,sr.ToDate,sr.LeaveCategoryId,CT.CategoryName
 From dbo.Emp_Request  sr
 Inner Join dbo.Emp_BasicInfo sb on sr.EmpId = sb.EmpBasicInfoID and sr.EmpId = @EmpID
 INNER JOIN dbo.HR_LeaveCategory CT ON CT.Id =  sr.LeaveCategoryId
 where sr.RequestType = 5 and sr.IsDeleted=0 
 order by Id desc

 End
  IF( @Type=6)       ---Only Leave List for Admin Portal [GetEmployeeRequestList] 51,6
 Begin
  Select empr.*,ant.CategoryName,
		
		Case empr.RequestType
		When  1 THen 'For Meeting'
		When  2 THen 'For Tailor/TuckShop'
		When  3 THen 'For NOC'
		When  4 THen 'For TC'
		When  5 THen 'For Leave'
		When  6 THen 'For Release Letter'
		end RequestType
  ,eb.FullName RequestedBy
 From dbo.Emp_Request  empr
 Inner Join dbo.Emp_BasicInfo eb on empr.EmpId = eb.EmpBasicInfoID 
 Inner join HR_LeaveCategory ant on ant.Id = empr.LeaveCategoryId
 --Inner JOin dbo.Att_LeaveTypes ant on ant.LeaveId = empr.LeaveCategoryId and ant.Type = 'Teacher'
 where empr.RequestType = 5 and empr.IsDeleted=0 
 order by empr.Id desc
 ENd
  If(@Type=7)      ---Only For Meeting and its Type='EmpPDept' (CategoryId)
 Begin
    Select er.Id, er.Status, er.AddDate, er.Date, er.MeetingIssue, er.CategoryId, cd.Text,
		er.Reason, er.Remarks, er.Time, er.Description, er.RequestType as ReqID,
		er.NOCType, er.TravelDesination, er.TravelFrom, er.TravelTo, er.LeaveDate, er.LeaveCategoryId,
		er.RequestOn, er.FromDate, er.ToDate,  er.Remarks, er.EmpId,
        sb.[BranchID], sb.FatherName, sb.MotherName, 
		Case er.RequestType
			When  1 THen 'For Meeting'
			--When  2 THen 'For Tailor/TuckShop'
			When  3 THen 'For NOC'
			When  4 THen 'For Experience Letter'
			When  5 THen 'For Leave'
			When  6 THen 'For Release Letter'
		end RequestTypeName
        ,sb.FullName RequestedBy
 From Emp_Request  er
 Inner Join Emp_BasicInfo sb on er.EmpId = sb.EmpBasicInfoID
 Inner join Common_DropDownConfig cd on er.CategoryId = cd.Value and cd.Type='EmpPDept'
 where er.RequestType = 1 and er.IsDeleted=0 
 order by Id desc

 End
  If(@Type=8)      ---For NOC, Experience Letter, Leave, Release Letter 
 Begin
    Select er.Id, er.Status, er.AddDate, er.Date, er.MeetingIssue, er.CategoryId, cd.Text,
		er.Reason, er.Remarks, er.Time, er.Description, er.RequestType as ReqID,
		er.NOCType, er.TravelDesination, er.TravelFrom, er.TravelTo, er.LeaveDate, er.LeaveCategoryId,
		er.RequestOn, er.FromDate, er.ToDate,  er.Remarks, er.EmpId,
        sb.[BranchID], sb.FatherName, sb.MotherName, 
		Case er.RequestType
			When  1 THen 'For Meeting'
			--When  2 THen 'For Tailor/TuckShop'
			When  3 THen 'For NOC'
			When  4 THen 'For Experience Letter'
		--	When  5 THen 'For Leave'
			When  6 THen 'For Release Letter'
		end RequestTypeName
        ,sb.FullName RequestedBy
 From Emp_Request  er
 Inner Join Emp_BasicInfo sb on er.EmpId = sb.EmpBasicInfoID
 left Outer join Common_DropDownConfig cd on er.CategoryId = cd.Value and cd.Type='EmpDept'
 where er.RequestType <> 1   and er.IsDeleted=0 AND ER.RequestType != 5
 order by Id desc

 End
 If(@Type=9) -- [GetEmployeeRequestList] 0,8			All Request list for Employee
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
		sr.Duration,
		sr.LeaveTypeCategory,
		sb.EmpBasicInfoID,
		sb.FatherName,
		sb.MotherName,
	    sb.EmpID,
	
		Case sr.RequestType
		When  1 THen 'For Meeting'
		When  2 THen 'For Tailor/TuckShop'
		When  3 THen 'For NOC'
		When  4 THen 'For TC'
		When  5 THen 'For Leave'
		When  6 THen 'For Release Letter'
		end RequestType
  ,sb.FullName RequestedBy,sr.FromDate,sr.ToDate,sr.LeaveCategoryId,CT.CategoryName
 From dbo.Emp_Request  sr
 Inner Join dbo.Emp_BasicInfo sb on sr.EmpId = sb.EmpBasicInfoID and sr.EmpId = @EmpID
 LEFT JOIN dbo.HR_LeaveCategory CT ON CT.Id =  sr.LeaveCategoryId
 where sr.IsDeleted=0 
 order by Id desc

 End
 
 --- GetEmployeeRequestList 0,6