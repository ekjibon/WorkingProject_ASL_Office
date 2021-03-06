USE [cgsd_new_2019_test_20200112]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeeListForIncrement]    Script Date: 5/6/2020 3:05:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		 AZMAL 
-- Create date: 5/6/2020
-- Description:	
-- =============================================
 -- execute [dbo].[GetEmployeeListForIncrement] 0,8,1

ALTER PROCEDURE [dbo].[GetEmployeeListForIncrement]
	@EmpBasicInfoID INT, 
	@BranchId INT,
	@CategoryId INT
	
AS
BEGIN
 IF(@EmpBasicInfoID>0) 
 BEGIN
 SELECT  EB.EmpBasicInfoID ,EB.EmpID,EB.FullName,ED.DesignationName,EC.CategoryName,EC.CategoryID,B.BranchId,B.BranchName,cast(EB.CurrentSalary as int) GrossSalary
		,0 Amount,0 AmountAfterIncrement,0 IsPercentage,'' Remarks
	FROM [dbo].[Emp_BasicInfo] EB
	INNER JOIN [dbo].[Emp_Category] EC ON EC.CategoryID = EB.CategoryID
	INNER JOIN [dbo].[Ins_Branch] B ON B.BranchId = EB.BranchID
	INNER JOIN [dbo].[Emp_Designation] ED ON ED.DesignationID = EB.DesignationID
	WHERE EB.EmpBasicInfoID = @EmpBasicInfoID AND EB.CurrentSalary>0
	
 END
 ELSE
 BEGIN
  SELECT  EB.EmpBasicInfoID ,EB.EmpID,EB.FullName,ED.DesignationName,EC.CategoryName,EC.CategoryID,B.BranchId,B.BranchName,cast(EB.CurrentSalary as int) GrossSalary
		,0 Amount,0 AmountAfterIncrement,0 IsPercentage,'' Remarks
	FROM [dbo].[Emp_BasicInfo] EB
	INNER JOIN [dbo].[Emp_Category] EC ON EC.CategoryID = EB.CategoryID
	INNER JOIN [dbo].[Ins_Branch] B ON B.BranchId = EB.BranchID
	INNER JOIN [dbo].[Emp_Designation] ED ON ED.DesignationID = EB.DesignationID
	WHERE EB.CategoryID = @CategoryId  AND EB.BranchID = @BranchId AND EB.CurrentSalary>0
 END

END