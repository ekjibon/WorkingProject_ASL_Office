IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmployeeLIFOList]'))
BEGIN
DROP PROCEDURE  GetEmployeeLIFOList
END
GO
/****** Object:  StoredProcedure [dbo].[GetStudentRequestList]    Script Date: 4/23/2019 11:05:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[GetEmployeeLIFOList]
 AS 
 Begin
	SELECT el.LIEOId,el.EmpId,eb.FullName,CONVERT(datetime,StartTime) StartTime, CONVERT(datetime,LateInTime) LateInTime, CONVERT(datetime,EndTime) EndTime,
      CONVERT(datetime,EarlyOutTime) EarlyOutTime from Emp_LIEO el inner join Emp_BasicInfo eb on el.EmpId=eb.EmpBasicInfoID where el.IsDeleted=0
 ENd
 
 