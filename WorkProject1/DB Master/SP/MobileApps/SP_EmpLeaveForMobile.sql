IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_EmpLeaveForMobile]'))
BEGIN
DROP PROCEDURE  SP_EmpLeaveForMobile
END
GO
/****** Object:  StoredProcedure [dbo].[SP_EmpLeaveForMobile]    Script Date: 02/04/2020 11:05:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[SP_EmpLeaveForMobile]
(
	@Block INT =0, 
	@EmpBasicInfoId INT = 0,
	@LeaveCategoryId INT = 0, -- 1. Sick 2. Casual(Advance) 3. Annual 4. Maternity
	@LeaveId INT =0
)
AS
BEGIN

IF(@Block=1)   -- [SP_EmpLeaveForMobile] 1,66,3,0
	BEGIN
		 Select EB.FullName, --LC.CategoryName, 
		 CASE 
			 WHEN @LeaveCategoryId = 3 THEN (ISNULL((SELECT AnnualLeaveDay FROM HR_EmpLeaveQuota WHERE EmpId = @EmpBasicInfoId),0) - (ISNULL((SELECT SUM(Duration) FROM Emp_Request HLA WHERE HLA.LeaveCategoryId = 3 AND HLA.EmpId = @EmpBasicInfoId AND HLA.IsDeleted =0 AND HLA.Status = 'Approved'), 0))) 
			 WHEN @LeaveCategoryId = 1 THEN (ISNULL((SELECT SickLeaveDay FROM HR_EmpLeaveQuota WHERE EmpId = @EmpBasicInfoId),0) - (ISNULL((SELECT SUM(Duration) FROM Emp_Request HLA WHERE HLA.LeaveCategoryId = 1 AND HLA.EmpId = @EmpBasicInfoId AND HLA.IsDeleted =0 AND  HLA.Status = 'Approved'), 0))) 
			 WHEN @LeaveCategoryId = 2 THEN (ISNULL((SELECT AdvanceLeaveDay FROM HR_EmpLeaveQuota WHERE EmpId = @EmpBasicInfoId),0) - (ISNULL((SELECT SUM(Duration) FROM Emp_Request HLA WHERE HLA.LeaveCategoryId = 2 AND HLA.EmpId = @EmpBasicInfoId AND HLA.IsDeleted =0 AND HLA.Status = 'Approved'), 0))) 
			 WHEN @LeaveCategoryId = 4 THEN (ISNULL((SELECT MaternityLeaveDay FROM HR_EmpLeaveQuota WHERE EmpId = @EmpBasicInfoId),0) - (ISNULL((SELECT SUM(Duration) FROM Emp_Request HLA WHERE HLA.LeaveCategoryId = 4 AND HLA.EmpId = @EmpBasicInfoId AND HLA.IsDeleted =0 AND HLA.Status = 'Approved'), 0))) 
		 END AS LeaveBalance

		 FROM Emp_BasicInfo EB 
		 WHERE EB.EmpBasicInfoID = @EmpBasicInfoId --AND LA.LeaveCategoryId = @LeaveCategoryId 
		 /*
					 Select EB.FullName, --LC.CategoryName, 
		 CASE 
			 WHEN @LeaveCategoryId = 1 THEN [dbo].[LeaveQuotaCalculation](@EmpBasicInfoId,@LeaveId,1,NULL,NULL,'SLB') -- SickLeaveDay
			 WHEN @LeaveCategoryId = 2 THEN [dbo].[LeaveQuotaCalculation](@EmpBasicInfoId,@LeaveId,2,NULL,NULL,'CLB') --AdvanceLeaveDay
			 WHEN @LeaveCategoryId = 3 THEN [dbo].[LeaveQuotaCalculation](@EmpBasicInfoId,@LeaveId,3,NULL,NULL,'ALB')   -- AnnualLeaveDay
			 WHEN @LeaveCategoryId = 4 THEN [dbo].[LeaveQuotaCalculation](@EmpBasicInfoId,@LeaveId,4,NULL,NULL,'MLB')   --MaternityLeaveDay
		 END AS LeaveBalance

		 FROM Emp_BasicInfo EB 
		 WHERE EB.EmpBasicInfoID = @EmpBasicInfoId --AND LA.LeaveCategoryId = @LeaveCategoryId 
		 
		 */

	END
