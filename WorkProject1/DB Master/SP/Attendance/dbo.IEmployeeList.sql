IF EXISTS (SELECT *  FROM   sys.objects WHERE  object_id = Object_id(N'IEmployeeList')) 
  BEGIN 
      DROP PROCEDURE IEmployeeList 
  END 
go 

SET ANSI_NULLS ON
GO 
SET QUOTED_IDENTIFIER ON
GO

CREATE TYPE  IEmployeeList
AS TABLE
(
  EmpId INT,
  InTime time(7),
  OutTime time(7),
  Remarks nvarchar(100)
);