/****** Object:  StoredProcedure [dbo].[GetPayrolList]    Script Date: 04/19/2020 6:19:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetPayrolList]'))
BEGIN
DROP PROCEDURE  GetPayrolList
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---[dbo].[GetPayrolList] 2,8,1,1
CREATE PROCEDURE [dbo].[GetPayrolList] 
(

@CategoryID INT = Null,
@BranchID INT = Null,
@PeriodId INT = Null,
@Block INT
)
AS
BEGIN
   IF(@Block = 1)
   BEGIN
   SELECT DISTINCT EB.EmpBasicInfoID,EB.EmpID,EB.FullName,EB.SMSNotificationNo
   FROM [dbo].[Emp_BasicInfo] EB
   INNER JOIN [dbo].[HR_SalaryPayDetails] HS ON HS.CategoryID = EB.CategoryID AND HS.EmpId =EB.EmpBasicInfoID AND HS.SalaryPeriodId = @PeriodId
   WHERE EB.CategoryID = @CategoryID  AND EB.BranchID = @BranchID
   END	
    
---[dbo].[GetPayrolList] null,null,1,2
   IF(@Block = 2) -- 
   BEGIN
   SELECT DISTINCT EB.EmpBasicInfoID,EB.EmpID,EB.FullName,EB.SMSNotificationNo
   FROM [dbo].[Emp_BasicInfo] EB
   INNER JOIN [dbo].[HR_SalaryPayDetails] HS ON HS.CategoryID = EB.CategoryID AND HS.EmpId =EB.EmpBasicInfoID
   WHERE HS.SalaryPeriodId = @PeriodId
   END	
END
-- GetPayrolList 0,0,0

