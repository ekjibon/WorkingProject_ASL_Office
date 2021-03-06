--USE [cgsd_new_2019_test_20200112]
GO
/****** Object:  StoredProcedure [dbo].[SP_ProcessLongHolidaySalary]    Script Date: 4/21/2020 2:25:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Azmal
-- Create date: 2020-05-14
-- Description:	
-- =============================================
	--- EXEC SP_ProcessLongHolidaySalary 1002
ALTER PROCEDURE [dbo].[SP_ProcessLongHolidaySalary]
(
@PeriodID AS Int = 0


)
AS

BEGIN

DECLARE @StartDate as DATETIME
DECLARE @EndDate as DATETIME
DECLARE @EmpId AS INT
DECLARE @NoOfMonths AS INT
DECLARE @NoOflongDays AS INT
DECLARE @NoOfNotLongHoliDays AS INT
DECLARE @TotalMonths AS INT
DECLARE @CategoryID AS INT
DECLARE @DurationtoNoOfMonths AS INT

	SELECT @StartDate= StartDate , @EndDate= EndDate , @CategoryID =CategoryID
	FROM HR_SalaryPeriod WHERE ID=@PeriodID

	SET @NoOflongDays = (SELECT COUNT(CalendarDate) FROM  [dbo].[Att_EmpAcademicCalendarDetails] 
	                  WHERE DayType='LongHoliday' AND CAST (CalendarDate AS DATE) BETWEEN (CAST(@StartDate AS DATE)) AND  (CAST(@EndDate AS DATE)) AND CalendarId = (SELECT TOP(1) Id FROM Att_EmpAcademicCalendar WHERE EmpCategory= @CategoryID ORDER BY Id DESC))
	
	SET @NoOfNotLongHoliDays = (SELECT COUNT(CalendarDate) FROM  [dbo].[Att_EmpAcademicCalendarDetails] 
	                  WHERE DayType<>'LongHoliday' AND CAST (CalendarDate AS DATE) BETWEEN (CAST(@StartDate AS DATE)) AND  (CAST(@EndDate AS DATE)) AND CalendarId = (SELECT TOP(1) Id FROM Att_EmpAcademicCalendar WHERE EmpCategory= @CategoryID ORDER BY Id DESC))
	--CONFIRM AND LESS THAN 1 YEAR
	DECLARE Structure_Cursor CURSOR FOR 
	
	select EmpBasicInfoID,DATEDIFF(month,JoiningDate,@StartDate)NoOfMonths,(DATEDIFF(month, JoiningDate,@StartDate)+month(JoiningDate))TotalMonths from Emp_BasicInfo 
		where DATEDIFF(month,JoiningDate,@StartDate)<12 AND CONVERT(NVARCHAR(12),CAST(@StartDate AS DATE), 112)>CONVERT(NVARCHAR(12),CAST(ConfirmationDate AS DATE), 112) AND CategoryID=@CategoryID AND IsDeleted = 0 AND Status='A' AND CAST(CurrentSalary AS DECIMAL (18,2)) > 0 
		AND (CONVERT(NVARCHAR(12),CAST(@StartDate AS DATE), 112) IN( select CONVERT(NVARCHAR(12),CAST(CalendarDate AS DATE), 112) from [dbo].[Att_EmpAcademicCalendarDetails] WHERE DayType='LongHoliday')
		OR CONVERT(NVARCHAR(12),CAST(@EndDate AS DATE), 112) IN( select CONVERT(NVARCHAR(12),CAST(CalendarDate AS DATE), 112) from [dbo].[Att_EmpAcademicCalendarDetails] WHERE DayType='LongHoliday'))
	
	OPEN Structure_Cursor;

	FETCH NEXT FROM Structure_Cursor 
	INTO @EmpId , @NoOfMonths,@TotalMonths

	WHILE @@FETCH_STATUS = 0
		BEGIN
			
			IF(@NoOfMonths>=1)
			BEGIN
			 Insert into  HR_SalaryPayDetails( SalaryPeriodId, EmpId,GrossAmount, NetAmount,BankAmount,CashAmount,AddDate,IsDeleted,CategoryID)
			SELECT  @PeriodID,@EmpId,ISNULL((cast(CurrentSalary as decimal(18,2))),0),ROUND(ISNULL((cast(CurrentSalary as decimal(18,2))/10)*(@NoOfMonths),0)/(30)*@NoOflongDays+((cast(CurrentSalary as decimal(18,2))/30)*@NoOfNotLongHoliDays),0),0,0 ,getdate(),0,@CategoryID  
			FROM  Emp_BasicInfo  WHERE EmpBasicInfoID =@EmpId AND IsDeleted = 0 AND Status='A'

			INSERT INTO HR_SalaryStructurePeriod( PeriodId, HeadId, EmpId , Amount, ProccessDate, CategoryID,Remarks)
			SELECT  @PeriodID, 1011,@EmpId,ROUND(ISNULL((cast(CurrentSalary as decimal(18,2))),0)-((ISNULL((cast(CurrentSalary as decimal(18,2))/10)*(@NoOfMonths),0)/(30)*@NoOflongDays+((cast(CurrentSalary as decimal(18,2))/30)*@NoOfNotLongHoliDays))),0),getdate(),CategoryID,cast(@NoOflongDays as nvarchar(50))+' '+'days long holiday'			
			FROM  Emp_BasicInfo EI WHERE EI.EmpBasicInfoID =@EmpId AND EI.IsDeleted = 0 AND EI.Status='A'
			END	
			
		FETCH NEXT FROM Structure_Cursor 
		
		INTO  @EmpId , @NoOfMonths,@TotalMonths
		END
		DEALLOCATE Structure_Cursor;

		--PROBATION AND LESS THAN 1 YEAR
	DECLARE Structure_Cursor1 CURSOR FOR 
	
	select EmpBasicInfoID,DATEDIFF(month,JoiningDate,@StartDate)NoOfMonths,(DATEDIFF(month, JoiningDate,@StartDate)+month(JoiningDate))TotalMonths from Emp_BasicInfo 
		where DATEDIFF(month,JoiningDate,@StartDate)<12 AND CONVERT(NVARCHAR(12),CAST(@StartDate AS DATE), 112)<CONVERT(NVARCHAR(12),CAST(ConfirmationDate AS DATE), 112) AND CategoryID=@CategoryID AND IsDeleted = 0 AND Status='A' AND CAST(CurrentSalary AS DECIMAL (18,2)) > 0 
		AND (CONVERT(NVARCHAR(12),CAST(@StartDate AS DATE), 112) IN( select CONVERT(NVARCHAR(12),CAST(CalendarDate AS DATE), 112) from [dbo].[Att_EmpAcademicCalendarDetails] WHERE DayType='LongHoliday')
		OR CONVERT(NVARCHAR(12),CAST(@EndDate AS DATE), 112) IN( select CONVERT(NVARCHAR(12),CAST(CalendarDate AS DATE), 112) from [dbo].[Att_EmpAcademicCalendarDetails] WHERE DayType='LongHoliday'))
	
	OPEN Structure_Cursor1;

	FETCH NEXT FROM Structure_Cursor1 
	INTO @EmpId , @NoOfMonths,@TotalMonths

	WHILE @@FETCH_STATUS = 0
		BEGIN
			
			IF(@NoOfMonths>=1)
			BEGIN
			 Insert into  HR_SalaryPayDetails( SalaryPeriodId, EmpId,GrossAmount, NetAmount,BankAmount,CashAmount,AddDate,IsDeleted,CategoryID)
			SELECT  @PeriodID,@EmpId,ISNULL((cast(CurrentSalary as decimal(18,2))),0),ROUND(((cast(CurrentSalary as decimal(18,2))/30)*@NoOfNotLongHoliDays),0),0,0 ,getdate(),0,@CategoryID 
		   
			FROM  Emp_BasicInfo  WHERE EmpBasicInfoID =@EmpId AND IsDeleted = 0 AND Status='A'

			INSERT INTO HR_SalaryStructurePeriod( PeriodId, HeadId, EmpId , Amount, ProccessDate, CategoryID,Remarks)
			SELECT  @PeriodID, 1011,@EmpId,ROUND(ISNULL((cast(CurrentSalary as decimal(18,2))),0)-(((cast(CurrentSalary as decimal(18,2))/30)*@NoOfNotLongHoliDays)),0),getdate(),CategoryID,cast(@NoOflongDays as nvarchar(50))+' '+'days long holiday'

			FROM  Emp_BasicInfo EI WHERE EI.EmpBasicInfoID =@EmpId AND EI.IsDeleted = 0 AND EI.Status='A'
			END	
			
		FETCH NEXT FROM Structure_Cursor1 
		
		INTO  @EmpId , @NoOfMonths,@TotalMonths
		END
		DEALLOCATE Structure_Cursor1;

		--CONFIRM AND LEAVE DURATION MORE THAN ONE MONTH IN A YEAR
	DECLARE Structure_Cursor2 CURSOR FOR 
	
	select EB.EmpBasicInfoID,(ROUND((ER.Duration/30),0)) AS DurationtoNoOfMonths from Emp_BasicInfo EB
	INNER JOIN Emp_Request ER ON ER.EmpId = EB.EmpBasicInfoID
		where DATEDIFF(month,JoiningDate,@StartDate)>12 AND CONVERT(NVARCHAR(12),CAST(@StartDate AS DATE), 112)>CONVERT(NVARCHAR(12),CAST(ConfirmationDate AS DATE), 112) AND EB.EmpBasicInfoID IN(SELECT EmpId FROM Emp_Request WHERE LeaveCategoryId <> 4 AND Duration>=30 AND Status= 'Approved' AND AddDate >= (SELECT TOP(1) StartDate FROM Att_EmpAcademicCalendar WHERE EmpCategory=2 ORDER BY Id DESC)  AND AddDate <= (SELECT TOP(1) EndDate FROM Att_EmpAcademicCalendar WHERE EmpCategory=2 ORDER BY Id DESC ))  AND EB.CategoryID=@CategoryID AND EB.IsDeleted = 0 AND EB.Status='A' AND CAST(CurrentSalary AS DECIMAL (18,2)) > 0 
		AND (CONVERT(NVARCHAR(12),CAST(@StartDate AS DATE), 112) IN( select CONVERT(NVARCHAR(12),CAST(CalendarDate AS DATE), 112) from [dbo].[Att_EmpAcademicCalendarDetails] WHERE DayType='LongHoliday')
		OR CONVERT(NVARCHAR(12),CAST(@EndDate AS DATE), 112) IN( select CONVERT(NVARCHAR(12),CAST(CalendarDate AS DATE), 112) from [dbo].[Att_EmpAcademicCalendarDetails] WHERE DayType='LongHoliday'))
	
	 OPEN Structure_Cursor2;

	FETCH NEXT FROM Structure_Cursor2 
	INTO @EmpId ,@DurationtoNoOfMonths

	WHILE @@FETCH_STATUS = 0
		BEGIN
			
			IF(@DurationtoNoOfMonths>=1)
			BEGIN
			Insert into  HR_SalaryPayDetails( SalaryPeriodId, EmpId,GrossAmount, NetAmount,BankAmount,CashAmount,AddDate,IsDeleted,CategoryID)
			SELECT  @PeriodID,@EmpId,ISNULL((cast(CurrentSalary as decimal(18,2))),0),ROUND(ISNULL((cast(CurrentSalary as decimal(18,2))/10)*(10-@DurationtoNoOfMonths)/(30)*@NoOflongDays+((cast(CurrentSalary as decimal(18,2))/30)*@NoOfNotLongHoliDays),0),0),0,0 ,getdate(),0,@CategoryID 			
			FROM  Emp_BasicInfo  WHERE EmpBasicInfoID =@EmpId AND IsDeleted = 0 AND Status='A'

			INSERT INTO HR_SalaryStructurePeriod( PeriodId, HeadId, EmpId , Amount, ProccessDate, CategoryID,Remarks)
			SELECT  @PeriodID, 1011,@EmpId,ROUND(ISNULL((cast(CurrentSalary as decimal(18,2))),0)-(ISNULL((cast(CurrentSalary as decimal(18,2))/10)*(10-@DurationtoNoOfMonths),0)/(30)*@NoOflongDays+((cast(CurrentSalary as decimal(18,2))/30)*@NoOfNotLongHoliDays)),0),getdate(),CategoryID,cast(@NoOflongDays as nvarchar(50))+' '+'days long holiday'
			FROM  Emp_BasicInfo EI WHERE EI.EmpBasicInfoID =@EmpId AND EI.IsDeleted = 0 AND EI.Status='A'
			END	
			
		FETCH NEXT FROM Structure_Cursor2 		
		INTO  @EmpId , @DurationtoNoOfMonths
		END
		DEALLOCATE Structure_Cursor2;

		--CONFIRM AND Maternity LEAVE Without pay and DURATION MORE THAN ONE MONTH IN A YEAR AND Maternity 
	DECLARE Structure_Cursor3 CURSOR FOR 
	
	select EB.EmpBasicInfoID,(ROUND((ER.Duration/30),0)) AS DurationtoNoOfMonths from Emp_BasicInfo EB
	INNER JOIN Emp_Request ER ON ER.EmpId = EB.EmpBasicInfoID
		where DATEDIFF(month,JoiningDate,@StartDate)>12 AND CONVERT(NVARCHAR(12),CAST(@StartDate AS DATE), 112)>CONVERT(NVARCHAR(12),CAST(ConfirmationDate AS DATE), 112) AND EB.EmpBasicInfoID IN(SELECT EmpId FROM Emp_Request WHERE LeaveCategoryId = 4 AND Duration>=30 AND Status= 'Approved' AND WithOutpay >= 30 AND AddDate >= (SELECT TOP(1) StartDate FROM Att_EmpAcademicCalendar WHERE EmpCategory=2 ORDER BY Id DESC)  AND AddDate <= (SELECT TOP(1) EndDate FROM Att_EmpAcademicCalendar WHERE EmpCategory=2 ORDER BY Id DESC ))  AND EB.CategoryID=@CategoryID AND EB.IsDeleted = 0 AND EB.Status='A' AND ER.Status= 'Approved' AND ER.LeaveCategoryId = 4 AND ER.Duration>=30 AND  ER.WithOutpay >= 30 AND  CAST(CurrentSalary AS DECIMAL (18,2)) > 0 AND CAST (ER.ToDate AS DATE) < CAST(@StartDate AS DATE)
		AND (CONVERT(NVARCHAR(12),CAST(@StartDate AS DATE), 112) IN( select CONVERT(NVARCHAR(12),CAST(CalendarDate AS DATE), 112) from [dbo].[Att_EmpAcademicCalendarDetails] WHERE DayType='LongHoliday')
		OR CONVERT(NVARCHAR(12),CAST(@EndDate AS DATE), 112) IN( select CONVERT(NVARCHAR(12),CAST(CalendarDate AS DATE), 112) from [dbo].[Att_EmpAcademicCalendarDetails] WHERE DayType='LongHoliday'))
	
	 OPEN Structure_Cursor3;

	FETCH NEXT FROM Structure_Cursor3 
	INTO @EmpId ,@DurationtoNoOfMonths

	WHILE @@FETCH_STATUS = 0
		BEGIN
			
			IF(@DurationtoNoOfMonths>=1)
			BEGIN
			DELETE HR_SalaryPayDetails WHERE EmpId = @EmpId AND SalaryPeriodId = @PeriodID
			Insert into  HR_SalaryPayDetails( SalaryPeriodId, EmpId,GrossAmount, NetAmount,BankAmount,CashAmount,AddDate,IsDeleted,CategoryID)
			SELECT  @PeriodID,@EmpId,ISNULL((cast(CurrentSalary as decimal(18,2))),0),ROUND(ISNULL((cast(CurrentSalary as decimal(18,2))/10)*(10-@DurationtoNoOfMonths)/(30)*@NoOflongDays+((cast(CurrentSalary as decimal(18,2))/30)*@NoOfNotLongHoliDays),0),0),0,0 ,getdate(),0,@CategoryID 			
			FROM  Emp_BasicInfo  WHERE EmpBasicInfoID =@EmpId AND IsDeleted = 0 AND Status='A'

			INSERT INTO HR_SalaryStructurePeriod( PeriodId, HeadId, EmpId , Amount, ProccessDate, CategoryID,Remarks)
			SELECT  @PeriodID, 1011,@EmpId,ROUND(ISNULL((cast(CurrentSalary as decimal(18,2))),0)-(ISNULL((cast(CurrentSalary as decimal(18,2))/10)*(10-@DurationtoNoOfMonths),0)/(30)*@NoOflongDays+((cast(CurrentSalary as decimal(18,2))/30)*@NoOfNotLongHoliDays)),0),getdate(),CategoryID,cast(@NoOflongDays as nvarchar(50))+' '+'days long holiday'
			FROM  Emp_BasicInfo EI WHERE EI.EmpBasicInfoID =@EmpId AND EI.IsDeleted = 0 AND EI.Status='A'
			END	
			
		FETCH NEXT FROM Structure_Cursor3 		
		INTO  @EmpId , @DurationtoNoOfMonths
		END
		DEALLOCATE Structure_Cursor3;


END