/****** Object:  StoredProcedure [dbo].[GetLeaveDetailsEmpWise]    Script Date: 04/05/2020 3:23:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetLeaveDetailsEmpWise]'))
BEGIN
DROP PROCEDURE GetLeaveDetailsEmpWise
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--- [dbo].[GetLeaveDetailsEmpWise] 2,10,55, 'ff896ebc-9060-49ed-8acf-a56571800820'
CREATE PROCEDURE [dbo].[GetLeaveDetailsEmpWise] 
(
	@Block INT = NULL,
	@ID INT = Null, -- Leave Id
	@EmpId INT = Null,
	@UserId VARCHAR(MAX) = NULL
)
AS
BEGIN
	DECLARE @Designation INT
	SELECT @Designation =  D.DesignationOrder
		 FROM AspNetUsers AU
		 INNER JOIN Emp_BasicInfo EB ON EB.EmpBasicInfoID =  AU.EmpId
		 INNER JOIN dbo.Emp_Designation D ON D.DesignationID =  EB.DesignationID
		 WHERE AU.Id =  @UserId
		 			CREATE TABLE #temp
			(
				LeaveId INT ,
				EmpId INT NOT NULL, LeaveCategoryId INT NOT NULL , CategoryName VARCHAR(MAX),EligibleDays DECIMAL(10,2)
				,LeaveAvailed DECIMAL(10,2),LeaveInHand DECIMAL(10,2),TotalLeave DECIMAL(10,2) NOT NULL
			)

IF(@Block = 1)

	BEGIN
		SELECT DISTINCT EMPR.*,LT.CategoryName,		
				CASE EMPR.RequestType
				WHEN  5 THEN 'For Leave'
				END RequestType,EB.FullName RequestedBy,ED.DesignationName,Q.SickLeaveDay ,Q.AdvanceLeaveDay,Q.AnnualLeaveDay,Q.MaternityLeaveDay,
		 CASE WHEN LT.Id = 1 THEN [dbo].[LeaveQuotaCalculation](EMPR.EmpId,@ID,1,NULL,NULL,'SLB') -- SickLeaveDay
			  WHEN LT.Id = 2 THEN [dbo].[LeaveQuotaCalculation](EMPR.EmpId,@ID,2,NULL,NULL,'CLB') --AdvanceLeaveDay
			  WHEN LT.Id = 3 THEN [dbo].[LeaveQuotaCalculation](EMPR.EmpId,@ID,3,NULL,NULL,'ALB')   -- AnnualLeaveDay
			  WHEN LT.Id = 4 THEN [dbo].[LeaveQuotaCalculation](EMPR.EmpId,@ID,4,NULL,NULL,'MLB')   --MaternityLeaveDay
			  ELSE '0'
			  END AS Adjustable,
		 CASE WHEN LT.Id = 1 THEN EMPR.Duration-([dbo].[LeaveQuotaCalculation](EMPR.EmpId,@ID,1,NULL,NULL,'SLB'))
			  WHEN LT.Id = 2 THEN EMPR.Duration-([dbo].[LeaveQuotaCalculation](EMPR.EmpId,@ID,2,NULL,NULL,'CLB'))
			  WHEN LT.Id = 3 THEN EMPR.Duration-([dbo].[LeaveQuotaCalculation](EMPR.EmpId,@ID,3,NULL,NULL,'ALB'))
			  WHEN LT.Id = 4 THEN EMPR.Duration-([dbo].[LeaveQuotaCalculation](EMPR.EmpId,@ID,4,NULL,NULL,'MLB'))
			  ELSE '0'
			  END AS Unadjusted,
			   [dbo].[LeaveQuotaCalculation](@EmpId,@ID,NULL,NULL,NULL,'TRL')  AS  RemainingUnadjusted

		 FROM dbo.Emp_Request  EMPR
		 INNER JOIN dbo.Emp_BasicInfo EB ON EMPR.EmpId = EB.EmpBasicInfoID 
		 INNER JOIN [dbo].[Emp_Designation] ED ON ED.DesignationID = EB.DesignationID
		 INNER JOIN [dbo].[HR_LeaveCategory] LT ON LT.Id = EMPR.LeaveCategoryId 
		 INNER JOIN dbo.HR_EmpLeaveQuota Q ON Q.EmpId = EB.EmpBasicInfoID 
		 WHERE EMPR.Id = @ID  AND EMPR.RequestType = 5 and EMPR.IsDeleted=0  --AND Q.CalenderId = @CalendarId
		   

	INSERT INTO #temp 
			SELECT LeaveId,EmpId,LeaveCategoryId,CategoryName,EligibleDays,LeaveAvailed,LeaveInHand,TotalLeave from LeaveQuotaCheck(@EmpId,0,@ID,'EXISTS') 

		 	INSERT INTO #temp 
			SELECT LeaveId,EmpId,LeaveCategoryId,CategoryName,EligibleDays,LeaveAvailed,LeaveInHand,TotalLeave from LeaveQuotaCheck(@EmpId,0,@ID,'NOTEXISTS') 

		 SELECT *,(CASE WHEN LeaveInHand > TotalLeave THEN TotalLeave ELSE LeaveInHand END) AS AdjustLeave FROM #temp 
		 
		 SELECT RH.LeaveHistoryId,RH.RoutingId, 
		 CASE 
		 	WHEN RH.IsApprove = 0 AND RH.IsReject = 0 THEN 'Pending'  
		 	WHEN RH.IsApprove = 1 AND RH.IsReject = 0 THEN 'Approved'
		 	WHEN RH.IsApprove = 0 AND RH.IsReject = 1 THEN 'Rejected'
		 END AS ApprovedStatus, 
		 (CASE WHEN D.DesignationOrder >= @Designation THEN ISNULL(RH.Comments, '') ELSE '' END) AS Comments,
		 --ISNULL(RH.Comments, '') AS Comments, 
		 CAST(RH.UpdateDate AS DATE) AS AddDate, 
		 AU.FullName,D.DesignationOrder,AU.Id
		 FROM HR_LeaveRoutingHistory RH
		 INNER JOIN HR_LeaveRoutingConfigDetails RCD ON RCD.DetailsId = RH.RoutingId 
		 INNER JOIN AspNetUsers AU ON AU.Id = RCD.NextApproval
		 INNER JOIN Emp_BasicInfo EB ON EB.EmpBasicInfoID =  AU.EmpId
		 INNER JOIN dbo.Emp_Designation D ON D.DesignationID =  EB.DesignationID
		 WHERE RH.LeaveId = @ID
		 ORDER BY RCD.SerialNo ASC
	END

IF(@Block = 2)
	BEGIN
		DECLARE @SickLeaveDay DECIMAL(10,2),@AdvanceLeaveDay DECIMAL(10,2),@AnnualLeaveDay DECIMAL(10,2),@MaternityLeaveDay DECIMAL(10,2)
		-- Request Table Data
		SELECT DISTINCT EMPR.*,LT.CategoryName,		
				CASE EMPR.RequestType
				WHEN  5 THEN 'For Leave'
				END RequestType,EB.FullName RequestedBy,ED.DesignationName
				--Q.SickLeaveDay ,Q.AdvanceLeaveDay,Q.AnnualLeaveDay,Q.MaternityLeaveDay,
		 --CASE WHEN LT.Id = 1 THEN Q.SickLeaveDay-ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = EMPR.EmpId AND LeaveCategoryId = 1 AND Status = 'Approved'),0)
			--  WHEN LT.Id = 2 THEN Q.AdvanceLeaveDay-ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = EMPR.EmpId AND LeaveCategoryId = 2 AND Status = 'Approved'),0)
			--  WHEN LT.Id = 3 THEN Q.AnnualLeaveDay-ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = EMPR.EmpId AND LeaveCategoryId = 3 AND Status = 'Approved'),0)
			--  WHEN LT.Id = 4 THEN Q.MaternityLeaveDay-ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = EMPR.EmpId AND LeaveCategoryId = 4 AND Status = 'Approved'),0)
			--  ELSE '0'
			--  END AS Adjustable,
		 --CASE WHEN LT.Id = 1 THEN EMPR.Duration-(Q.SickLeaveDay-ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = EMPR.EmpId AND LeaveCategoryId = 1 AND Status = 'Approved'),0))
			--  WHEN LT.Id = 2 THEN EMPR.Duration-(Q.AdvanceLeaveDay-ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = EMPR.EmpId AND LeaveCategoryId = 2 AND Status = 'Approved'),0))
			--  WHEN LT.Id = 3 THEN EMPR.Duration-(Q.AnnualLeaveDay-ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = EMPR.EmpId AND LeaveCategoryId = 3 AND Status = 'Approved'),0))
			--  WHEN LT.Id = 4 THEN EMPR.Duration-(Q.MaternityLeaveDay-ISNULL((SELECT SUM(Duration) FROM dbo.Emp_Request  WHERE EmpId = EMPR.EmpId AND LeaveCategoryId = 4 AND Status = 'Approved'),0))
			--  ELSE '0'
			--  END AS Unadjusted,
			  --,[dbo].[GetRenainingUnadjustedLeave] (EMPR.EmpId) AS RemainingUnadjusted
			  ,[dbo].[LeaveQuotaCalculation](@EmpId,@ID,NULL,NULL,NULL,'TRL')  AS RemainingUnadjusted
		 FROM dbo.Emp_Request  EMPR
		 INNER JOIN dbo.Emp_BasicInfo EB ON EMPR.EmpId = EB.EmpBasicInfoID 
		 INNER JOIN [dbo].[Emp_Designation] ED ON ED.DesignationID = EB.DesignationID
		 INNER JOIN [dbo].[HR_LeaveCategory] LT ON LT.Id = EMPR.LeaveCategoryId 
		 --INNER JOIN dbo.HR_EmpLeaveQuota Q ON Q.EmpId = EB.EmpBasicInfoID 
		 WHERE EMPR.Id = @ID  AND EMPR.RequestType = 5 and EMPR.IsDeleted=0 

		-- Leave Summary

		
			
		INSERT INTO #temp 
			SELECT LeaveId,EmpId,LeaveCategoryId,CategoryName,EligibleDays,LeaveAvailed,LeaveInHand from LeaveQuotaCheck(@EmpId,0,@ID,'EXISTS') 

		 	INSERT INTO #temp 
			SELECT LeaveId,EmpId,LeaveCategoryId,CategoryName,EligibleDays,LeaveAvailed,LeaveInHand from LeaveQuotaCheck(@EmpId,0,@ID,'NOTEXISTS') 

		 SELECT * FROM #temp
		-- Routing History
		SELECT RH.LeaveHistoryId,RH.RoutingId, 
		 CASE 
		 	WHEN RH.IsApprove = 0 AND RH.IsReject = 0 THEN 'Pending'  
		 	WHEN RH.IsApprove = 1 AND RH.IsReject = 0 THEN 'Approved'
		 	WHEN RH.IsApprove = 0 AND RH.IsReject = 1 THEN 'Rejected'
		 END AS ApprovedStatus, 
		 (CASE WHEN D.DesignationOrder >= @Designation THEN ISNULL(RH.Comments, '') ELSE '' END) AS Comments,
		 --ISNULL(RH.Comments, '') AS Comments, 
		 CAST(RH.UpdateDate AS DATE) AS AddDate, 
		 AU.FullName,D.DesignationOrder,AU.Id
		 FROM HR_LeaveRoutingHistory RH
		 INNER JOIN HR_LeaveRoutingConfigDetails RCD ON RCD.DetailsId = RH.RoutingId 
		 INNER JOIN AspNetUsers AU ON AU.Id = RCD.NextApproval
		 INNER JOIN Emp_BasicInfo EB ON EB.EmpBasicInfoID =  AU.EmpId
		 INNER JOIN dbo.Emp_Designation D ON D.DesignationID =  EB.DesignationID
		 WHERE RH.LeaveId = @ID
		 ORDER BY RCD.SerialNo ASC

		-- Leave Quota Info
		--SELECT EmpId,CalenderId, RoutingId, AnnualLeaveDay,AdvanceLeaveDay,SickLeaveDay,MaternityLeaveDay FROM HR_EmpLeaveQuota WHERE EmpId = @EmpId
	SELECT	@SickLeaveDay = [dbo].[LeaveQuotaCalculation](@EmpId,@ID,1,NULL,NULL,'SL') -- SickLeaveDay
	SELECT	@AdvanceLeaveDay = [dbo].[LeaveQuotaCalculation](@EmpId,@ID,2,NULL,NULL,'CL') --AdvanceLeaveDay
	SELECT	@AnnualLeaveDay = [dbo].[LeaveQuotaCalculation](@EmpId,@ID,3,NULL,NULL,'AL')   -- AnnualLeaveDay
	SELECT	@MaternityLeaveDay =[dbo].[LeaveQuotaCalculation](@EmpId,@ID,4,NULL,NULL,'ML')   --MaternityLeaveDay

	SELECT @SickLeaveDay AS SickLeaveDay,@AdvanceLeaveDay AS AdvanceLeaveDay,@AnnualLeaveDay AS AnnualLeaveDay,@MaternityLeaveDay AS MaternityLeaveDay

		-- Routing History For Employee Portal
		SELECT RH.LeaveHistoryId,RH.RoutingId, 
		 CASE 
		 	WHEN RH.IsApprove = 0 AND RH.IsReject = 0 THEN 'Pending'  
		 	WHEN RH.IsApprove = 1 AND RH.IsReject = 0 THEN 'Approved'
		 	WHEN RH.IsApprove = 0 AND RH.IsReject = 1 THEN 'Rejected'
		 END AS ApprovedStatus, 
		 --(CASE WHEN D.DesignationOrder >= @Designation THEN ISNULL(RH.Comments, '') ELSE '' END) AS Comments,
		 --ISNULL(RH.Comments, '') AS Comments, 
		 CAST(RH.UpdateDate AS DATE) AS AddDate, 
		 AU.FullName,D.DesignationOrder,AU.Id
		 FROM HR_LeaveRoutingHistory RH
		 INNER JOIN HR_LeaveRoutingConfigDetails RCD ON RCD.DetailsId = RH.RoutingId 
		 INNER JOIN AspNetUsers AU ON AU.Id = RCD.NextApproval
		 INNER JOIN Emp_BasicInfo EB ON EB.EmpBasicInfoID =  AU.EmpId
		 INNER JOIN dbo.Emp_Designation D ON D.DesignationID =  EB.DesignationID
		 WHERE RH.LeaveId = @ID
		 ORDER BY RCD.SerialNo ASC
		
	END
	DROP TABLE #temp
END

-- [dbo].[GetLeaveDetailsEmpWise] 1,1,24, NULL
-- [dbo].[GetLeaveDetailsEmpWise] 2,1,24, '4086bbfd-5e2b-4656-bfbc-6045bb438a68'
