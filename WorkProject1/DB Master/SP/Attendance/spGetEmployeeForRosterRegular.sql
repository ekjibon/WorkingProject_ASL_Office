IF EXISTS (SELECT *  FROM   sys.objects WHERE  object_id = Object_id(N'spGetEmployeeForRosterRegular')) 
  BEGIN 
      DROP PROCEDURE spGetEmployeeForRosterRegular 
  END 
go 
SET ANSI_NULLS ON
GO 
SET QUOTED_IDENTIFIER ON
GO 

--spGetRosterRegular

CREATE PROCEDURE spGetEmployeeForRosterRegular  

@BatchId INT = null, 
@EmployeeId int =0,
@CategoryID int = null , 
@BranchId int = null ,
@FromDate datetime = NULL ,
@ToDate datetime = NULL
AS
IF (@BatchId =1)
BEGIN  
	IF (@EmployeeId=0)
	BEGIN
		CREATE TABLE #ShowTable
		(
		 ShowDate varchar(MAX),
		 EmpBasicInfoID int,
		 EmployeeName nvarchar(MAX)
		)

		    INSERT INTO #ShowTable(ShowDate,EmpBasicInfoID,EmployeeName)

		  SELECT  ((select  left(@FromDate,11)) +' - '+(select  left(@ToDate,11))), EmpBasicInfoID,e.FullName
		  FROM Emp_BasicInfo e
		  left join Emp_Category c on c.CategoryID= e.CategoryID
		  inner join AspNetUsers a on a.EmpId=e.EmpBasicInfoID
		  inner join ACC_Branchs b on b.BranchId =a.AccountBranchId
		  where e.CategoryID=@CategoryID and a.AccountBranchId=@BranchId
		  --where e.CategoryID=1003 and a.AccountBranchId=1008
		  SELECT * FROM #ShowTable
	END
END



--Drop table #ShowTable
  

 

