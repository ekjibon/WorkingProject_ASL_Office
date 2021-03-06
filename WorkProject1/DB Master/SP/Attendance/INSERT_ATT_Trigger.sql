USE [ZKT_DB]
GO
/****** Object:  Trigger [dbo].[INSERT_ATT]    Script Date: 11/5/2020 10:53:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[INSERT_ATT]
   ON  [dbo].[CHECKINOUT]
   AFTER  INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @EmpId VARCHAR(50),@AttnTime  DATETIME

	SELECT @EmpId = (SELECT TOP 1 E.EmpBasicInfoID FROM ASL_Office_DB.dbo.Emp_BasicInfo E WHERE E.EmpID = U.BADGENUMBER) , @AttnTime=I.CHECKTIME FROM inserted AS I
				INNER JOIN USERINFO U ON U.USERID= I.USERID

	IF  EXISTS(SELECT EmpId FROM ASL_Office_DB.dbo.Emp_Attendance WHERE EmpId=CAST( @EmpId AS INT) AND CAST(InTime AS DATE)=CAST(@AttnTime AS DATE))
			BEGIN
				DECLARE @Lateminutes int=0,@DefaultLITime int=0,@IsLate int=0,@IsEarlyOut int=0, @AttStatusType VARCHAR(50)
				SELECT  @Lateminutes=DATEDIFF(MINUTE, CAST(OfficeInTime AS TIME), CAST(@AttnTime AS TIME)) , @IsEarlyOut=CASE WHEN CAST( @AttnTime AS TIME(7)) < CAST( OfficeOutTime AS TIME(7)) THEN 1 ELSE 0 END 
				,@AttStatusType=AttStatusType,@DefaultLITime=DefaultLITime FROM ASL_Office_DB.dbo.[Emp_Attendance] WHERE EmpId = CAST( @EmpId AS INT) AND CONVERT(DATE,InTime)=CONVERT(DATE,@AttnTime)
				IF(@Lateminutes>@DefaultLITime )
				BEGIN
					SET @IsLate=1
				END	
				IF(@AttStatusType='P')
				BEGIN
					UPDATE ASL_Office_DB.dbo.Emp_Attendance SET	 IsPresent=1,InTime=@AttnTime,IsLate= @IsLate,AttStatusType='A'
						,SoftwareResult = (CASE WHEN @IsLate=1 THEN 'LI' ELSE NULL END)
						,Remarks = (CASE WHEN @IsLate=1 THEN 'LI' ELSE NULL END)
					WHERE EmpId=CAST( @EmpId AS INT) AND CAST(InTime AS DATE)=CAST(@AttnTime AS DATE)
				END
				ELSE
				BEGIN
				UPDATE ASL_Office_DB.dbo.Emp_Attendance
					SET Remarks=SoftwareResult,
						SoftwareResult =  NULL
					WHERE EmpId=CAST( @EmpId AS INT) AND CAST(InTime AS DATE)=CAST(@AttnTime AS DATE)

				UPDATE ASL_Office_DB.dbo.Emp_Attendance SET	 OutTime=@AttnTime,IsEarlyOut= @IsEarlyOut
					,SoftwareResult = (CASE 
											WHEN @IsEarlyOut=1 AND IsLate = 1   THEN 'LI,EO'										
											WHEN @IsEarlyOut=1 AND IsLate = 0   THEN  'EO' 
											WHEN @IsEarlyOut=0 AND IsLate = 1    THEN 'LI'

										ELSE NULL END)
					WHERE EmpId=CAST( @EmpId AS INT) AND CAST(InTime AS DATE)=CAST(@AttnTime AS DATE)
				END

			END	
		   --ASL_Office_DB_test Insert Update Attendance
		 --  SET  @EmpId='';
		 --  SELECT @EmpId = (SELECT TOP 1 E.EmpBasicInfoID FROM ASL_Office_DB_test.dbo.Emp_BasicInfo E WHERE E.EmpID = U.BADGENUMBER) , @AttnTime=I.CHECKTIME FROM inserted AS I
			--	INNER JOIN USERINFO U ON U.USERID= I.USERID
		 -- IF  EXISTS(SELECT EmpId FROM ASL_Office_DB_test.dbo.Emp_Attendance WHERE EmpId=CAST( @EmpId AS INT) AND CAST(InTime AS DATE)=CAST(@AttnTime AS DATE))
			--BEGIN
			--	DECLARE @LateminutesT int=0,@DefaultLITimeT int=0,@IsLateT int=0,@IsEarlyOutT int=0, @AttStatusTypeT VARCHAR(50)
			--	SELECT @LateminutesT=DATEDIFF(MINUTE, CAST(OfficeInTime AS TIME), CAST(@AttnTime AS TIME)) , @IsEarlyOutT=CASE WHEN CAST( @AttnTime AS TIME(7)) < CAST( OfficeOutTime AS TIME(7)) THEN 1 ELSE 0 END 
			--	,@AttStatusTypeT=AttStatusType,@DefaultLITimeT=DefaultLITime FROM ASL_Office_DB_test.dbo.[Emp_Attendance] WHERE EmpId = CAST( @EmpId AS INT) AND CONVERT(DATE,InTime)=CONVERT(DATE,@AttnTime)
			--	IF(@LateminutesT>@DefaultLITimeT )
			--	BEGIN
			--	 SET @IsLateT=1
			--	END		
			--	IF(@AttStatusType='P')
			--	BEGIN
			--		UPDATE ASL_Office_DB_test.dbo.Emp_Attendance SET	 IsPresent=1,InTime=@AttnTime,IsLate= @IsLateT,AttStatusType='A'
			--		,SoftwareResult = (CASE WHEN @IsLateT=1 THEN 'LI' ELSE NULL END)
			--		,Remarks = (CASE WHEN @IsLateT=1 THEN 'LI' ELSE NULL END)
			--		WHERE EmpId=CAST( @EmpId AS INT) AND CAST(InTime AS DATE)=CAST(@AttnTime AS DATE)
					
			--	END
			--	ELSE
			--	BEGIN
			--	UPDATE ASL_Office_DB_test.dbo.Emp_Attendance
			--		SET Remarks=SoftwareResult,
			--			SoftwareResult =  NULL
			--		WHERE EmpId=CAST( @EmpId AS INT) AND CAST(InTime AS DATE)=CAST(@AttnTime AS DATE)

			--		UPDATE ASL_Office_DB_test.dbo.Emp_Attendance SET	 OutTime=@AttnTime,IsEarlyOut= @IsEarlyOutT
			--		,SoftwareResult = (CASE 
			--								WHEN @IsEarlyOutT=1 AND IsLate = 1   THEN 'LI,EO'										
			--								WHEN @IsEarlyOutT=1 AND IsLate = 0   THEN  'EO' 
			--								WHEN @IsEarlyOutT=0 AND IsLate = 1    THEN 'LI'

			--							ELSE NULL END)
			--		WHERE EmpId=CAST( @EmpId AS INT) AND CAST(InTime AS DATE)=CAST(@AttnTime AS DATE)

					
			--	END

			--END	
    -- Insert statements for trigger here

END
