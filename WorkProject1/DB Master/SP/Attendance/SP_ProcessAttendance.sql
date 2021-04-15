IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SP_ProcessAttendance]'))
BEGIN
DROP PROCEDURE  SP_ProcessAttendance
END
GO
/****** Object:  StoredProcedure [dbo].[SP_ProcessAttendance]    Script Date:14/02/2021 3:41:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


  -- EXEC SP_ProcessAttendance 2,0,0,0,0,15,'','','2021-03-03 00:00:00.000','2021-03-03 00:00:00.000','Admin'
CREATE PROCEDURE [dbo].SP_ProcessAttendance
@Block INT,
@BranchId INT ,
@CategoryId INT ,
@DepartmentId INT ,
@DesignationId INT,
@EmpId INT ,
@AttDeviceId VARCHAR(200),
@Date VARCHAR(200),
@FromDate VARCHAR(200),
@ToDate VARCHAR(200),
@UserName VARCHAR(300)

AS
BEGIN
BEGIN try

Begin transaction	
		Declare  @Row INT =1, @Max INT=0,@count INT = 1,@MaxDate INT = 0

			--RETURN;
			CREATE TABLE #TempAttendance 
			(
				Id INT IDENTITY(1,1),
				EmpId VARCHAR(50)
			)
		CREATE TABLE #calendarDate
			(
				ID INT IDENTITY (1,1) NOT NULL,
				CalendarDate DATETIME,
				DateNameString NVARCHAR(25)
			)
			INSERT INTO #calendarDate select datestring ,DateNameString from DateRange_To_Table(CAST(CAST(@FromDate AS DATETIME) AS NVARCHAR(50)),CAST(CAST(@ToDate AS DATETIME) AS NVARCHAR(50)))
			--SELECT * FROM #calendarDate
			SET @MaxDate =  @@ROWCOUNT
			--RETURN;
		--Insert Log data
		INSERT INTO [dbo].[Att_AttendanceLog]([LogType], [LogStatus], [Description], [LogDate], [UserId], [IsDeleted], [AddBy], [AddDate])
		VALUES('Attendance Process','Attendance Process successfully','Attendance Process by SP',GETDATE(),@UserName,0,@UserName,GETDATE())

		--Update attendance status
		UPDATE ED SET ED.AttStatusType='P' 
		FROM Emp_Attendance  ED 
		INNER JOIN Emp_BasicInfo EMP ON ED.EmpId = EMP.EmpBasicInfoID 
		INNER JOIN dbo.Att_EmpAcademicCalendarDetails ECD ON ECD.Id =  ED.CalanderDetailsId
		WHERE   EMP.BranchID=CASE WHEN @BranchId<>0 THEN @BranchId ELSE EMP.BranchID END
				AND EMP.CategoryID=CASE WHEN @CategoryId<>0 THEN @CategoryId ELSE EMP.CategoryID END
				AND EMP.DepartmentID=CASE WHEN @DepartmentId<>0 THEN @DepartmentId ELSE EMP.DepartmentID END
				AND EMP.DesignationID=CASE WHEN @DesignationId<>0 THEN @DesignationId ELSE EMP.DesignationID END
				AND EMP.EmpBasicInfoID=CASE WHEN @EmpId<>0 THEN @EmpId ELSE EMP.EmpBasicInfoID END
				AND CAST(ECD.CalendarDate as date) IN (SELECT CAST(CalendarDate as date) FROM #calendarDate)
				AND ED.IsChangedStatus=0 AND ED.IsApproved=0
		--Insert Temp table
		INSERT INTO #TempAttendance( EmpId)
		SELECT EMP.EmpBasicInfoID FROM  Emp_BasicInfo EMP 
		WHERE   EMP.BranchID=CASE WHEN @BranchId<>0 THEN @BranchId ELSE EMP.BranchID END
				AND EMP.CategoryID=CASE WHEN @CategoryId<>0 THEN @CategoryId ELSE EMP.CategoryID END
				AND EMP.DepartmentID=CASE WHEN @DepartmentId<>0 THEN @DepartmentId ELSE EMP.DepartmentID END
				AND EMP.DesignationID=CASE WHEN @DesignationId<>0 THEN @DesignationId ELSE EMP.DesignationID END
				AND EMP.EmpBasicInfoID=CASE WHEN @EmpId<>0 THEN @EmpId ELSE EMP.EmpBasicInfoID END
				
		
		SET @Max= @@ROWCOUNT

		WHILE(@Row <= @Max)
		BEGIN

		DECLARE @Att_EmpId VARCHAR(50)
		SELECT @Att_EmpId = EmpId  FROM #TempAttendance WHERE Id= @Row
			SET @count =  1;
			WHILE (@count<=@MaxDate)
			BEGIN
				DECLARE @CalendarDate DATETIME = NULL,@FAttnTime   DATETIME = NULL,@SAttnTime  DATETIME = NULL,@CalenderDetailsID INT = 0
				SELECT @CalendarDate = CAST(CalendarDate as date) FROM #calendarDate WHERE ID =  @count

				SELECT   TOP (1) @FAttnTime = CHECKTIME FROM Emp_DeviceAttendance WHERE EmpId = @Att_EmpId AND CAST(CHECKTIME AS DATE) = CAST(@CalendarDate AS DATE) ORDER BY Id ASC
				SELECT   TOP (1) @SAttnTime = CHECKTIME FROM Emp_DeviceAttendance WHERE EmpId = @Att_EmpId AND CAST(CHECKTIME AS DATE) = CAST(@CalendarDate AS DATE) ORDER BY Id DESC

				SELECT @CalenderDetailsID = Id FROM dbo.Att_EmpAcademicCalendarDetails WHERE CAST(CalendarDate AS DATE) =  CAST(@FAttnTime AS DATE)
				
				PRINT 'EMP>>' + CAST( @Att_EmpId AS VARCHAR)
				PRINT '@CalenderDetailsID>>' + CAST( @CalenderDetailsID AS VARCHAR)
				IF  EXISTS(SELECT EmpId FROM [dbo].Emp_Attendance WHERE EmpId=CAST( @Att_EmpId AS INT) AND CalanderDetailsId = @CalenderDetailsID AND IsChangedStatus=0 AND IsApproved=0)
						BEGIN
							DECLARE @Lateminutes int=0,@DefaultLITime int=0,@IsLate int=0,@IsEarlyOut int=0, @AttStatusType VARCHAR(50)

							SELECT  @Lateminutes=DATEDIFF(MINUTE, CAST(OfficeInTime AS TIME), CAST(@FAttnTime AS TIME)) , 
									@IsEarlyOut=CASE WHEN CAST( @FAttnTime AS TIME(7)) < CAST( OfficeOutTime AS TIME(7)) THEN 1 ELSE 0 END 
									,@AttStatusType=AttStatusType,@DefaultLITime=DefaultLITime 
									FROM [dbo].[Emp_Attendance] 
									WHERE EmpId = CAST( @Att_EmpId AS INT) AND CalanderDetailsId = @CalenderDetailsID

							IF(@Lateminutes>@DefaultLITime )
							BEGIN
								SET @IsLate=1
							END	
				
						
							IF(@AttStatusType='P')
							BEGIN
								UPDATE [dbo].Emp_Attendance SET	 IsPresent=1,InTime=@FAttnTime,IsLate= @IsLate,AttStatusType='A',SoftwareResult = NULL
								WHERE EmpId=CAST( @Att_EmpId AS INT) AND CalanderDetailsId = @CalenderDetailsID

								UPDATE [dbo].Emp_Attendance SET	 
								SoftwareResult = (CASE 
													WHEN IsLate=1 AND IsPresent=1 AND SoftwareResult IS  NULL THEN 'LI' 
													WHEN IsLate=1 AND IsPresent=1 AND SoftwareResult IS NOT NULL THEN 'LI' 
													WHEN IsPresent=0 AND SoftwareResult IS  NULL THEN 'Absent' 
													WHEN IsPresent=0 AND SoftwareResult IS NOT NULL THEN SoftwareResult +',Absent' 
													WHEN IsLeave=1 AND SoftwareResult IS NOT NULL THEN SoftwareResult + ',Leave' 
													WHEN IsLeave=1 AND IsPresent=0 AND SoftwareResult IS NULL THEN  'Leave' 
													ELSE SoftwareResult END)
								WHERE EmpId=CAST( @Att_EmpId AS INT) AND CalanderDetailsId = @CalenderDetailsID AND IsChangedStatus = 0
							END
							--- Second Row Update

							IF(@SAttnTime IS NOT NULL )
							BEGIN
							DECLARE @SLateminutes int=0,@SDefaultLITime int=0,@SIsLate int=0,@SIsEarlyOut int=0

							SELECT @CalenderDetailsID = Id FROM dbo.Att_EmpAcademicCalendarDetails WHERE CAST(CalendarDate AS DATE) =  CAST(@SAttnTime AS DATE)

							SELECT  @SLateminutes=DATEDIFF(MINUTE, CAST(OfficeInTime AS TIME), CAST(@SAttnTime AS TIME)) , 
									@SIsEarlyOut=CASE WHEN CAST( @SAttnTime AS TIME(7)) < CAST( OfficeOutTime AS TIME(7)) THEN 1 ELSE 0 END 
									,@SDefaultLITime=DefaultLITime 
									FROM [dbo].[Emp_Attendance] WHERE EmpId = CAST( @Att_EmpId AS INT) 
									AND CalanderDetailsId = @CalenderDetailsID
			
								UPDATE [dbo].Emp_Attendance SET	 OutTime=@SAttnTime,IsEarlyOut= @SIsEarlyOut
								WHERE EmpId=CAST( @Att_EmpId AS INT) AND CalanderDetailsId = @CalenderDetailsID

								UPDATE [dbo].Emp_Attendance SET	 OutTime=@SAttnTime,IsEarlyOut= @SIsEarlyOut
											,SoftwareResult = (CASE 
														WHEN IsEarlyOut=1 AND SoftwareResult IS NULL  THEN 'EO' 
														WHEN IsEarlyOut=1  AND SoftwareResult IS NOT NULL 
														AND( CHARINDEX('EO', SoftwareResult) = 0 OR CHARINDEX('EO', SoftwareResult) IS NULL)   THEN SoftwareResult + ',EO' 
														WHEN IsEarlyOut=1 AND SoftwareResult IS NOT NULL AND IsLeave = 1   THEN SoftwareResult + ',EO,Leave' 
														WHEN IsLeave=1 AND SoftwareResult IS NULL  THEN 'Leave' 
														WHEN IsLeave=1 AND SoftwareResult IS NOT NULL   THEN SoftwareResult + ',Leave'
														WHEN IsPresent=0 AND SoftwareResult IS NOT NULL   THEN SoftwareResult + ',Absent' 
														WHEN IsPresent=0 AND SoftwareResult IS NULL   THEN SoftwareResult + 'Absent' 
													ELSE SoftwareResult END)
								WHERE EmpId=CAST( @Att_EmpId AS INT) AND CalanderDetailsId = @CalenderDetailsID AND IsChangedStatus = 0
							END

						END

				SET @count = @count + 1;
			END
		
			
		SET @Row = @Row + 1
		END
		DROP TABLE #TempAttendance
		DROP TABLE #calendarDate
		commit transaction
	print 'Successfully commited....'
	END TRY  
	BEGIN CATCH  
	rollback transaction
		DECLARE @ErrorMessage NVARCHAR(4000);  
		DECLARE @ErrorSeverity INT;  
		DECLARE @ErrorState INT;  
  
		SELECT   
			@ErrorMessage = ERROR_MESSAGE(),  
			@ErrorSeverity = ERROR_SEVERITY(),  
			@ErrorState = ERROR_STATE();  
		-- Use RAISERROR inside the CATCH block to return error  
		-- information about the original error that caused  
		-- execution to jump to the CATCH block.  
		RAISERROR (@ErrorMessage, -- Message text.  
				   @ErrorSeverity, -- Severity.  
				   @ErrorState -- State.  
				   );  
		END CATCH; 
	
END
