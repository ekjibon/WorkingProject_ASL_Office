/****** Object:  StoredProcedure [dbo].[GetLeaveRoutingConfigDetails]    Script Date: 08/01/2021 3:23:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetLeaveRoutingConfigDetails]'))
BEGIN
DROP PROCEDURE GetLeaveRoutingConfigDetails
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--- [dbo].[GetLeaveRoutingConfigDetails] 1, 1
CREATE PROCEDURE [dbo].[GetLeaveRoutingConfigDetails] 
(
	@Block INT = NULL,
	@RoutingId INT = NULL
)
AS
BEGIN
	IF(@Block=1)
	BEGIN
		SELECT RCD.*, AU.FullName AS EmpName FROM HR_LeaveRoutingConfigDetails RCD 
		LEFT JOIN AspNetUsers AU ON AU.Id = RCD.NextApproval
		WHERE RCD.RoutingId = @RoutingId AND RCD.IsDeleted = 0  
	END
END
