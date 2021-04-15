/****** Object:  StoredProcedure [dbo].[SP_GetAllEmpList]    Script Date: 11/19/2020 6:37:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetAllEmpList]'))
BEGIN
DROP PROCEDURE  GetAllEmpList
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAllEmpList]  

AS

BEGIN
	SELECT EB.EmpBasicInfoID, EB.EmpID, EB.FullName, EB.NationalID, EB.BloodGroup, EB.JoiningDate
	FROM Emp_BasicInfo EB
END

-- EXEC GetAllEmpList