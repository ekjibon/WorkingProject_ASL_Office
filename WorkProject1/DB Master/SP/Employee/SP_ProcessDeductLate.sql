USE [cgsd_new_2019_test_20200112]
GO
/****** Object:  StoredProcedure [dbo].[SP_ProcessDeductLate]    Script Date: 3/25/2020 12:51:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  EXEC SP_ProcessDeductLate 1
ALTER PROCEDURE [dbo].[SP_ProcessDeductLate]
(
@PeriodID AS Int = 0


)
AS

BEGIN

DECLARE @StartDate as NVARCHAR(12)
DECLARE @EndDate as NVARCHAR(12)
DECLARE @EmpId AS INT
DECLARE @NoOfDays AS INT
DECLARE @CategoryID AS INT

	SELECT @StartDate= CONVERT(NVARCHAR(12),CAST(StartDate AS DATE), 112), @EndDate=  CONVERT(NVARCHAR(12),CAST(EndDate AS DATE), 112), @CategoryID =CategoryID
	FROM HR_SalaryPeriod WHERE ID=@PeriodID
	
	DECLARE Structure_Cursor CURSOR FOR 
	
	select A.EmpId,COUNT(A.EmpId) NoOfDays from [dbo].[Emp_Attendance] A
	INNER JOIN Emp_BasicInfo EI ON EI.EmpBasicInfoID =A.EmpId
	WHERE CONVERT(NVARCHAR(12),CAST(A.Intime AS DATE), 112) between @StartDate and @EndDate AND A.Islate=1 AND EI.CategoryID=@CategoryID
	AND A.EmpId IN(SELECT EmpId FROM HR_SalaryStructure)
	GROUP BY A.EmpId
	
	OPEN Structure_Cursor;

	FETCH NEXT FROM Structure_Cursor 
	INTO @EmpId , @NoOfDays

	WHILE @@FETCH_STATUS = 0
		BEGIN
			
			IF(@NoOfDays>=3)
			BEGIN
			INSERT INTO HR_SalaryStructurePeriod( PeriodId, HeadId, EmpId , Amount, ProccessDate, CategoryID,Remarks)
			SELECT  @PeriodID, 1005,@EmpId,ROUND((ISNULL(CAST(CurrentSalary AS decimal(18,2)),0)/30)*(@NoOfDays/3),0),getdate(),CategoryID,cast(@NoOfDays as nvarchar(50))+' days late'
			FROM  Emp_BasicInfo EI WHERE EI.EmpBasicInfoID =@EmpId AND EI.IsDeleted = 0 AND EI.Status='A'
			END		
			
		FETCH NEXT FROM Structure_Cursor 
		
		INTO  @EmpId , @NoOfDays
		END
		DEALLOCATE Structure_Cursor;
	

END
