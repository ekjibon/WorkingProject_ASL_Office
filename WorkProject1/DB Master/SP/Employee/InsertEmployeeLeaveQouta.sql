
/****** Object:  StoredProcedure [dbo].[InsertEmployeeLeaveQouta]    Script Date: 5/4/2020 11:15:16 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[InsertEmployeeLeaveQouta]'))
BEGIN
DROP PROCEDURE  [InsertEmployeeLeaveQouta]
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Khaled
-- Create date: 
-- Description:	
-- =============================================
-- 
CREATE PROCEDURE [dbo].[InsertEmployeeLeaveQouta]

	@EmpLeaveQuotaId INT,
	@AnnualLeaveDay INT,
	@SickLeaveDay INT,
	@AdvanceLeaveDay INT,
	@MaternityLeaveDay INT,
	@RoutingId INT,
	@AddBy VARCHAR(MAX),
	@BranchId INT,
	@DeptId INT,
	@DesignationId INT,
	@CalendarId INT,
	@EmpBasicInfoID INT,
	@IP VARCHAR(MAX),
	@MacAddress VARCHAR(MAX)

AS
BEGIN
	IF(@EmpLeaveQuotaId=0)
	BEGIN
	INSERT INTO [dbo].[HR_EmpLeaveQuota]
           ([EmpId],[BranchId],[EmpCategory],[AnnualLeaveDay],[SickLeaveDay]
           ,[AdvanceLeaveDay],[MaternityLeaveDay],[IsDeleted]
           ,[AddBy],[AddDate],[Status]
           ,[IP],[MacAddress],[CalenderId],[RoutingId])
		   SELECT @EmpBasicInfoID,@BranchId,0,@AnnualLeaveDay,@SickLeaveDay
				  ,@AdvanceLeaveDay,@MaternityLeaveDay,0,@Addby,GETDATE(),'A',@IP,@MacAddress,@CalendarId,@RoutingId
		  

		SELECT @@ROWCOUNT AS TOTALLROWS
	END
	ELSE
	BEGIN
		UPDATE [dbo].[HR_EmpLeaveQuota] SET AnnualLeaveDay =  @AnnualLeaveDay,
											SickLeaveDay =  @SickLeaveDay,
											AdvanceLeaveDay = @AdvanceLeaveDay,
											MaternityLeaveDay =  @MaternityLeaveDay,
											RoutingId =  @RoutingId,
											CalenderId = @CalendarId
										WHERE EmpLeaveQuotaId =  @EmpLeaveQuotaId
		SELECT @@ROWCOUNT AS TOTALLROWS
	END
END



