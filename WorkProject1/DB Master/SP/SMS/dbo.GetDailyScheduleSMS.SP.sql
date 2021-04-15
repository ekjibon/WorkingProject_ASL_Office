/****** Object:  StoredProcedure [dbo].[ProccessMarks]    Script Date: 7/22/2017 @GrandExamId:26:07 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GetDailyScheduleSMS]'))
BEGIN
DROP PROCEDURE  GetDailyScheduleSMS
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetDailyScheduleSMS] --- GetDailyScheduleSMS 17
@ConfigId INT 
AS
BEGIN
	DECLARE @SMS VARCHAR(1000) , @CType VARCHAR(5) , @Cate INT , @Reciver VARCHAR(1000)


	CREATE TABLE #temp
	(
		IID BIGINT NULL,
		SMSNotificationNo VARCHAR(20),
		SMSBody VARCHAR(1000)
		
		
	)
	-- Get Config 
	SELECT @SMS =  Body , @Reciver = Recipent, @CType = [Type] , @Cate = CategoryId FROm SMS_ScheduleSMSConfig WHERE ConfigId =@ConfigId AND Status = 'A'
	
	
	SELECT value  INTO #Recivr FROM STRING_SPLIT(@Reciver, ',')  

	--SELECT * FROM #Recivr

	IF(@SMS = '' OR @SMS IS NULL)
	BEGIN
		SELECT * FROM #temp
		RETURN 
	END

	IF(@CType='A')
	BEGIN
	INSERT INTO #temp
	SELECT S.StudentIID,S.SMSNotificationNo, REPLACE(REPLACE(REPLACE(@SMS,'[StudentName]',S.FullName),'[Roll]',S.RollNo),'[StudentID]',S.StudentInsID)	
		AS SmsBody FROM Student_BasicInfo S
		 WHERE S.DateOfBirth IS NOT NULL AND CAST(S.DateOfBirth AS DATE) = CAST(GETDATE() AS DATE)
	END

	IF(@CType='S' AND @Cate = 1) --- 1 = Daily Fees Collection
	BEGIN
	
	DECLARE @TotalCollection DECIMAL(10,2) = 15.02

	INSERT INTO #temp
	SELECT  0,R.value,  REPLACE(@SMS,'[TotalCollection]',@TotalCollection)  
	FROM #Recivr R

	END

	IF(@CType='S' AND @Cate = 2) --- 2 = Daily Accounts
	BEGIN

	DECLARE  @TotalIncome DECIMAL(10,2) = 0,  @TotalExpense DECIMAL(10,2) = 0,  @HeadName DECIMAL(10,2) = 0 , @HeadIncome DECIMAL(10,2) = 0

	INSERT INTO #temp
	SELECT  0,R.value,  REPLACE(REPLACE(@SMS,'[TotalIncome]',@TotalIncome),'[TotalExpense]',@TotalExpense)  
	FROM #Recivr R

	END

	IF(@CType='S' AND @Cate = 3) --- 3 = Student Attendance summary
	BEGIN

	INSERT INTO #temp
	SELECT S.StudentIID,S.SMSNotificationNo, REPLACE(REPLACE(REPLACE(@SMS,'[StudentName]',S.FullName),'[Roll]',S.RollNo),'[StudentID]',S.StudentInsID)	
		AS SmsBody FROM Student_BasicInfo S
		 WHERE S.DateOfBirth IS NOT NULL AND CAST(S.DateOfBirth AS DATE) = CAST(GETDATE() AS DATE)
	END

	IF(@CType='S' AND @Cate = 4) --- 4 = Employee attendance summary
	BEGIN
	INSERT INTO #temp
	SELECT S.StudentIID,S.SMSNotificationNo, REPLACE(REPLACE(REPLACE(@SMS,'[StudentName]',S.FullName),'[Roll]',S.RollNo),'[StudentID]',S.StudentInsID)	
		AS SmsBody FROM Student_BasicInfo S
		 WHERE S.DateOfBirth IS NOT NULL AND CAST(S.DateOfBirth AS DATE) = CAST(GETDATE() AS DATE)
	END

	IF(@CType='S' AND @Cate = 5) --- 5 =Employee Leave summary
	BEGIN
	INSERT INTO #temp
	SELECT S.StudentIID,S.SMSNotificationNo, REPLACE(REPLACE(REPLACE(@SMS,'[StudentName]',S.FullName),'[Roll]',S.RollNo),'[StudentID]',S.StudentInsID)	
		AS SmsBody FROM Student_BasicInfo S
		 WHERE S.DateOfBirth IS NOT NULL AND CAST(S.DateOfBirth AS DATE) = CAST(GETDATE() AS DATE)
	END





	SELECT * FROM #temp
	DROP TABLE #temp


END
   --  GetDailyScheduleSMS  1
	