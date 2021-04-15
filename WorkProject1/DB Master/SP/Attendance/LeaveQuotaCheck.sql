/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LeaveQuotaCheck]'))
BEGIN
DROP FUNCTION  LeaveQuotaCheck
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- SELECT [dbo].[LeaveQuotaCheck] (24,3,34,'LH')

CREATE FUNCTION [dbo].[LeaveQuotaCheck]
(	
	@EmpId INT,
	@LeaveCateId INT,	
	@LeaveId INT,
	@Type VARCHAR(30)
	
)
RETURNS  @Result TABLE(LeaveId INT ,EmpId INT NOT NULL, LeaveCategoryId INT NOT NULL , CategoryName VARCHAR(MAX),EligibleDays DECIMAL(10,2),LeaveAvailed DECIMAL(10,2),LeaveInHand DECIMAL(10,2),TotalLeave DECIMAL(10,2) NOT NULL)
AS
BEGIN

	IF(@Type='NOTEXISTS')
		BEGIN
		    INSERT INTO @Result(LeaveId ,EmpId, LeaveCategoryId, CategoryName,EligibleDays,LeaveAvailed,LeaveInHand,TotalLeave)
		 		SELECT DISTINCT @LeaveId,ER.EmpId,LT.Id AS LeaveCategoryId, LT.CategoryName,
		 CASE WHEN LT.Id = 1 THEN [dbo].[LeaveQuotaCalculation](ER.EmpId,@LeaveId,1,NULL,NULL,'SL') -- SickLeaveDay
			  WHEN LT.Id = 2 THEN [dbo].[LeaveQuotaCalculation](ER.EmpId,@LeaveId,2,NULL,NULL,'CL') --AdvanceLeaveDay
			  WHEN LT.Id = 3 THEN [dbo].[LeaveQuotaCalculation](ER.EmpId,@LeaveId,3,NULL,NULL,'AL')   -- AnnualLeaveDay
			  WHEN LT.Id = 4 THEN [dbo].[LeaveQuotaCalculation](ER.EmpId,@LeaveId,4,NULL,NULL,'ML')   --MaternityLeaveDay
			  END AS EligibleDays,
		 CASE WHEN LT.Id = 1 THEN ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = ER.EmpId AND LeaveCategoryId = 1 AND Status = 'Approved'),0)
			  WHEN LT.Id = 2 THEN ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = ER.EmpId AND LeaveCategoryId = 2 AND Status = 'Approved'),0)
			  WHEN LT.Id = 3 THEN ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = ER.EmpId AND LeaveCategoryId = 3 AND Status = 'Approved'),0)
			  WHEN LT.Id = 4 THEN ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = ER.EmpId AND LeaveCategoryId = 4 AND Status = 'Approved'),0)
			  END AS LeaveAvailed,
		 CASE WHEN LT.Id = 1 THEN [dbo].[LeaveQuotaCalculation](ER.EmpId,@LeaveId,1,NULL,NULL,'SLB') -- SickLeaveDay
			  WHEN LT.Id = 2 THEN [dbo].[LeaveQuotaCalculation](ER.EmpId,@LeaveId,2,NULL,NULL,'CLB') --AdvanceLeaveDay
			  WHEN LT.Id = 3 THEN [dbo].[LeaveQuotaCalculation](ER.EmpId,@LeaveId,3,NULL,NULL,'ALB')   -- AnnualLeaveDay
			  WHEN LT.Id = 4 THEN [dbo].[LeaveQuotaCalculation](ER.EmpId,@LeaveId,4,NULL,NULL,'MLB')   --MaternityLeaveDay
			  END AS LeaveInHand,0		
		 
		 FROM [dbo].[HR_LeaveCategory] LT
		 INNER JOIN dbo.Emp_Request ER ON ER.LeaveCategoryId <> LT.Id
		 --INNER JOIN dbo.HR_EmpLeaveQuota Q ON Q.EmpId = ER.EmpId
		 WHERE ER.EmpId = @EmpId  AND LT.IsDeleted = 0 AND ER.Id = @LeaveId
		END
		IF(@Type='EXISTS')
		BEGIN
		    INSERT INTO @Result(LeaveId,EmpId, LeaveCategoryId, CategoryName,EligibleDays,LeaveAvailed,LeaveInHand,TotalLeave)
		 		SELECT DISTINCT @LeaveId,ER.EmpId,LT.Id AS LeaveCategoryId, LT.CategoryName,
		 CASE WHEN LT.Id = 1 THEN [dbo].[LeaveQuotaCalculation](ER.EmpId,@LeaveId,1,NULL,NULL,'SL') -- SickLeaveDay
			  WHEN LT.Id = 2 THEN [dbo].[LeaveQuotaCalculation](ER.EmpId,@LeaveId,2,NULL,NULL,'CL') --AdvanceLeaveDay
			  WHEN LT.Id = 3 THEN [dbo].[LeaveQuotaCalculation](ER.EmpId,@LeaveId,3,NULL,NULL,'AL')   -- AnnualLeaveDay
			  WHEN LT.Id = 4 THEN [dbo].[LeaveQuotaCalculation](ER.EmpId,@LeaveId,4,NULL,NULL,'ML')   --MaternityLeaveDay
			  END AS EligibleDays,
		 CASE WHEN LT.Id = 1 THEN [dbo].[LeaveQuotaCalculation](ER.EmpId,@LeaveId,1,NULL,NULL,'LA')
			  WHEN LT.Id = 2 THEN [dbo].[LeaveQuotaCalculation](ER.EmpId,@LeaveId,2,NULL,NULL,'LA')
			  WHEN LT.Id = 3 THEN [dbo].[LeaveQuotaCalculation](ER.EmpId,@LeaveId,3,NULL,NULL,'LA')
			  WHEN LT.Id = 4 THEN [dbo].[LeaveQuotaCalculation](ER.EmpId,@LeaveId,4,NULL,NULL,'LA')
			  END AS LeaveAvailed,
		 CASE WHEN LT.Id = 1 THEN [dbo].[LeaveQuotaCalculation](ER.EmpId,@LeaveId,1,NULL,NULL,'SLB') -- SickLeaveDay
			  WHEN LT.Id = 2 THEN [dbo].[LeaveQuotaCalculation](ER.EmpId,@LeaveId,2,NULL,NULL,'CLB') --AdvanceLeaveDay
			  WHEN LT.Id = 3 THEN [dbo].[LeaveQuotaCalculation](ER.EmpId,@LeaveId,3,NULL,NULL,'ALB')   -- AnnualLeaveDay
			  WHEN LT.Id = 4 THEN [dbo].[LeaveQuotaCalculation](ER.EmpId,@LeaveId,4,NULL,NULL,'MLB')   --MaternityLeaveDay
			  END AS LeaveInHand,ER.Duration
		
		 
		 FROM [dbo].[HR_LeaveCategory] LT
		 INNER JOIN dbo.Emp_Request ER ON ER.LeaveCategoryId = LT.Id
		 INNER JOIN dbo.HR_EmpLeaveQuota Q ON Q.EmpId = ER.EmpId
		 WHERE ER.EmpId = @EmpId  AND LT.IsDeleted = 0 AND ER.Id = @LeaveId
		END
		--DROP TABLE @tempCalendar
	
	RETURN ;

END
GO


