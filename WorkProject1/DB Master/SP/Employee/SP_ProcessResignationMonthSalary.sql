GO
/****** Object:  StoredProcedure [dbo].[SP_ProcessResignationMonthSalary]    Script Date: 4/21/2020 2:25:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	--- EXEC SP_ProcessResignationMonthSalary 1002
ALTER PROCEDURE [dbo].[SP_ProcessResignationMonthSalary]
(
@PeriodID AS Int = 0

)
AS

BEGIN

DECLARE @StartDate as DATETIME
DECLARE @EndDate as DATETIME
DECLARE @EmpId AS INT
DECLARE @NoOfMonths AS INT
DECLARE @NoOfdaysBefrServeDate AS INT
DECLARE @NoOfNotLongHoliDays AS INT
DECLARE @NoOflongDays AS INT
DECLARE @TotalMonths AS INT
DECLARE @CategoryID AS INT




	SELECT @StartDate= StartDate , @EndDate= EndDate , @CategoryID =CategoryID
	FROM HR_SalaryPeriod WHERE ID=@PeriodID

		SET @NoOfNotLongHoliDays = 
	(SELECT COUNT(CalendarDate) FROM  [dbo].[Att_EmpAcademicCalendarDetails] 
	                  WHERE DayType<>'LongHoliday' AND CAST (CalendarDate AS DATE) BETWEEN (CAST(@StartDate AS DATE)) AND  (CAST(@EndDate AS DATE)) AND CalendarId = (SELECT TOP(1) Id FROM Att_EmpAcademicCalendar WHERE EmpCategory= @CategoryID ORDER BY Id DESC))
	SET @NoOflongDays = 
	(SELECT COUNT(CalendarDate) FROM  [dbo].[Att_EmpAcademicCalendarDetails] 
	                  WHERE DayType='LongHoliday' AND CAST (CalendarDate AS DATE) BETWEEN (CAST(@StartDate AS DATE)) AND  (CAST(@EndDate AS DATE)) AND CalendarId = (SELECT TOP(1) Id FROM Att_EmpAcademicCalendar WHERE EmpCategory= @CategoryID ORDER BY Id DESC))

	DECLARE Structure_Cursor CURSOR FOR 
	
	select EmpBasicInfoID,DATEDIFF(month,JoiningDate,@StartDate)NoOfMonths,(DATEDIFF(month, JoiningDate,@StartDate)+month(JoiningDate))TotalMonths,DATEDIFF(DAY,@StartDate,ServeDate)NoOfdaysBefrServeDate from Emp_BasicInfo 
		where IsResignationApplied = 1 AND ServeDate >= @StartDate --AND  ServeDate <= @EndDate 
		AND CategoryID=@CategoryID AND IsDeleted = 0 AND Status='A' AND CAST(CurrentSalary AS DECIMAL (18,2)) > 0 

	
	OPEN Structure_Cursor;

	FETCH NEXT FROM Structure_Cursor 
	INTO @EmpId,@NoOfMonths,@TotalMonths,@NoOfdaysBefrServeDate

	WHILE @@FETCH_STATUS = 0
		BEGIN
			
			IF(@NoOfMonths>=1)
			BEGIN
			 Insert into  HR_SalaryPayDetails( SalaryPeriodId, EmpId,GrossAmount, NetAmount,BankAmount,CashAmount,AddDate,IsDeleted,CategoryID)
			SELECT  @PeriodID,@EmpId,ISNULL((cast(CurrentSalary as decimal(18,2))),0),ROUND(ISNULL((cast(CurrentSalary as decimal(18,2))/30)*(@NoOfNotLongHoliDays),0),0),0,0 ,getdate(),0,@CategoryID 
			FROM  Emp_BasicInfo  WHERE EmpBasicInfoID =@EmpId AND IsDeleted = 0 AND Status='A'
			INSERT INTO HR_SalaryStructurePeriod( PeriodId, HeadId, EmpId , Amount, ProccessDate, CategoryID,Remarks)
			SELECT  @PeriodID, 1011,@EmpId,ROUND(ISNULL((cast(CurrentSalary as decimal(18,2))),0)-(ISNULL((cast(CurrentSalary as decimal(18,2))/30)*(@NoOfNotLongHoliDays),0)),0),getdate(),CategoryID,cast(@NoOflongDays as nvarchar(50))+' '+'days long holiday'
			FROM  Emp_BasicInfo EI WHERE EI.EmpBasicInfoID =@EmpId AND EI.IsDeleted = 0 AND EI.Status='A'
			END	
			
		FETCH NEXT FROM Structure_Cursor 
		
		INTO  @EmpId,@NoOfMonths,@TotalMonths,@NoOfdaysBefrServeDate
		END
		DEALLOCATE Structure_Cursor;


END