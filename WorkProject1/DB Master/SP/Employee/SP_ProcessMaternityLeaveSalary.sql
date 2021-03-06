--USE [cgsd_new_2019_test_20200112]
GO
/****** Object:  StoredProcedure [dbo].[SP_ProcessMaternityLeaveSalary]    Script Date: 4/21/2020 2:26:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	--- EXEC SP_ProcessMaternityLeaveSalary 1002,null
ALTER PROCEDURE [dbo].[SP_ProcessMaternityLeaveSalary]
(
@PeriodID AS Int = 0


)
AS

BEGIN

DECLARE @StartDate as DATETIME
DECLARE @EndDate as DATETIME
DECLARE @EmpId AS INT
DECLARE @NoOfMonths AS INT
DECLARE @NoOfDays AS INT
DECLARE @CategoryID AS INT

	SELECT @StartDate= StartDate , @EndDate= EndDate , @CategoryID =CategoryID
	FROM HR_SalaryPeriod WHERE ID=@PeriodID
	
	DECLARE Structure_Cursor CURSOR FOR 

	select L.EmpId,(L.Duration/30) NoOfMonths from [dbo].[Emp_Request] L
		INNER JOIN Emp_BasicInfo EI ON  EI.EmpBasicInfoID = L.EmpId 
		WHERE EI.IsDeleted = 0 AND EI.Status='A' AND EI.CategoryID=@CategoryID
		AND L.LeaveCategoryId=4 and L.Status='Approved' AND L.Duration/30>2 AND L.MaternityLeaveType = 2 AND L.WithOutpay = 0
		AND CONVERT(NVARCHAR(12),CAST(@StartDate AS DATE), 112) BETWEEN CONVERT(NVARCHAR(12),CAST(L.FromDate AS DATE), 112) AND CONVERT(NVARCHAR(12),CAST(L.ToDate AS DATE), 112)
	
	
	OPEN Structure_Cursor;

	FETCH NEXT FROM Structure_Cursor 
	INTO @EmpId , @NoOfMonths

	WHILE @@FETCH_STATUS = 0
		BEGIN
			
			IF(@NoOfMonths>2)
			BEGIN

			Insert into  HR_SalaryPayDetails( SalaryPeriodId, EmpId,GrossAmount, NetAmount,BankAmount,CashAmount,AddDate,IsDeleted,CategoryID)
			SELECT  @PeriodID,@EmpId,ISNULL((cast(CurrentSalary as decimal(18,2))),0),ROUND((ISNULL((cast(CurrentSalary as decimal(18,2))/@NoOfMonths)* 2,0)),0),0,0 ,getdate(),0,@CategoryID 
			FROM  Emp_BasicInfo  WHERE EmpBasicInfoID =@EmpId AND IsDeleted = 0 AND Status='A'

			INSERT INTO HR_SalaryStructurePeriod( PeriodId, HeadId, EmpId , Amount, ProccessDate, CategoryID,Remarks)
			SELECT  @PeriodID, 1012,@EmpId,ROUND((ISNULL((cast(CurrentSalary as decimal(18,2))-(cast(CurrentSalary as decimal(18,2))/@NoOfMonths)* 2),0)),0),getdate(),CategoryID,cast(@NoOfMonths as nvarchar(50))+' '+'month Maternity Leave'
			FROM  Emp_BasicInfo EI WHERE EI.EmpBasicInfoID =@EmpId AND EI.IsDeleted = 0 AND EI.Status='A'
			END		
			
		FETCH NEXT FROM Structure_Cursor 
		
		INTO  @EmpId, @NoOfMonths
		END
		DEALLOCATE Structure_Cursor;
 --Genaral type MaternityLeave with out pay
	DECLARE Structure_Cursor1 CURSOR FOR 
	
		select L.EmpId,COUNT(EA.EmpId) NoOfDays,(L.Duration/30) NoOfMonths from [dbo].[Emp_Request] L
		INNER JOIN Emp_BasicInfo EI ON  EI.EmpBasicInfoID = L.EmpId 
		INNER JOIN Emp_Attendance EA ON EA.EmpId = L.EmpId  AND  CONVERT(NVARCHAR(12),CAST(EA.Intime AS DATE), 112) between @StartDate and @EndDate
		WHERE EI.IsDeleted = 0 AND EI.Status='A' AND EI.CategoryID=2
		AND L.LeaveCategoryId=4 and L.Status='Approved' AND L.Duration/30>2 AND L.MaternityLeaveType = 1
		AND CONVERT(NVARCHAR(12),CAST(@StartDate AS DATE), 112) BETWEEN CONVERT(NVARCHAR(12),CAST(L.FromDate AS DATE), 112) AND CONVERT(NVARCHAR(12),CAST(L.ToDate AS DATE), 112)
	   GROUP BY L.EmpId,L.Duration
	OPEN Structure_Cursor1;

	FETCH NEXT FROM Structure_Cursor1 
	INTO @EmpId , @NoOfDays,@NoOfMonths

	WHILE @@FETCH_STATUS = 0
		BEGIN
			
			IF(@NoOfDays>=1)
	

			BEGIN
			INSERT INTO HR_SalaryStructurePeriod( PeriodId, HeadId, EmpId , Amount, ProccessDate, CategoryID,Remarks)
			SELECT  @PeriodID, 1012,@EmpId,ROUND((ISNULL(cast(CurrentSalary as decimal(18,2)),0)/30*@NoOfDays),0),getdate(),CategoryID,cast(@NoOfMonths as nvarchar(50))+' month Maternity Leave'
			FROM  Emp_BasicInfo EI WHERE EI.EmpBasicInfoID =@EmpId AND EI.IsDeleted = 0 AND EI.Status='A'
			END		
			
		FETCH NEXT FROM Structure_Cursor1 
		
		INTO  @EmpId , @NoOfDays,@NoOfMonths
		END
		DEALLOCATE Structure_Cursor1;
	

END