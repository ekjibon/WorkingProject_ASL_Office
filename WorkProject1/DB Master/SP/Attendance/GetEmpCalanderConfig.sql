IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetEmpCalanderConfig]'))
BEGIN
DROP PROCEDURE  GetEmpCalanderConfig
END
GO
/****** Object:  StoredProcedure [dbo].[GetEmpCalanderConfig]    Script Date:17/11/2020 3:41:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- EXEC GetEmpCalanderConfig 2,36,2022,1,15,74477,'','23:24:00',''
CREATE PROCEDURE [dbo].GetEmpCalanderConfig
@Block INT,
@CalanderId INT ,
@Year INT ,
@Month INT ,
@EmpId INT,
@AttId INT ,
@DayType VARCHAR(200),
@InTime TIME(7),
@OutTime TIME(7),
@BranchId INT,
@CalendarDetailsId INT =0
AS
BEGIN
	IF(@Block=1)
	BEGIN
		SELECT EB.EmpID AS EmpBasicId,EB.FullName,EA.EmpId,EA.AttendId,ECD.CalendarDate,ECD.DayType AS OfficeDay
			,DATENAME(WEEKDAY,ECD.CalendarDate) AS [DayName],EA.DayType AS AttDayType,CAST(EA.OfficeInTime AS DATETIME ) AS OfficeInTime
			,CAST(EA.OfficeOutTime AS DATETIME) AS OfficeOutTime
				,EA.AttStatusType
		FROM [dbo].[Emp_Attendance]  EA 
			INNER JOIN dbo.Emp_BasicInfo EB ON EB.EmpBasicInfoID = EA.EmpId
			INNER JOIN [dbo].[Att_EmpAcademicCalendarDetails] ECD ON ECD.Id = EA.CalanderDetailsId	 AND ECD.CalendarId = @CalanderId
		WHERE --AttStatusType = 'P'  AND 
		ECD.Year =  @Year AND  ECD.Month = @Month AND EA.EmpId =  @EmpId

	END
	IF(@Block =2)
	BEGIN
		DECLARE @AttStatus VARCHAR(50) = NULL 
		IF(@DayType='Weekend')
		SET @AttStatus =  'WK'

		UPDATE [dbo].[Emp_Attendance]  SET DayType = (CASE WHEN @DayType IS NULL OR @DayType = '' THEN DayType ELSE @DayType END)
										--,DefaultLateInTime = (CASE WHEN @InTime IS NULL OR @InTime = '' THEN InTime ELSE @InTime END)
										--,DefaultEarlyOutTime = (CASE WHEN @OutTime IS NULL OR @OutTime = '' THEN OutTime ELSE @OutTime END)
										,OfficeInTime = (CASE WHEN @InTime IS NULL OR @InTime = '' THEN InTime ELSE @InTime END)
										,OfficeOutTime = (CASE WHEN @OutTime IS NULL OR @OutTime = '' THEN OutTime ELSE @OutTime END)
										--,AttStatusType =  (CASE WHEN @AttStatus IS NULL  THEN AttStatusType ELSE @AttStatus END)
		WHERE AttendId =  @AttId
		SELECT @@ROWCOUNT AS Updated
				
	END

	IF(@Block =3)
	BEGIN
		IF(@EmpId = 0)
		BEGIN
			UPDATE EA
			SET EA.OfficeInTime = (CASE WHEN @InTime IS NULL OR @InTime = '' THEN EA.OfficeInTime ELSE @InTime END),
			EA.OfficeOutTime = (CASE WHEN @OutTime IS NULL OR @OutTime = '' THEN EA.OfficeOutTime ELSE @OutTime END)
			FROM [dbo].[Emp_Attendance]  EA
			INNER JOIN Emp_BasicInfo EB ON EB.EmpBasicInfoID = EA.EmpId
			INNER JOIN Att_EmpAcademicCalendarDetails EAC ON EAC.Id = EA.CalanderDetailsId
			WHERE EB.BranchID = @BranchId AND EAC.CalendarId = @CalanderId
		END
		
		ELSE
		BEGIN
			IF NOT EXISTS (SELECT * FROM Emp_Attendance WHERE EmpId = @EmpId)
			BEGIN
				--DECLARE @AttStatusType VARCHAR(2) = 'P'

				INSERT INTO Emp_Attendance 
					([EmpId],[InTime],[OutTime],[IsPresent],[IsLeave],[IsDeleted],[CalanderDetailsId],[DayType],
					[OfficeInTime],[OfficeOutTime],[AttStatusType])
				SELECT 
					@EmpId, CD.CalendarDate, NULL,0,0,0,CD.Id,CD.DayType,
					--AC.InTime, AC.OutTime, 'P' 
					@InTime, @OutTime, 'P'
					FROM Att_EmpAcademicCalendar AC 
					INNER JOIN Att_EmpAcademicCalendarDetails CD ON CD.CalendarId = AC.Id
					WHERE CD.CalendarId = @CalanderId
			END

			ELSE
			BEGIN
				UPDATE [dbo].[Emp_Attendance]  SET OfficeInTime = (CASE WHEN @InTime IS NULL OR @InTime = '' THEN InTime ELSE @InTime END),
				OfficeOutTime = (CASE WHEN @OutTime IS NULL OR @OutTime = '' THEN OutTime ELSE @OutTime END)
				WHERE EmpId =  @EmpId
			END
			
		END
		
		SELECT @@ROWCOUNT AS Updated
				
	END

	IF(@Block=4) -- EXEC GetEmpCalanderConfig 4,36,2022,1,15,74477,'','23:24:00','',1987,2022

	BEGIN
		--SELECT 
		--			*
		--			FROM [dbo].[Emp_Attendance] AC 
		--			INNER JOIN Att_EmpAcademicCalendarDetails CD ON CD.Id = AC.CalanderDetailsId
		--			WHERE CD.CalendarId = @CalanderId AND CD.Id = @CalendarDetailsId

		UPDATE EA SET EA.DayType = CD.DayType
			FROM [dbo].[Emp_Attendance]  EA 
			INNER JOIN Att_EmpAcademicCalendarDetails CD ON CD.Id = EA.CalanderDetailsId
			WHERE EA.CalanderDetailsId = @CalendarDetailsId AND EA.AttStatusType = 'P'

		SELECT @@ROWCOUNT AS Updated
	END

	IF(@Block=5)
	BEGIN
		SELECT  * FROM Att_EmpAcademicCalendarDetails ECD
		WHERE ECD.CalendarId = @CalanderId AND ECD.Year =  @Year AND  ECD.Month = @Month 
	END
END

-- EXEC GetEmpCalanderConfig 5,1,2021,1,0,0,'','23:24:00','',1987,2022