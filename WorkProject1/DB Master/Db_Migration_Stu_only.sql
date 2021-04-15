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
, [RollNo] ,[RegiNo],[FullName],[NameBangla],[FatherName],[MotherName],[SMSNotificationNo],[DateOfBirth],[Age],[Gender],[Nationality],[Religion],[BloodGroup]

,[PreInsInfoClass],[PreInsInfoSection],[PreInsInfoGroup],[PreInsInfoSession],[PreInsInfoVersion],[PreInsInfoRollNo],[PreInsInfoGPAResult],[PreInsInfoTCNo],[PreInsInfoDate]

,[StudentTypeID],[HouseID],[Quota],TransportFacility,[AdmissionDate],AddmissionEntryType,[IsDeleted],[Status],IsTC)
    

	SELECT StudentInfo_SlNo,StudentInfo_VersionID,StudentInfo_SessionID,StudentInfo_BranchID,StudentInfo_ShiftID,StudentInfo_ClassID,StudentInfo_GroupID,StudentInfo_SectionID,
	StudentInfo_StudentID,REPLACE( RTRIM(lTrim( StudentInfo_Roll)),'	',''),RegistrationNo ,StudentInfo_Name,NULL,StudentInfo_FatherName,StudentInfo_MotherName,StudentInfo_SMSNotificationNo,
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
	
	 FROM [rsc_db].[dbo].[Tbl_StudentInformation]

	 SET IDENTITY_INSERT [dbo].[Student_BasicInfo] OFF