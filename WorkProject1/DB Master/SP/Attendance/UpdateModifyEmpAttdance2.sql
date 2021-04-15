/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[UpdateModifyEmpAttdance2]'))
BEGIN
DROP PROCEDURE  [UpdateModifyEmpAttdance2]
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
-- execute [dbo].[InsertEmployeeRoster] 19,1003,8,1,'17:15:44.4600000','17:15:44.4600000',''
CREATE PROCEDURE [dbo].[UpdateModifyEmpAttdance2] 
  @AttendId INT,
  @Status VARCHAR(12),
  @UpdateBy VARCHAR(MAX)

AS
BEGIN

   DECLARE @IsChangedStatus BIT

   SELECT @IsChangedStatus = IsChangedStatus FROM [dbo].[Emp_Attendance] WHERE AttendId=@AttendId
		 
IF(@IsChangedStatus>0)
BEGIN     --- Modify Attendance Approval
	UPDATE [dbo].[Emp_Attendance]
	SET 
	
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 IsApproved = 1
	 WHERE AttendId=@AttendId
END
ELSE     --- Modify Attendance Update
BEGIN
	UPDATE [dbo].[Emp_Attendance]
	SET 
	 [Status]=@Status,
	 UpdateBy =@UpdateBy,
	 UpdateDate= GETDATE(),
	 IsChangedStatus = 1
	 WHERE AttendId=@AttendId
END



	SELECT @@ROWCOUNT AS TOTALLROWS

	-- SELECT * FROM [dbo].[Emp_Attendance]

END



