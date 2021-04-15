/****** Object:  StoredProcedure [dbo].[SP_GetEmpAllInfo]    Script Date: 11/18/2017 6:37:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmpInfoByIDs]'))
BEGIN
DROP PROCEDURE  GetEmpID
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetEmpInfoByIDs] 

@EmpIDs nvarchar(max)


AS
BEGIN
SELECT value  INTO #EMPIDs
FROM String_Split(@EmpIDs, ',')
select * from Emp_BasicInfo where EmpID in (select * from #EMPIDs)
END

