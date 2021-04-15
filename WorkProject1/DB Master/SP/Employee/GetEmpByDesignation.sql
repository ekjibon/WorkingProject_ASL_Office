/****** Object:  StoredProcedure [dbo].[GetEmpByDesignation]    Script Date: 08/01/2021 3:23:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmpByDesignation]'))
BEGIN
DROP PROCEDURE GetEmpByDesignation
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--- [dbo].[GetEmpByDesignation] 2, 19
CREATE PROCEDURE [dbo].[GetEmpByDesignation] 
(
	@Block INT,
	@DesignationId INT = NULL
)
AS
BEGIN
	IF(@Block = 1)
	BEGIN
		SELECT FullName, Id FROM AspNetUsers WHERE EmpId IN (  
			SELECT EmpBasicInfoID FROM Emp_BasicInfo WHERE IsDeleted = 0 AND DesignationID= @DesignationId)
	END
	IF(@Block = 2)
	BEGIN
		SELECT DesignationID,DesignationName,DesignationOrder FROM Emp_Designation 
		WHERE DesignationOrder < (SELECT DesignationOrder FROM Emp_Designation Where DesignationID = @DesignationId AND IsDeleted = 0) AND IsDeleted = 0
	END

END
