
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptEmpIndividualAttendance]'))
BEGIN
DROP PROCEDURE  [rptEmpIndividualAttendance]
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
-- execute [dbo].[rptEmpIndividualAttendance] 9,'2021-01-01','2021-01-31'
CREATE PROCEDURE [dbo].[rptEmpIndividualAttendance]
	 
	@EmpId INT,			
    @FromDate VARCHAR(MAX),
    @ToDate VARCHAR(MAX)
	
AS
BEGIN
DECLARE @total_sec INT
DECLARE @total_min INT

CREATE TABLE #TempOT
(
	EmpId INT,
	CalendarDate DATETIME,
    Ot DATETIME,
	TWH INT NULL
) 
 INSERT INTO #TempOT (EmpId,CalendarDate,Ot,TWH)
 SELECT EB.EmpBasicInfoID,EA.InTime,(CASE WHEN  CAST(OfficeOutTime AS TIME) < CAST(EA.OutTime AS TIME) THEN CAST(DATEADD(SECOND, DATEDIFF(SECOND, CAST(OfficeOutTime AS TIME), CAST(EA.OutTime AS TIME)), 0) AS TIME)ELSE '' END) ,DATEDIFF(Minute,EA.InTime,EA.OutTime)
FROM Emp_BasicInfo EB 
INNER  JOIN Emp_Attendance EA ON EB.EmpBasicInfoID = EA.EmpId 
WHERE EA.EmpId = @EmpId AND CAST(EA.InTime AS DATE) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE) 
--GROUP BY EB.EmpBasicInfoID,EA.OutTime,EA.InTime,EA.InTime,EA.DefaultEarlyOutTime
--SELECT * FROM  #TempOT
SELECT  @total_sec = SUM(( DATEPART(hh, Ot) * 3600 ) +
                          ( DATEPART(mi, Ot) * 60 ) +
                            DATEPART(ss, Ot)),
		@total_min = SUM(TWH)
FROM   #TempOT

PRINT @total_sec
PRINT @total_min

SELECT DISTINCT [EmpID], IsPresent, IsLeave, [IsLate], [IsEarlyOut],IsWithPay,IsWithOutPay,IsHalfDay,IsAbsetLongHoliday, Convert(DATE,[InTime]) AS [InTime],IsPriApproved,IsChangedStatus,IsApproved ,Status,DayType INTO #Att_Attendance1 FROM [dbo].[Emp_Attendance] 
            WHERE  CONVERT(DATE,InTime) BETWEEN CONVERT(DATE,@FromDate) AND CONVERT(DATE,@ToDate) AND IsDeleted=0

SELECT EB.EmpBasicInfoID,EB.EmpID,EB.FullName,EB.JoiningDate,EB.ConfirmationDate, CAST(EA.InTime AS DATE) CalendarDate,FORMAT( EA.InTime,'dddd') AS DayName, 
EA.DayType, ED.DepartmentName, EDE.DesignationName, CAST(@FromDate AS DATE) AS FromDate, CAST(@ToDate AS DATE) AS ToDate,
--(EA.FinalStatus + '(' + EA.AdminStatus + ')') AS FinalStatus, 
EA.Reason AS EmpRequestReason,EA.FinalStatus AS AdminStatus, 
CASE
WHEN EA.IsChangedStatus =1 AND EA.IsApproved=0 AND EA.IsRejected =0 THEN 'Pending'
WHEN EA.IsChangedStatus =1 AND EA.IsApproved=1 AND EA.IsRejected =0 THEN 'Approved'
WHEN EA.IsChangedStatus =1 AND EA.IsApproved=0 AND EA.IsRejected=1 THEN 'Rejected'
END
AS FinalStatus,

