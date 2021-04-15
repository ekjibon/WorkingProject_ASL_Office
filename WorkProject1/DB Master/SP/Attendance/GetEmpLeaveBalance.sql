IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmpLeaveBalance]'))
BEGIN
DROP PROCEDURE  GetEmpLeaveBalance
END
GO
/****** Object:  StoredProcedure [dbo].[GetStudentRequestList]    Script Date: 02/04/2020 11:05:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[GetEmpLeaveBalance]
(
	@Block INT =0, 
	@EmpBasicInfoId INT = 0,
	@LeaveCategoryId INT = 0, -- 1. Sick 2. Casual(Advance) 3. Annual 4. Maternity
	@FromDate DATETIME, 
	@ToDate DATETIME 
)
AS
IF(@Block=1)   -- [GetEmpLeaveBalance] 1,66,4
BEGIN
BEGIN TRY
	BEGIN TRANSACTION; 

	IF NOT EXISTS (SELECT * FROM Att_EmpAcademicCalendarDetails WHERE CAST(CalendarDate AS DATE) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE))
	BEGIN
		RAISERROR ('Employee Quota Not Setup.',16,1);  
	END

	SELECT CalendarId INTO #CalendarId FROM Att_EmpAcademicCalendarDetails 
	WHERE CAST(CalendarDate AS DATE) BETWEEN CAST(@FromDate AS DATE)  AND CAST(@ToDate AS DATE)
	GROUP BY CalendarId
	DECLARE @AnnualLeaveDay DECIMAL(10,2),@SickLeaveDay DECIMAL(10,2),@AdvanceLeaveDay DECIMAL(10,2),@MaternityLeaveDay DECIMAL(10,2),@LeaveBalance DECIMAL(10,2),@TotalLeave DECIMAL(10,2)
	SELECT @AnnualLeaveDay = SUM(AnnualLeaveDay),
			@SickLeaveDay =SUM(SickLeaveDay)  ,
			@AdvanceLeaveDay =SUM(AdvanceLeaveDay)  ,
			@MaternityLeaveDay =SUM(MaternityLeaveDay)  
			FROM HR_EmpLeaveQuota 
				WHERE CalenderId IN(SELECT * FROM #CalendarId) AND EmpId = @EmpBasicInfoId AND IsDeleted = 0

	SELECT @TotalLeave = ISNULL(SUM(Duration) , 0) FROM Emp_Request ER WHERE ER.LeaveCategoryId = @LeaveCategoryId AND ER.EmpId = @EmpBasicInfoId AND ER.Status = 'Approved' AND ER.IsDeleted = 0

	IF(@LeaveCategoryId = 1) --SickLeaveDay
	BEGIN
		SET @LeaveBalance  = CASE WHEN (@SickLeaveDay - @TotalLeave) < 0 THEN 0 ELSE (@SickLeaveDay - @TotalLeave) END
	END

	ELSE IF(@LeaveCategoryId = 2) --AdvanceLeaveDay
	BEGIN
		SET @LeaveBalance  = CASE WHEN (@AdvanceLeaveDay - @TotalLeave) <0 THEN 0 ELSE (@AdvanceLeaveDay - @TotalLeave) END
	END
	ELSE IF(@LeaveCategoryId = 3) --AnnualLeaveDay
	BEGIN
		SET @LeaveBalance  = CASE WHEN (@AnnualLeaveDay - @TotalLeave) < 0 THEN 0 ELSE (@AnnualLeaveDay - @TotalLeave) END
	END
	ELSE IF(@LeaveCategoryId = 4) --MaternityLeaveDay
	BEGIN
		SET @LeaveBalance  = CASE WHEN (@MaternityLeaveDay - @TotalLeave) < 0 THEN 0 ELSE (@MaternityLeaveDay - @TotalLeave) END
	END

	 SELECT  EB.FullName, --LC.CategoryName, 
			@LeaveBalance LeaveBalance
	 FROM Emp_BasicInfo EB  	
	 WHERE EB.EmpBasicInfoID = @EmpBasicInfoId AND IsDeleted  = 0

	 --DROP TABLE #date2
	 DROP TABLE #CalendarId
	 
	 COMMIT;  
END TRY
BEGIN Catch
	  ROLLBACK TRANSACTION 
	    DECLARE @ErrorMessage NVARCHAR(4000); 
        DECLARE @ErrorSeverity INT; 
        DECLARE @ErrorState INT; 

        SELECT @ErrorMessage = Error_message(), 
               @ErrorSeverity = Error_severity(), 
               @ErrorState = Error_state(); 

        -- Use RAISERROR inside the CATCH block to return error  
        -- information about the original error that caused  
        -- execution to jump to the CATCH block.  
        RAISERROR (@ErrorMessage,-- Message text.  
                   @ErrorSeverity,-- Severity.  
                   @ErrorState -- State.  
        ); 
END Catch
END

-- EXEC [GetEmpLeaveBalance] 1,24,1
-- EXEC [GetEmpLeaveBalance] 1,24,2
-- EXEC [GetEmpLeaveBalance] 1,24,3
-- EXEC [GetEmpLeaveBalance] 1,24,4

-- SELECT * FROM HR_EmpLeaveQuota WHERE EmpId = 24

