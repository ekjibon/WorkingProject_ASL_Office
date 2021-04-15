
/****** Object:  StoredProcedure [dbo].[InsertIntoEmpAcademicCalender]    Script Date: 10/02/2021 11:15:16 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[InsertIntoEmpAcademicCalender]'))
BEGIN
DROP PROCEDURE  [InsertIntoEmpAcademicCalender]
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Sourav
-- Create date: 
-- Description:	
-- =============================================
-- 
CREATE PROCEDURE [dbo].[InsertIntoEmpAcademicCalender]

	@Title VARCHAR(MAX),
	@StartDate DATETIME=NULL,
	@EndDate DATETIME=NULL, 
	@EmpCategory INT=NULL,
	@EmpBranchId INT=NULL,
	@WeekendDay  VARCHAR(MAX)=NULL,
	@InTime time(7)=NULL,
	@OutTime time(7)=NULL,
	@DefaultLateInTime INT=NULL,
	@DefaultEarlyOutTime INT=NULL,
	@AddBy VARCHAR(MAX)=NULL,
	@MacAddress VARCHAR(MAX)=NULL,
	@IP VARCHAR(MAX)=NULL,
	@CalenderId INT = 0,
	@IsUpdateExisting BIT = 0

AS
BEGIN  -- [dbo].[InsertIntoEmpAcademicCalender] 'Test', '2021-01-01', '2021-01-31', 0, 10, 'Sunday', '10:00', '19:00', 15, 10, 'admin','','',0,0
BEGIN TRY
	BEGIN TRANSACTION; 
	DECLARE @EmpCalendarId INT = 0,@MaxId INT = 0, @Counter INT = 1

			CREATE TABLE #date2
			(
				ID INT IDENTITY (1,1) NOT NULL,
				CalendarDate DATETIME,
				DateNameString NVARCHAR(25)
			)
			INSERT INTO #date2 select datestring ,DateNameString from DateRange_To_Table(CAST(@StartDate AS NVARCHAR(50)),CAST(@EndDate AS NVARCHAR(50)))
			SET @MaxId = @@ROWCOUNT

	SELECT value  INTO #WeekDays
	FROM STRING_SPLIT(@WeekendDay, ',')

		--DELETE FROM [dbo].[Att_EmpAcademicCalendar] WHERE Year = @Year
		--DELETE FROM [dbo].[Att_EmpAcademicCalendarDetails] WHERE Year = @Year
		--DELETE FROM [dbo].[Emp_Attendance] WHERE AttStatusType = 'P'
		IF(@CalenderId=0)
		BEGIN
			IF  EXISTS (SELECT TOP (1) Id FROM [dbo].[Att_EmpAcademicCalendarDetails] WHERE  CAST(CalendarDate AS DATE) IN(SELECT CAST(CalendarDate AS DATE) FROM #date2))
			BEGIN
					RAISERROR ('Employee Academic Calendar Overlapping.',16,1);  
			END
   			INSERT INTO [dbo].[Att_EmpAcademicCalendar]
			(
				[Title],[StartDate],[EndDate],[EmpCategory],
				[IsDeleted],[AddBy],[AddDate],[UpdateBy],[UpdateDate],[Remarks],[Status],[IP],[MacAddress],
				[EmpBranchId],[WeekendDay],[InTime],[OutTime],[DefaultLITime],[DefaultEOTime]
			)
			VALUES
			(	
				@Title,@StartDate,@EndDate,@EmpCategory,
				0,@AddBy,GETDATE(),NULL,GETDATE(),NULL,'A',NULL,NULL,
				@EmpBranchId,@WeekendDay,@InTime,@OutTime,@DefaultLateInTime,@DefaultEarlyOutTime
			)
			IF( @@ROWCOUNT = 0 ) 
				RAISERROR ('Employee Academic Calendar Not Insert.',16,1);  
			SET @EmpCalendarId = @@IDENTITY
		END
		ELSE 
		BEGIN
			--IF  EXISTS (SELECT TOP (1) Id FROM [dbo].[Att_EmpAcademicCalendarDetails] WHERE  CAST(CalendarDate AS DATE) IN(SELECT CAST(CalendarDate AS DATE) FROM #date2))
			--BEGIN
			--		RAISERROR ('Employee Academic Calendar Overlapping.',16,1);  
			--END
			UPDATE [dbo].[Att_EmpAcademicCalendar]
					SET [Title] = @Title,
					[WeekendDay] = @WeekendDay,
					[InTime] = @InTime,
					[OutTime] = @OutTime,
					[DefaultLITime]=@DefaultLateInTime,
					[DefaultEOTime]= @DefaultEarlyOutTime
					WHERE Id =  @CalenderId
		END

		PRINT 'Primary Key For Calendar Id >>>> ' + CAST(@EmpCalendarId AS VARCHAR(200))


			SET @Counter = 1
			WHILE(@Counter<=@MaxId)
			BEGIN
				DECLARE @Date DATETIME, @DayType VARCHAR(MAX) = NULL,@CalenderDetailsId INT = 0
				SELECT @Date=CalendarDate,@DayType=(CASE 	WHEN EXISTS(SELECT * FROM #WeekDays WHERE value = DateNameString)  THEN 'Weekend' ELSE 'Regular' END)  
											FROM #date2 WHERE ID =  @Counter

				IF NOT EXISTS (SELECT TOP (1) Id FROM [dbo].[Att_EmpAcademicCalendarDetails] WHERE  CAST(CalendarDate AS DATE) = CAST(@Date AS DATE))
				BEGIN
					INSERT INTO [dbo].[Att_EmpAcademicCalendarDetails]
							   ([CalendarId],[Year]
							   ,[Month],[Day],[CalendarDate],[DayType]
							   ,[HolidayName],[IsDeleted],[AddBy],[AddDate],[Remarks],[Status],[IP],[MacAddress])
							   SELECT @EmpCalendarId,YEAR(@Date),MONTH(@Date),DAY(@Date),@Date,@DayType,'',0,@AddBy,GETDATE(),'Insert','A',@IP,@MacAddress
					SET @CalenderDetailsId =  @@IDENTITY

					IF NOT EXISTS (SELECT * FROM [dbo].[Emp_Attendance] WHERE CalanderDetailsId = @CalenderDetailsId)
					BEGIN 
						INSERT INTO [dbo].[Emp_Attendance]
							   ([EmpId],[IsPresent],[IsLeave],[IsLate]
							   ,[IsEarlyOut],[IsDeleted],[AddBy],[AddDate]
								,[IsPriApproved],[IsFinalApproved]
							   ,[IsChangedStatus],[IsApproved],[IsRejected]
							   ,[CalanderDetailsId],[DayType],[OfficeInTime],[OfficeOutTime]
							   ,[DefaultLITime],[DefaultEOTime],[AttStatusType])
							   SELECT EmpBasicInfoID,0,0,0
										,0,0,@AddBy,GETDATE()
										,0,0,0,0,0,@CalenderDetailsId,@DayType,@InTime,@OutTime,@DefaultLateInTime,@DefaultEarlyOutTime,'P'
							   FROM dbo.Emp_BasicInfo 
							   WHERE BranchID =  @EmpBranchId AND [Status] = 'A'
					END
				END
				ELSE 
				BEGIN
					IF(@IsUpdateExisting=1)
					BEGIN
						SELECT @CalenderDetailsId = Id FROM [dbo].[Att_EmpAcademicCalendarDetails] WHERE  CAST(CalendarDate AS DATE) = CAST(@Date AS DATE) AND CalendarId =  @CalenderId
						UPDATE [dbo].[Att_EmpAcademicCalendarDetails] 
						SET 
							--[Year] = YEAR(@Date),
							--[Month] = MONTH(@Date),
							--[Day] = DAY(@Date),
							--[CalendarDate] = @Date,
							[DayType] =@DayType,
							[UpdateBy] = @AddBy,
							[UpdateDate] = GETDATE()
						WHERE Id =  @CalenderDetailsId

						UPDATE [dbo].[Emp_Attendance] 
								SET OfficeInTime =  @InTime,
									OfficeOutTime = @OutTime,
									DefaultLITime = @DefaultLateInTime,
									DefaultEOTime = @DefaultEarlyOutTime,
									DayType =  @DayType,
									UpdateBy =  @AddBy,
									UpdateDate = GETDATE()
						WHERE CalanderDetailsId =  @CalenderDetailsId
					END
				END

				SET @Counter = @Counter +1 
			END

		--SELECT ID,CalendarDate,DateNameString  FROM #date2
	--SELECT @MaxId



		--SELECT * FROM [dbo].[Att_EmpAcademicCalendar] 	SELECT * FROM #WeekDays
		DROP TABLE #date2
		DROP TABLE #WeekDays
	COMMIT;  
END TRY
BEGIN Catch
	  ROLLBACK TRANSACTION 
	    DECLARE @ErrorMessage NVARCHAR(4000); 
        DECLARE @ErrorSeverity INT; 
        DECLARE @ErrorState INT; 

        SELECT @ErrorMessage = Error_message(), 
               @ErrorSeverity = Error_severity(), 
               @ErrorState = Error_state(); 

        -- Use RAISERROR inside the CATCH block to return error  
        -- information about the original error that caused  
        -- execution to jump to the CATCH block.  
        RAISERROR (@ErrorMessage,-- Message text.  
                   @ErrorSeverity,-- Severity.  
                   @ErrorState -- State.  
        ); 
END Catch
END

 --SELECT [dbo].[DateRange_To_Table] ('2021-01-01','2021-12-31')

/*

SELECT * FROM [dbo].[Att_EmpAcademicCalendar]

*/
