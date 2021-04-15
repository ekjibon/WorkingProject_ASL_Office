USE lghsc_new_2018

	--- Emp_Designation 
	ALTER TABLE [Emp_Designation] NOCHECK CONSTRAINT ALL
	ALTER TABLE [Emp_Designation] DISABLE TRIGGER ALL
	DELETE FROM [Emp_Designation]
	DBCC CHECKIDENT ('[Emp_Designation]',RESEED, 0)
	ALTER TABLE [Emp_Designation] CHECK CONSTRAINT ALL
	ALTER TABLE [Emp_Designation] ENABLE TRIGGER ALL

	SET IDENTITY_INSERT [Emp_Designation] ON

	INSERT INTO [Emp_Designation]([DesignationID],[DesignationName],[CategoryID],[DesignationOrder],[CategoryName],[IsDeleted])
	SELECT  [Designation_ID],[Designation_Name],[Category_ID],ISNULL([Designation_Order],0),[Category_Name] , CASE WHEN [Designation_Status]='D' THEN 1 ELSE 0 END  
	FROM [lghsc_db].dbo.[Tbl_Designation]
	
	SET IDENTITY_INSERT [Emp_Designation] OFF

--- Emp_Category 
	ALTER TABLE [Emp_Category] NOCHECK CONSTRAINT ALL
	ALTER TABLE [Emp_Category] DISABLE TRIGGER ALL
	DELETE FROM [Emp_Category]
	DBCC CHECKIDENT ('[Emp_Category]',RESEED, 0)
	ALTER TABLE [Emp_Category] CHECK CONSTRAINT ALL
	ALTER TABLE [Emp_Category] ENABLE TRIGGER ALL

	SET IDENTITY_INSERT [Emp_Category] ON

	INSERT INTO [Emp_Category]([CategoryID],[CategoryName],[CategoryIsTeacher],[IsDeleted])
	SELECT  [EmployeeCategory_ID],[EmployeeCategory_Name],[EmployeeCategory_IsTeacher], CASE WHEN [EmployeeCategory_Status]='D' THEN 1 ELSE 0 END  
	FROM [lghsc_db].dbo.[Tbl_EmployeeCategory]
	
	SET IDENTITY_INSERT [Emp_Category] OFF

--- Emp_Department 
	ALTER TABLE [Emp_Department] NOCHECK CONSTRAINT ALL
	ALTER TABLE [Emp_Department] DISABLE TRIGGER ALL
	DELETE FROM [Emp_Department]
	DBCC CHECKIDENT ('[Emp_Department]',RESEED, 0)
	ALTER TABLE [Emp_Department] CHECK CONSTRAINT ALL
	ALTER TABLE [Emp_Department] ENABLE TRIGGER ALL

	SET IDENTITY_INSERT [Emp_Department] ON

	INSERT INTO [Emp_Department](DepartmentID,DepartmentName,[IsDeleted])
	SELECT  EmployeeDepartment_ID,EmployeeDepartment_Name, CASE WHEN EmployeeDepartment_Status='D' THEN 1 ELSE 0 END  
	FROM [lghsc_db].dbo.[Tbl_EmployeeDepartment]
	
	SET IDENTITY_INSERT [Emp_Department] OFF

--- Emp_Section 
	ALTER TABLE [Emp_Section] NOCHECK CONSTRAINT ALL
	ALTER TABLE [Emp_Section] DISABLE TRIGGER ALL
	DELETE FROM [Emp_Section]
	DBCC CHECKIDENT ('[Emp_Section]',RESEED, 0)
	ALTER TABLE [Emp_Section] CHECK CONSTRAINT ALL
	ALTER TABLE [Emp_Section] ENABLE TRIGGER ALL

	SET IDENTITY_INSERT [Emp_Section] ON

	INSERT INTO [Emp_Section]([SectionID],[SectionName],[IsDeleted])
	SELECT  [EmployeeSection_ID],[EmployeeSection_Name], CASE WHEN EmployeeSection_Status='D' THEN 1 ELSE 0 END  
	FROM [lghsc_db].dbo.[Tbl_EmployeeSection]
	
	SET IDENTITY_INSERT [Emp_Section] OFF

