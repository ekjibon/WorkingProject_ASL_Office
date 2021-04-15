/****** Object:  StoredProcedure [dbo].[GetLeaveDetailsEmpWise]    Script Date: 04/05/2020 3:23:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetLeaveSummaryEmpWise]'))
BEGIN
DROP PROCEDURE GetLeaveSummaryEmpWise
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--- [dbo].[GetLeaveSummaryEmpWise] 55
CREATE PROCEDURE [dbo].[GetLeaveSummaryEmpWise] 
(

@EmpId INT = Null

)
AS
BEGIN
   
SELECT DISTINCT LT.CategoryName,
 CASE WHEN LT.Id = 1 THEN Q.SickLeaveDay
      WHEN LT.Id = 2 THEN Q.AdvanceLeaveDay
	  WHEN LT.Id = 3 THEN Q.AnnualLeaveDay
	  WHEN LT.Id = 4 THEN Q.MaternityLeaveDay
	  END AS EligibleDays,
 CASE WHEN LT.Id = 1 THEN ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = ER.EmpId AND LeaveCategoryId = 1 AND Status = 'Approved'),0)
      WHEN LT.Id = 2 THEN ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = ER.EmpId AND LeaveCategoryId = 2 AND Status = 'Approved'),0)
	  WHEN LT.Id = 3 THEN ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = ER.EmpId AND LeaveCategoryId = 3 AND Status = 'Approved'),0)
	  WHEN LT.Id = 4 THEN ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = ER.EmpId AND LeaveCategoryId = 4 AND Status = 'Approved'),0)
	  END AS LeaveAvailed,
 CASE WHEN LT.Id = 1 THEN Q.SickLeaveDay-ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = ER.EmpId AND LeaveCategoryId = 1 AND Status = 'Approved'),0)
      WHEN LT.Id = 2 THEN Q.AdvanceLeaveDay-ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = ER.EmpId AND LeaveCategoryId = 2 AND Status = 'Approved'),0)
	  WHEN LT.Id = 3 THEN Q.AnnualLeaveDay-ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = ER.EmpId AND LeaveCategoryId = 3 AND Status = 'Approved'),0)
	  WHEN LT.Id = 4 THEN Q.MaternityLeaveDay-ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = ER.EmpId AND LeaveCategoryId = 4 AND Status = 'Approved'),0)
	  END AS LeaveInHand

 FROM [dbo].[HR_LeaveCategory] LT
 INNER JOIN dbo.Emp_Request ER ON ER.LeaveCategoryId = LT.Id 
 INNER JOIN dbo.HR_EmpLeaveQuota Q ON Q.EmpId = ER.EmpId
WHERE ER.EmpId = @EmpId
		   
END