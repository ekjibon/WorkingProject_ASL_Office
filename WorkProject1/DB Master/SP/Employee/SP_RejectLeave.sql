IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_RejectLeave]'))
BEGIN
DROP PROCEDURE  [SP_RejectLeave]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		 Khaled 
-- Create date: 
-- Description:	
-- =============================================

CREATE  PROCEDURE SP_RejectLeave
(
@LeaveId INT,
@AdjustedDay INT=0,
@UnAdjustedDay INT=0,
@LeaveWithPay INT=0,
@LeaveWithOutPay INT=0,
@MaternityLeaveType INT=0,
@ApproveBy NVARCHAR(100),
@LeaveHistoryId INT,
@Reason VARCHAR(MAX)
)
AS
BEGIN

DECLARE @FROMDATE DATETIME
DECLARE @TODATE DATETIME
DECLARE @EmpId INT
DECLARE @CalendarId INT
DECLARE @AttendenceId INT
DECLARE @LeaveCategoryId INT
DECLARE @Duretion INT
DECLARE @Count INT
set @Count = 0


UPDATE HR_LeaveRoutingHistory SET Comments =  @Reason,IsReject=1,UpdateDate = GETDATE() WHERE LeaveHistoryId =  @LeaveHistoryId


SELECT @FROMDATE=FromDate,@TODATE=ToDate,@EmpId=EmpId,@LeaveCategoryId = LeaveCategoryId,@Duretion =  Duration FROM Emp_Request WHERE Id=@LeaveId

SELECT @CalendarId=AEC.Id 
FROM Att_EmpAcademicCalendar AEC
INNER JOIN Emp_BasicInfo EB ON AEC.EmpCategory = EB.CategoryID
WHERE EB.EmpBasicInfoID = @EmpId AND AEC.IsDeleted = 0 
ORDER BY AEC.Id ASC 


	UPDATE [dbo].[Emp_Attendance] SET IsLeave = 0,IsPresent = 0,
								  LeaveId = @LeaveId
								  ,IsLate = 0,IsDeleted=0
								  ,UpdateBy = @ApproveBy
								  ,UpdateDate =  GETDATE()
								  WHERE EmpId =  @EmpId AND CAST(InTime AS DATE) BETWEEN CAST(@FROMDATE AS DATE) AND CAST(@TODATE AS DATE)


	UPDATE [dbo].[Emp_Request]
	SET AdjustableDay = @AdjustedDay,
		UnadjustedDay=@UnAdjustedDay,
		Withpay=@LeaveWithPay,
		WithOutpay=@LeaveWithOutPay,
		MaternityLeaveType=@MaternityLeaveType,
	[Status] = 'Rejected' WHERE Id = @LeaveId



--IF(@Duretion<=@AdjustedDay)
--BEGIN
--UPDATE [dbo].[Emp_Attendance] SET IsWithPay=1 WHERE EmpId = @EmpId AND InTime BETWEEN @FROMDATE AND @TODATE 
--END

--IF(@LeaveCategoryId = 4)
--BEGIN
--IF(@LeaveWithOutPay>0)
--BEGIN
--DECLARE Structure_Cursor1 CURSOR FOR 
	
	
--	SELECT AttendId FROM [dbo].[Emp_Attendance]  WHERE InTime BETWEEN @FROMDATE AND @TODATE AND EmpId = @EmpId
	
--	OPEN Structure_Cursor1;

--	FETCH NEXT FROM Structure_Cursor1 
--	INTO @AttendenceId 

--	WHILE @@FETCH_STATUS = 0
--		BEGIN
--		IF(@LeaveWithOutPay>@Count)
--		BEGIN
--	         print @LeaveWithOutPay
--			UPDATE [dbo].[Emp_Attendance] 
--			SET IsWithOutPay=1 WHERE EmpId = @EmpId AND AttendId=@AttendenceId
--		END
				
--			SET @Count = @Count + 1;
--		FETCH NEXT FROM Structure_Cursor1 
		
--		INTO  @AttendenceId 
--		END
--		DEALLOCATE Structure_Cursor1;
--END
--ELSE
--BEGIN
--	DECLARE Structure_Cursor2 CURSOR FOR 
	
	
--	SELECT AttendId FROM [dbo].[Emp_Attendance]  WHERE InTime BETWEEN @FROMDATE AND @TODATE AND EmpId = @EmpId
	
--	OPEN Structure_Cursor2;

--	FETCH NEXT FROM Structure_Cursor2 
--	INTO @AttendenceId 

--	WHILE @@FETCH_STATUS = 0
--		BEGIN
--		    IF((@AdjustedDay+@LeaveWithPay)>@Count)			 		
--			BEGIN
--		     print @AdjustedDay+@LeaveWithPay
		
--			UPDATE [dbo].[Emp_Attendance] 
--			SET IsWithPay=1 WHERE EmpId = @EmpId AND AttendId=@AttendenceId
--			END		
--			SET @Count = @Count + 1;
--		FETCH NEXT FROM Structure_Cursor2 
		
--		INTO  @AttendenceId 
--		END
--		DEALLOCATE Structure_Cursor2;

--END
--END 

--IF(@LeaveCategoryId != 4 AND @AdjustedDay < @Duretion)

--BEGIN
--	DECLARE Structure_Cursor CURSOR FOR 
	
	
--	SELECT AttendId FROM [dbo].[Emp_Attendance]  WHERE InTime BETWEEN @FROMDATE AND @TODATE AND EmpId = @EmpId
	
--	OPEN Structure_Cursor;

--	FETCH NEXT FROM Structure_Cursor 
--	INTO @AttendenceId 

--	WHILE @@FETCH_STATUS = 0
--		BEGIN
--		    IF((@AdjustedDay+@LeaveWithPay)>@Count)			 		
--			BEGIN
--		     print @AdjustedDay+@LeaveWithPay
		
--			UPDATE [dbo].[Emp_Attendance] 
--			SET IsWithPay=1 WHERE EmpId = @EmpId AND AttendId=@AttendenceId
--			END
			
--			ELSE
--			BEGIN
--	         print @LeaveWithOutPay
--			UPDATE [dbo].[Emp_Attendance] 
--			SET IsWithOutPay=1 WHERE EmpId = @EmpId AND AttendId=@AttendenceId
--			END
				
--			SET @Count = @Count + 1;
--		FETCH NEXT FROM Structure_Cursor 
		
--		INTO  @AttendenceId 
--		END
--		DEALLOCATE Structure_Cursor;

--END

END
