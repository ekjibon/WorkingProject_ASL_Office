IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DeleteORForfeitHoldRefund]'))
BEGIN
DROP PROCEDURE  DeleteORForfeitHoldRefund
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
	--- EXEC DeleteORForfeitHoldRefund 1002
CREATE PROCEDURE [dbo].[DeleteORForfeitHoldRefund]
(
@EmpId AS Int = 0,
@Block AS Int
)
AS

BEGIN
IF(@Block =1)
BEGIN
UPDATE HR_SalaryHoldRefund
SET IsDeleted = 1
WHERE EmpId = @EmpId	
END
IF(@Block =2)
BEGIN
UPDATE HR_SalaryHoldRefund
SET [Status] = 'Forfeit'
WHERE EmpId = @EmpId AND IsDeleted = 0	
END
END