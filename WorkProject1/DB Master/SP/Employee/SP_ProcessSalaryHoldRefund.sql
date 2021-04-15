/****** Object:  StoredProcedure [dbo].[InsertCalenderIdOnLeaveQouta]    Script Date: 06/05/2020 11:33:37 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_ProcessSalaryHoldRefund]'))
BEGIN
DROP PROCEDURE  SP_ProcessSalaryHoldRefund
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Author: Khaled
---[dbo].[SP_ProcessSalaryHoldRefund] 3
CREATE PROCEDURE [dbo].[SP_ProcessSalaryHoldRefund] 
(
@PeriodID AS Int = 0
)
AS
BEGIN
DECLARE @EmpId AS INT
DECLARE @InstallmentAmount AS DECIMAL
DECLARE @Remarks AS NVARCHAR(50)

	DECLARE Structure_Cursor CURSOR FOR 
	
	SELECT EB.EmpBasicInfoID,SHR.InstallmentAmount,SHR.Remarks from Emp_BasicInfo EB 
	INNER JOIN HR_SalaryHoldRefund SHR ON SHR.EmpId = EB.EmpBasicInfoID
		WHERE EmpBasicInfoID IN ( SELECT EmpId FROM HR_SalaryHoldRefund WHERE SalaryPeriodId = @PeriodID AND IsDeleted = 0 AND [Status] = 'Pending' GROUP BY EmpId)
		AND SHR.[Status] = 'Pending' AND SHR.IsDeleted = 0 AND SHR.SalaryPeriodId = @PeriodID
	
	OPEN Structure_Cursor;

	FETCH NEXT FROM Structure_Cursor 
	INTO @EmpId,@InstallmentAmount,@Remarks 

	WHILE @@FETCH_STATUS = 0
		BEGIN			
			
			BEGIN			
			INSERT INTO HR_SalaryStructurePeriod( PeriodId, HeadId, EmpId , Amount, ProccessDate, CategoryID,Remarks)
			SELECT  @PeriodID,2032,@EmpId,@InstallmentAmount,getdate(),CategoryID,CAST(@Remarks AS NVARCHAR(50)) +' Installment of salary hold refund'			
			FROM  Emp_BasicInfo EI WHERE EI.EmpBasicInfoID =@EmpId AND EI.IsDeleted = 0 AND EI.Status='A' 
			END	
			BEGIN
			UPDATE HR_SalaryHoldRefund
			SET [Status] = 'Refund'
			WHERE EmpId = @EmpId AND SalaryPeriodId =@PeriodID AND IsDeleted = 0
			END 

		FETCH NEXT FROM Structure_Cursor 
		
		INTO  @EmpId,@InstallmentAmount,@Remarks
		END
		DEALLOCATE Structure_Cursor;


END