/****** Object:  StoredProcedure [dbo].[GetInstutionSetup]    Script Date: 7/22/2017 4:32:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetRenainingUnadjustedLeave]'))
BEGIN
DROP FUNCTION  GetRenainingUnadjustedLeave
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- SELECT dbo.GetRenainingUnadjustedLeave(50,1002,'Opening')

CREATE FUNCTION [dbo].[GetRenainingUnadjustedLeave]
(	
	@EmpId INT
	
)
RETURNS  DECIMAL(18,2)
AS
BEGIN
	DECLARE @Value DECIMAL(18,2)

	DECLARE @TempTotalConsumed TABLE (Duration DECIMAL(18,2))
	INSERT INTO @TempTotalConsumed(Duration)
	SELECT SUM(Duration) AS TotalConsumed FROM Emp_Request WHERE EmpId = @EmpId AND Status = 'Approved' AND IsDeleted = 0
	
	
	DECLARE @TempTotalLeaveCount TABLE (AnnualLeaveDay INT, AdvanceLeaveDay INT, SickLeaveDay INT, MaternityLeaveDay INT, TotalLeaveCount INT)
	INSERT INTO @TempTotalLeaveCount(AnnualLeaveDay, AdvanceLeaveDay, SickLeaveDay, MaternityLeaveDay, TotalLeaveCount)
	SELECT AnnualLeaveDay, AdvanceLeaveDay, SickLeaveDay, MaternityLeaveDay, (AnnualLeaveDay+ AdvanceLeaveDay+ SickLeaveDay+ MaternityLeaveDay) AS TotalLeaveCount  FROM HR_EmpLeaveQuota where EmpId = @EmpId
	
	SET @Value = (SELECT TotalLeaveCount FROM @TempTotalLeaveCount) - (SELECT Duration FROM @TempTotalConsumed)
	
	RETURN @Value

END
GO


