
GO
/****** Object:  StoredProcedure [dbo].[GetAllAdvanceSalary]    Script Date: 4/26/2020 4:01:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

alter procedure [dbo].[GetAllAdvanceSalary]

as 
begin
	
	select A.*,EMP.FullName,EMP.EmpId EmpoyeeId,D.DesignationName from HR_AdvanceSalary A
	INNER JOIN Emp_BasicInfo EMP ON A.EmpId = EMP.EmpBasicInfoID 
	INNER JOIN Emp_Designation D ON D.DesignationID=EMP.DesignationID
	where A.IsDeleted=0 and A.Status='A'
end