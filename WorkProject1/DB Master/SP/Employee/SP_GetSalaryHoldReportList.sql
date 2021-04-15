/****** Object:  StoredProcedure [dbo].[SP_GetSalaryHoldReportList]    Script Date: 06/14/2020 6:19:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_GetSalaryHoldReportList]'))
BEGIN
DROP PROCEDURE  SP_GetSalaryHoldReportList
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Azmal
-- Create date: 06/14/2020
-- Description:	
-- =============================================
---  EXEC [dbo].[SP_GetSalaryHoldReportList] 2,8
CREATE PROCEDURE [dbo].[SP_GetSalaryHoldReportList] 
(

@CategoryID INT = 0,
@BranchID INT = 0
)
AS
BEGIN 
  
   SELECT DISTINCT EB.EmpBasicInfoID,EB.EmpID,EB.FullName,EB.SMSNotificationNo,HS.GrossSalary, HS.HoldPerMonthAmount, HS.NoOfInstallment,Convert(nvarchar(15), cast(HS.HoldDate as Date),106)HoldDate
   FROM [dbo].[Emp_BasicInfo] EB
   INNER JOIN [dbo].[HR_SalaryHold] HS ON  HS.EmpId =EB.EmpBasicInfoID 
   WHERE EB.CategoryID = @CategoryID  AND EB.BranchID = @BranchID AND HS.IsDeleted=0
   ORDER BY EB.FullName
 
END


