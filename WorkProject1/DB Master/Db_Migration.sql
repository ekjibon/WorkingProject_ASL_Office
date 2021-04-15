	
	USE [sef_new_2018]

	IF EXISTS(SELECT * FROM Res_MainExam )
	return;


	--- Version 
	ALTER TABLE [dbo].[Ins_Version] NOCHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Ins_Version] DISABLE TRIGGER ALL
	DELETE FROM [dbo].[Ins_Version]
	DBCC CHECKIDENT ('[dbo].[Ins_Version]',RESEED, 0)
	ALTER TABLE [dbo].[Ins_Version] CHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Ins_Version] ENABLE TRIGGER ALL

	SET IDENTITY_INSERT [dbo].[Ins_Version] ON

	INSERT INTO [dbo].[Ins_Version]([VersionId],[VersionName],[IsActive],[VersionCode],[IsDeleted])
	SELECT  * , 0 FROM [sef_db].dbo.[Tbl_Version]
	
	

	SET IDENTITY_INSERT [dbo].[Ins_Version] OFF

		--- Ins_Session 
	ALTER TABLE [dbo].[Ins_Session] NOCHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Ins_Session] DISABLE TRIGGER ALL
	DELETE FROM [dbo].[Ins_Session]
	DBCC CHECKIDENT ('[dbo].[Ins_Session]',RESEED, 0)
	ALTER TABLE [dbo].[Ins_Session] CHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Ins_Session] ENABLE TRIGGER ALL

	SET IDENTITY_INSERT [dbo].[Ins_Session] ON

	INSERT INTO [dbo].[Ins_Session](SessionId,[SessionName],[SessionCode],[Session_ForSchool],[Session_ForCollege],[Session_ForUniversity],[Session_StartDate],[Session_EndDate],[IsDeleted])
	SELECT  Session_ID,	Session_Name,Session_Code,ISNULL(Session_ForSchool,0), ISNULL( Session_ForCollege ,0),ISNULL(Session_ForUniversity,0), ISNULL(Session_StartDate , GETDATE()),ISNULL(Session_EndDate, GETDATE()),CASE WHEN [Session_Status]='A'THEN 0 ELSE 1 END 
	FROM [sef_db].[dbo].[Tbl_Session]

	SET IDENTITY_INSERT [dbo].[Ins_Session] OFF

		--- Ins_Brnach 
	ALTER TABLE [dbo].[Ins_Branch] NOCHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Ins_Branch] DISABLE TRIGGER ALL
	DELETE FROM [dbo].[Ins_Branch]
	DBCC CHECKIDENT ('[dbo].[Ins_Branch]',RESEED, 0)
	ALTER TABLE [dbo].[Ins_Branch] CHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Ins_Branch] ENABLE TRIGGER ALL

	SET IDENTITY_INSERT [dbo].[Ins_Branch] ON

	INSERT INTO [dbo].[Ins_Branch]([BranchId],[BranchName],[Code] ,[Address],[IsDeleted])
	SELECT Branch_ID,Branch_Name,Branch_Code,Branch_Address,0 FROM [sef_db].[dbo].[Tbl_Branch]

	SET IDENTITY_INSERT [dbo].[Ins_Branch] OFF

		--- Ins_Shift 
	ALTER TABLE [dbo].[Ins_Shift] NOCHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Ins_Shift] DISABLE TRIGGER ALL
	DELETE FROM [dbo].[Ins_Shift]
	DBCC CHECKIDENT ('[dbo].[Ins_Shift]',RESEED, 0)
	ALTER TABLE [dbo].[Ins_Shift] CHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Ins_Shift] ENABLE TRIGGER ALL

	SET IDENTITY_INSERT [dbo].[Ins_Shift] ON

	INSERT INTO [dbo].[Ins_Shift]([ShiftId],[BranchId],[ShiftName],[ShiftCode],[ShiftStartTime],[ShiftEndTime],[IsDeleted])
	SELECT ShiftSetup_ID,ShiftSetup_BranchID,ShiftSetup_Name,ShiftSetup_Code,ShiftSetup_From,ShiftSetup_To,0 
	FROM [sef_db].[dbo].[Tbl_ShiftSetup]

	SET IDENTITY_INSERT [dbo].[Ins_Shift] OFF

	--- Ins_ClassInfo 
	ALTER TABLE [dbo].[Ins_ClassInfo] NOCHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Ins_ClassInfo] DISABLE TRIGGER ALL
	DELETE FROM [dbo].[Ins_ClassInfo]
	DBCC CHECKIDENT ('[dbo].[Ins_ClassInfo]',RESEED, 0)
	ALTER TABLE [dbo].[Ins_ClassInfo] CHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Ins_ClassInfo] ENABLE TRIGGER ALL

	SET IDENTITY_INSERT [dbo].[Ins_ClassInfo] ON

	INSERT INTO [dbo].[Ins_ClassInfo]([ClassId],[VersionId],[ClassName],[CalssCode],[Class_HasGroup],[Class_ForCollege],[DisplayOrder],[IsDeleted])
	SELECT Class_ID,Class_VersionID,Class_Name,Class_Code,Class_HasGroup,Class_ForCollege,1,0 FROM [sef_db].[dbo].[Tbl_Class] WHERE Class_Status = 'A'

	SET IDENTITY_INSERT [dbo].[Ins_ClassInfo] OFF


		 --Group will nothing to migrate it will 0,1,2,3

	--- Ins_Group 
	ALTER TABLE [dbo].[Ins_Group] NOCHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Ins_Group] DISABLE TRIGGER ALL
	DELETE FROM [dbo].[Ins_Group]
	DBCC CHECKIDENT ('[dbo].[Ins_Group]',RESEED, 0)
	ALTER TABLE [dbo].[Ins_Group] CHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Ins_Group] ENABLE TRIGGER ALL

	SET IDENTITY_INSERT [dbo].[Ins_Group] ON

	INSERT INTO [dbo].[Ins_Group]([GroupId],[GroupName],[Group_Code],[Group_Status])
	SELECT Group_ID,Group_Name,Group_Code,Group_Status
	FROM [sef_db].[dbo].[Tbl_Group] --WHERE SectionSetup_Status = 'A'

	SET IDENTITY_INSERT [dbo].[Ins_Group] OFF


						
		--- Ins_Section 
	ALTER TABLE [dbo].[Ins_Section] NOCHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Ins_Section] DISABLE TRIGGER ALL
	DELETE FROM [dbo].[Ins_Section]
	DBCC CHECKIDENT ('[dbo].[Ins_Section]',RESEED, 0)
	ALTER TABLE [dbo].[Ins_Section] CHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Ins_Section] ENABLE TRIGGER ALL

	SET IDENTITY_INSERT [dbo].[Ins_Section] ON

	INSERT INTO [dbo].[Ins_Section]([SectionId],[ClassId],[GroupId],[ShiftId],[SectionName],[SectionCode],[IsDeleted])
	SELECT SectionSetup_ID,SectionSetup_ClassID,SectionSetup_GroupID,1,SectionSetup_Name,SectionSetup_Code,0 
	FROM [sef_db].[dbo].[Tbl_SectionSetup] WHERE SectionSetup_Status = 'A'

	SET IDENTITY_INSERT [dbo].[Ins_Section] OFF

			--- [dbo].[Tbl_House] 
	ALTER TABLE [dbo].[Ins_House] NOCHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Ins_House] DISABLE TRIGGER ALL
	DELETE FROM [dbo].[Ins_House]
	DBCC CHECKIDENT ('[dbo].[Ins_House]',RESEED, 0)
	ALTER TABLE [dbo].[Ins_House] CHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Ins_House] ENABLE TRIGGER ALL

	SET IDENTITY_INSERT [dbo].[Ins_House] ON

	INSERT INTO [dbo].[Ins_House](HouseId,HouseCode,HouseName,[IsDeleted])
	SELECT House_ID,House_Code,House_Name,0 
	FROM [sef_db].[dbo].[Tbl_House] 

	SET IDENTITY_INSERT [dbo].[Ins_House] OFF
		
	
			--- Student Type
	ALTER TABLE [dbo].[Ins_StudentType] NOCHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Ins_StudentType] DISABLE TRIGGER ALL
	DELETE FROM [dbo].[Ins_StudentType]
	DBCC CHECKIDENT ('[dbo].[Ins_StudentType]',RESEED, 0)
	ALTER TABLE [dbo].[Ins_StudentType] CHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Ins_StudentType] ENABLE TRIGGER ALL

	SET IDENTITY_INSERT [dbo].[Ins_StudentType] ON

	INSERT INTO [dbo].[Ins_StudentType](StudentTypeId,StudentTypeName,StudentTypeCode,[IsDeleted])
	SELECT [FeesGroup_ID],[FeesGroup_Name],[FeesGroup_Code],CASE WHEN  [FeesGroup_Status] ='D' THEN 1 ELSE 0 END
	FROM [sef_db].[dbo].[Tbl_FeesGroup] 

	SET IDENTITY_INSERT [dbo].[Ins_StudentType] OFF



		----------------------------------------------------------------------
		---------------------Student Info ------------------------------------

		--- Student_BasicInfo
	ALTER TABLE [dbo].[Student_BasicInfo] NOCHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Student_BasicInfo] DISABLE TRIGGER ALL
	DELETE FROM [dbo].[Student_BasicInfo]
	DBCC CHECKIDENT ('[dbo].[Student_BasicInfo]',RESEED, 0)
	ALTER TABLE [dbo].[Student_BasicInfo] CHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Student_BasicInfo] ENABLE TRIGGER ALL

	SET IDENTITY_INSERT [dbo].[Student_BasicInfo] ON

