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
@EmployeeId int =null,
@EmpCategory int = null , 
@BranchId int = null ,
@FromDate datetime = NULL ,
@ToDate datetime = NULL
AS
IF (@BatchId =1)
BEGIN  
	IF @EmployeeId IS NULL
	BEGIN
		CREATE TABLE #ShowTable
		(
		 ShowDate nvarchar(MAX),
		 EmployeeName nvarchar(MAX)
		)

		    INSERT INTO #ShowTable(ShowDate,EmployeeName)

		  SELECT (SELECT convert(varchar, @FromDate, 105) + ' - '  + convert(varchar, @ToDate, 105)) ,FullName
		  FROM Emp_BasicInfo e
		  left join Emp_Category c on c.CategoryID= e.CategoryID
		  inner join Ins_Branch b on b.BranchId =e.BranchID
	END
END




  

 

