/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UpdateModifyEmpAttdance]'))
BEGIN
DROP PROCEDURE  [UpdateModifyEmpAttdance]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		KHALED
-- Create date: 
-- Description:	
-- =============================================

CREATE PROCEDURE [dbo].[UpdateModifyEmpAttdance] 
  @AttendId INT,
  @Status VARCHAR(12),
  @UpdateBy VARCHAR(MAX),
  @EmpId INT,
  @FromDate VARCHAR(MAX)

AS
BEGIN

   DECLARE @IsChangedStatus BIT,@IsPrrApp BIT

   SELECT @IsChangedStatus = IsChangedStatus, @IsPrrApp=IsPriApproved FROM [dbo].[Emp_Attendance] WHERE AttendId=@AttendId
		 
IF(@IsPrrApp = 1)
BEGIN     --- Modify Attendance Approval

 IF(@Status = '1') --Present
 BEGIN
	UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 IsPresent =1,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
 END
  ELSE IF (@Status = '2') --Absent
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 IsPresent =0,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END

   ELSE IF (@Status = '3') --Present In Holiday
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 IsPresent =1,
	 IsPresentInHoliday = 1,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END

    ELSE IF (@Status = '4') --Late In
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 IsLate =1,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END

    ELSE IF (@Status = '5') --Not Late
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 IsLate = 0,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END

     ELSE IF (@Status = '6') --Early Leave
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	 IsEarlyOut = 1,
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END

      ELSE IF (@Status = '7')  --Not Early Leave
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 IsEarlyOut = 0,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END

      ELSE IF (@Status = '8') --for Early Leave for 5 + Years Privilege
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 IsEarlyOut5Years = 1,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END

       ELSE IF (@Status = '9') --Not Early Leave for 5 + Years Privilege
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 IsEarlyOut = 0,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END

        ELSE IF (@Status = '10') --ECA Absent
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	-- IsLate = 0,
	IsECAabsent=1,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END

         ELSE IF (@Status = '11') --Not ECA Absent
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	-- IsPresent = 0,
	IsECAabsent=0,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
          ELSE IF (@Status = '12') --Half Day Leave
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	
	 IsHalfDay = 1,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
          ELSE IF (@Status = '13') --Not Half Day Leave
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	
	 IsHalfDay = 0,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
          ELSE IF (@Status = '14') --Leave
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 IsLeave = 1,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
          ELSE IF (@Status = '15') --Duty Off
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 IsDutyOff =1,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
          ELSE IF (@Status = '16') --Late In + Early Leave
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 IsLate = 1,
	 IsEarlyOut = 1,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
          ELSE IF (@Status = '17') --Not Late + Not Early Leave
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 IsLate = 0,
	 IsEarlyOut = 0,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
          ELSE IF (@Status = '18') --Late In + Half Day Leave
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 IsLate = 1,
	 IsHalfDay = 1,
	-- IsPresent = 0,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
          ELSE IF (@Status = '19') --Not Late + Not Half Day Leave
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 IsLate = 0,
	 IsHalfDay = 0,
	-- IsPresent = 0,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
          ELSE IF (@Status = '20') --Outside Visit
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
          ELSE IF (@Status = '21') --Outside Visit + Half Day Leave
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	IsHalfDay=1,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
          ELSE IF (@Status = '22') --Half Day Leave + Early Leave
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	-- IsPresent = 0,
	IsHalfDay = 1,
	IsEarlyOut = 1,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
          ELSE IF (@Status = '23') --Not Half Day Leave + Not Early Leave
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	-- IsPresent = 0,
	 IsHalfDay = 0,
	 IsEarlyOut = 0,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
          ELSE IF (@Status = '24') --Half Day Leave + ECA Absent
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	-- IsPresent = 0,
	IsECAabsent=1,
	 IsHalfDay = 1,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
          ELSE IF (@Status = '25') --Not Half Day Leave + Not ECA Absent
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	-- IsPresent = 0,
	IsHalfDay = 0,
	IsECAabsent=0,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
          ELSE IF (@Status = '40') --ECA Absent + Early Leave
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	-- IsPresent = 0,
	IsECAabsent=1,
	IsEarlyOut=1,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
          ELSE IF (@Status = '26') --Not ECA Absent + Not Early Leave
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	-- IsPresent = 0,
	IsECAabsent=0,
	IsEarlyOut=0,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
          ELSE IF (@Status = '27') --Present+Late In
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 IsPresent = 1,
	 IsLate =1,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
          ELSE IF (@Status = '28') --Present+Half Day Leave
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 IsPresent = 1,
	 IsHalfDay = 1,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
          ELSE IF (@Status = '29') --Present+Early Leave
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	
	IsPresent = 1,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
          ELSE IF (@Status = '30') --Present+ECA Absent
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 
	IsPresent = 1,
	IsECAabsent=1,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
          ELSE IF (@Status = '31') --Present+Early Leave for 5+ Years Privilege
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 
	IsPresent=1,
	IsEarlyOut=1,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
          ELSE IF (@Status = '32') --Late In + Early Leave + ECA Absent
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 IsPresent = 1,
	IsLate=1,
	IsEarlyOut=1,
	IsECAabsent=1,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
          ELSE IF (@Status = '33') --Present+Late In+Early Leave
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 IsPresent = 1,
	 	IsLate=1,
	 IsEarlyOut=1,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
          ELSE IF (@Status = '34') --Present+Late In + Half Day Leave
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 IsPresent = 1,
	 IsLate =1,
	 IsHalfDay = 1,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
          ELSE IF (@Status = '35') --Present+Late In+ECA Absent
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
		 IsPresent = 1,
	 IsLate =1,
	 IsECAabsent=1,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
          ELSE IF (@Status = '36') --Present+Half Day Leave+Early Leave
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	IsPresent=1,
	IsEarlyOut=1,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
          ELSE IF (@Status = '37') --Present+Half Day Leave + ECA Absent
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 IsPresent = 1,
	 IsHalfDay = 1,
	 IsECAabsent=1,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
          ELSE IF (@Status = '38') --Present+Early Leave+ECA Absent
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
		IsPresent=1,
	 IsEarlyOut=1,
	 IsECAabsent=1,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END

           ELSE IF (@Status = '41') -- Absent after long holiday
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 IsAbsetLongHoliday=1,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
           ELSE IF (@Status = '42') --Leave (with pay)
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
     IsWithPay=1,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END
           ELSE IF (@Status = '43') --
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 IsWithOutPay=1,
	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END

         ELSE 
 BEGIN
     UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),

	 IsApproved = 1
	 WHERE AttendId=@AttendId
  
 END