IF(@Block=2)   -- [SP_EmpLeaveForMobile]2,null,null,0
	BEGIN
		SELECT EAC.*
		,EC.CategoryName 
		FROM Att_EmpAcademicCalendar EAC
		LEFT JOIN Emp_Category EC ON EC.CategoryID = EAC.EmpCategory
		WHERE EAC.IsDeleted = 0 AND EAC.[Status] = 'A'
	END
IF(@Block=3)-- [SP_EmpLeaveForMobile] 3,0,0,6
	BEGIN
		 SELECT RH.RoutingId, 
		 CASE 
		 	WHEN RH.IsApprove = 0 AND RH.IsReject = 0 THEN 'Pending'  
		 	WHEN RH.IsApprove = 1 AND RH.IsReject = 0 THEN 'Approved'
		 	WHEN RH.IsApprove = 0 AND RH.IsReject = 1 THEN 'Rejected'
		 END AS ApprovedStatus, 
		 ISNULL(RH.Comments, '') AS Comments, 
		 CAST(RH.UpdateDate AS DATE) AS AddDate, 
		 AU.FullName
		 FROM HR_LeaveRoutingHistory RH
		 INNER JOIN HR_LeaveRoutingConfigDetails RCD ON RCD.DetailsId = RH.RoutingId 
		 INNER JOIN AspNetUsers AU ON AU.Id = RCD.NextApproval 
		 WHERE RH.LeaveId = @LeaveId
		 ORDER BY RH.RoutingId ASC
	END
	IF(@Block=4)-- [SP_EmpLeaveForMobile] 4,66,0,0
	BEGIN		
		 DECLARE @AdvanceUsed DECIMAL(10,2), @MaternityUsed DECIMAL(10,2), @SickUsed DECIMAL(10,2), @AnnualUsed DECIMAL(10,2);

		 SELECT @SickUsed = ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = @EmpBasicInfoId AND LeaveCategoryId = 1 AND Status = 'Approved'),0),
				@AdvanceUsed = ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = @EmpBasicInfoId AND LeaveCategoryId = 2 AND Status = 'Approved'),0),
				@AnnualUsed =  ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = @EmpBasicInfoId AND LeaveCategoryId = 3 AND Status = 'Approved'),0),
				@MaternityUsed = ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = @EmpBasicInfoId AND LeaveCategoryId = 4 AND Status = 'Approved'),0)

		 SELECT 
		 EmpId, SickLeaveDay AS TotalSickLeaveDay,     @SickUsed AS UsedSickLeaveDay,           SickLeaveDay      - @SickUsed AS DueSickLeaveDay,
		 AdvanceLeaveDay AS TotalAdvanceLeaveDay,      @AdvanceUsed AS UsedAdvanceLeaveDay,     AdvanceLeaveDay   - @AdvanceUsed AS DueAdvanceLeaveDay,
		 AnnualLeaveDay AS TotalAnnualLeaveDay,        @AnnualUsed AS UsedAnnualLeaveDay,       AnnualLeaveDay    -  @AnnualUsed AS DueAnnualLeaveDay,
		 MaternityLeaveDay AS TotalMaternityLeaveDay,  @MaternityUsed AS UsedMaternityLeaveDay, MaternityLeaveDay - @MaternityUsed AS DueMaternityLeaveDay,
		 (SickLeaveDay      - @SickUsed) + (AdvanceLeaveDay   - @AdvanceUsed) + (AnnualLeaveDay    -  @AnnualUsed) + (MaternityLeaveDay - @MaternityUsed) AS TotalAvailableLeave
		 FROM HR_EmpLeaveQuota WHERE EmpId = @EmpBasicInfoId AND IsDeleted = 0 
	END
END


