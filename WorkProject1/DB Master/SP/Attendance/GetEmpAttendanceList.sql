/****** Object:  StoredProcedure [dbo].[GetGrades]    Script Date: 7/22/2017 4:09:53 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmpAttendanceList]'))
BEGIN
DROP PROCEDURE  [GetEmpAttendanceList]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	
-- Create date: 
-- Description:	
-- =============================================

CREATE PROCEDURE [dbo].[GetEmpAttendanceList] 
(
	@EmpId INT
)

AS
BEGIN
    SELECT AttendId, InTime, OutTime, IsChangedStatus, EmpRequestId, Reason, --GETDATE() CurrentDate,DATEADD(HOUR, 48, InTime) AS ValidCheck,
	CASE WHEN GETDATE() < DATEADD(HOUR, 48, InTime) THEN 1 ELSE 0 END AS IsValid 
	FROM Emp_Attendance
	WHERE EmpId = @EmpId AND DATEPART(MONTH, CAST(InTime AS DATE)) = DATEPART(MONTH, GETDATE()) AND DATEPART(YEAR, CAST(InTime AS DATE)) = DATEPART(YEAR, GETDATE()) AND IsPresent = 1
	ORDER BY AttendId DESC
END

-- EXEC [dbo].[GetEmpAttendanceList]  24