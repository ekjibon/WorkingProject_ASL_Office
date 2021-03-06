/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[LeaveQuotaCalculation]'))
BEGIN
DROP FUNCTION  LeaveQuotaCalculation
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Biplob>
-- Create date: <01-Jun-2017,>
-- Description:	<For Latter grade ad GP  Present>
-- =============================================
CREATE FUNCTION [dbo].[LeaveQuotaCalculation]
(
	@EmpId INT=NULL,
	@LeaveId INT = NULL,	
	@LeaveCateId INT = NULL,	
	@FromDate SMALLDATETIME=NULL,
	@ToDate SMALLDATETIME=NULL,
	@Type VARCHAR(25)
)
RETURNS DECIMAL(18,2)
AS
BEGIN
	
	DECLARE @Value DECIMAL(18,2),@FDate DATETIME ,@TDate DATETIME

	SELECT @FDate = ISNULL(@FromDate,FromDate) ,@TDate = ISNULL(@ToDate,ToDate),@LeaveCateId =  ISNULL(@LeaveCateId,LeaveCategoryId) 
		FROM dbo.Emp_Request WHERE Id = @LeaveId AND IsDeleted = 0

	DECLARE  @tempCalendar TABLE
	(
		CalendarId INT NOT NULL
	)
	INSERT INTO @tempCalendar(CalendarId)
		SELECT CalendarId  FROM Att_EmpAcademicCalendarDetails 
	WHERE CAST(CalendarDate AS DATE) BETWEEN CAST(@FDate AS DATE)  AND CAST(@TDate AS DATE) AND IsDeleted = 0
	GROUP BY CalendarId

	DECLARE @AnnualLeaveDay DECIMAL(10,2),@SickLeaveDay DECIMAL(10,2),@AdvanceLeaveDay DECIMAL(10,2),@MaternityLeaveDay DECIMAL(10,2),@LeaveBalance DECIMAL(10,2),@TotalLeave DECIMAL(10,2)
	
	SELECT @AnnualLeaveDay = SUM(AnnualLeaveDay),
			@SickLeaveDay =SUM(SickLeaveDay)  ,
			@AdvanceLeaveDay =SUM(AdvanceLeaveDay)  ,
			@MaternityLeaveDay =SUM(MaternityLeaveDay)  
			FROM HR_EmpLeaveQuota 
				WHERE CalenderId IN(SELECT * FROM @tempCalendar) AND EmpId = @EmpId AND IsDeleted = 0

	SELECT @TotalLeave = ISNULL(SUM(Duration) , 0) FROM Emp_Request ER WHERE ER.LeaveCategoryId = @LeaveCateId AND ER.EmpId = @EmpId AND ER.Status = 'Approved' AND ER.IsDeleted = 0
	
	IF(@Type='AL')
	SET @Value = @AnnualLeaveDay
	IF(@Type='SL')
	SET @Value = @SickLeaveDay
	IF(@Type='CL')
	SET @Value = @AdvanceLeaveDay
	IF(@Type='ML')
	SET @Value = @MaternityLeaveDay
	IF(@Type='ALB')
	SET @Value = @AnnualLeaveDay  - @TotalLeave
	IF(@Type='SLB')
	SET @Value = @SickLeaveDay  - @TotalLeave
	IF(@Type='CLB')
	SET @Value = @AdvanceLeaveDay  - @TotalLeave
	IF(@Type='MLB')
	SET @Value = @MaternityLeaveDay - @TotalLeave
	IF(@Type='TRL') --  Total Remaning Leave 
	BEGIN	
		SELECT @TotalLeave = ISNULL(SUM(Duration) , 0) FROM Emp_Request ER 
			WHERE  ER.EmpId = @EmpId AND ER.Status = 'Approved' AND ER.IsDeleted = 0
		SET @Value = (@AnnualLeaveDay+@SickLeaveDay+@AdvanceLeaveDay+@MaternityLeaveDay) - @TotalLeave
	END
	IF(@Type='LA') -- LeaveAvailed
	SET @Value = @TotalLeave
	--TRUNCATE TABLE @tempCalendar
	RETURN @Value
	
END

GO


--SELECT [dbo].[LeaveQuotaCalculation](24,34,3,NULL,NULL,'ALB')
--[GetEmpLeaveBalance2] 1,66,1,'2021-02-18 17:34:24.577','2022-02-18 17:34:24.577'