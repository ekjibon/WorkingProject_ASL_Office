/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RejectModifyEmpAttdance]'))
BEGIN
DROP PROCEDURE  [RejectModifyEmpAttdance]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Khaled
-- Create date: 
-- Description:	
-- =============================================
-- execute [dbo].[RejectModifyEmpAttdance] 1809,'','NOOOOO',2019328
CREATE PROCEDURE [dbo].[RejectModifyEmpAttdance] 
  @AttendId INT,
  @Status VARCHAR(12),
  @Reason VARCHAR(MAX),
  @UpdateBy VARCHAR(MAX)

AS
BEGIN

   DECLARE @IsChangedStatus BIT,@IsPrrApp BIT

   SELECT @IsChangedStatus = IsChangedStatus,@IsPrrApp=IsPriApproved FROM [dbo].[Emp_Attendance] WHERE AttendId=@AttendId
		 
IF(@IsChangedStatus > 0)-- AND  @IsPrrApp > 0 )
BEGIN     --- Modify Attendance Approval
	UPDATE [dbo].[Emp_Attendance]
	SET 	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 [FinalStatus] = @Reason,
	 IsRejected = 1
	 WHERE AttendId=@AttendId
END
ELSE
BEGIN     --- Modify Attendance Approval
	UPDATE [dbo].[Emp_Attendance]
	SET 	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 [FinalStatus] = @Reason,
	 IsPriReject = 1
	 WHERE AttendId=@AttendId
END



	SELECT @@ROWCOUNT AS TOTALLROWS

	-- SELECT * FROM [dbo].[Emp_Attendance]

END