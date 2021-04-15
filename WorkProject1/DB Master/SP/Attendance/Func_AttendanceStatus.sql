/****** Object:  StoredProcedure [dbo].[Func_AttendanceStatus]    Script Date: 24/02/2021 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Func_AttendanceStatus]'))
BEGIN
DROP FUNCTION  Func_AttendanceStatus
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Robiul>
-- Create date: <24-Feb-2021,>
-- Description:	<For Employee Attendance Status>
-- =============================================
CREATE FUNCTION [dbo].[Func_AttendanceStatus]
(
	@EmpId INT=NULL,
	@FromDate SMALLDATETIME=NULL,
	@ToDate SMALLDATETIME=NULL,
	@Type VARCHAR(25)
)
RETURNS INT
AS
BEGIN   --
 
	DECLARE @Value INT,@FDate DATETIME ,@TDate DATETIME
	IF(@Type='TD')--Total Day
		SELECT @Value = COUNT(OfficeInTime) FROM Emp_Attendance EA   WHERE EmpId = @EmpId  AND CAST( InTime AS DATE)    BETWEEN CAST( @FromDate AS DATE) AND CAST( @ToDate AS DATE) AND IsDeleted =0
	IF(@Type='TWS')   --Total WorkingDay
	   SELECT @Value = COUNT(IsPresent) FROM Emp_Attendance WHERE EmpId = @EmpId AND CAST(InTime AS Date) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE) AND DayType='Regular' 
	IF(@Type='TP')--Total Prasent
	   SELECT  @Value = COUNT(IsPresent) FROM Emp_Attendance WHERE EmpId = @EmpId AND CAST(InTime AS Date) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE) AND (IsPresent= 1 OR (IsPriApproved=1 AND IsChangedStatus=1 AND IsApproved=1))  AND DATENAME(WEEKDAY,CAST(InTime AS Date)) != 'Friday'
	IF(@Type='TL') --Total Leave
	   SELECT @Value = COUNT(IsLeave) FROM Emp_Attendance WHERE EmpId = @EmpId AND CAST(InTime AS Date) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE) AND IsLeave= 1
	IF(@Type='THL') --Total HalfDay Leave
	   SELECT @Value =COUNT(IsHalfDay) FROM Emp_Attendance WHERE EmpId = @EmpId AND CAST(InTime AS Date) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE) AND IsHalfDay= 1
	IF(@Type='Late')  --Total Late
	   SELECT @Value= COUNT(IsLate) FROM Emp_Attendance WHERE EmpId = @EmpId AND CAST(InTime AS Date) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE) AND (IsLate= 1 OR(IsChangedStatus=1 AND IsApproved=1 AND IsLate=1))
	IF(@Type='EarlyOut') --Total EarlyOut
	   SELECT @Value= COUNT(IsEarlyOut) FROM Emp_Attendance WHERE EmpId = @EmpId AND CAST(InTime AS Date) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE) AND IsEarlyOut= 1
	IF(@Type='LI_EA')  --Total Late AND EarlyOut
	   SELECT @Value= COUNT(IsPresent) FROM Emp_Attendance WHERE EmpId = @EmpId AND CAST(InTime AS Date) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE) AND IsLate= 1 	AND IsEarlyOut= 1
	IF(@Type='TA')   --Total Absent
	   SELECT @Value = COUNT(IsPresent) FROM Emp_Attendance WHERE EmpId = @EmpId AND CAST(InTime AS Date) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE) AND IsPresent= 0 AND DayType='Regular' AND IsLeave = 0
	IF(@Type='TH') --Total Holiday
	   SELECT @Value =COUNT(IsPresent) FROM Emp_Attendance WHERE EmpId = @EmpId AND CAST(InTime AS Date) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE)  AND DayType = 'Holiday'
	IF(@Type='TW') --Total Weekend
	   SELECT @Value =COUNT(IsPresent) FROM Emp_Attendance WHERE EmpId = @EmpId AND CAST(InTime AS Date) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE)  AND DayType<>'Regular' AND DayType <> 'Holiday'
	IF(@Type='TWPSL') --Total WithPaySickLeave
	   SELECT @Value = (SUM(Duration)- SUM(ISNULL(WithOutpay,0))) FROM Emp_Request WHERE EmpId = @EmpId AND AddDate BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE) AND Status = 'Approved' AND RequestType = 5 AND LeaveCategoryId = 1
	IF(@Type='TWOPSL') --Total WithOutPaySickLeave
	   SELECT @Value =  SUM(ISNULL(WithOutpay,0)) FROM Emp_Request WHERE EmpId = @EmpId AND AddDate BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE) AND Status = 'Approved' AND RequestType = 5 AND LeaveCategoryId = 1
	IF(@Type='TWPML') --Total WithPayMeternityLeave
	   SELECT @Value = (SUM(Duration)- SUM(ISNULL(WithOutpay,0))) FROM Emp_Request WHERE EmpId = @EmpId AND AddDate BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE) AND Status = 'Approved' AND RequestType = 5 AND LeaveCategoryId = 4
    IF(@Type='TWOPML') --Total WithOutPayMeternityLeave
	   SELECT @Value =  SUM(ISNULL(WithOutpay,0)) FROM Emp_Request WHERE EmpId = @EmpId AND AddDate BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE) AND Status = 'Approved' AND RequestType = 5 AND LeaveCategoryId = 4
	IF(@Type='TWPAL') --Total WithPayAnualLeave
	   SELECT @Value =  SUM(Duration) FROM Emp_Request WHERE EmpId = @EmpId AND AddDate BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE) AND Status = 'Approved' AND RequestType = 5 AND LeaveCategoryId = 3
	IF(@Type='TWOPAL') --Total WithOutPayAnualLeave
	   SELECT @Value =  SUM(ISNULL(WithOutpay,0)) FROM Emp_Request WHERE EmpId = @EmpId AND AddDate BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE) AND Status = 'Approved' AND RequestType = 5 AND LeaveCategoryId = 3
	IF(@Type='TWPCL') --Total WithPayCasualLeave
	   SELECT @Value =  SUM(Duration) FROM Emp_Request WHERE EmpId = @EmpId AND AddDate BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE) AND Status = 'Approved' AND RequestType = 5 AND LeaveCategoryId = 2
	IF(@Type='TWOPCL') --Total WithOutPayCasualLeave
	   SELECT @Value =  SUM(ISNULL(WithOutpay,0)) FROM Emp_Request WHERE EmpId = @EmpId AND AddDate BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE) AND Status = 'Approved' AND RequestType = 5 AND LeaveCategoryId = 2


	RETURN @Value
	
END

GO

--SELECT [dbo].[Func_AttendanceStatus]( 55, '2021-02-01', '2021-02-22', 'TP') AS test;
