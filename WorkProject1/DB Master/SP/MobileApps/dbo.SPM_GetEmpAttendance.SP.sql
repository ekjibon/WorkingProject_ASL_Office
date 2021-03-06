/****** Object:  StoredProcedure [dbo].[SP_GetEmpAllInfo]    Script Date: 11/18/2017 6:37:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SPM_GetEmpAttendance]'))
BEGIN
DROP PROCEDURE  SPM_GetEmpAttendance
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 --execute [dbo].[SPM_GetEmpAttendance] 55, '2021-02-01', '2021-02-25'
 --execute [dbo].[SPM_GetEmpAttendance] 55, '2021-02-01', '2021-02-28'
 
CREATE PROCEDURE [dbo].[SPM_GetEmpAttendance] 	
	@EmpId INT,			
    @FromDate VARCHAR(MAX),
    @ToDate VARCHAR(MAX)
AS
BEGIN

SELECT EB.EmpBasicInfoID,EB.EmpID,EB.FullName,EB.JoiningDate,
EA.InTime AS CalendarDate,FORMAT( EA.InTime,'dddd') AS DayName,EA.[DayType]
,
CASE
--WHEN EA.IsApproved=1 AND EA.IsChangedStatus=1 THEN EA.InTime 
WHEN EA.IsPresent=0  THEN NULL
WHEN EA.IsPresent=1  THEN EA.InTime
END
AS InTime,EA.OutTime,EA.IsPresent, EA.IsLate,EA.IsEarlyOut ,EA.IsLeave ,
CASE WHEN DATEDIFF(Minute, DATEADD(mi, DefaultLITime,   CAST(EA.OfficeInTime AS Time)),  CAST(EA.InTime AS Time) ) < 0 THEN 0 ELSE  DATEDIFF(Minute, DATEADD(mi, DefaultLITime,   CAST(EA.OfficeInTime AS Time)),  CAST(EA.InTime AS Time) )  END AS  LateTime,
CASE WHEN DATEDIFF(Minute,   CAST(EA.OutTime AS Time),  CAST(EA.OfficeOutTime AS Time) ) < 0 THEN 0 ELSE  DATEDIFF(Minute,  CAST(EA.OutTime AS Time),  CAST(EA.OfficeOutTime AS Time) )  END AS  EarlyOutTime,
						 [dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TD') AS TotalDays,
						 [dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TP') AS Present,
						 [dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TL') AS Leave,
						 [dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'THL') AS Halfday,
						 [dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'Late') AS Late,
						 [dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'EarlyOut') AS EarlyLeave,
						 [dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'LI_EA') AS Late_EarlyLeave,
						 CASE WHEN [dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TA')<0 THEN 0 ELSE [dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TA') END AS Absent,
						 [dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TH') AS Holiday,
						 [dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TW') AS Weekend,
						ISNULL([dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TWPSL'),0) AS WithPaySickLeave,
						ISNULL([dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TWOPSL'),0) AS WithOutPaySickLeave,
						ISNULL([dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TWPML'),0) AS WithPayMeternityLeave,
						ISNULL([dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TWOPML'),0) AS WithOutPayMeternityLeave,
						ISNULL([dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TWPAL'),0) AS WithPayAnualLeave,
						ISNULL([dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TWOPAL'),0) AS WithOutPayAnualLeave,
						ISNULL([dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TWPCL'),0) AS WithPayCasualLeave,
						ISNULL([dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TWOPCL'),0) AS WithOutPayCasualLeave,
(  CASE WHEN EA.IsLate=1 THEN 'Late'
	       WHEN EA.IsHalfDay = 1 THEN 'Half Day'
		   WHEN EA.IsEarlyOut =1 THEN 'Early Out'
		   ELSE '' END
 ) AS SoftwareResult
 ,(CASE
WHEN EA.IsApproved=1 AND EA.IsChangedStatus=1 THEN CD.Text
END
)AS Remarks
,CASE
	WHEN EA.OutTime IS NULL THEN ''
	ELSE CONCAT((DATEDIFF(Minute,EA.InTime,EA.OutTime)/60),' H ',   (DATEDIFF(Minute,EA.InTime,EA.OutTime)%60), ' M' )
END AS WorkingHour,
CONVERT(DECIMAL(7,2),(SELECT CONVERT(DECIMAL(7,2), ([dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TP') * 100 ) ) / CONVERT(DECIMAL(7,2), NULLIF(([dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TD')),0) ) ) )  AS PercentPersent,
CONVERT(DECIMAL(7,2),(SELECT CONVERT(DECIMAL(7,2), ([dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TH') * 100 ) ) / CONVERT(DECIMAL(7,2), NULLIF(([dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TD')),0) ) ) )  AS PercentHoliday,
CONVERT(DECIMAL(7,2),(SELECT CONVERT(DECIMAL(7,2), ([dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TA') * 100 ) ) / CONVERT(DECIMAL(7,2), NULLIF(([dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TD')),0) ) ) )  AS PercentAbsent,
CONVERT(DECIMAL(7,2),(SELECT CONVERT(DECIMAL(7,2), ([dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TW') * 100 ) ) / CONVERT(DECIMAL(7,2), NULLIF(([dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TD')),0) ) ) )  AS PercentWeekend,
EA.AttendId,EA.Reason,
CASE
WHEN EA.IsApproved=1 AND EA.IsChangedStatus=1 THEN 'Approved' 
WHEN EA.IsApproved=0  AND ISNULL(EA.IsPriReject,0)=0 AND ISNULL(EA.IsRejected,0)=0 AND EA.EmpRequestId IS NOT NULL AND EA.EmpRequestId <>0 THEN 'Pending'
WHEN (EA.IsPriReject=1 OR EA.IsRejected=1) AND EA.IsChangedStatus=1 THEN 'Rejected'
END
AS ApprovalStatus, EA.FinalStatus,EA.AdminStatus
FROM  Emp_Attendance EA
LEFT JOIN Emp_BasicInfo EB ON EA.EmpId = EB.EmpBasicInfoID 
LEFT JOIN Common_DropDownConfig CD ON CD.Type = 'PresentEmployee' AND CD.Value = EA.Status
WHERE EA.IsDeleted = 0 AND  CAST(EA.InTime AS DATE) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE) AND EA.EmpId = @EmpId
		  
END