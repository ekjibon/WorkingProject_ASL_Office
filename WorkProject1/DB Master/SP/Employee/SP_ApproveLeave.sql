
/****** Object:  StoredProcedure [dbo].[SP_ApproveLeave]    Script Date: 5/10/2020 11:21:03 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_ApproveLeave]'))
BEGIN
DROP PROCEDURE  [SP_ApproveLeave]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		 Arifur 
-- Create date: 
-- Description:	
-- =============================================
--SP_ApproveLeave 22,3,1,0,1,0,''
CREATE  PROCEDURE [dbo].[SP_ApproveLeave]
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

DECLARE @FROMDATE DATETIME,@TODATE DATETIME,@EmpId INT,@CalendarId INT,@AttendenceId INT,@LeaveCategoryId INT,@Duration INT,@Count INT,@LeaveType VARCHAR(25)

SET @Count = 0


UPDATE HR_LeaveRoutingHistory SET Comments =  @Reason,IsApprove=1,UpdateDate = GETDATE() WHERE LeaveHistoryId =  @LeaveHistoryId


SELECT @FROMDATE=FromDate,@TODATE=ToDate,@EmpId=EmpId,@LeaveCategoryId = LeaveCategoryId,@Duration =  Duration,@LeaveType = LeaveTypeCategory
FROM Emp_Request WHERE Id=@LeaveId AND IsDeleted = 0


SELECT @CalendarId=AEC.Id 
FROM Att_EmpAcademicCalendar AEC
INNER JOIN Emp_BasicInfo EB ON AEC.EmpCategory = EB.CategoryID
WHERE EB.EmpBasicInfoID = @EmpId AND AEC.IsDeleted = 0 
ORDER BY AEC.Id ASC 
 

 DECLARE @isPresent BIT = 0,@isEO BIT = 0,@isHalfDay BIT = 0,@isLeave BIT =0,@isLI BIT = 0
 
 IF(@LeaveType = 'HD')
 BEGIN
	SET @isPresent = 1;
	SET @isHalfDay = 1;
	SET @isEO  = 0;
	SET @isLI = 0;
 END
 ELSE IF(@LeaveType = 'FD')
 BEGIN
	SET @isLeave = 1
	SET @isEO  = 0;
	SET @isLI = 0;
 END

	UPDATE [dbo].[Emp_Attendance] SET  
									IsPresent = @isPresent,
								  LeaveId = @LeaveId						
								  ,IsDeleted=0
								  ,UpdateBy = @ApproveBy
								  ,UpdateDate =  GETDATE()
								  ,IsHalfDay = @isHalfDay
								  ,IsLeave = @isLeave
								  --,IsLate = (CASE WHEN @LeaveType = 'HD' THEN IsLate ELSE @isLI END)
								  --,IsEarlyOut = (CASE WHEN @LeaveType = 'HD' THEN IsEarlyOut ELSE @isEO END)
								  ,IsLate = @isLI
								  ,IsEarlyOut = @isEO
								  ,IsChangedStatus = 1
								  ,IsApproved = 1
								,SoftwareResult = (CASE 
											WHEN  SoftwareResult IS NOT NULL AND @LeaveType = 'HD'   THEN SoftwareResult + ',Half Day Leave'											
											WHEN  SoftwareResult IS NOT NULL AND @LeaveType = 'FD'   THEN SoftwareResult + ',Leave'											
											WHEN  SoftwareResult IS NULL AND @LeaveType = 'HD'  THEN  'Half Leave' 
											WHEN  SoftwareResult IS NULL  AND @LeaveType = 'FD' THEN  'Leave' 
										ELSE NULL END)
								  WHERE EmpId =  @EmpId AND CAST(InTime AS DATE) BETWEEN CAST(@FROMDATE AS DATE) AND CAST(@TODATE AS DATE)


	UPDATE [dbo].[Emp_Request]
	SET AdjustableDay = @AdjustedDay,
		UnadjustedDay=@UnAdjustedDay,
		Withpay=@LeaveWithPay,
		WithOutpay=@LeaveWithOutPay,
		MaternityLeaveType=@MaternityLeaveType,
	[Status] = 'Approved' WHERE Id = @LeaveId



IF(@Duration<=@AdjustedDay)
BEGIN
UPDATE [dbo].[Emp_Attendance] SET IsWithPay=1 WHERE EmpId = @EmpId AND InTime BETWEEN @FROMDATE AND @TODATE 
END

IF(@LeaveCategoryId = 4)
BEGIN
IF(@LeaveWithOutPay>0)
BEGIN
DECLARE Structure_Cursor1 CURSOR FOR 
	
	
	SELECT AttendId FROM [dbo].[Emp_Attendance]  WHERE InTime BETWEEN @FROMDATE AND @TODATE AND EmpId = @EmpId
	
	OPEN Structure_Cursor1;

	FETCH NEXT FROM Structure_Cursor1 
	INTO @AttendenceId 

	WHILE @@FETCH_STATUS = 0
		BEGIN
		IF(@LeaveWithOutPay>@Count)
		BEGIN
	         print @LeaveWithOutPay
			UPDATE [dbo].[Emp_Attendance] 
			SET IsWithOutPay=1 WHERE EmpId = @EmpId AND AttendId=@AttendenceId
		END
				
			SET @Count = @Count + 1;
		FETCH NEXT FROM Structure_Cursor1 
		
		INTO  @AttendenceId 
		END
		DEALLOCATE Structure_Cursor1;
END
ELSE
BEGIN
	DECLARE Structure_Cursor2 CURSOR FOR 
	
	
	SELECT AttendId FROM [dbo].[Emp_Attendance]  WHERE InTime BETWEEN @FROMDATE AND @TODATE AND EmpId = @EmpId
	
	OPEN Structure_Cursor2;

	FETCH NEXT FROM Structure_Cursor2 
	INTO @AttendenceId 

	WHILE @@FETCH_STATUS = 0
		BEGIN
		    IF((@AdjustedDay+@LeaveWithPay)>@Count)			 		
			BEGIN
		     print @AdjustedDay+@LeaveWithPay
		
			UPDATE [dbo].[Emp_Attendance] 
			SET IsWithPay=1 WHERE EmpId = @EmpId AND AttendId=@AttendenceId
			END		
			SET @Count = @Count + 1;
		FETCH NEXT FROM Structure_Cursor2 
		
		INTO  @AttendenceId 
		END
		DEALLOCATE Structure_Cursor2;

END
END 

IF(@LeaveCategoryId != 4 AND @AdjustedDay < @Duration)

BEGIN
	DECLARE Structure_Cursor CURSOR FOR 
	
	
	SELECT AttendId FROM [dbo].[Emp_Attendance]  WHERE InTime BETWEEN @FROMDATE AND @TODATE AND EmpId = @EmpId
	
	OPEN Structure_Cursor;

	FETCH NEXT FROM Structure_Cursor 
	INTO @AttendenceId 

	WHILE @@FETCH_STATUS = 0
		BEGIN
		    IF((@AdjustedDay+@LeaveWithPay)>@Count)			 		
			BEGIN
		     print @AdjustedDay+@LeaveWithPay
		
			UPDATE [dbo].[Emp_Attendance] 
			SET IsWithPay=1 WHERE EmpId = @EmpId AND AttendId=@AttendenceId
			END
			
			ELSE
			BEGIN
	         print @LeaveWithOutPay
			UPDATE [dbo].[Emp_Attendance] 
			SET IsWithOutPay=1 WHERE EmpId = @EmpId AND AttendId=@AttendenceId
			END
				
			SET @Count = @Count + 1;
		FETCH NEXT FROM Structure_Cursor 
		
		INTO  @AttendenceId 
		END
		DEALLOCATE Structure_Cursor;

END

END

--IF(@UnAdjustedDay=0 AND @AdjustedDay>0)
--BEGIN
--UPDATE [dbo].[Emp_Attendance] SET IsWithPay=1 WHERE InTime BETWEEN @FROMDATE AND @TODATE
--END

--IF(@UnAdjustedDay>0 AND @AdjustedDay=0)
--BEGIN
--UPDATE [dbo].[Emp_Attendance] SET IsWithOutPay=1 WHERE InTime BETWEEN @FROMDATE AND @TODATE
--END

--IF(@UnAdjustedDay>0)

--BEGIN
--IF(@LeaveWithPay > 0)
--BEGIN
--UPDATE [dbo].[Emp_Attendance] SET IsWithPay=1 WHERE InTime BETWEEN @FROMDATE AND @TODATE
--END
--IF(@LeaveWithOutPay> 0)