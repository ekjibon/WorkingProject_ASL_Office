/****** Object:  StoredProcedure [dbo].[GetDataForEmpLeaveApplicationForm]    Script Date: 04/05/2020 3:23:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetDataForEmpLeaveApplicationForm]'))
BEGIN
DROP PROCEDURE GetDataForEmpLeaveApplicationForm
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--- [dbo].[GetDataForEmpLeaveApplicationForm] 48
CREATE PROCEDURE [dbo].[GetDataForEmpLeaveApplicationForm] 
(
	@LeaveId INT = Null
)
AS
BEGIN
	SELECT ER.*, EB.FullName, EB.MobileNo, EB.SMSNotificationNo, ISNULL(EB.EmergencyContactNo, '') AS EmergencyContactNo, ISNULL(EB.PresentAddress, '') AS ContactAddress,
	--(ISNULL(EB.PresentAddress, '') + ', ' + ISNULL(EB.PresentThana, '') + ', ' + ISNULL(EB.PresentDistrict,'')) AS ContactAddress,
	D.DesignationID, D.DesignationName, DEPT.DepartmentName, CAT.CategoryName
	FROM Emp_Request ER
	INNER JOIN Emp_BasicInfo EB ON EB.EmpBasicInfoID = ER.EmpId
	INNER JOIN Emp_Designation D ON D.DesignationID = EB.DesignationID
	INNER JOIN Emp_Department DEPT ON DEPT.DepartmentID = EB.DepartmentID
	LEFT JOIN HR_LeaveCategory CAT ON CAT.Id = ER.LeaveCategoryId
	WHERE RequestType = 5 AND ER.Id = @LeaveId
END

-- SELECT * FROM Emp_BasicInfo WHERE EmpBasicInfoID = 24
-- SELECT TOP 5 * FROM Emp_Request WHERE RequestType = 5 ORDER BY Id DESC 