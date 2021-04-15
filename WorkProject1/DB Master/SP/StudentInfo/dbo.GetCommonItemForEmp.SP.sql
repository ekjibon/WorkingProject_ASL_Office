/****** Object:  StoredProcedure [dbo].[SP_GetEmpAllInfo]    Script Date: 11/18/2017 6:37:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetCommonItemForEmp]'))
BEGIN
DROP PROCEDURE  GetCommonItemForEmp
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCommonItemForEmp] 


AS
BEGIN
SELECT * From [dbo].[Emp_Designation] where IsDeleted=0 
SELECT * FROM [dbo].[Emp_Category] where IsDeleted=0 
SELECT * FROM [dbo].[Emp_Department] where IsDeleted=0
SELECT * FROM [dbo].[Emp_Section]  WHERE IsDeleted=0
SELECT * From [dbo].[Emp_Status] where IsDeleted=0
SELECT * From [dbo].[Emp_Subject] WHERE IsDeleted=0
SELECT * FROM [dbo].[Ins_Branch] where IsDeleted=0

END