--- Emp_Shift 
	ALTER TABLE [Emp_Shift] NOCHECK CONSTRAINT ALL
	ALTER TABLE [Emp_Shift] DISABLE TRIGGER ALL
	DELETE FROM [Emp_Shift]
	DBCC CHECKIDENT ('[Emp_Shift]',RESEED, 0)
	ALTER TABLE [Emp_Shift] CHECK CONSTRAINT ALL
	ALTER TABLE [Emp_Shift] ENABLE TRIGGER ALL

	SET IDENTITY_INSERT [Emp_Shift] ON

	INSERT INTO [Emp_Shift]([ShiftID],[ShiftBranchID],[ShiftName],[ShiftInTime],[ShiftOutTime],[IsDeleted])
	SELECT [EmployeeShift_ID],[EmployeeShift_BranchID],[EmployeeShift_Name],[EmployeeShift_InTime],[EmployeeShift_OutTime], CASE WHEN EmployeeShift_Status='D' THEN 1 ELSE 0 END  
	FROM [lghsc_db].dbo.[Tbl_EmployeeShift]
	
	SET IDENTITY_INSERT [Emp_Shift] OFF

--- Emp_Status 
	ALTER TABLE [Emp_Status] NOCHECK CONSTRAINT ALL
	ALTER TABLE [Emp_Status] DISABLE TRIGGER ALL
	DELETE FROM [Emp_Status]
	DBCC CHECKIDENT ('[Emp_Status]',RESEED, 0)
	ALTER TABLE [Emp_Status] CHECK CONSTRAINT ALL
	ALTER TABLE [Emp_Status] ENABLE TRIGGER ALL

	SET IDENTITY_INSERT [Emp_Status] ON

	INSERT INTO [Emp_Status]([StatusID],[StatusName],[IsDeleted])
	SELECT  [EmployeeStatus_ID],[EmployeeStatus_Name], CASE WHEN EmployeeStatus_Status='D' THEN 1 ELSE 0 END  
	FROM [lghsc_db].dbo.[Tbl_EmployeeStatus]
	
	SET IDENTITY_INSERT [Emp_Status] OFF

	--- Emp_Subject 
	ALTER TABLE [Emp_Subject] NOCHECK CONSTRAINT ALL
	ALTER TABLE [Emp_Subject] DISABLE TRIGGER ALL
	DELETE FROM [Emp_Subject]
	DBCC CHECKIDENT ('[Emp_Subject]',RESEED, 0)
	ALTER TABLE [Emp_Subject] CHECK CONSTRAINT ALL
	ALTER TABLE [Emp_Subject] ENABLE TRIGGER ALL

	SET IDENTITY_INSERT [Emp_Subject] ON

	INSERT INTO [Emp_Subject]([SubjectID],[SubjectName],[IsDeleted])
	SELECT [EmployeeSubject_ID], [EmployeeSubject_Name], CASE WHEN EmployeeSubject_Status='D' THEN 1 ELSE 0 END  
	FROM [lghsc_db].dbo.[Tbl_EmployeeSubject]
	
	SET IDENTITY_INSERT [Emp_Subject] OFF

	--- Emp_ExamName 
	ALTER TABLE [Emp_ExamName] NOCHECK CONSTRAINT ALL
	ALTER TABLE [Emp_ExamName] DISABLE TRIGGER ALL
	DELETE FROM [Emp_ExamName]
	DBCC CHECKIDENT ('[Emp_ExamName]',RESEED, 0)
	ALTER TABLE [Emp_ExamName] CHECK CONSTRAINT ALL
	ALTER TABLE [Emp_ExamName] ENABLE TRIGGER ALL

	SET IDENTITY_INSERT [Emp_ExamName] ON

	INSERT INTO [Emp_ExamName]([EmployeeExam_ID],[EmployeeExam_Name],[IsDeleted])
	SELECT [EmployeeExam_ID],[EmployeeExam_Name] , CASE WHEN EmployeeExam_Status='D' THEN 1 ELSE 0 END  
	FROM [lghsc_db].dbo.[Tbl_EmployeeExam]
	
	SET IDENTITY_INSERT [Emp_ExamName] OFF

	--- Emp_ExamGroup 
	ALTER TABLE [Emp_ExamGroup] NOCHECK CONSTRAINT ALL
	ALTER TABLE [Emp_ExamGroup] DISABLE TRIGGER ALL
	DELETE FROM [Emp_ExamGroup]
	DBCC CHECKIDENT ('[Emp_ExamGroup]',RESEED, 0)
	ALTER TABLE [Emp_ExamGroup] CHECK CONSTRAINT ALL
	ALTER TABLE [Emp_ExamGroup] ENABLE TRIGGER ALL

	SET IDENTITY_INSERT [Emp_ExamGroup] ON

	INSERT INTO [Emp_ExamGroup]([EmployeeExamGroup_ID],[EmployeeExamGroup_Name],[IsDeleted])
	SELECT [EmployeeExamGroup_ID],[EmployeeExamGroup_Name], CASE WHEN EmployeeExamGroup_Status='D' THEN 1 ELSE 0 END  
	FROM [lghsc_db].dbo.[Tbl_EmployeeExamGroup]
	
	SET IDENTITY_INSERT [Emp_ExamGroup] OFF

