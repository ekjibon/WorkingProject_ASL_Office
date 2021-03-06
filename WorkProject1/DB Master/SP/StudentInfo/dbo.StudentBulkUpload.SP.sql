/****** Object:  StoredProcedure [dbo].[StudentBulkUpload]    Script Date: 7/22/2017 4:49:13 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[StudentBulkUpload]'))
BEGIN
DROP PROCEDURE  StudentBulkUpload
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO    
Create PROCEDURE [dbo].[StudentBulkUpload]
	@SessionId INT,
	@BranchID INT,
	@ShiftID INT ,
	@ClassId INT,
	
	@SectionId INT,

	@HouseId INT,
	@RollNo INT,
	@FullName varchar(50) ,
	@FatherName varchar(50) ,
	@MotherName varchar(50) ,
	@AddmissionDate varchar(50)=null ,
	@SMSNotificationNo varchar(50)
	,@AddBy varchar(500)
	
AS
--sp_GetStudentIDForSP 1,10,8,3,20,0,82,1,0,'SCHOOL',''
BEGIN TRY  --   StudentBulkUpload 1,10,8,3,20,0,82,1,0,1,'ABDULLAH','MD. ATAUR RAHMAN','AIRIN AKTER',' ','01969292356',' admin'
print 'START ID GENERATE'
DECLARE @Ins_ID VARCHAR(50), @IID INT = 0;
		EXEC  [dbo].[sp_GetStudentIDForSP] @SessionId,@BranchID,@ShiftID,@ClassId,@SectionId,@HouseID,'SCHOOL', @Ins_ID output
	SELECT @Ins_ID = RTRIM(LTRIM(@Ins_ID))
		print 'STUDENT ID : '+ @Ins_ID 
	--print RTRIM(LTRIM(@Ins_ID))
	
	IF NOT EXISTS(SELECT StudentIID FROM Student_BasicInfo WHERE LTRIM(RTRIM(StudentInsID)) = LTRIM(RTRIM(@Ins_ID))) AND @Ins_ID IS NOT NULL

	BEGIN
	print'START SAVE OPERATION'
	--print'SectionId :'+CONVERT(varchar,@SectionId)
	IF NOT EXISTS(SELECT StudentIID FROM Student_BasicInfo WHERE RollNo = @RollNo AND FullName= LTRIM(RTRIM(@FullName)) AND SectionId=@SectionId)
		BEGIN
		print'BEGIN SAVE OPERATION'
		INSERT INTO [dbo].[Student_BasicInfo]
			   ([SessionId],[ClassId],[BranchID],[ShiftID],SectionId,[RollNo],[StudentInsID]
			   ,[FullName],AdmissionDate,[SMSNotificationNo],FatherName,MotherName,
				DateOfBirth,Age
			   ,[StudentTypeID]
			   ,[HouseID],AddmissionEntryType,AddmissionStatus,IsDeleted,[Status],FirstAdmittedDate,AddBy,AddDate)
		 VALUES
			   (@SessionId,@ClassId,@BranchID ,@ShiftID,@SectionId,@RollNo,@Ins_ID
			   ,@FullName
			   ,(CASE WHEN @AddmissionDate='' THEN null ELSE CONVERT(datetime,@AddmissionDate) END)
			   ,(CASE WHEN @SMSNotificationNo='' THEN null ELSE @SMSNotificationNo END)
			   , (CASE WHEN @FatherName='' THEN null ELSE @FatherName END)
			   , (CASE WHEN @MotherName='' THEN null ELSE @MotherName END)
			   ,null,null
			   ,2 
			   ,@HouseId,'GN','N',0,'A',null,@AddBy,GETDATE())
		END
		ELSE 
		BEGIN
			SET @IID =  0
			RAISERROR('Full Name And Roll Duplicated',16,1) rollback;
		END
	   SET @IID =  @@IDENTITY
	END
	SELECT @IID AS IID
    -- RAISERROR with severity 11-19 will cause execution to   
    -- jump to the CATCH block.  
    --RAISERROR ('Error raised in TRY block.', -- Message text.  
    --           16, -- Severity.  
    --           1 -- State.  
    --           );  
END TRY  
BEGIN CATCH  
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