END
ELSE
BEGIN
IF(@IsChangedStatus > 0)    --- Modify Attendance Update
BEGIN
	UPDATE [dbo].[Emp_Attendance]
	SET 
	-- [Status]=@Status,
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),	
	 IsPriApproved = 1
	 WHERE AttendId=@AttendId
END

ELSE    --- Modify Attendance Update
BEGIN
IF(@AttendId > 0)
BEGIN
	UPDATE [dbo].[Emp_Attendance]
	SET 
	 [Status]=@Status,
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 IsChangedStatus = 1
	 WHERE AttendId=@AttendId
END
ELSE
BEGIN
INSERT INTO [dbo].[Emp_Attendance]([EmpId], [InTime], [OutTime], [IsPresent], [IsLeave], [LeaveId], [IsLate], [LateTime], [IsEarlyOut], 
[EarlyOutTime], [Device_SerialNo], [Device_UserID], [Device_CardNo], [EntryType], [IsDeleted], [AddBy], [AddDate], [UpdateBy], [UpdateDate], [Remarks], [Status],
[IP], [MacAddress], [UpdatedStatus], [IsPriApproved], [IsFinalApproved], [IsChangedStatus], [IsApproved], [IsRejected], [IsWithPay], [IsWithOutPay], [IsHalfDay], [IsAbsetLongHoliday])
VALUES( @EmpId,CAST(@FromDate AS DATE),NULL,0,0,0,0,NULL,0,NULL,NULL,NULL,NULL,NULL,0,@UpdateBy,GETDATE(),NULL,NULL,NULL,@Status,NULL,NULL,NULL,0,0,1,0,0,0,0,0,0)
END
END

END



	SELECT @@ROWCOUNT AS TOTALLROWS
	return @@ROWCOUNT


	-- SELECT * FROM [dbo].[Emp_Attendance]

END