IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rptEMPAttendanceDetails]'))
BEGIN
DROP PROCEDURE  [rptEMPAttendanceDetails]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Azmal
-- Create date: 5/3/2020
-- Description:	
-- =============================================
-- rptEMPAttendanceDetails   10,'2021-01-01 00:00:00.000','2021-01-15 00:00:00.000'
CREATE PROCEDURE [dbo].[rptEMPAttendanceDetails]     
	@BranchId INT = NULL,
	@FromDate SMALLDATETIME=NULL,
	@ToDate SMALLDATETIME=NULL

AS
BEGIN

	SELECT EA.EmpId,EB.EmpID AS EmployeeID,EB.FullName,D.DepartmentName,BR.BranchName
			,DATENAME(WEEKDAY,EA.InTime) AS [DayName],
			Convert(nvarchar(15), cast(@FromDate as Date),106) FromDate,
			Convert(nvarchar(15), cast(@ToDate as Date),106) ToDate,
			Convert(nvarchar(15), cast(EA.InTime as Date),103) CalendarDate
			,(
				CASE WHEN EA.InTime IS NOT NULL AND EA.OutTime IS NOT NULL THEN ISNULL(SUBSTRING(CAST(InTime AS NVARCHAR(100)), 13 ,7),'-')+' | '+ISNULL(SUBSTRING(CAST(OutTime AS NVARCHAR(100)), 13 ,7),'-') ELSE '' END 
			 ) AS INOUTTIME
			
			,CASE
				--WHEN EA.AttendId  IS NOT NULL AND [dbo].[EmpAttStatus]  (EA.EmpId,EA.InTime,'L') IS NOT NULL  THEN [dbo].[EmpAttStatus]  (EA.EmpId,EA.InTime,'L') 
				WHEN EA.AttendId IS NOT NULL AND [dbo].[EmpAttStatus]  (EA.EmpId,EA.InTime,'LI') IS NOT NULL THEN [dbo].[EmpAttStatus]  (EA.EmpId,EA.InTime,'LI') 
				WHEN EA.OutTime IS NULL AND DATENAME(WEEKDAY,EA.InTime) = 'Friday'  THEN 'Public Holiday' 
				WHEN EA.OutTime IS NULL AND EA.DayType = 'Weekend'  THEN 'Weekend' 
				WHEN EA.DayType = 'Regular' AND EA.IsPresent = 0  THEN 'Absent'
				ELSE 'Present'
				END AS AttendenceStatus
				,[dbo].[EmpAttStatus]  (EA.EmpId,EA.InTime,'EO') AS EarlyOut
				,[dbo].[EmpAttStatus]  (EA.EmpId,EA.InTime,'HDL') AS HalfDayLeave
	FROM  [dbo].[Emp_Attendance] EA --ON #TMP_DATES.EmpBasicInfoID= EA.EmpId AND CAST( DT AS DATE) = CAST( InTime AS DATE)
					INNER JOIN Emp_BasicInfo EB ON EB.EmpBasicInfoID = EA.EmpId AND CAST(EA.InTime AS DATE) between CAST(@FromDate AS DATE) AND CAST(@ToDate AS DATE)
					INNER JOIN dbo.Ins_Branch BR ON BR.BranchId =  EB.BranchID
					INNER JOIN dbo.Emp_Department D ON D.DepartmentID =  EB.DepartmentID
					INNER JOIN dbo.Emp_Designation DEG ON DEG.DesignationID =  EB.DesignationID

	WHERE EB.Status = 'A' AND EB.BranchID = @BranchId 
					--AND EB.EmpBasicInfoID = 24
	ORDER BY BR.DisOrder ASC,D.DisOrder ASC,EB.EmpID ASC, DEG.DesignationOrder ASC,EB.DisOrder ASC

END
