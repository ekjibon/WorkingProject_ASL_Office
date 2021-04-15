--select * from Emp_LeaveType
--select * from HR_LeaveCategory
--select * from HR_LeaveApplication
--select * from HR_LeaveQuota
--select * from Att_LeaveTypes
--select distinct * from HR_EmpLeaveQuota


--select * from Att_EmpAcademicCalendar

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[EmpLeaveDetails]'))
BEGIN
DROP PROCEDURE  [EmpLeaveDetails]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
-- execute [dbo].[EmpLeaveDetails] 13
CREATE PROCEDURE [dbo].[EmpLeaveDetails]	 
	@EmpId INT	
AS
BEGIN
	DECLARE @totalLeave INT, @CostLeave INT, @applyedLeave INT;

SELECT TOP(1) @totalLeave = AnnualLeaveDay +SickLeaveDay + AdvanceLeaveDay + MaternityLeaveDay  FROM HR_EmpLeaveQuota WHERE EmpId = @EmpId AND IsDeleted = 0 ORDER BY EmpLeaveQuotaId DESC
PRINT @totalLeave


SELECT @applyedLeave =  COUNT(TotalDays) FROM HR_LeaveApplication WHERE IsDeleted = 0 AND EmpId = @EmpId 
PRINT @applyedLeave

SELECT @EmpId AS EmpId, @totalLeave AS TotalLeave, @applyedLeave AS ApplyedLeave, (@totalLeave-@applyedLeave) AS DueLeave
		  
END