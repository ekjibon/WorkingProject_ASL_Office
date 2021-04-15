IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SalaryModifyLog]'))
BEGIN
DROP PROCEDURE  [SalaryModifyLog]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Khaled
-- Description:	
-- =============================================

-- SalaryModifyLog 160,1,1,1
CREATE PROCEDURE [dbo].[SalaryModifyLog]
(
    @Id INT =0,	
	@CategoryID INT = 0,
	@EmpId INT = 0,
	@SalaryPeriodId INT = 0


)	
AS
BEGIN
 DECLARE @NetAmount DECIMAL (10,2) = 0;
 
 
SELECT @NetAmount =  NetAmount FROM HR_SalaryPayDetails WHERE Id = @Id

		INSERT INTO  [dbo].[HR_SalaryStructurePeriodModifylog]
		(PaydetailsId,NetAmount,SalaryStructurePeriodId,CategoryID,PeriodId,HeadId,EmpId,Amount,ProccessDate,AddBy,AddDate,UpdateBy,UpdateDate,IsDeleted,Remarks)
		SELECT @Id,@NetAmount,[Id],CategoryID,PeriodId,HeadId,EmpId,Amount,ProccessDate,AddBy,AddDate,UpdateBy,UpdateDate,IsDeleted,Remarks FROM HR_SalaryStructurePeriod 
		WHERE EmpId = @EmpId AND CategoryID = @CategoryID AND PeriodId = @SalaryPeriodId

END