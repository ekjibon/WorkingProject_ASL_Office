IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SP_LeaveRoutingHistory'))
BEGIN
DROP PROCEDURE  SP_LeaveRoutingHistory
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
	-- SP_LeaveRoutingHistory 3158, '2016199','::1','B4-2E-99-6A-E3-17-'
CREATE PROCEDURE [dbo].SP_LeaveRoutingHistory
@LeaveId INT,
@AddBy VARCHAR(200),
@IP  VARCHAR(200),
@MacAddress VARCHAR(200)
AS
BEGIN 
		INSERT INTO HR_LeaveRoutingHistory (LeaveId,  RoutingId,  AddBy,  AddDate,   Status, IsDeleted, IP, MacAddress, IsApprove) 
		SELECT @LeaveId, LD.DetailsId, @AddBy, GETDATE(), 'A',    0,         @IP, @MacAddress, 0	
	    FROM Emp_Request ER
	   	   INNER JOIN HR_EmpLeaveQuota LQ ON LQ.EmpId = ER.EmpId
	    INNER JOIN HR_LeaveRoutingConfigDetails LD ON LD.RoutingId = LQ.RoutingId
	    WHERE ER.Id = @LeaveId AND LD.IsDeleted = 0

		SELECT Email = STUFF((
         SELECT ',' + AU.Email 
            FROM Emp_Request ER 
		INNER JOIN HR_EmpLeaveQuota  LQ ON LQ.EmpId = ER.EmpId
	    INNER JOIN HR_LeaveRoutingConfigDetails LD ON LD.RoutingId = LQ.RoutingId
		INNER JOIN AspNetUsers AU ON AU.Id = LD.NextApproval
		WHERE ER.Id = @LeaveId
            FOR XML PATH('')
         ), 1, 1, '')
END  

