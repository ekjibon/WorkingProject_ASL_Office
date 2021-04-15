/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UpdateEmpModifyAttdance]'))
BEGIN
DROP PROCEDURE  [UpdateEmpModifyAttdance]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		ARIFUR
-- Create date: 
-- Description:	
-- =============================================

CREATE PROCEDURE [dbo].[UpdateEmpModifyAttdance] 

  @Block INT = 0,
  @AttendId INT,
  @RequestId INT,
  @UpdateBy VARCHAR(MAX),
  @EmpId INT,
  @FromDate VARCHAR(MAX),
  @Reason VARCHAR(MAX)

AS
BEGIN

   DECLARE @IsChangedStatus BIT,@IsPrrApp BIT,@ReqId INT = 0

   SELECT @ReqId = RequestId, @IsPrrApp=IsPriApproved FROM [dbo].[Emp_Attendance] WHERE AttendId=@AttendId
	IF(@Block = 1)  --  Admin Request
	BEGIN
	IF(@AttendId > 0)
		BEGIN
			UPDATE [dbo].[Emp_Attendance]
			SET 
			 [RequestId]=@RequestId,
			 UpdateBy =@UpdateBy,
			 UpdateDate= GETDATE(),
			 IsChangedStatus = 1
			 WHERE AttendId=@AttendId
		END
	END

	IF(@Block = 2)  --  Employee  Request
	BEGIN
	IF(@AttendId > 0)
		BEGIN
			UPDATE [dbo].[Emp_Attendance]
			SET 
			 [EmpRequestId]=@RequestId,
			 UpdateBy =@UpdateBy,
			 UpdateDate= GETDATE(),
			 [Reason] = @Reason
			 --IsChangedStatus = 1
			 WHERE AttendId=@AttendId
		END
	END
	IF(@Block = 3)  --  Employee  Request
	BEGIN
	IF(@AttendId > 0)
		BEGIN
		DECLARE @IsLate BIT = 0,@IsEarlyOut BIT = 0,@IsAbsent BIT = 0,@IsLeave BIT = 0
		SELECT @IsLate=IsLate,@IsEarlyOut =  IsEarlyout,@IsAbsent = IsAbsent,@IsLeave =  IsLeave
				FROM dbo.Emp_EmpLeaveModify WHERE Id = @ReqId AND IsDeleted = 0 AND IsNoAction = 0

				IF(@IsLate=1) -- Update Late In As Not Late
				BEGIN
					UPDATE [dbo].[Emp_Attendance]
						SET 	
							UpdateBy =@UpdateBy,
							UpdateDate= GETDATE(),					
							[FinalStatus] = @Reason,
							[IsLate] = 0,
							IsApproved = 1
					WHERE AttendId=@AttendId
				END
				IF(@IsEarlyOut=1) -- Update Early Out As Not Early Out
				BEGIN
					UPDATE [dbo].[Emp_Attendance]
						SET 	
							UpdateBy =@UpdateBy,
							UpdateDate= GETDATE(),					
							[FinalStatus] = @Reason,
							[IsEarlyOut] = 0,
							IsApproved = 1
					WHERE AttendId=@AttendId
				END
			IF(@IsAbsent=1) -- Update Absent As Present
				BEGIN
					UPDATE [dbo].[Emp_Attendance]
						SET 	
							UpdateBy =@UpdateBy,
							UpdateDate= GETDATE(),					
							[FinalStatus] = @Reason,
							IsPresent = 1,
							IsApproved = 1
					WHERE AttendId=@AttendId
				END
				IF(@IsLeave=1) -- Update Leave As Present
				BEGIN
					UPDATE [dbo].[Emp_Attendance]
						SET 	
							UpdateBy =@UpdateBy,
							UpdateDate= GETDATE(),					
							[FinalStatus] = @Reason,
							IsPresent = 1,
							IsLeave = 0,
							IsApproved = 1
					WHERE AttendId=@AttendId
				END
		END
	END
	SELECT @@ROWCOUNT AS TotalRows

END
--SELECT * FROM [dbo].[Emp_EmpLeaveModify]