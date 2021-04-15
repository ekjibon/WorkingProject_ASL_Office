IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmpMeetingList]'))
BEGIN
DROP PROCEDURE  GetEmpMeetingList
END
GO
/****** Object:  StoredProcedure [dbo].[GetEmpMeetingList]    Script Date: 7/9/2019 11:12:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[GetEmpMeetingList]
(
    @Block INT=0,
	@ClassId INT=null
)
As
BEGIN
IF(@Block=1) 
	BEGIN  
 SELECT EMC.FirstEmpId,
		EMC.DayId,
		EMC.BranchId,
		EMC.ClassId,
		B.BranchName,
		CInfo.ClassName,
        EMC.StartTime,
		EMC.EndTime,
		CASE EMC.DayId
		WHEN 0 THEN 'Sunday' 
		WHEN 2 THEN 'TuesDay' 
		WHEN 1 THEN 'Monday' 
		WHEN 3 THEN 'Wednesday' 
		WHEN 4 THEN 'Thrusday' 
		WHEN 6 THEN 'Satureday' ELSE NULL
		END as DayName,
        EMC.SecondEmpId,	
		EMC.EmpCategoryId,
        EMC.ConfigId,
		(SELECT FullName FROM dbo.Emp_BasicInfo WHERE EmpBasicInfoID = EMC.FirstEmpId) AS FirstName,
		(SELECT FullName FROM dbo.Emp_BasicInfo WHERE EmpBasicInfoID = EMC.SecondEmpId) AS SecondName,
		c.[Text]
		From dbo.Emp_MeetingConfig EMC
		LEFT JOIN dbo.Common_DropDownConfig c on c.[Value] = EMC.EmpCategoryId and Type='EmpDept'
		LEFT JOIN dbo.Ins_ClassInfo CInfo ON CInfo.ClassId = EMC.ClassId
		LEFT JOIN dbo.Ins_Branch B ON B.BranchId = EMC.BranchId

END
IF(@Block=2) 
	BEGIN  
 SELECT EMC.FirstEmpId,
		EMC.DayId,
		EMC.BranchId,
		EMC.ClassId,
		B.BranchName,
		CInfo.ClassName,
        EMC.StartTime,
		EMC.EndTime,
		CASE EMC.DayId
		WHEN 0 THEN 'Sunday' 
		WHEN 2 THEN 'TuesDay' 
		WHEN 1 THEN 'Monday' 
		WHEN 3 THEN 'Wednesday' 
		WHEN 4 THEN 'Thrusday' 
		WHEN 6 THEN 'Satureday' ELSE NULL
		END as DayName,
        EMC.SecondEmpId,	
		EMC.EmpCategoryId,
        EMC.ConfigId,
		(SELECT FullName FROM dbo.Emp_BasicInfo WHERE EmpBasicInfoID = EMC.FirstEmpId) AS FirstName,
		(SELECT FullName FROM dbo.Emp_BasicInfo WHERE EmpBasicInfoID = EMC.SecondEmpId) AS SecondName,
		c.[Text]
		From dbo.Emp_MeetingConfig EMC
		LEFT JOIN dbo.Common_DropDownConfig c on c.[Value] = EMC.EmpCategoryId and Type='EmpDept'
		LEFT JOIN dbo.Ins_ClassInfo CInfo ON CInfo.ClassId = EMC.ClassId
		LEFT JOIN dbo.Ins_Branch B ON B.BranchId = EMC.BranchId
		WHERE EMC.ClassId = @ClassId

END
END
--GetEmpMeetingList 2,24