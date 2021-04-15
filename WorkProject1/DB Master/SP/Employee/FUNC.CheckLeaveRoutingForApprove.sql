/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CheckLeaveRoutingForApprove]'))
BEGIN
DROP FUNCTION  CheckLeaveRoutingForApprove
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
--SELECT dbo.CheckLeaveRoutingForApprove(6,'506e12eb-90c8-4b83-92f1-f1b76b8a5f2c')

CREATE FUNCTION [dbo].[CheckLeaveRoutingForApprove]
(	
	@LeaveId  INT = 0,
	@UserId VARCHAR(MAX) = NULL
	
)
RETURNS  BIT  
AS
BEGIN
	DECLARE @SerialNo INT = 0,@IsReady BIT = 0,@Counter INT = 0,@EmpId INT = 0,@RoutePathId INT= 0,
		@IsFinalApprove BIT = 0,@IsFirstCheckMandatory BIT = 0,@FirstSerilaNo  INT =0, @SecondSerial INT  = 0 , @FirstApprove BIT = 0,@SecondApprove BIT = 0,@IsSecondCheckMandatory BIT = 0
		, @FirstReject BIT = 0
		SELECT @EmpId= EmpId FROM dbo.Emp_Request WHERE Id = @LeaveId 	
		SELECT @RoutePathId=RoutingId FROM dbo.HR_EmpLeaveQuota WHERE EmpId =  @EmpId AND IsDeleted = 0

		SELECT @SerialNo = LRC.SerialNo,@IsFinalApprove =  IsFinalApprove
				FROM dbo.HR_LeaveRoutingConfigDetails LRC WHERE  LRC.NextApproval = @UserId AND LRC.IsDeleted = 0 AND RoutingId = @RoutePathId
				--AND LRC.EmpId = @EmpId
		
		IF(@SerialNo=1) 
		BEGIN
			SET  @FirstSerilaNo= @SerialNo		
		END				
		ELSE
		SET @FirstSerilaNo = @SerialNo - 1
		SET @SecondSerial =  @SerialNo + 1
			   
		--IF(@IsCheckMandatory=1) 
		--	SET @IsCheckApprove = 1

		SELECT @FirstApprove =  IsApprove,@IsFirstCheckMandatory =  IsMandatory,@FirstReject =  IsReject FROM dbo.HR_LeaveRoutingHistory  LRH
									INNER JOIN  dbo.HR_LeaveRoutingConfigDetails LRC ON LRC.DetailsId =  LRH.RoutingId
							WHERE LeaveId = @LeaveId AND LRC.IsDeleted = 0 
							--AND LRH.IsApprove = @IsCheckApprove 		
							
							AND LRC.SerialNo = @FirstSerilaNo	
	--SELECT @SecondApprove =  IsApprove,@IsSecondCheckMandatory = IsMandatory FROM dbo.HR_LeaveRoutingHistory  LRH
	--								INNER JOIN  dbo.HR_LeaveRoutingConfigDetails LRC ON LRC.DetailsId =  LRH.RoutingId
	--						WHERE LeaveId = @LeaveId AND LRC.IsDeleted = 0 
	--						--AND LRH.IsApprove = @IsCheckApprove 
	--						--AND LRC.IsMandatory = 1 
	--						AND LRC.SerialNo = @SecondSerial

		IF(@FirstApprove=1 AND @IsFinalApprove = 0) -- Ready For Approve
		BEGIN
			SET @IsReady = 1
		END
		ELSE IF(@SerialNo=1 AND @IsFinalApprove = 0) -- Readay For Approve First Serial No
		SET @IsReady = 1
		ELSE IF(@FirstApprove=0 AND @IsFirstCheckMandatory = 0 AND @IsFinalApprove = 0 AND @FirstReject = 0) -- First Approve Not Found and Not Mandatory
		SET @IsReady = 1
		ELSE IF(@FirstApprove=0 AND @IsFirstCheckMandatory = 1 AND @IsFinalApprove = 0 AND @FirstReject = 0) -- First Approve Not Found and  Mandatory
		SET @IsReady = 0
		ELSE IF(@FirstApprove=1 AND @IsFirstCheckMandatory = 0 AND @IsFinalApprove = 0 AND @FirstReject = 0) -- First Approved and Not Mandatory
		SET @IsReady = 1
		ELSE IF(@FirstApprove=1 AND @IsFirstCheckMandatory = 1 AND @IsFinalApprove = 0 AND @FirstReject = 0) -- First Approved Found and  Mandatory
		SET @IsReady = 1
		ELSE IF(@FirstApprove=0 AND @IsFirstCheckMandatory = 1 AND @IsFinalApprove = 0 AND @FirstReject = 1) -- First Rejected Found and  Mandatory
		SET @IsReady = 1

		IF(@IsFinalApprove = 1)
		SET @IsReady = 1

	RETURN @IsReady 

END
GO


/*
SELECT dbo.CheckLeaveRoutingForApprove(6,'57562580-f197-40ca-84cf-a984269383cf') -- Azmal NM
SELECT dbo.CheckLeaveRoutingForApprove(1,'4086bbfd-5e2b-4656-bfbc-6045bb438a68') -- Kawsar M
SELECT dbo.CheckLeaveRoutingForApprove(1,'506e12eb-90c8-4b83-92f1-f1b76b8a5f2c') -- Shakib M
SELECT dbo.CheckLeaveRoutingForApprove(6,'71b6bcff-68c2-4211-8bcc-73ae2d7a8e73') -- Fhamida M + Final

*/