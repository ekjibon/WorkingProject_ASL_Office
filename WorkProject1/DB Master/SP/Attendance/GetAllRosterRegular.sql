
IF EXISTS (SELECT *  FROM   sys.objects WHERE  object_id = Object_id(N'GetAllRosterRegular')) 
  BEGIN 
      DROP PROCEDURE GetAllRosterRegular 
  END 
go 
SET ANSI_NULLS ON
GO 
SET QUOTED_IDENTIFIER ON
GO 

--GetAllRosterRegular

CREATE PROCEDURE GetAllRosterRegular  
(
 @Block INT,
 @FromDate VARCHAR(MAX),
 @ToDate VARCHAR(MAX),
 @BranchID INT = 0,
 @DepartmentID INT = 0,
 @EmpBasicInfoID INT = 0 
)
AS
BEGIN
IF(@Block=1) --- For Approval Roster List GetAllRosterRegular 1,'2019-09-24 00:00:00.000','2019-11-01 00:00:00.000'
  BEGIN 
  SELECT  ER.*
	        ,EB.EmpID AS EmployeeID
			,EB.FullName
			,EAC.EmpCategory
			,EC.CategoryName
			,B.BranchId
			,B.BranchName
			,EAC.StartDate
			,EACD.CalendarId
			,EAC.EndDate 
	FROM [dbo].[Att_EmpRoster] ER
	LEFT JOIN [dbo].[Emp_BasicInfo] EB ON EB.EmpBasicInfoID = ER.EmpId
	INNER JOIN [dbo].[Emp_Category] EC ON EC.CategoryID = EB.CategoryID
	INNER JOIN [dbo].[Ins_Branch] B ON B.BranchId = EB.BranchID
	INNER JOIN [dbo].[Att_EmpAcademicCalendar] EAC ON EAC.EmpCategory = EB.CategoryID
	INNER JOIN  [dbo].[Att_EmpAcademicCalendarDetails] EACD ON EACD.CalendarId = EAC.Id
	WHERE CAST(EAC.StartDate AS DATE) = CAST(@FromDate AS DATE) 
			AND CAST(EAC.EndDate AS DATE) = CAST(@ToDate AS DATE) 
  END
	
	IF(@Block=2) -- For Modify Attendance List  exec GetAllRosterRegular 2,'2021-02-28',null ,10,NULL,NULL
  BEGIN 
 
	SELECT 
	 CASE WHEN(EA.IsLate = 1 AND EA.IsEarlyOut =1) THEN 'Late and Early Leave'
	       WHEN(EA.IsLate = 1) THEN 'Late'
		   WHEN (EA.IsEarlyOut =1) THEN 'Early Leave'
		   WHEN (EA.IsLeave =1 AND EA.IsEarlyOut=1) THEN 'Half Day Leave'
		   WHEN (EA.IsLate = 1 AND EA.IsLeave =1 AND EA.IsEarlyOut=1) THEN 'Late and Half Day Leave'
	       ELSE 'Present'
	
	END AS LateStatus,
	CASE EA.IsLeave
    WHEN 1 THEN 'Leave'
    ELSE 'Not Leave'
	END AS LeaveStatus,
	CASE EA.IsEarlyOut
    WHEN 1 THEN 'Early Leave'
    ELSE 'Not Early Leave'
	END AS EarlyOutStatus,

	CAST(EA.InTime AS DATETIME) AS InTime,
	CAST(EA.OutTime AS DATETIME) AS OutTime
	,EB.EmpBasicInfoID
	,EB.EmpID  AS EmployeeID
	,EB.FullName 
	,EA.AttendId
	,EA.DayType
	,ECD.DayType AS OfficeDay
	, EA.RequestId
	,ELM.Title AS EmpRequest
	, EA.Reason
	,EA.FinalStatus
	,EA.SoftwareResult
	FROM [dbo].[Emp_Attendance] EA
    INNER JOIN [dbo].[Emp_BasicInfo] EB ON EB.EmpBasicInfoID =EA.EmpId 
	INNER JOIN dbo.Att_EmpAcademicCalendarDetails ECD ON ECD.Id =  EA.CalanderDetailsId
	LEFT JOIN [dbo].[Emp_EmpLeaveModify] ELM ON ELM.Id =  EA.EmpRequestId
	LEFT JOIN [dbo].[Emp_EmpLeaveModify] ELMD ON ELMD.Id =  EA.RequestId
	WHERE 
		CAST(EA.InTime AS DATE) = CAST(@FromDate AS DATE) 
		AND  EB.BranchID = CASE WHEN @BranchID<>0 THEN @BranchID ELSE EB.BranchID END
		AND  EB.DepartmentID = CASE WHEN @DepartmentId<>0 THEN @DepartmentId ELSE EB.DepartmentID END
		AND  EB.EmpBasicInfoID = CASE WHEN @EmpBasicInfoID<>0 THEN @EmpBasicInfoID ELSE EB.EmpBasicInfoID END
		AND IsChangedStatus = 0 AND IsPresent =1 
		ORDER BY EB.EmpID
			
  END
	
	IF(@Block=3) -- For ModifyAttendanceApproval  List  GetAllRosterRegular 3,'2021-02-18 00:00:00.000',null ,0,0,0
  BEGIN 

	  
  SELECT	
	 CASE WHEN(EA.IsLate = 1 AND EA.IsEarlyOut =1) THEN 'Late and Early Leave'
	       WHEN(EA.IsLate = 1) THEN 'Late'
		   WHEN (EA.IsEarlyOut =1) THEN 'Early Leave'
		   WHEN (EA.IsLeave =1 AND EA.IsEarlyOut=1) THEN 'Half Day Leave'
		   WHEN (EA.IsLate = 1 AND EA.IsLeave =1 AND EA.IsEarlyOut=1) THEN 'Late and Half Day Leave'
	       ELSE 'Present'
			END AS LateStatus,
			CASE EA.IsLeave
			WHEN 1 THEN 'Leave'
			ELSE 'Not Leave'
			END AS LeaveStatus,
			CASE EA.IsEarlyOut
			WHEN 1 THEN 'Early Out'
			ELSE 'Not Early Out'
			END AS EarlyOutStatus,
			CAST(EA.InTime AS datetime) InTime,
			CAST(EA.OutTime AS datetime) OutTime,
			EA.Status,
			EMA.Title AS AdminRequest,
			EmpR.Title AS EmpRequest
			,EA.AttendId
	        ,EB.EmpID AS EmployeeID
			,EB.FullName
	        ,CASE EA.IsApproved 
			WHEN 1 THEN 'Approved'
			ELSE 'Pending' END AS ApproveStatus
		    ,CASE EA.IsRejected
			WHEN 1 THEN 'Rejected'
			ELSE 'Pending' END AS RejecteStatus
			,EC.CategoryName
			,B.BranchId
			,B.BranchName
			,EA.Reason
			,EMA.Title
			,EA.FinalStatus
			,EA.SoftwareResult
	FROM [dbo].[Emp_Attendance] EA
	LEFT JOIN [dbo].[Emp_BasicInfo] EB ON EB.EmpBasicInfoID = EA.EmpId
	LEFT JOIN [dbo].[Emp_Category] EC ON EC.CategoryID = EB.CategoryID
	INNER JOIN [dbo].[Ins_Branch] B ON B.BranchId = EB.BranchID
	LEFT JOIN  [dbo].[Emp_EmpLeaveModify] EMA ON EMA.Id =  EA.RequestId
	LEFT JOIN  [dbo].[Emp_EmpLeaveModify] EmpR ON EmpR.Id =  EA.EmpRequestId

	WHERE CAST(EA.InTime AS DATE) = CAST(@FromDate AS DATE)
		AND  EB.BranchID = CASE WHEN @BranchID<>0 THEN @BranchID ELSE EB.BranchID END
		AND  EB.DepartmentID = CASE WHEN @DepartmentId<>0 THEN @DepartmentId ELSE EB.DepartmentID END
		AND  EB.EmpBasicInfoID = CASE WHEN @EmpBasicInfoID<>0 THEN @EmpBasicInfoID ELSE EB.EmpBasicInfoID END
		AND IsChangedStatus = 1    AND EB.Status = 'A' AND IsPresent =1
		ORDER BY EB.EmpID	
  END
  -- GetAllRosterRegular 4,'2020-8-31 00:00:00.000',null
  IF(@Block =4) 
  BEGIN
  SELECT
	 CASE WHEN(EA.IsLate = 1 AND EA.IsEarlyOut =1) THEN 'Late and Early Leave'
	      WHEN(EA.IsLate = 1) THEN 'Late'
		  WHEN (EA.IsEarlyOut =1) THEN 'Early Leave'
		  WHEN (EA.IsLeave =1 AND EA.IsEarlyOut=1) THEN 'Half Day Leave'
		  WHEN (EA.IsLate = 1 AND EA.IsLeave =1 AND EA.IsEarlyOut=1) THEN 'Late and Half Day Leave'
		  WHEN (EA.IsPresent = 0)  THEN 'Absent'
		  WHEN (EA.IsLeave = 1)  THEN 'Leave'
	      ELSE 'Present'
	END AS LateStatus,
	CASE EA.IsLeave
    WHEN 1 THEN 'Leave'
    ELSE 'Not Leave'
	END AS LeaveStatus,
	CASE EA.IsEarlyOut
    WHEN 1 THEN 'Early Out'
    ELSE 'Not Early Out'
	END AS EarlyOutStatus,
	CAST(EA.InTime AS DATETIME) AS InTime,
	CAST(EA.OutTime AS DATETIME) AS OutTime,
	 
	  --CASE  
	  --WHEN (EA.IsChangedStatus=0 AND EA.IsApproved=0) THEN 'Pending'
	  --WHEN (EA.IsChangedStatus=1 AND EA.IsApproved=1) THEN 'Approve'
	  --WHEN (EA.IsChangedStatus=1 AND EA.IsApproved=0) THEN 'Rejected'
	  --ELSE ''
	  	     CASE EA.IsApproved
			WHEN 1 THEN 'Approved'
			ELSE 'Pending' END AS ApproveStatus
			,CASE EA.IsRejected
			WHEN 1 THEN 'Rejected'
			ELSE 'Pending' END AS RejecteStatus,
	  CDD.Text,
	  EA.Status,
	  EA.AttendId,
	  EB.FullName,
	  EB.EmpID AS EmployeeID,
	  EA.SoftwareResult
	 FROM [dbo].[Emp_Attendance] EA
	 INNER JOIN dbo.Emp_BasicInfo EB ON EB.EmpBasicInfoID = EA.EmpId
	 LEFT JOIN  [dbo].[Common_DropDownConfig] CDD ON CDD.Type ='PresentEmployee' AND CDD.Value=EA.Status
	 WHERE CAST(EA.InTime AS DATE) = CAST(@FromDate AS DATE) 
		AND  EB.BranchID = CASE WHEN @BranchID<>0 THEN @BranchID ELSE EB.BranchID END
		AND  EB.DepartmentID = CASE WHEN @DepartmentId<>0 THEN @DepartmentId ELSE EB.DepartmentID END
		AND  EB.EmpBasicInfoID = CASE WHEN @EmpBasicInfoID<>0 THEN @EmpBasicInfoID ELSE EB.EmpBasicInfoID END
		AND IsChangedStatus = 1 AND IsPriApproved = 1 --AND IsApproved =1
		ORDER BY EB.EmpID
  END

  IF(@Block=5) -- For Modify Attendance Absent List  GetAllRosterRegular 5,'2021-02-25 00:00:00.000',null --Add By Khaled for absent list
  BEGIN 

  SELECT 'Absent' AS LateStatus,'',CAST(@FromDate AS DATE),NULL, EB.EmpBasicInfoID,
	 EB.EmpID  AS EmployeeID
	,EB.FullName
	,''
	,EA.AttendId
	,EA.DayType
	,ECD.DayType AS OfficeDay
	,EA.Reason
	,ELM.Title AS EmpRequest
	FROM  [dbo].[Emp_BasicInfo] EB
	INNER JOIN [dbo].[Emp_Attendance] EA  ON EB.EmpBasicInfoID =EA.EmpId AND CAST(EA.InTime AS DATE) = CAST(@FromDate AS DATE) 
	LEFT JOIN dbo.Att_EmpAcademicCalendarDetails ECD ON ECD.Id =  EA.CalanderDetailsId
	LEFT JOIN [dbo].[Emp_EmpLeaveModify] ELM ON ELM.Id =  EA.EmpRequestId

	WHERE --CAST(EA.InTime AS DATE) <> CAST('2020-12-15 09:54:58.000' AS DATE) 
	EA.AttendId NOT IN(SELECT AttendId FROM [Emp_Attendance] WHERE  CAST(EA.InTime AS DATE)BETWEEN CAST(@FromDate AS DATE) AND  CAST(@FromDate AS DATE))
		AND  EB.BranchID = CASE WHEN @BranchID<>0 THEN @BranchID ELSE EB.BranchID END
		AND  EB.DepartmentID = CASE WHEN @DepartmentId<>0 THEN @DepartmentId ELSE EB.DepartmentID END
		AND  EB.EmpBasicInfoID = CASE WHEN @EmpBasicInfoID<>0 THEN @EmpBasicInfoID ELSE EB.EmpBasicInfoID END
		AND EB.Status='A'  OR EA.IsPresent = 0 AND IsChangedStatus = 0
	GROUP BY EB.EmpBasicInfoID,	EB.EmpID,EB.FullName	,EA.DayType
	,ECD.DayType	,EA.AttendId, EA.Reason, ELM.Title
	ORDER BY EB.EmpID


			
  END

  	IF(@Block=6) -- For ModifyAttendanceApproval  List  GetAllRosterRegular 6,'2021-02-25 00:00:00.000',null 
  BEGIN 
	  
  SELECT
  CASE
			WHEN (EA.IsPresent = 1) THEN 'Present'
			WHEN (EA.IsLeave =1) THEN 'Leave'
			ELSE 'Absent'
			END AS LateStatus,
			CASE EA.IsLeave
			WHEN 1 THEN 'Leave'
			ELSE 'Not Leave'
			END AS LeaveStatus,
			CASE EA.IsEarlyOut
			WHEN 1 THEN 'Early Out'
			ELSE 'Not Early Out'
			END AS EarlyOutStatus,
			CAST(EA.InTime AS datetime) InTime,
			CAST(EA.OutTime AS datetime) OutTime,
			EA.Status,
			EMA.Title AS AdminRequest,
			EmpR.Title AS EmpRequest
			,EA.Reason
			,EA.AttendId
	        ,EB.EmpID AS EmployeeID
			,EB.FullName
	        ,CASE EA.IsApproved 
			WHEN 1 THEN 'Approved'
			ELSE 'Pending' END AS ApproveStatus
		    ,CASE EA.IsPriReject
			WHEN 1 THEN 'Rejected'
			ELSE 'Pending' END AS RejecteStatus
			,EC.CategoryName
			,B.BranchId
			,B.BranchName
  	--		CASE 
			--WHEN (EA.IsPresent = 1) THEN 'Present'
			--WHEN (EA.IsLeave =1) THEN 'Leave'
			--ELSE 'Absent'
			--END AS LateStatus,
			--CASE EA.IsLeave
			--WHEN 1 THEN 'Leave'
			--ELSE 'Not Leave'
			--END AS LeaveStatus,
			--EA.Status,
			--CDD.Text
			--,EA.AttendId
	  --      ,EB.EmpID AS EmployeeID
			--,EB.FullName
	  --      ,CASE EA.IsPriApproved
			--WHEN 1 THEN 'Approved'
			--ELSE 'Pending' END AS ApproveStatus
			--,CASE EA.IsPriReject
			--WHEN 1 THEN 'Rejected'
			--ELSE 'Pending' END AS RejecteStatus
			--,EC.CategoryName
			--,B.BranchId
			--,B.BranchName
	 
	FROM [dbo].[Emp_Attendance] EA
	LEFT JOIN [dbo].[Emp_BasicInfo] EB ON EB.EmpBasicInfoID = EA.EmpId
	LEFT JOIN [dbo].[Emp_Category] EC ON EC.CategoryID = EB.CategoryID
	INNER JOIN [dbo].[Ins_Branch] B ON B.BranchId = EB.BranchID
	LEFT JOIN  [dbo].[Common_DropDownConfig] CDD ON CDD.Type='PresentEmployee' AND CDD.Value=EA.Status
	LEFT JOIN  [dbo].[Emp_EmpLeaveModify] EMA ON EMA.Id =  EA.RequestId
	LEFT JOIN  [dbo].[Emp_EmpLeaveModify] EmpR ON EmpR.Id =  EA.EmpRequestId
	WHERE CAST(EA.InTime AS DATE) = CAST(@FromDate AS DATE) 
		AND  EB.BranchID = CASE WHEN @BranchID<>0 THEN @BranchID ELSE EB.BranchID END
		AND  EB.DepartmentID = CASE WHEN @DepartmentId<>0 THEN @DepartmentId ELSE EB.DepartmentID END
		AND  EB.EmpBasicInfoID = CASE WHEN @EmpBasicInfoID<>0 THEN @EmpBasicInfoID ELSE EB.EmpBasicInfoID END
		AND IsChangedStatus = 1 AND IsPresent=0 --AND EA.IsApproved = 0
		ORDER BY EB.EmpID
			
  END

END
