IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmployeeLeaveRequestList]'))
BEGIN
DROP PROCEDURE  GetEmployeeLeaveRequestList
END
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeeLeaveRequestList] author khaled    Script Date: 4/5/2020 12:39:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[GetEmployeeLeaveRequestList]
(
	@Block INT =0,
    @FromDate VARCHAR(MAX)=NULL,
    @ToDate VARCHAR(MAX),
    @UserId VARCHAR(MAX),
    @CalendarId INT =0,
    @Status VARCHAR(MAX) = NULL
)
 AS
 DECLARE @JoiningDate DATETIME, @TodayDate DATETIME   
BEGIN --GetEmployeeLeaveRequestList 1,NULL,NULL,'506e12eb-90c8-4b83-92f1-f1b76b8a5f2c',0,NULL
		IF(@Status='') SET @Status = NULL
		IF(@CalendarId=0) SET @CalendarId = NULL
		IF(@Block=1)
		BEGIN
			SELECT @TodayDate = GETDATE();
			SELECT  LRH.LeaveHistoryId,LRH.Comments,LRH.IsApprove
					,(CASE WHEN (LRH.IsApprove=1 AND LRH.IsReject=0) THEN 'Approved' 
							WHEN (LRH.IsApprove=0 AND LRH.IsReject=1) THEN 'Rejected'
						ELSE 'Pending' END) AS UserStatus
					,EMPR.[Status],LQ.CalenderId,LRH.IsReject,EMPR.Id,	EMPR.EmpId,EMPR.CategoryId,
					EMPR.DesignationId,	EMPR.Date,	EMPR.Reason,EMPR.Time,	EMPR.Description,	
					EMPR.MeetingIssue,	EMPR.NOCType,EMPR.TravelDesination,EMPR.TravelTo,EMPR.TravelFrom,EMPR.LeaveDate,EMPR.FromDate,EMPR.ToDate	
					,EMPR.Duration,EMPR.RequestOn,EMPR.IsDeleted,EMPR.AddBy	
					AddDate,EMPR.UpdateBy,EMPR.UpdateDate,EMPR.Remarks,EMPR.IP	
					,EMPR.MacAddress,EMPR.LeaveCategoryId,EMPR.AdjustableDay	
					,EMPR.UnadjustedDay,EMPR.Withpay,EMPR.WithOutpay	
					,EMPR.MaternityLeaveType,EMPR.LeaveTypeId	
					LeaveTypeCategory
					,LT.CategoryName,		
					CASE EMPR.RequestType
					WHEN  1 THEN 'For Meeting'
					WHEN  2 THEN 'For Tailor/TuckShop'
					WHEN  3 THEN 'For NOC'
					WHEN  4 THEN 'For TC'
					WHEN  5 THEN 'For Leave'
					END RequestType
					 ,LRCD.IsFinalApprove,dbo.CheckLeaveRoutingForApprove(EMPR.Id,@UserId) AS IsReadyLeaveApprove,LRCD.SerialNo
					,EB.FullName RequestedBy,ED.DesignationName,(SELECT dbo.fnServiceLength(EB.JoiningDate,@TodayDate)) AS ServiceLength
					,(DATEDIFF(month,EB.JoiningDate,EB.ProbationPeriodEndDate)) AS ProbationPeriod,EB.ConfirmationDate INTO #Temp
			FROM dbo.Emp_Request  EMPR
					INNER JOIN dbo.Emp_BasicInfo EB ON EMPR.EmpId = EB.EmpBasicInfoID 
					INNER JOIN [dbo].[Emp_Designation] ED ON ED.DesignationID = EB.DesignationID
					INNER JOIN [dbo].[HR_LeaveCategory] LT ON LT.Id = EMPR.LeaveCategoryId 
					INNER JOIN dbo.HR_EmpLeaveQuota LQ ON LQ.EmpId =  EMPR.EmpId
					INNER JOIN dbo.HR_LeaveRoutingConfig LRC ON LRC.RoutingId =  LQ.RoutingId
					INNER JOIN dbo.HR_LeaveRoutingConfigDetails LRCD ON LRCD.RoutingId =  LRC.RoutingId 
					INNER JOIN dbo.HR_LeaveRoutingHistory LRH ON LRH.RoutingId =  LRCD.DetailsId AND LRH.LeaveId = EMPR.Id
			WHERE   LRCD.NextApproval = @UserId 
					AND LQ.CalenderId =  ISNULL(@CalendarId,LQ.CalenderId)
					AND EMPR.[Status] =  ISNULL(@Status,EMPR.[Status]) 
					--AND	CAST (EMPR.AddDate AS DATE) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE)
					AND EMPR.RequestType = 5 and EMPR.IsDeleted=0 
			ORDER BY EMPR.Id DESC

			SELECT * FROM #Temp WHERE IsReadyLeaveApprove = 1 ORDER BY Id DESC

			DROP TABLE #Temp
		END 
 End

 