--- Emp_ExamBoard 
	ALTER TABLE [Emp_ExamBoard] NOCHECK CONSTRAINT ALL
	ALTER TABLE [Emp_ExamBoard] DISABLE TRIGGER ALL
	DELETE FROM [Emp_ExamBoard]
	DBCC CHECKIDENT ('[Emp_ExamBoard]',RESEED, 0)
	ALTER TABLE [Emp_ExamBoard] CHECK CONSTRAINT ALL
	ALTER TABLE [Emp_ExamBoard] ENABLE TRIGGER ALL

	SET IDENTITY_INSERT [Emp_ExamBoard] ON

	INSERT INTO [Emp_ExamBoard]([EmployeeExamBoard_ID],[EmployeeExamBoard_Name],[IsDeleted])
	SELECT [EmployeeExamBoard_ID],[EmployeeExamBoard_Name] , CASE WHEN [EmployeeExamBoard_Status]='D' THEN 1 ELSE 0 END  
	FROM [lghsc_db].dbo.[Tbl_EmployeeExamBoard]
	
	SET IDENTITY_INSERT [Emp_ExamBoard] OFF


	--- Emp_EducationalInfo 
	ALTER TABLE [Emp_EducationalInfo] NOCHECK CONSTRAINT ALL
	ALTER TABLE [Emp_EducationalInfo] DISABLE TRIGGER ALL
	DELETE FROM [Emp_EducationalInfo]
	DBCC CHECKIDENT ('[Emp_EducationalInfo]',RESEED, 0)
	ALTER TABLE [Emp_EducationalInfo] CHECK CONSTRAINT ALL
	ALTER TABLE [Emp_EducationalInfo] ENABLE TRIGGER ALL

	SET IDENTITY_INSERT [Emp_EducationalInfo] ON

	INSERT INTO [Emp_EducationalInfo]([EducationalInfo_ID],[EmployeeID],[ExamID],[ExamGroupID],[ExamBoard],[ExamInstituteName],[ExamPasYear],[ExamTotal],[IsDeleted])
	SELECT [EmployeeEducationalInfo_ID],[EmployeeEducationalInfo_EmployeeAutoID],[EmployeeEducationalInfo_ExamID],[EmployeeEducationalInfo_ExamGroupID],[EmployeeEducationalInfo_ExamBoard],[EmployeeEducationalInfo_ExamInstituteName],[EmployeeEducationalInfo_ExamPasYear],EmployeeEducationalInfo_ExamTotal, CASE WHEN EmployeeEducationalInfo_Status='D' THEN 1 ELSE 0 END  
	FROM [lghsc_db].dbo.[Tbl_EmployeeEducationalInfo]
	
	SET IDENTITY_INSERT [Emp_EducationalInfo] OFF


	--- Emp_BasicInfo 
	ALTER TABLE [Emp_BasicInfo] NOCHECK CONSTRAINT ALL
	ALTER TABLE [Emp_BasicInfo] DISABLE TRIGGER ALL
	DELETE FROM [Emp_BasicInfo]
	DBCC CHECKIDENT ('[Emp_BasicInfo]',RESEED, 0)
	ALTER TABLE [Emp_BasicInfo] CHECK CONSTRAINT ALL
	ALTER TABLE [Emp_BasicInfo] ENABLE TRIGGER ALL 

	SET IDENTITY_INSERT [Emp_BasicInfo] ON

	INSERT INTO [Emp_BasicInfo]([EmpBasicInfoID]
,[EmpID],[FullName],[DesignationID],[IsClassTeacher],[TypeID],[SectionID],[BranchID],[ShiftID],[DepartmentID],[SubjectID]
,[CategoryID],[VersionID],[JoiningDate],[StatusID],[Image],[FatherName],[MotherName],[Nationality],[Religion],[BloodGroup],[NationalID],[DateOfBirth],[Contact],[PresentAddress],[PresentPost],[PresentThana],[PresentDistrict],[PermanentAddress],[PermanentPost],[PermanentThana],[PermanentDistrict],
[InstituteAccount],[IsGovtSalaryActive],[GovtSalaryGrade],[Gender],[MaritalStatus],[EmergencyContactAddress],[EmergencyTandTNo]
,[MobileNo],[Email],[SMSNotificationNo],[DeviceUserID],[CardNo],[IsPermanent],[ProbationPeriodEndDate],[ConfirmationDate],[Accountname],[AccountType],[BankName],[BranchName]
,[MPOIndexNo],[PassportNo],[EmergencyContactName],[EmergencyContactRelation],[ContactOfficeEmail],[ContactOtherEmail]
,[ContactHomeNo],[ContactOfficeNo],[DPSAcccountNo],[eTIN],[InstituteGrade],[PFAccountNo],[ReportingPersonID],[ReportOrderNo]
,[SalaryGradeID],[ShortName],[IsDeleted],[Status])
	SELECT 
		[EmployeeBasicInfo_ID],RTRIM(LTRIM([EmployeeBasicInfo_EmployeeID])),[EmployeeBasicInfo_Name],[EmployeeBasicInfo_DesignationID],[EmployeeBasicInfo_IsClassTeacher],[EmployeeBasicInfo_TypeID],[EmployeeBasicInfo_SectionID],[EmployeeBasicInfo_BranchID],[EmployeeBasicInfo_ShiftID],[EmployeeBasicInfo_DepartmentID],[EmployeeBasicInfo_SubjectID]
