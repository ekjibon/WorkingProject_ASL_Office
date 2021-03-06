IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptAttendance]'))
BEGIN
DROP PROCEDURE  [rptAttendance]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Kawsar
-- Create date: 
-- Description:	
-- =============================================
--VersionID	SessionId	BranchID	ShiftID	ClassId	GroupId	SectionId
--1	6	1	1	1	0	3
-- execute [dbo].[rptAttendance] 0, 10, 0,0,0,0,'2021-02-01','2021-02-25',NULL,14
CREATE PROCEDURE [dbo].[rptAttendance] 
	@SessionId INT,
	@BranchId INT = NULL,
	@ShiftId INT =NULL,
	@ClassId INT = NULL,
	@SectionId INT = NULL,
	@PeriodId INT = NULL,
	@FromDate SMALLDATETIME=NULL,
	@ToDate SMALLDATETIME=NULL,
	@DepartmentID int = 0,
	@BlockNo INT
AS
BEGIN



	IF(@BlockNo=14)   -- execute [dbo].[rptAttendance] 0, 56, 0,0,0,0,'01/03/2021 12:00:00 AM','01/03/2021 12:00:00 AM',4,14
	BEGIN

	SELECT EA.EmpId, EB.EmpID AS EmployeeID,EB.FullName,D.DepartmentName,BR.BranchName,AttendId,CAST(@FromDate AS DATE) AS HeaderDate,
			(CASE
				WHEN EA.IsApproved=1 AND EA.IsChangedStatus=1 THEN InTime
				WHEN EA.IsApproved=0 AND EA.IsChangedStatus=0 THEN InTime
				WHEN EA.IsPresent=1 THEN InTime
			END)
			AS Intime
			,OutTime,IsPresent,EA.IsLeave,EA.IsLate,LeaveId,EA.IsEarlyOut,EarlyOutTime,Device_CardNo,Device_SerialNo,Device_UserID
			,EntryType,EA.IsDeleted,EA.AddBy,EA.AddDate,EA.UpdateBy,EA.UpdateDate,EA.UpdatedStatus,EA.IsPriApproved,EA.IsFinalApproved,EA.IsChangedStatus
			,EA.IsApproved,EA.IsRejected,EA.IsWithPay,EA.IsWithOutPay,EA.IsHalfDay,EA.IsAbsetLongHoliday,EA.IsDutyOff,EA.IsECAabsent,EA.IsEarlyOut5Years,EA.IsPresentInHoliday,EA.IsPriReject
			,DATENAME(WEEKDAY,EA.InTime) AS [DayName]
			,CASE
				WHEN EA.OutTime IS NULL THEN ''
				ELSE CONCAT((DATEDIFF(Minute,EA.InTime,EA.OutTime)/60),' H ', (DATEDIFF(Minute,EA.InTime,EA.OutTime)%60), ' M' )
				END AS WorkingHour
			,(CASE WHEN EA.AttendId IS NULL THEN 1 ELSE 0 END ) AS IsAbsent,
			(CASE WHEN EA.IsApproved = 1 AND EA.IsChangedStatus=1 AND IsRejected = 0 THEN CD.Text  ELSE '' END) AS Remarks,
			EA.Reason AS EmpRequestReason,EA.FinalStatus AS AdminStatus, 
			CASE
			WHEN EA.IsChangedStatus =1 AND EA.IsApproved=0 AND EA.IsRejected =0 THEN 'Pending'
			WHEN EA.IsChangedStatus =1 AND EA.IsApproved=1 AND EA.IsRejected =0 THEN 'Approved'
			WHEN EA.IsChangedStatus =1 AND EA.IsApproved=0 AND EA.IsRejected=1 THEN 'Rejected'
			END
			AS FinalStatus,
			ELM.Title AS RequestReason, EA.SoftwareResult,
			GETDATE() AS PrintDate
	FROM  [dbo].[Emp_Attendance] EA 
					INNER JOIN Emp_BasicInfo EB ON EB.EmpBasicInfoID = EA.EmpId AND CAST(EA.InTime AS DATE) between CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE)
					INNER JOIN dbo.Ins_Branch BR ON BR.BranchId =  EB.BranchID
					INNER JOIN dbo.Emp_Department D ON D.DepartmentID =  EB.DepartmentID
					INNER JOIN dbo.Emp_Designation DEG ON DEG.DesignationID =  EB.DesignationID
					LEFT JOIN Common_DropDownConfig CD ON CD.Type = 'PresentEmployee' AND CD.Value = EA.Status
					LEFT JOIN Emp_EmpLeaveModify ELM ON ELM.Id = EA.RequestId
	WHERE EB.Status = 'A' AND EB.BranchID = @BranchId AND EB.DepartmentID = CASE WHEN @DepartmentID<>0 THEN @DepartmentID ELSE EB.DepartmentID END
	ORDER BY BR.DisOrder ASC,D.DisOrder ASC,EB.EmpID ASC, DEG.DesignationOrder ASC

	END

	
END


