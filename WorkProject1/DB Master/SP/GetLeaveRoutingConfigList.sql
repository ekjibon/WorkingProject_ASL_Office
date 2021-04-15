IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetLeaveRoutingConfigList]'))
BEGIN
DROP PROCEDURE  GetLeaveRoutingConfigList
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
 ---- [dbo].GetLeaveRoutingConfigList 
Create PROCEDURE [dbo].GetLeaveRoutingConfigList 

AS
BEGIN  
	--  GetLeaveRoutingConfigList 
	SELECT RC.*, DesignationName
	FROM HR_LeaveRoutingConfig RC
	INNER JOIN Emp_Designation ED ON ED.DesignationID = RC.DesignationId
	WHERE RC.IsDeleted = 0
	ORDER BY RC.RoutingId DESC
END
 
--SELECT TOP 5 * FROM HR_LeaveRoutingConfig ORDER By RoutingId DESC