INSERT INTO [dbo].[Student_BasicInfo]
([StudentIID],[VersionID],[SessionId],[BranchID],[ShiftID],[ClassId],[GroupId],[SectionId],[StudentInsID]
,[RollNo],[RegiNo],[FullName],[NameBangla],[FatherName],[MotherName],[SMSNotificationNo],[DateOfBirth],[Age],[Gender],[Nationality],[Religion],[BloodGroup]

,[PreInsInfoClass],[PreInsInfoSection],[PreInsInfoGroup],[PreInsInfoSession],[PreInsInfoVersion],[PreInsInfoRollNo],[PreInsInfoGPAResult],[PreInsInfoTCNo],[PreInsInfoDate]

,[StudentTypeID],[HouseID],[Quota],TransportFacility,[AdmissionDate],AddmissionEntryType,[IsDeleted],[Status],IsTC)
    

	SELECT StudentInfo_SlNo,StudentInfo_VersionID,StudentInfo_SessionID,StudentInfo_BranchID,StudentInfo_ShiftID,StudentInfo_ClassID,StudentInfo_GroupID,StudentInfo_SectionID,
	StudentInfo_StudentID,dbo.RemoveWhiteSpace(StudentInfo_Roll),RegistrationNo ,StudentInfo_Name,NULL,StudentInfo_FatherName,StudentInfo_MotherName,StudentInfo_SMSNotificationNo,
	StudentInfo_DateofBirth,StudentInfo_Age,StudentInfo_Gender,StudentInfo_Nationality,StudentInfo_Religion,StudentInfo_BloodGroup,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,StudentInfo_FeesGroupID,
	ISNULL(StudentInfo_HouseID,0),NULL,StudentInfo_TransportFacility,StudentInfo_AdmissionDate, CASE WHEN IsNewAdmissionWithTC = 1 THEN 'WT' ELSE 'GN' END,
	CASE WHEN StudentInfo_Status  = 'D'  	THEN 1 
	WHEN StudentInfo_Status  = 'I'  	THEN 1 
	ELSE 0 END,
	StudentInfo_Status,
	0
	
	 FROM [sef_db].[dbo].[Tbl_StudentInformation]

	 --WHERE StudentInfo_Roll = '29n'

	SET IDENTITY_INSERT [dbo].[Student_BasicInfo] OFF

		--- Student_Image -----------------------------------------------------------------------------------
	ALTER TABLE [dbo].[Student_Image] NOCHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Student_Image] DISABLE TRIGGER ALL
	DELETE FROM [dbo].[Student_Image]
	DBCC CHECKIDENT ('[dbo].[Student_Image]',RESEED, 0)
	ALTER TABLE [dbo].[Student_Image] CHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Student_Image] ENABLE TRIGGER ALL

		INSERT INTO [dbo].[Student_Image]
			([StudentIID],[Photo],[ImageName], [IsDeleted])
    
		SELECT StudentInfo_SlNo,[StudentInfo_StuPic],REPLACE( [StudentInfo_Name] , ' ','') ,0
	
		FROM [sef_db].[dbo].[Tbl_StudentInformation]


		--- Student_ContactInfo -----------------------------------------------------------------------------------
	ALTER TABLE [dbo].[Student_ContactInfo] NOCHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Student_ContactInfo] DISABLE TRIGGER ALL
	DELETE FROM [dbo].[Student_ContactInfo]
	DBCC CHECKIDENT ('[dbo].[Student_ContactInfo]',RESEED, 0)
	ALTER TABLE [dbo].[Student_ContactInfo] CHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Student_ContactInfo] ENABLE TRIGGER ALL

	--INSERT into [dbo].[Common_District]([DistrictName]) values ('N/A')	
	--INSERT into [dbo].[Common_PoliceStation] ([DistrictId],[PsName]) values (66, 'N/A')

	
	
	

	INSERT INTO [dbo].[Student_ContactInfo]([StudentIID],[Pre_PSId],[Pre_DisId],[Pre_Address],[Pre_PostOffice],[Pre_PostalCode]
	,[Par_PSId],[Par_DisId],[Par_Address],[Par_PostOffice],[Par_PostalCode],[IsDeleted])
    
	SELECT [StudentInfo_SlNo],538,66,[StudentInfo_PresentAddress],[StudentInfo_PresentPost],'' 
	,538,66,StudentInfo_PermanentAddress,StudentInfo_PermanentPost,'' ,0
	FROM [sef_db].[dbo].[Tbl_StudentInformation] 

	

	
	--- Student_AcademicInfo -----------------------------------------------------------------------------------
	ALTER TABLE [dbo].[Student_AcademicInfo] NOCHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Student_AcademicInfo] DISABLE TRIGGER ALL
	DELETE FROM [dbo].[Student_AcademicInfo]
	DBCC CHECKIDENT ('[dbo].[Student_AcademicInfo]',RESEED, 0)
	ALTER TABLE [dbo].[Student_AcademicInfo] CHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Student_AcademicInfo] ENABLE TRIGGER ALL

	INSERT INTO [dbo].[Student_AcademicInfo]([StudentIID],[ExamName],[InstituteName],[DistrictThana],[PassYear],[ExamSession],
	[ExamRegNo],[ExamRoll],[GPA],[Comment], [IsDeleted])
    SELECT [StudentInfo_SlNo],'PSC',[StudentInfo_PSCSchoolName],[StudentInfo_PSCDistrictandThana],[StudentInfo_PSCYear]
      ,[StudentInfo_PSCSession],[StudentInfo_PSCRegNo],[StudentInfo_PSCRollNo],CAST(ISNULL(CASE WHEN LTRIM(RTRIM( [StudentInfo_PSCGPAMarks]))='' THEN '00.00'  ELSE [StudentInfo_PSCGPAMarks] END,'00.00') AS decimal(4,2)) ,[StudentInfo_PSCComments],	0
	FROM [sef_db].[dbo].[Tbl_StudentInformation] 

	INSERT INTO [dbo].[Student_AcademicInfo]([StudentIID],[ExamName],[InstituteName],[Board],[PassYear],[ExamSession],
	[ExamRegNo],[ExamRoll],[GPA],[Comment], [IsDeleted])
    SELECT [StudentInfo_SlNo],'JSC',[StudentInfo_JSCInstituteName],[StudentInfo_JSCBoard],[StudentInfo_JSCYear]
      ,[StudentInfo_JSCSession],[StudentInfo_JSCRegNo],[StudentInfo_JSCRollNo], CAST(ISNULL(CASE WHEN LTRIM(RTRIM( [StudentInfo_JSCGPAMarks]))='' THEN '00.00'  ELSE [StudentInfo_JSCGPAMarks] END,'00.00') AS decimal(4,2)),[StudentInfo_JSCComments],	0
	FROM [sef_db].[dbo].[Tbl_StudentInformation] 

	INSERT INTO [dbo].[Student_AcademicInfo]([StudentIID],[ExamName],[InstituteName],[InstituteAddress],[Board],[PassYear],[ExamSession],[ExamGroup],
	[ExamRegNo],[ExamRoll],[GPA],[GPAWithOut4thSubject],[Comment], [IsDeleted])
    SELECT [StudentInfo_SlNo],'SSC',[StudentInfo_SSCInstituteName],[StudentInfo_SSCInstituteAdress],[StudentInfo_SSCBoard],[StudentInfo_SSCPassYear]
      ,[StudentInfo_SSCSession],[StudentInfo_SSCGroup],[StudentInfo_SSCRegNo],[StudentInfo_SSCRollNo],CAST(ISNULL(CASE WHEN LTRIM(RTRIM( [StudentInfo_SSCGPAMarks]))='' THEN '00.00'  ELSE [StudentInfo_SSCGPAMarks] END,'00.00') AS decimal(4,2)) ,
	  CAST(ISNULL(CASE WHEN LTRIM(RTRIM( [StudentInfo_SSCGPAMarksWithoutFourth]))='' THEN '00.00'  ELSE [StudentInfo_SSCGPAMarksWithoutFourth] END,'00.00') AS decimal(4,2)),[StudentInfo_SSCComments],	0
	FROM [sef_db].[dbo].[Tbl_StudentInformation] 


	INSERT INTO [dbo].[Student_AcademicInfo]([StudentIID],[ExamName],[InstituteName],[InstituteAddress],[Board],[PassYear],[ExamSession],[ExamGroup],
	[ExamRegNo],[ExamRoll],[GPA],[GPAWithOut4thSubject],[Comment], [IsDeleted])
    SELECT [StudentInfo_SlNo],'HSC',[StudentInfo_HSCInstituteName],[StudentInfo_HSCInstituteAdress],[StudentInfo_HSCBoard],[StudentInfo_HSCPassYear]
      ,[StudentInfo_HSCSession],[StudentInfo_HSCGroup],[StudentInfo_HSCRegNo],[StudentInfo_HSCRollNo], CAST(ISNULL(CASE WHEN LTRIM(RTRIM( [StudentInfo_HSCGPAMarks]))='' THEN '00.00'  ELSE [StudentInfo_HSCGPAMarks] END,'00.00') AS decimal(4,2)) ,
	  CAST(ISNULL(CASE WHEN LTRIM(RTRIM( [StudentInfo_HSCGPAMarksWithoutFourth]))='' THEN '00.00'  ELSE [StudentInfo_HSCGPAMarksWithoutFourth] END,'00.00') AS decimal(4,2)),[StudentInfo_HSCComments],	0
	FROM [sef_db].[dbo].[Tbl_StudentInformation] 

