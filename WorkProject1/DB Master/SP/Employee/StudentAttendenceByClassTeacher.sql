IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'StudentAttendenceByClassTeacher'))
BEGIN
DROP PROCEDURE  StudentAttendenceByClassTeacher
END
/****** Object:  StoredProcedure [dbo].[Attendence]    Script Date: 3/28/2019 11:55:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE StudentAttendenceByClassTeacher --'2019-09-24 18:29:04.117' --'98122228-546d-4e0e-a34e-27b56da35dfb' 
@TeacherId VARCHAR(MAX),
@FromDate VARCHAR(MAX)

AS
BEGIN          -- StudentAttendenceByClassTeacher  '1beb496c-5d4f-407b-aa3e-afffa4624383','2019-10-13 15:52:00.000'


	  SELECT DISTINCT SB.StudentIID
		  ,	CASE SA.IsLate
			WHEN 1 THEN 'Late'
			ELSE 'Not Late'
			END AS LateStatus,
			CASE SA.IsLeave
			WHEN 1 THEN 'Leave'
			ELSE 'Not Leave'
			END AS LeaveStatus,
			CASE SA.IsEarlyOut
			WHEN 1 THEN 'Early Out'
			ELSE 'Not Early Out'
			END AS EarlyOutStatus,
			CASE SA.IsPresent
			WHEN 1 THEN 'Present'
			ELSE 'Absent'
			END AS PresentStatus,
			CAST(SA.InTime AS DATETIME) AS StudentInTime,
			CAST(SA.OutTime AS DATETIME) AS StudentOutTime
		  ,EB.FullName AS TeacherName
		  ,SB.RollNo,SB.StudentInsID
		  ,EB.EmpBasicInfoID,SB.FullName AS StudentName ,SA.*
		  FROM dbo.Att_StudentAttendance SA 
		  INNER JOIN dbo.Student_BasicInfo SB ON SB.StudentIID = SA.StudentId
		  INNER JOIN dbo.[Emp_ClassTeacher] CT ON CT.ClassId = SB.ClassId
		  INNER JOIN dbo.Emp_BasicInfo EB ON EB.EmpBasicInfoID =  CT.TeacherId
		  INNER JOIN dbo.AspNetUsers U ON U.EmpId = EB.EmpBasicInfoID
		  WHERE U.Id =  @TeacherId AND CAST(SA.InTime AS DATE) = CAST(@FromDate AS DATE)
          --where u.Id='98122228-546d-4e0e-a34e-27b56da35dfb'

END