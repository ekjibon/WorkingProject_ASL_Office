IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptEMPAttendanceSummary]'))
BEGIN
DROP PROCEDURE  [rptEMPAttendanceSummary]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Azmal
-- Create date: 5/2/2020
-- Description:	
-- =============================================
-- rptEMPAttendanceSummary   10,  '2021-02-01','2021-02-18',0
CREATE PROCEDURE [dbo].[rptEMPAttendanceSummary]     
	@BranchID int,
	@FromDate nvarchar(max)=null,
	@ToDate nvarchar(max)=null,
	@DepartmentID int = 0
	
AS
BEGIN

	 SELECT DISTINCT [EmpID], IsPresent, IsLeave, [IsLate], [IsEarlyOut],IsWithPay,IsWithOutPay,IsHalfDay,IsAbsetLongHoliday, Convert(DATE,[InTime]) AS [InTime],IsPriApproved,IsChangedStatus,IsApproved ,Status,DayType INTO #Att_Attendance1 FROM [dbo].[Emp_Attendance] 
            WHERE  CONVERT(DATE,InTime) BETWEEN CONVERT(DATE,@FromDate) AND CONVERT(DATE,@ToDate) AND IsDeleted=0 --AND ISNULL(IsPriReject,0)	=0
			
			SELECT * FROM
			(SELECT DISTINCT B.EmpBasicInfoID,B.EmpID,D.DisOrder AS DeptDisOrder,Br.DisOrder AS BRDisOrder,DEG.DesignationOrder, B.EmpID EmployeeID ,B.FullName, Br.BranchName, D.DepartmentName,
			ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND  DayType= 'Regular' GROUP BY EmpId),0) AS WorkingDays,
			ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND ((IsPresent=1) OR (IsPriApproved=1 AND IsChangedStatus=1 AND IsApproved=1 AND IsPresent=0)) GROUP BY EmpId),0) AS [PresentDay], 
	        ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsLeave=1 GROUP BY EmpId),0) AS [LeaveDay],
			ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsPresent= 0 AND IsLeave = 0 AND DayType= 'Regular' GROUP BY EmpId),0) AS [AbsentDay],
			ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsLate=1 GROUP BY EmpId),0) AS [LateDay],
			ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsEarlyOut=1 GROUP BY EmpId),0) AS [EarlyOutDay],
			ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsWithPay=1 GROUP BY EmpId),0) AS [WithPayDay],
			ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsWithOutPay=1 GROUP BY EmpId),0) AS [WithOutPayDay],
			ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsHalfDay=1 GROUP BY EmpId),0) AS [HalfDay],
			ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND IsAbsetLongHoliday=1 GROUP BY EmpId),0) AS [AbsentLongHoliyDay],
			CASE 
			WHEN (CAST(ISNULL((100*ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND  ((IsPresent=1) OR (IsPriApproved=1 AND IsChangedStatus=1 AND IsApproved=1 AND IsPresent=0 AND Status<>'2'))  GROUP BY EmpId),0)/ ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND  DayType= 'Regular' GROUP BY EmpId),0)),0)AS DECIMAL) > 100 )
				THEN 100
			ELSE
				CAST(ISNULL((100*ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND  ((IsPresent=1) OR (IsPriApproved=1 AND IsChangedStatus=1 AND IsApproved=1 AND IsPresent=0 AND Status<>'2'))  GROUP BY EmpId),0)/ ISNULL((SELECT ISNULL(COUNT(DISTINCT InTime),0) FROM #Att_Attendance1 WHERE EmpId=B.EmpBasicInfoID AND  DayType= 'Regular' GROUP BY EmpId),0)),0)AS DECIMAL)
			END
			 AS [Percentage],
			Convert(nvarchar(15), cast(@FromDate as Date),106) FromDate,Convert(nvarchar(15), cast(@ToDate as Date),106) ToDate,GETDATE() AS PrintTime
			FROM Emp_BasicInfo AS B 
			INNER JOIN Emp_Attendance EA ON  B.EmpBasicInfoID = EA.EmpId AND B.BranchID = @BranchId
	        INNER JOIN dbo.Ins_Branch Br ON Br.BranchId = B.BranchID
			INNER JOIN dbo.Emp_Department D ON D.DepartmentID = B.DepartmentID
			INNER JOIN dbo.Emp_Designation DEG ON DEG.DesignationID = B.DesignationID
	        WHERE (CAST(EA.InTime as date)) BETWEEN  (CAST(@FromDate AS date)) AND (CAST(@ToDate AS date)) 
			AND B.BranchID = @BranchId AND B.DepartmentID = CASE WHEN @DepartmentID<>0 THEN @DepartmentID ELSE B.DepartmentID END AND B.Status='A'
			)T
			WHERE WorkingDays>0
			ORDER BY T.BRDisOrder,T.DeptDisOrder,T.EmpID,T.DesignationOrder ASC

			 DROP TABLE #Att_Attendance1

END
