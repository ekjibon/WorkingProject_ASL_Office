IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_processClear]'))
BEGIN
DROP PROCEDURE  SP_processClear
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
	--- EXEC SP_processClear 1002
CREATE PROCEDURE [dbo].[SP_processClear]
(
@PeriodID AS Int = 0


)
AS

BEGIN

DECLARE @CategoryID AS INT

	SELECT @CategoryID =CategoryID
	FROM HR_SalaryPeriod WHERE ID=@PeriodID

	DELETE HR_SalaryStructurePeriod
	WHERE PeriodId = @PeriodID AND CategoryID=@CategoryID

	DELETE  HR_SalaryPayDetails 
	WHERE SalaryPeriodId=@PeriodId AND EmpId IN(SELECT EmpBasicInfoID FROM Emp_BasicInfo WHERE CategoryID=@CategoryID)

	DECLARE @EmpId AS INT
  

	DECLARE Structure_Cursor CURSOR FOR 
	
	SELECT EB.EmpBasicInfoID from Emp_BasicInfo EB 
	INNER JOIN HR_SalaryHoldRefund SHR ON SHR.EmpId = EB.EmpBasicInfoID
		WHERE EmpBasicInfoID IN ( SELECT EmpId FROM HR_SalaryHoldRefund WHERE SalaryPeriodId = @PeriodID AND IsDeleted = 0 AND [Status] = 'Refund' GROUP BY EmpId)
	
	OPEN Structure_Cursor;

	FETCH NEXT FROM Structure_Cursor 
	INTO @EmpId 

	WHILE @@FETCH_STATUS = 0
		BEGIN					
			BEGIN
			UPDATE HR_SalaryHoldRefund
			SET [Status] = 'Pending'
			WHERE EmpId = @EmpId AND SalaryPeriodId =@PeriodID
			END 
		FETCH NEXT FROM Structure_Cursor 		
		INTO  @EmpId
		END
		DEALLOCATE Structure_Cursor;
	
END