,[EmployeeBasicInfo_CategoryID] ,[EmployeeBasicInfo_VersionID] ,[EmployeeBasicInfo_JoiningDate],[EmployeeBasicInfo_StatusID],[EmployeeBasicInfo_Image],[EmployeeBasicInfo_FatherName],[EmployeeBasicInfo_MotherName],[EmployeeBasicInfo_Nationality],[EmployeeBasicInfo_Religion],[EmployeeBasicInfo_BloodGroup],[EmployeeBasicInfo_NationalID],[EmployeeBasicInfo_DateOfBirth],[EmployeeBasicInfo_Contact],[EmployeeBasicInfo_PresentAddress],[EmployeeBasicInfo_PresentPost],[EmployeeBasicInfo_PresentThana],[EmployeeBasicInfo_PresentDistrict],[EmployeeBasicInfo_PermanentAddress],[EmployeeBasicInfo_PermanentPost],[EmployeeBasicInfo_PermanentThana],[EmployeeBasicInfo_PermanentDistrict]
      

      ,[EmployeeBasicInfo_InstituteAccount],[EmployeeBasicInfo_IsGovtSalaryActive],[EmployeeBasicInfo_GovtSalaryGrade],[EmployeeBasicInfo_Gender],[EmployeeBasicInfo_MaritalStatus],[EmployeeBasicInfo_EmergencyContactAddress],[EmployeeBasicInfo_EmergencyTandTNo]

	,[EmployeeBasicInfo_MobileNo],[EmployeeBasicInfo_Email],[EmployeeBasicInfo_SMSNotificationNo],[EmployeeBasicInfo_EmpDeviceUserID],[EmployeeBasicInfo_CardNo],ISNULL([IsPermanent],0),[ProbationPeriodEndDate],[ConfirmationDate],[Accountname],[AccountType],[BankName],[BranchName]

,[EmployeeMPO_IndexNo],[EmployeeBasicInfo_PassportNo],[EmployeeBasicInfo_EmergencyContactName],[EmployeeBasicInfo_EmergencyContactRelation],[EmployeeBasicInfo_ContactOfficeEmail],[EmployeeBasicInfo_ContactOtherEmail]
,[EmployeeBasicInfo_ContactHomeNo],[EmployeeBasicInfo_ContactOfficeNo],[EmployeeBasicInfo_DPSAcccountNo],[EmployeeBasicInfo_eTIN],[EmployeeBasicInfo_InstituteGrade],[EmployeeBasicInfo_PFAccountNo],ISNULL([EmployeeBasicInfo_ReportingPersonID],0),ISNULL([EmployeeBasicInfo_ReportOrderNo],0)
,ISNULL([EmployeeBasicInfo_SalaryGradeID],0),[EmployeeBasicInfo_ShortName]
	, CASE WHEN [EmployeeBasicInfo_Status]='D' THEN 1 ELSE 0 END  ,  [EmployeeBasicInfo_Status]
	FROM [lghsc_db].dbo.[Tbl_EmployeeBasicInfo]
	
	SET IDENTITY_INSERT [Emp_BasicInfo] OFF