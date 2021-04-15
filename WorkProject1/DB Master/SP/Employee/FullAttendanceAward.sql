
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FullAttendanceAward]'))
BEGIN
DROP PROCEDURE  FullAttendanceAward
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[FullAttendanceAward] 9,'2020-01-1','2020-12-31'
CREATE PROCEDURE [dbo].[FullAttendanceAward]  
@BranchId INT=0,
@FromDate NVARCHAR(MAX) ,
@ToDate NVARCHAR(MAX)
	
	
AS
BEGIN
SELECT EB.EmpBasicInfoID, EB.FullName,EB.EmpID,ED.DesignationName,B.BranchName,EB.JoiningDate,EB.CurrentSalary, ((EB.CurrentSalary/30)*6) AS SixdaysSalary,Re.RewardAmount,(((EB.CurrentSalary/30)*6)+ISNULL(Re.RewardAmount,0)) AS TotalReward,CAST(@FromDate AS DATE)AS FromDate,CAST(@ToDate AS DATE)AS ToDate FROM Emp_Attendance EA
INNER JOIN Emp_BasicInfo EB ON EB.EmpBasicInfoID = EA.EmpId
LEFT JOIN HR_Reward Re ON Re.EmpId = EA.EmpId
INNER JOIN Emp_Designation ED ON ED.DesignationID = EB.DesignationID
INNER JOIN Ins_Branch B ON B.BranchId = EB.BranchID
WHERE EA.EmpId NOT IN (SELECT  EmpBasicInfoID FROM
(SELECT (SELECT Count(AttendId) FROM Emp_Attendance WHERE EmpId =EmpBasicInfoID AND IsLate =1 AND CAST(InTime AS DATE) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE))lateday,EmpBasicInfoID 
FROM Emp_BasicInfo WHERE BranchID = @BranchId AND IsDeleted=0 AND Status= 'A')t
WHERE lateday >= 3) 
AND EA.EmpId IN (SELECT EmpId FROM Emp_Attendance 
WHERE LeaveId In (SELECT Id FROM Emp_Request WHERE RequestType = 5 AND LeaveCategoryId = 3 AND [Status] = 'Approved') AND CAST(InTime AS DATE) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE)
INTERSECT 
SELECT EmpId FROM Emp_Attendance
WHERE CAST(InTime AS DATE) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE) AND IsHalfDay =0) AND CAST(EA.InTime AS DATE) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE)
GROUP BY EB.FullName,EB.EmpID,ED.DesignationName,B.BranchName,EB.JoiningDate,EB.CurrentSalary,Re.RewardAmount,EB.EmpBasicInfoID


END