CASE
WHEN EA.IsApproved=1 AND EA.IsChangedStatus=1 THEN EA.InTime 
WHEN EA.IsApproved=0 AND EA.IsChangedStatus=0 THEN EA.InTime
WHEN EA.IsPresent = 1 AND LEFT(CAST(EA.InTime AS TIME),2)>0 THEN EA.InTime
END
AS InTime
,EA.OutTime,EA.IsPresent,EA.IsChangedStatus, EA.IsLate,EA.IsEarlyOut,
						 [dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TD') AS TotalDays,
						 [dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TP') AS Present,
						 [dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TL') AS Leave,
						 [dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'THL') AS Halfday,
						 [dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'Late') AS Late,
						 [dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'EarlyOut') AS EarlyLeave,
						 CASE WHEN [dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TA')<0 THEN 0 ELSE [dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TA') END AS Absent,
						 [dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TH') AS Holiday,
						ISNULL([dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TWPSL'),0) AS WithPaySickLeave,
						ISNULL([dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TWOPSL'),0) AS WithOutPaySickLeave,
						ISNULL([dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TWPML'),0) AS WithPayMeternityLeave,
						ISNULL([dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TWOPML'),0) AS WithOutPayMeternityLeave,
						ISNULL([dbo].[Func_AttendanceStatus]( @EmpId, @FromDate, @ToDate, 'TWPAL'),0) AS WithPayAnualLeave
  , EA.SoftwareResult,
 ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=EB.EmpBasicInfoID AND  DayType= 'Regular' GROUP BY EmpId),0) AS WorkingDays,

(CASE
WHEN EA.IsApproved=1 AND EA.IsChangedStatus=1 THEN CD.Text
END
)AS Remarks
,CAST(EA.OfficeOutTime AS DATETIME) AS SignIntime, CAST(EA.OfficeOutTime AS DATETIME) AS SignOuttime,
( CASE WHEN (DATEPART(hh,OT.Ot)>0) THEN CAST(DATEPART(hh,OT.Ot) AS nvarchar(100)) + ' H '
ELSE '00 H ' END
+CASE WHEN (DATEPART(mi,OT.Ot)>0 )THEN CAST((DATEPART(mi,OT.Ot)) AS nvarchar(100)) + ' M'
ELSE '00 M' END) AS OT
,
(CASE WHEN @total_sec >0 THEN CAST(@total_sec/3600 AS nvarchar(100)) + ' H '
ELSE '00 H ' END 
+CASE WHEN (@total_sec >0 )THEN CAST(((@total_sec/60)-((@total_sec/3600)*60)) AS nvarchar(100)) + ' M'
ELSE '00 M' END ) ToTalOT,  
CASE
	WHEN EA.OutTime IS NULL THEN ''
	ELSE CONCAT((DATEDIFF(Minute,EA.InTime,EA.OutTime)/60),' H ',   (DATEDIFF(Minute,EA.InTime,EA.OutTime)%60), ' M' )
END AS WorkingHour,
CONCAT((@total_min/60),' H ',   (@total_min%60), ' M' ) AS TotalWorkingHour,
GETDATE() AS PrintTime,EA.IsLeave,EMA.Title AS AdminRequest,EmpR.Title AS EmpRequest
FROM Emp_BasicInfo EB 
LEFT JOIN Emp_Attendance EA ON EB.EmpBasicInfoID = EA.EmpId 
INNER JOIN #TempOT OT ON OT.EmpId = EA.EmpId AND CAST(OT.CalendarDate AS DATE) = CAST(EA.InTime AS DATE)
LEFT JOIN Common_DropDownConfig CD ON CD.Type = 'PresentEmployee' AND CD.Value = EA.Status
INNER JOIN Emp_Department ED ON EB.DepartmentID = ED.DepartmentID
INNER JOIN Emp_Designation EDE ON EB.DesignationID = EDE.DesignationID 
LEFT JOIN  [dbo].[Emp_EmpLeaveModify] EMA ON EMA.Id =  EA.RequestId
LEFT JOIN  [dbo].[Emp_EmpLeaveModify] EmpR ON EmpR.Id =  EA.EmpRequestId
WHERE EA.EmpId = @EmpId AND CAST(EA.InTime AS DATE) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE) 
--GROUP BY EB.EmpBasicInfoID,EB.EmpID,EB.FullName,CAST(EA.InTime AS DATE),EA.InTime,EA.OutTime,EB.JoiningDate,EB.ConfirmationDate,EA.IsLate,EA.IsEarlyOut,EA.IsHalfDay,EB.CategoryID,OT.Ot,CD.Text,ea.IsApproved,EA.IsChangedStatus,EA.IsPresent, EA.IsLate,EA.DefaultLateInTime,EA.DefaultEarlyOutTime

DROP TABLE #TempOT


SELECT LC.CategoryName,LRD.LeaveCategoryId, SUM(LRD.EligibleLeave) AS EligibleLeave,SUM(LRD.LeaveAvailable) AS LeaveAvailable,SUM(LRD.LeaveInHand) AS LeaveInHand,
SUM(LRD.AdjustLeave) AS AdjustLeave,SUM(LRD.WithPayLeave) AS WithPayLeave,SUM(LRD.WithoutPayLeave) AS WithoutPayLeave
FROM HR_LeaveRequestDetails LRD JOIN HR_LeaveCategory LC ON LRD.LeaveCategoryId = LC.Id
WHERE   EmpId = @EmpId AND CAST(LRD.AddDate AS DATE) BETWEEN CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE) 
GROUP BY LeaveCategoryId , LC.CategoryName
		  
END