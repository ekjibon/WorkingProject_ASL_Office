/****** Object:  StoredProcedure [dbo].[GetStudentInfoByFilter]    Script Date: 7/22/2017 4:15:28 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[StudentBulkUpdate]'))
BEGIN
DROP PROCEDURE  StudentBulkUpdate
END
GO
SET ANSI_NULLS ON 
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[StudentBulkUpdate]
	@Roll VARCHAR(20),
	@Name			   VARCHAR(100),
	@Ins_ID VARCHAR(50),
	@Cur_ID VARCHAR(50),
	@DOB			   VARCHAR(50),
	@M_Name			   VARCHAR(20),
	@M_Mobile		   VARCHAR(20),
	@M_Email		   VARCHAR(50),
	@F_Name			   VARCHAR(200),
	@F_Mobile		   VARCHAR(20),
	@F_Email		   VARCHAR(50),
	@Pre_Address	   VARCHAR(200),
	@Pre_PostOffice	   VARCHAR(100),
	@Pre_PostCode	   VARCHAR(100),
	@Par_Address	   VARCHAR(020),
	@Par_PostOffice	   VARCHAR(100),
	@Par_PostCode	   VARCHAR(20),
	@AdmissionDate     VARCHAR(50),
	@SMS_Noti		   VARCHAR(20),
	@Height			   VARCHAR(20),
	@Weight			   VARCHAR(20),
	@F_TIN_No		   VARCHAR(20),
	@F_NID			   VARCHAR(20),
	@F_Passport		   VARCHAR(20),
	@M_TIN_No		   VARCHAR(20),
	@M_NID			   VARCHAR(20),
	@M_Passport		   VARCHAR(20),

	@L_Guardian_Name   VARCHAR(200),
	@L_Relation        VARCHAR(20),
	@L_Mobile		   VARCHAR(20),
	@L_Email		   VARCHAR(50),
	@L_Address		   VARCHAR(200),

	@L2_Guardian_Name   VARCHAR(200),
	@L2_Relation        VARCHAR(20),
	@L2_Mobile		   VARCHAR(20),
	@L2_Email		   VARCHAR(50),
	@L2_Address		   VARCHAR(200),

	@L3_Guardian_Name   VARCHAR(200),
	@L3_Relation        VARCHAR(20),
	@L3_Mobile		   VARCHAR(20),
	@L3_Email		   VARCHAR(50),
	@L3_Address		   VARCHAR(200),

	@L4_Guardian_Name   VARCHAR(200),
	@L4_Relation        VARCHAR(20),
	@L4_Mobile		   VARCHAR(20),
	@L4_Email		   VARCHAR(50),
	@L4_Address		   VARCHAR(200),

	--@Age	           VARCHAR(20),
	@UpdateBy          VARCHAR(200)
AS
BEGIN
	DECLARE @IID BIGINT 
	SELECT @IID = StudentIID FROM  dbo.Student_BasicInfo WHERE StudentInsID = @Ins_ID
	
	UPDATE [dbo].[Student_BasicInfo]
   SET 
      [RollNo] = @Roll
	  ,[CurrentStudentId] = @Cur_ID 
      ,[FullName] = @Name
      ,[FatherName] = @F_Name
      ,[MotherName] = @M_Name
      ,[SMSNotificationNo] = @SMS_Noti
      ,[DateOfBirth] = (CASE WHEN @DOB='' THEN null ELSE CONVERT(datetime,@DOB) END) 
      ,[Age] = (CASE WHEN @DOB='' THEN null ELSE (YEAR(GETDATE())-YEAR(CONVERT(datetime,@DOB))) END) 
      --,[TransportFacility] = @Transport
      ,[Height] = @Height
      ,[Weight] = @Weight
      ,[AdmissionDate] =(CASE WHEN @AdmissionDate='' THEN null ELSE CONVERT(datetime,@AdmissionDate) END) 
      ,[UpdateBy] = @UpdateBy
      ,[UpdateDate] = GETDATE()
 WHERE StudentIID =  @IID  AND Status= 'A'

 IF NOT EXISTS(SELECT StudentIID from Student_GuardianInfo WHERE StudentIID = @IID)
	 BEGIN
		INSERT INTO [dbo].[Student_GuardianInfo]
           ( StudentIID, [F_Mobile],[F_Email],[F_TIN],[F_NIDNo],[F_PassportNo]
			,[M_Mobile],[M_Email],[M_TIN],[M_NIDNo],[M_PassportNo]
			,[LG_Name],[LG_Relation],[LG_Address],[LG_Mobile],[LG_Email]
			,[LG2_Name],[LG2_Relation],[LG2_Address],[LG2_Mobile],[LG2_Email]
			,[LG3_Name],[LG3_Relation],[LG3_Address],[LG3_Mobile],[LG3_Email]
			,[LG4_Name],[LG4_Relation],[LG4_Address],[LG4_Mobile],[LG4_Email]
			,AddBy,AddDate,IsDeleted)

	 VALUES(   @IID,@F_Mobile,@F_Email,@F_TIN_No,@F_NID,@F_Passport,
				@M_Mobile,@M_Email,@M_TIN_No,@M_NID,@M_Passport,
				@L_Guardian_Name,@L_Relation,@L_Address,@L_Mobile,@L_Email,
				@L2_Guardian_Name,@L2_Relation,@L2_Address,@L2_Mobile,@L2_Email,
				@L3_Guardian_Name,@L3_Relation,@L3_Address,@L3_Mobile,@L3_Email,
				@L4_Guardian_Name,@L4_Relation,@L4_Address,@L4_Mobile,@L4_Email,
				@UpdateBy,GETDATE(),0)
	 END
 ELSE
	BEGIN
		UPDATE Student_GuardianInfo SET 
				[F_Mobile] = @F_Mobile,[F_Email]=@F_Email,[F_TIN]=@F_TIN_No,[F_NIDNo]=@F_NID,[F_PassportNo]=@F_Passport
			,[M_Mobile]=@M_Mobile,[M_Email]=@M_Email,[M_TIN]=@M_TIN_No,[M_NIDNo]=@M_NID,[M_PassportNo]=@M_Passport
			,[LG_Name]=@L_Guardian_Name,[LG_Relation]=@L_Relation,[LG_Address]=@L_Address,[LG_Mobile]=@L_Mobile,[LG_Email]=@L_Email
			,[LG2_Name]=@L2_Guardian_Name,[LG2_Relation]=@L2_Relation,[LG2_Address]=@L2_Address,[LG2_Mobile]=@L2_Mobile,[LG2_Email]=@L2_Email
			,[LG3_Name]=@L3_Guardian_Name,[LG3_Relation]=@L3_Relation,[LG3_Address]=@L3_Address,[LG3_Mobile]=@L3_Mobile,[LG3_Email]=@L3_Email
			,[LG4_Name]=@L4_Guardian_Name,[LG4_Relation]=@L4_Relation,[LG4_Address]=@L4_Address,[LG4_Mobile]=@L4_Mobile,[LG4_Email]=@L4_Email
			,UpdateBy = @UpdateBy , UpdateDate= GETDATE()

		WHERE StudentIID = @IID
	END
	IF NOT EXISTS(SELECT StudentIID from Student_ContactInfo WHERE StudentIID = @IID)
	 BEGIN
		INSERT INTO Student_ContactInfo
			   ([StudentIID],[Pre_PSId],[Pre_DisId],[Pre_Address],[Pre_PostOffice],[Pre_PostalCode],[Par_PSId],[Par_DisId],[Par_Address],[Par_PostOffice],[Par_PostalCode]
				,[IsDeleted],[AddBy],[AddDate])
	 VALUES(@IID,0,0,@Pre_Address,@Pre_PostOffice,@Pre_PostCode,0,0,@Par_Address,@Par_PostOffice,@Par_PostCode,0,@UpdateBy,GETDATE())
	 END
 ELSE
	BEGIN
		UPDATE Student_ContactInfo SET 
				Pre_Address = @Pre_Address,
				Pre_PostOffice=@Pre_PostOffice,
				Pre_PostalCode=@Pre_PostCode,
				Par_Address = @Par_Address,
				Par_PostOffice=@Par_PostOffice,
				Par_PostalCode=@Par_PostCode
		WHERE StudentIID = @IID
	END
 SELECT @IID


END
