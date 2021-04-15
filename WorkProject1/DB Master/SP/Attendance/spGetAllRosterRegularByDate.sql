
IF EXISTS (SELECT *  FROM   sys.objects WHERE  object_id = Object_id(N'spGetAllRosterRegularByDate')) 
  BEGIN 
      DROP PROCEDURE spGetAllRosterRegularByDate 
  END 
go 
SET ANSI_NULLS ON
GO 
SET QUOTED_IDENTIFIER ON
GO 

--spGetRosterRegular

CREATE PROCEDURE spGetAllRosterRegularByDate
@searchDate DateTime
AS
SELECT '1100' AS Id, 'fdsdff' AS [Name],12 AS InTime , 4 AS OutTime, 'Late' AS Attendance
--      'sdf' AS Id, 'fdsdff' AS EmpName,GETDATE() AS INTIME , GETDATE() AS OutTime, '22-03-20019 - 22-11-2019' AS FromToDate,'sdsddsss' AS Remarks,
--'sdf' AS Id, 'fdsdff' AS EmpName,GETDATE() AS INTIME , GETDATE() AS OutTime, '22-03-20019 - 22-11-2019' AS FromToDate,'sdsddsss' AS Remarks,
-- 'sdf' AS Id, 'fdsdff' AS EmpName,GETDATE() AS INTIME , GETDATE() AS OutTime, '22-03-20019 - 22-11-2019' AS FromToDate,'sdsddsss' AS Remarks,
--'sdf' AS Id, 'fdsdff' AS EmpName,GETDATE() AS INTIME , GETDATE() AS OutTime, '22-03-20019 - 22-11-2019' AS FromToDate,'sdsddsss' AS Remarks,
-- 'sdf' AS Id, 'fdsdff' AS EmpName,GETDATE() AS INTIME , GETDATE() AS OutTime, '22-03-20019 - 22-11-2019' AS FromToDate,'sdsddsss' AS Remarks,
-- 'sdf' AS Id, 'fdsdff' AS EmpName,GETDATE() AS INTIME , GETDATE() AS OutTime, '22-03-20019 - 22-11-2019' AS FromToDate,'sdsddsss' AS Remarks
 