DELETE [dbo].[Student_AcademicInfo] WHERE ([InstituteName] = '' OR [InstituteName] IS NULL) AND ([ExamRoll] = '' OR [ExamRoll] IS NULL)


--- Student_GuardianInfo -----------------------------------------------------------------------------------
	ALTER TABLE [dbo].[Student_GuardianInfo] NOCHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Student_GuardianInfo] DISABLE TRIGGER ALL
	DELETE FROM [dbo].[Student_GuardianInfo]
	DBCC CHECKIDENT ('[dbo].[Student_GuardianInfo]',RESEED, 0)
	ALTER TABLE [dbo].[Student_GuardianInfo] CHECK CONSTRAINT ALL
	ALTER TABLE [dbo].[Student_GuardianInfo] ENABLE TRIGGER ALL

INSERT INTO [dbo].[Student_GuardianInfo]
           ([StudentIID]
           ,[IsDeleted]
           
           ,[F_MonthlyIncome],[F_OfficeAddress],[F_Mobile],[F_GuardianImage]
		   ,[M_MonthlyIncome],[M_OfficeAddress],[M_Mobile],[M_GuardianImage]
		   ,[LG_Name],[LG_Mobile],[LG_Relation],[LG_Address]
		  )

  	
    SELECT [StudentInfo_SlNo],0,StudentInfo_FatherMonthlyIncome,[StudentInfo_FatherOfficeAddress], [StudentInfo_FatherMobileNo],[StudentInfo_FatherPic],
			[StudentInfo_MotherMonthlyIncome],[StudentInfo_MotherOfficeAddress],[StudentInfo_MotherMobileNo],[StudentInfo_MotherPic],
			[StudentInfo_LocalGuardianName],[StudentInfo_LocalGuardianMobileNo],[StudentInfo_LocalGuardianRelation],[StudentInfo_LocalGuardianContactAddress]
	FROM [sef_db].[dbo].[Tbl_StudentInformation] 

	