
truncate table [dbo].[AspNetApis]
truncate table [dbo].[AspNetPageApis]

--- StudentController 100
--- SetupInstitutionController 200
--- AttendanceController 300
--- EmployeeController 400
--- GrandResultController 500
--- ResultController 600
--- PromotionController 700
--- UserController  800

SET IDENTITY_INSERT [dbo].[AspNetApis] ON 

--StudentInfo
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (101, N'StudentInfo', N'LockUser', N'StudentInfo/LockUser/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (102, N'StudentInfo', N'StuBulkUpload', N'Student/BulkUploadStu/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (103, N'StudentInfo', N'AddStudent', N'Student/AddStudent/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (104, N'StudentInfo', N'AddStudent_old', N'Student/AddStudent_old/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (105, N'StudentInfo', N'SearchStudent', N'Student/Search/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (106, N'StudentInfo', N'GetStudents', N'StudentInfo/GetStudents/{StudentInsID}/{VersionId}/{SessionId}/{BranchId}/{ShiftId}/{ClassId}/{GroupId}/{SectionId}')

GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (107, N'StudentInfo', N'SearchStudenForMainExamt', N'Student/SearchMainExam/')

GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (108, N'StudentInfo', N'SearchStudentForGrandResult', N'Student/SearchStudentForGrandResult/')

GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (109, N'StudentInfo', N'GetStudentByID', N'Student/GetStudentByID/{id}')

GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (110, N'StudentInfo', N'GetStudentByInsID', N'Student/GetStudentByInsID/{id}')

GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (111, N'StudentInfo', N'CheckStudent', N'Student/CheckStudent/{id}/')

GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (112, N'StudentInfo', N'GetStudentByRoll', N'Student/GetStudentByRoll/{versionId}/{sessionId}/{branchId}/{shiftId}/{classId}/{groupId}/{sectionId}/{roll}')

GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (113, N'StudentInfo', N'UpdateStudentBasicInfo', N'Student/UpdateStudentBasicInfo/')


GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (114, N'StudentInfo', N'DeleteStudentBasicInfo', N'Student/DeleteStudent/{ContactIID}')
GO

GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (115, N'StudentInfo', N'GetStudentByID', N'Student/GetStudentByID/{id}')

GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (116, N'StudentInfo', N'GetStudentByInsID', N'Student/GetStudentByInsID/{id}')

GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (117, N'StudentInfo', N'CheckStudent', N'Student/CheckStudent/{id}/')

GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (118, N'StudentInfo', N'GetStudentByRoll', N'Student/GetStudentByRoll/{versionId}/{sessionId}/{branchId}/{shiftId}/{classId}/{groupId}/{sectionId}/{roll}')

GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (119, N'StudentInfo', N'UpdateStudentBasicInfo', N'Student/UpdateStudentBasicInfo/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (120, N'StudentInfo', N'DeleteStudentBasicInfo', N'Student/DeleteStudent/{ContactIID}')

GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (121, N'StudentInfo', N'AddStudentContactInfo', N'Student/AddStudentContact/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (122, N'StudentInfo', N'GetStudentContactInfo', N'Student/GetStudentContact/{pageno}/{pagesize}/{searchtxt}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (123, N'StudentInfo', N'GetContactInfoByID', N'Student/GetContactInfoByID/{SIId}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (124, N'StudentInfo', N'GetStudentContactByID', N'Student/GetStudentContactByID/{id}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (125, N'StudentInfo', N'UpdateStudentContactInfo', N'Student/UpdateStudentContact/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (126, N'StudentInfo', N'GetStudentID', N'Student/GetStudentID/{versionId}/{sessionId}/{branchId}/{shiftId}/{classId}/{groupId}/{sectionId}/{sttypeId}/{houseId}/{configType}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (127, N'StudentInfo', N'GetStudentIDList', N'Student/GetStudentIDList/{versionId}/{sessionId}/{classId}/{groupId}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (128, N'StudentInfo', N'GetAllStudentBasicInfo', N'Student/GetAllStudentBasicInfo/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (129, N'StudentInfo', N'GetAllStudentBasicInfo', N'Student/GetAllStudentBasicInfo/{NameID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (130, N'StudentInfo', N'AddAcademicInfo', N'Student/AddAcademicInfo/')

GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (131, N'StudentInfo', N'GetAcademicInfoByID', N'Student/GetAcademicInfoByID/{id}/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (132, N'StudentInfo', N'UpdateAcademicInfo', N'Student/UpdateAcademicInfo')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (133, N'StudentInfo', N'DeleteAcademicInfo', N'Student/DeleteAcademicInfo/{academicId}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (134, N'StudentInfo', N'AddGuardianInfo', N'Student/AddGuardianInfo/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (135, N'StudentInfo', N'GetGuardianInfoByID', N'Student/GetGuardianInfoByID/{id}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (136, N'StudentInfo', N'UpdateGuardianInfo', N'Student/UpdateGuardianInfo/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (137, N'StudentInfo', N'DeleteGuardianInfo', N'Student/DeleteGuardianInfo/{aguardianId}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (138, N'StudentInfo', N'AddSiblingInfo', N'Student/AddSiblingInfo/{studentIID}/{siblingstudentIID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (139, N'StudentInfo', N'GetSiblingInfoByID', N'Student/GetSiblingInfoByID/{id}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (140, N'StudentInfo', N'GetSiblingInfoByInsID', N'Student/GetSiblingInfoByInsID/{id}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (141, N'StudentInfo', N'UpdateSiblingInfo', N'Student/UpdateSiblingInfo/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (142, N'StudentInfo', N'DeleteSiblingInfo', N'Student/DeleteSiblingInfo/{siblingId}')

GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (143, N'StudentInfo', N'AddOthersInfo', N'Student/AddOthersInfo/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (144, N'StudentInfo', N'GetOthersInfo', N'Student/GetOthersInfo/{pageno}/{pagesize}/{searchtxt}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (145, N'StudentInfo', N'GetOthersInfoByID', N'Student/GetOthersInfoByID/{Id}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (146, N'StudentInfo', N'GetOthersInfo', N'Student/GetOthersInfo/{otherInfoId}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (147, N'StudentInfo', N'UpdateOthersInfo', N'Student/UpdateOthersInfo/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (148, N'StudentInfo', N'DeleteOthersInfo', N'Student/DeleteOthersInfo/{othersInfoID}')

GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (149, N'StudentInfo', N'SubjectList', N'Student/SubjectList/{versionId}/{sessionID}/{classId}/{groupId}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (150, N'StudentInfo', N'StuDetailInfo', N'Student/StuDetailInfo/')

GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (151, N'StudentInfo', N'DeleteStudentContactInfo', N'Student/DeleteStudentContact/{ContactIID}')


--Institute Setup
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (201, N'SetupInstitution', N'AddSession', N'SetupInstitution/AddSession/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (202, N'SetupInstitution', N'GetSessions', N'SetupInstitution/GetSessions/{pageno}/{pagesize}/{searchtxt}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (203, N'SetupInstitution', N'UpdateSession', N'Student/DeleteStudentContact/{ContactIID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (204, N'SetupInstitution', N'DeleteSession', N'SetupInstitution/DeleteSession/{Sessionid}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (205, N'SetupInstitution', N'AddClassInfo', N'SetupInstitution/AddClassInfo/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (206, N'SetupInstitution', N'GetClassInfo', N'SetupInstitution/GetClassInfo/{pageno}/{pagesize}/{searchtxt}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (207, N'SetupInstitution', N'UpdateClassInfo', N'SetupInstitution/UpdateClassInfo/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (208, N'SetupInstitution', N'DeleteClassInfo', N'SetupInstitution/DeleteClassInfo/{ClassInfoid}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (209, N'SetupInstitution', N'AddBranch', N'SetupInstitution/AddBranch/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (210, N'SetupInstitution', N'GetBranchs', N'SetupInstitution/GetBranchs/{pageno}/{pagesize}/{searchtxt}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (211, N'SetupInstitution', N'GetAllBranchs', N'SetupInstitution/GetAllBranchs/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (212, N'SetupInstitution', N'UpdateBranch', N'SetupInstitution/UpdateBranch/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (213, N'SetupInstitution', N'DeleteBranch', N'SetupInstitution/DeleteBranch/{Branchid}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (214, N'SetupInstitution', N'AddShift', N'SetupInstitution/AddShift/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (215, N'SetupInstitution', N'GetShifts', N'SetupInstitution/GetShifts/{pageno}/{pagesize}/{searchtxt}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (216, N'SetupInstitution', N'UpdateShift', N'SetupInstitution/UpdateShift/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (217, N'SetupInstitution', N'DeleteShift', N'SetupInstitution/DeleteShift/{Shiftid}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (218, N'SetupInstitution', N'AddGroup', N'SetupInstitution/AddGroup/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (219, N'SetupInstitution', N'GetGroupInfo', N'SetupInstitution/GetGroupInfo/{pageno}/{pagesize}/{searchtxt}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (220, N'SetupInstitution', N'UpdateGroupInfo', N'SetupInstitution/UpdateGroupInfo/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (221, N'SetupInstitution', N'DeleteGroup', N'SetupInstitution/DeleteGroup/{GroupID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (222, N'SetupInstitution', N'AddSection', N'SetupInstitution/AddSection/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (223, N'SetupInstitution', N'GetSectionInfo', N'SetupInstitution/GetSectionInfo/{pageno}/{pagesize}/{searchtxt}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (224, N'SetupInstitution', N'GetSection', N'SetupInstitution/GetAllSection/{pageno}/{pagesize}/{searchtxt}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (225, N'SetupInstitution', N'UpdateSectionInfo', N'SetupInstitution/UpdateSectionInfo/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (226, N'SetupInstitution', N'DeleteSection', N'SetupInstitution/DeleteSection/{SectionID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (227, N'SetupInstitution', N'AddFeesBooth', N'SetupInstitution/AddFeesBooth/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (228, N'SetupInstitution', N'GetFeesBooth', N'SetupInstitution/GetFeesBooth/{pageno}/{pagesize}/{searchtxt}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (229, N'SetupInstitution', N'GetAllFeesBooth', N'SetupInstitution/GetAllFeesBooth/{pageno}/{pagesize}/{searchtxt}')

GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (230, N'SetupInstitution', N'UpdateFeesBooth', N'SetupInstitution/UpdateFeesBooth/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (231, N'SetupInstitution', N'DeleteFeesBooth', N'SetupInstitution/DeleteFeesBooth/{BoothID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (232, N'SetupInstitution', N'AddAcademicProgram', N'SetupInstitution/AddAcademicProgram/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (233, N'SetupInstitution', N'GetAcademicProgram', N'SetupInstitution/GetAcademicProgram/{pageno}/{pagesize}/{searchtxt}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (234, N'SetupInstitution', N'UpdateAcademicProgram', N'SetupInstitution/UpdateAcademicProgram/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (235, N'SetupInstitution', N'DeleteAcademicProgram', N'SetupInstitution/DeleteAcademicProgram/{AcademicProgramID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (236, N'SetupInstitution', N'AddAcademicProgramCategory', N'SetupInstitution/AddAcademicProgramCategory/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (237, N'SetupInstitution', N'GetAcademicProgramCategory', N'SetupInstitution/GetAcademicProgramCategory/{pageno}/{pagesize}/{searchtxt}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (238, N'SetupInstitution', N'UpdateAcademicProgramCategory', N'SetupInstitution/UpdateAcademicProgramCategory/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (239, N'SetupInstitution', N'DeleteAcademicProgramCategory', N'SetupInstitution/DeleteAcademicProgramCategory/{AcademicProgramCategoryID}')


GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (240, N'SetupInstitution', N'AddAcademicSemester', N'SetupInstitution/AddAcademicSemester/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (241, N'SetupInstitution', N'GetAcademicSemester', N'SetupInstitution/GetAcademicSemester/{pageno}/{pagesize}/{searchtxt}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (242, N'SetupInstitution', N'UpdateAcademicSemester', N'SetupInstitution/UpdateAcademicSemester/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (243, N'SetupInstitution', N'DeleteAcademicSemester', N'SetupInstitution/DeleteAcademicSemester/{AcademicProgramCategoryID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (244, N'SetupInstitution', N'AddAcademinBatch', N'SetupInstitution/AddAcademinBatch/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (245, N'SetupInstitution', N'GetAcademinBatch', N'SetupInstitution/GetAcademinBatch/{pageno}/{pagesize}/{searchtxt}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (246, N'SetupInstitution', N'UpdateAcademinBatch', N'SetupInstitution/UpdateAcademinBatch/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (247, N'SetupInstitution', N'DeleteAcademinBatch', N'SetupInstitution/DeleteAcademinBatch/{AcademicBatchId}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (248, N'SetupInstitution', N'AddAcademicDepartmentInfo', N'SetupInstitution/AddAcademicDepartmentInfo/{acadeptname}/{acadeptcode}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (249, N'SetupInstitution', N'GetAcademicDepartmentInfo', N'SetupInstitution/GetAcademicDepartmentInfo/{pageno}/{pagesize}/{searchtxt}')

GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (250, N'SetupInstitution', N'UpdateAcademicDepartmentInfo', N'SetupInstitution/UpdateAcademicDepartmentInfo/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (251, N'SetupInstitution', N'DeleteAcademicDepartmentInfo', N'SetupInstitution/DeleteAcademicDepartmentInfo/{AcademicDepartmentId}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (252, N'SetupInstitution', N'GetAllVersion', N'SetupInstitution/GetAllVersion/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (253, N'SetupInstitution', N'Getidconfig', N'SetupInstitution/Getidconfig/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (254, N'SetupInstitution', N'Updateconfig', N'SetupInstitution/Updateconfig/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (255, N'SetupInstitution', N'AddStudentType', N'SetupInstitution/AddStudentType/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (256, N'SetupInstitution', N'GetStudentType', N'SetupInstitution/GetStudentType/{pageno}/{pagesize}/{searchtxt}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (257, N'SetupInstitution', N'UpdateStudentType', N'SetupInstitution/UpdateStudentType/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (258, N'SetupInstitution', N'DeleteStudentType', N'SetupInstitution/DeleteStudentType/{StudentTypeID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (259, N'SetupInstitution', N'AddScholarshipType', N'SetupInstitution/AddScholarshipType/')
GO

GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (260, N'SetupInstitution', N'GetoScholarshipType', N'SetupInstitution/GetoScholarshipType/{pageno}/{pagesize}/{searchtxt}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (261, N'SetupInstitution', N'UpdateScholarshipType', N'SetupInstitution/UpdateScholarshipType/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (262, N'SetupInstitution', N'DeleteScholarshipType', N'SetupInstitution/DeleteScholarshipType/{ScholarshipTypeID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (263, N'SetupInstitution', N'GetClass', N'SetupInstitution/GetClass/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (264, N'SetupInstitution', N'GetVersion', N'SetupInstitution/GetVersion/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (265, N'SetupInstitution', N'AddStudentType', N'SetupInstitution/AddStudentType/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (266, N'SetupInstitution', N'GetStudentType', N'SetupInstitution/GetStudentType/{pageno}/{pagesize}/{searchtxt}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (267, N'SetupInstitution', N'UpdateStudentType', N'SetupInstitution/UpdateStudentType/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (268, N'SetupInstitution', N'DeleteStudentType', N'SetupInstitution/DeleteStudentType/{StudentTypeID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (269, N'SetupInstitution', N'AddScholarshipType', N'SetupInstitution/AddScholarshipType/')
GO

--Attendance Controller
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (301, N'Attendance', N'AttendanceSearch', N'Attendance/AttendanceSearch/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (302, N'Attendance', N'SaveExamAtte', N'Attendance/SaveExamAtte/')
GO



--Employee
--
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (401, N'Employee', N'LockUser', N'Employee/LockUser/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (402, N'Employee', N'GetSingleEmployeeInfo', N'Employee/GetSingleEmployeeInfo/{EmpBasicInfoID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (403, N'Employee', N'SearchEmployee', N'Employee/SearchEmployee/{srhtext}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (404, N'Employee', N'TeacherSubjectList', N'Employee/TeacherSubjectLists/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (405, N'Employee', N'GetEmployeeInfo', N'Employee/GetEmployeeInfo/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (406, N'Employee', N'GetEmployeeForSubjectMapping', N'Employee/GetEmployeeForSubjectMapping/{versionId}/{branchId}/{shiftId}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (407, N'Employee', N'GetEmployeeID', N'Employee/GetEmployeeID/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (408, N'Employee', N'AddEmployee', N'Employee/AddEmployee/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (409, N'Employee', N'UpdateAllOthers', N'Employee/UpdateAllOthers/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (410, N'Employee', N'AddEducationalInfo', N'Employee/AddEducationalInfo/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (411, N'Employee', N'GetExamName', N'Employee/GetExamName/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (412, N'Employee', N'GetEmpExamGroup', N'Employee/GetEmpExamGroup/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (413, N'Employee', N'GetEmpExamBoard', N'Employee/GetEmpExamBoard/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (414, N'Employee', N'GetCategories', N'Employee/GetCategories/{pageno}/{pagesize}/{searchtxt}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (415, N'Employee', N'GetAllCategories', N'Employee/GetAllCategories/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (416, N'Employee', N'AddCategory', N'Employee/AddCategory/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (417, N'Employee', N'UpdateCategory', N'Employee/UpdateCategory/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (418, N'Employee', N'DeleteCategory', N'Employee/DeleteCategory/{CategoryID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (419, N'Employee', N'GetDesignations', N'Employee/GetDesignations/{pageno}/{pagesize}/{searchtxt}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (420, N'Employee', N'AddDesignation', N'Employee/AddDesignation/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (421, N'Employee', N'UpdateDesignation', N'Employee/UpdateDesignation/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (422, N'Employee', N'DeleteDesignation', N'Employee/DeleteDesignation/{DesignationID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (423, N'Employee', N'GetSubjects', N'Employee/GetSubjects/{pageno}/{pagesize}/{searchtxt}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (424, N'Employee', N'AddSubject', N'Employee/AddSubject/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (425, N'Employee', N'UpdateSubject', N'Employee/UpdateSubject/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (426, N'Employee', N'DeleteSubject', N'Employee/DeleteSubject/{SubjectID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (427, N'Employee', N'GetDepartments', N'Employee/GetDepartments/{pageno}/{pagesize}/{searchtxt}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (428, N'Employee', N'AddDepartment', N'Employee/AddDepartment/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (429, N'Employee', N'UpdateDepartment', N'Employee/UpdateDepartment/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (430, N'Employee', N'DeleteDepartment', N'Employee/DeleteDepartment/{DepartmentID}')

GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (431, N'Employee', N'GetStatus', N'Employee/GetStatus/{pageno}/{pagesize}/{searchtxt}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (432, N'Employee', N'AddStatus', N'Employee/AddStatus/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (433, N'Employee', N'UpdateStatus', N'Employee/UpdateStatus/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (434, N'Employee', N'DeleteStatus', N'Employee/DeleteStatus/{StatusID}')
GO

INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (435, N'Employee', N'UpdateEmployee', N'Employee/UpdateEmployee')
GO

INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (501, N'GrandResult', N'GetMainExamByGrandSetup', N'GrandResult/GetMainExamByGrandSetup/{versionId}/{sessionID}/{classId}/{groupId}')--GrandExamClone
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (502, N'GrandResult', N'GetMainExamSubject', N'GrandResult/GetMainExamSubject/{versionId}/{sessionID}/{classId}/{groupId}/{mainExamID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (503, N'GrandResult', N'CloneMainExam', N'GrandResult/CloneMainExam/{MainExamId}/{NewExamName}/{Version}/{Session}/{Class}/{Group}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (504, N'GrandResult', N'AddMainExam', N'GrandResult/AddMainExam/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (505, N'GrandResult', N'DeleteAllMainExamSubject', N'GrandResult/DeleteAllMainExamSubject/{versionId}/{sessionID}/{classId}/{groupId}/{mainExamID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (506, N'GrandResult', N'DeleteMainExamMark', N'GrandResult/DeleteMainExamMark/{id}')
GO--
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (507, N'GrandResult', N'AddMainExamMark', N'GrandResult/AddMainExamMark/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (508, N'GrandResult', N'GetDividedExamMark', N'GrandResult/GetDividedExamMark/{subExamID}/{subExamMarkSetupID}/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (509, N'GrandResult', N'AddDividedExamMark', N'GrandResult/AddDividedExamMark/{subExamID}/{mainExamID}/{subjectID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (510, N'GrandResult', N'DeleteAllDividedGrandResult', N'GrandResult/DeleteAllDividedGrandResult/{SubExamMarkSetupId}/{SubExamId}/{mainExamID}/{subjectID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (511, N'GrandResult', N'DeleteDividedExamMark', N'GrandResult/DeleteDividedExamMark/{id}/{SubjectID}/{SubExamID}/{MainExamID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (512, N'GrandResult', N'DeleteSubExam', N'GrandResult/DeleteSubExam/{subExamID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (513, N'GrandResult', N'UpdateDividedExam', N'GrandResult/UpdateDividedExam/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (514, N'GrandResult', N'AddDividedExam', N'GrandResult/AddDividedExam/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (515, N'GrandResult', N'DeleteDividedExam', N'GrandResult/DeleteDividedExam/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (516, N'GrandResult', N'GetSubExamMarkSetup', N'GrandResult/GetSubExamMarkSetup/{MainExamMarkSetupId}/{mainExamId}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (517, N'GrandResult', N'AddSubExamMarkSetup', N'GrandResult/AddSubExamMarkSetup/{mainExamId}/{subjectID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (518, N'GrandResult', N'DeleteAllSubExamMarkSetup', N'GrandResult/DeleteAllSubExamMarkSetup/{MainExamMarkSetupId}/{mainExamId}/{subexamID}/{subjectID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (519, N'GrandResult', N'DeleteSubExamMark', N'GrandResult/DeleteSubExamMark/{id}/{MainExamID}/{SubjectID}')
GO-- GrandExamMarkSetup
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (520, N'GrandResult', N'GetMainExamByGroup', N'GrandResult/GetMainExamByGroup/{versionId}/{sessionID}/{classId}/{groupId}')--GrandExamMarkSetup
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (521, N'GrandResult', N'GetMainExamSubject', N'GrandResult/GetMainExamSubject/{versionId}/{sessionID}/{classId}/{groupId}/{mainExamID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (522, N'GrandResult', N'AddMainExam', N'GrandResult/AddMainExam/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (523, N'GrandResult', N'DeleteAllMainExamSubject', N'GrandResult/DeleteAllMainExamSubject/{versionId}/{sessionID}/{classId}/{groupId}/{mainExamID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (524, N'GrandResult', N'DeleteMainExamMark', N'GrandResult/DeleteMainExamMark/{id}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (525, N'GrandResult', N'AddMainExamMark', N'GrandResult/AddMainExamMark/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (526, N'GrandResult', N'GetDividedExamMark', N'GrandResult/GetDividedExamMark/{subExamID}/{subExamMarkSetupID}/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (527, N'GrandResult', N'AddDividedExamMark', N'GrandResult/AddDividedExamMark/{subExamID}/{mainExamID}/{subjectID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (528, N'GrandResult', N'DeleteAllDividedGrandResult', N'GrandResult/DeleteAllDividedGrandResult/{SubExamMarkSetupId}/{SubExamId}/{mainExamID}/{subjectID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (529, N'GrandResult', N'DeleteDividedExamMark', N'GrandResult/DeleteDividedExamMark/{id}/{SubjectID}/{SubExamID}/{MainExamID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (530, N'GrandResult', N'DeleteSubExam', N'GrandResult/DeleteSubExam/{subExamID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (531, N'GrandResult', N'UpdateDividedExam', N'GrandResult/UpdateDividedExam')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (532, N'GrandResult', N'AddDividedExam', N'GrandResult/AddDividedExam/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (533, N'GrandResult', N'DeleteDividedExam', N'GrandResult/DeleteDividedExam/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (534, N'GrandResult', N'GetSubExamMarkSetup', N'GrandResult/GetSubExamMarkSetup/{MainExamMarkSetupId}/{mainExamId}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (535, N'GrandResult', N'AddSubExamMarkSetup', N'GrandResult/AddSubExamMarkSetup/{mainExamId}/{subjectID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (536, N'GrandResult', N'DeleteAllSubExamMarkSetup', N'GrandResult/DeleteAllSubExamMarkSetup/{MainExamMarkSetupId}/{mainExamId}/{subexamID}/{subjectID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (537, N'GrandResult', N'DeleteSubExamMark', N'GrandResult/DeleteSubExamMark/{id}/{MainExamID}/{SubjectID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (538, N'GrandResult', N'GetMainExamByGroup', N'GrandResult/GetMainExamByGroup/{versionId}/{sessionID}/{classId}/{groupId}')-- GrandExams
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (539, N'GrandResult', N'GetAllMainExam', N'GrandResult/GetAllMainExam/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (540, N'GrandResult', N'DeleteMainExam', N'GrandResult/DeleteMainExam/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (541, N'GrandResult', N'AddMainExam', N'GrandResult/AddMainExam/')-- GrandExamsSetup
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (542, N'GrandResult', N'GetMainExam', N'GrandResult/GetMainExam/{mainExamID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (543, N'GrandResult', N'GetSubExamByMainExamID', N'GrandResult/GetSubExamByMainExamID/{mainExamID}/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (544, N'GrandResult', N'UpdateSubExam', N'GrandResult/UpdateSubExam/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (545, N'GrandResult', N'AddSubExam', N'GrandResult/AddSubExam/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (546, N'GrandResult', N'DeleteSubExam', N'GrandResult/DeleteSubExam/{subExamID}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (547, N'GrandResult', N'UpdateDividedExam', N'GrandResult/UpdateDividedExam/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (548, N'GrandResult', N'AddDividedExam', N'GrandResult/AddDividedExam/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (549, N'GrandResult', N'DeleteDividedExam', N'GrandResult/DeleteDividedExam/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (550, N'GrandResult', N'GetDividedExamByMainExamID', N'GrandResult/GetDividedExamByMainExamID/{GrandExamId}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (551, N'GrandResult', N'GetGrandVirtualExamSetup', N'GrandResult/GetGrandVirtualExamSetup/')--CltrGrandExamEdit
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (552, N'GrandResult', N'AddGrandVirtualExam', N'GrandResult/AddGrandVirtualExam/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (553, N'GrandResult', N'DeleteGrandVirtualExam', N'GrandResult/DeleteGrandVirtualExam/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (554, N'Result', N'GetGrandExam', N'ExamSetup/GetGrandExam/{versionId}/{sessionID}/{classId}/{groupId}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (555, N'Result', N'GetAllSubjectForVirtualExam', N'SubjectSetup/GetAllSubjectForVirtualExam/{versionId}/{classId}/{sessionID}/{groupId}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (556, N'Result', N'GetGrandExamForMarksEntry', N'ExamSetup/GetGrandExamForMarksEntry/{versionId}/{sessionID}/{classId}/{groupId}')-- CltrGrandExamEdit
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (557, N'Result', N'GetMainExamBySession', N'ExamSetup/GetMainExamBySession/{versionId}/{sessionID}/{classId}/{groupId}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (558, N'GrandResult', N'GetGrandSetup', N'GrandResult/GetGrandSetup/{versionId}/{classId}/{sessionID}/{groupId}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (559, N'GrandResult', N'AddGrandSetup', N'GrandResult/AddGrandSetup/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (560, N'GrandResult', N'SingleAddandUpdateGrandSetup', N'GrandResult/SingleAddandUpdateGrandSetup')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (561, N'GrandResult', N'SingleDeleteGrandSetup', N'GrandResult/SingleDeleteGrandSetup/{GrandId}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (587, N'GrandResult', N'DeleteGrandSetup', N'GrandResult/DeleteGrandSetup/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (562, N'GrandResult', N'GetGrandSetupByVCSG', N'GrandResult/GetGrandSetupByVCSG/{versionId}/{sessionID}/{classId}/{groupId}/{mainExamId}')--GrandConfig
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (563, N'Result', N'GetAllSubExam', N'ExamSetup/GetAllSubExam/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (564, N'Result', N'GetAllDividedExam', N'ExamSetup/GetAllDividedExam')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (565, N'GrandResult', N'GetAllGrandSubExam', N'GrandResult/GetAllGrandSubExam/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (566, N'GrandResult', N'GetAllGrandDividedExam', N'GrandResult/GetAllGrandDividedExam/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (567, N'GrandResult', N'GetGrandSetupDetail', N'GrandResult/GetGrandSetupDetail/{versionId?}/{sessionId?}/{classId?}/{groupId?}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (568, N'GrandResult', N'ExamMapping', N'GrandResult/ExamMapping/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (569, N'GrandResult', N'GrandConfigDelete', N'GrandResult/GrandConfigDelete/{MainExamId}/{SubExamId}/{DivExamId}/{GrandExamId}/{GrandSubExamId}/{GrandDivExamId}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (570, N'Result', N'ProccessMainExam', N'Result/ProccessMainExam/{versionId}/{sessionID}/{ShiftId}/{classId}/{groupId}/{MainExamId}')--GrandProcessResult 
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (571, N'Result', N'ProHighestMark', N'Result/ProHighestMark/{versionId}/{sessionID}/{ShiftId}/{classId}/{groupId}/{MainExamId}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (572, N'Result', N'ProMerit', N'Result/ProMerit/{versionId}/{sessionID}/{ShiftId}/{classId}/{groupId}/{MainExamId}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (573, N'Result', N'ProTabulation', N'Result/ProTabulation/{versionId}/{sessionID}/{BranchID}/{ShiftId}/{classId}/{groupId}/{MainExamId}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (574, N'Result', N'GetProccesLog', N'Result/GetProccesLog/{ShiftId}/{MainExamId}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (575, N'GrandResult', N'GetGrandAllMeritListConfigById', N'GrandResult/GetGrandAllMeritListConfigById/') --GrandMeritListConfig
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (576, N'GrandResult', N'GetGrandMeritListConfig', N'GrandResult/GetGrandMeritListConfig/{VersionId}/{SessionId}/{ClassId}/{GroupId}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (577, N'Result', N'GetMainExam', N'ExamSetup/GetMainExam/{versionId}/{sessionID}/{classId}/{groupId}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (578, N'GrandResult', N'GetGrandAllMeritListConfig', N'GrandResult/GetGrandAllMeritListConfig/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (579, N'GrandResult', N'UpdateGrandMeritListConfig', N'GrandResult/UpdateGrandMeritListConfig/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (580, N'GrandResult', N'AddGrandMeritListConfig', N'GrandResult/AddGrandMeritListConfig/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (581, N'GrandResult', N'DeleteGrandMeritListConfig', N'GrandResult/DeleteGrandMeritListConfig/{id}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (582, N'GrandResult', N'GetAllSubject', N'SubjectSetup/GetAllSubject/{versionId}/{classId}/{sessionID}/{groupId}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (583, N'GrandResult', N'GetAssessment', N'GrandResult/GetAssessment/{GrandExamId}/{SubjectId}/{version}/{session}/{branch}/{shift}/{classid}/{groupid}/{section}')--GrandAssessment
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (584, N'GrandResult', N'AddAssessment', N'GrandResult/AddAssessment/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (585, N'Result', N'BulkDeleteStudentMark', N'Result/BulkDeleteStudentMark/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (586, N'GrandResult', N'GetAssessmentSubject', N'GrandResult/GetAssessmentSubject/')
GO

--grand Config Page
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (592, N'GrandResult', N'GetAllSubExam', N'GrandResult/GetAllGrandSubExam/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (593, N'GrandResult', N'GetAllGrandDividedExam', N'GrandResult/GetAllGrandDividedExam/')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (594, N'Result', N'GetGrandSetupDetail', N'GrandResult/GetGrandSetupDetail/{versionId?}/{sessionId?}/{classId?}/{groupId?}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (595, N'GrandResult', N'ExamMapping', N'GrandResult/ExamMapping/')
GO
--grand Config Page end

--QuickAddStudent
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (596, N'GrandResult', N'ExamMapping', N'GrandResult/ExamMapping/')
GO

--User
--Roll
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (801, N'User', N'AddRole', N'user/AddRole/{RoleName}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (802, N'User', N'UpdateRole', N'user/UpdateRole/{RoleName}/{id}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (803, N'User', N'Roles', N'user/Roles/{pageno}/{pagesize}/{searchtxt}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (804, N'User', N'DeleteRoles', N'user/DeleteRoles/{roleid}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (805, N'User', N'GetRolePermission', N'user/GetRolePermission/{roleid}')
GO

--user
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (806, N'User', N'GetAlluser', N'user/GetAlluser/{pageno}/{pagesize}/{searchtext}')
GO
INSERT [dbo].[AspNetApis] ([ApiId], [Controller], [Action], [Route]) VALUES (807, N'User', N'AddRolePermission', N'user/AddRolePermission/{roleid}')
GO




SET IDENTITY_INSERT [dbo].[AspNetApis] OFF
GO
SET IDENTITY_INSERT [dbo].[AspNetPageApis] ON 
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (101, 126, 2021)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (102, 112, 2021)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (103, 103, 2021)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (104, 135, 2021)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (105, 136, 2021)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (106, 134, 2021)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (107, 137, 2021)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (108, 131, 2021)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (109, 132, 2021)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (110, 130, 2021)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (111, 133, 2021)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (112, 123, 2021)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (113, 124, 2021)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (114, 125, 2021)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (115, 121, 2021)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (116, 151, 2021)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (117, 139, 2021)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (118, 141, 2021)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (119, 138, 2021)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (120, 142, 2021)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (121, 140, 2021)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (122, 145, 2021)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (123, 147, 2021)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (124, 143, 2021)
GO
--DynamicListReport
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (125, 105, 2031)

--Edit Student use StudentInfo as a parent
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (126, 113, 2022)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (127, 109, 2022)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (128, 126, 2022)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (129, 135, 2022)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (130, 136, 2022)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (131, 134, 2022)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (132, 137, 2022)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (133, 131, 2022)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (134, 132, 2022)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (135, 130, 2022)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (136, 133, 2022)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (137, 123, 2022)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (138, 124, 2022)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (139, 125, 2022)

GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (140, 121, 2022)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (141, 139, 2022)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (142, 141, 2022)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (143, 138, 2022)

GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (144, 142, 2022)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (145, 140, 2022)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (146, 145, 2022)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (147, 147, 2022)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (148, 143, 2022)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (149, 148, 2022)
GO
--StudentRecord
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (150, 128, 2022)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (151, 150, 2022)
GO
--IdCard
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (152, 105, 2022)
GO
--StuBulkUpload
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (153, 102, 2022)
GO
--StudentInfo
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (154, 105, 2022)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (155, 101, 2022)
GO
--Testimonial
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (156, 106, 2022)
GO
--TransferCertificate
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (157, 106, 2022)
GO

--
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (158, 121, 2022)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (159, 151, 2022)
GO
--Student End

---Institute Setup Start

INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (160, 202, 4016)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (161, 203, 4016)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (162, 201, 4016)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (163, 204, 4016)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (164, 210, 4016)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (165, 212, 4016)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (166, 209, 4016)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (167, 213, 4016)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (168, 206, 4016)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (169, 207, 4016)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (170, 205, 4016)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (171, 208, 4016)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (172, 252, 4016)
GO
--feesbooth
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (173, 229, 4016)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (174, 230, 4016)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (175, 227, 4016)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (176, 231, 4016)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (177, 210, 4016)
GO
--Group
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (178, 219, 4016)
GO

--Section
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (179, 224, 4015)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (180, 225, 4015)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (181, 222, 4015)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (182, 226, 4015)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (183, 219, 4015)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (184, 263, 4015)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (185, 264, 4015)
GO

-- 
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (186, 202, 4015)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (187, 203, 4015)
GO

--session
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (188, 204, 4015)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (189, 203, 4015)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (190, 201, 4015)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (191, 204, 4015)
GO

--Shift 
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (192, 215, 4015)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (193, 216, 4015)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (194, 214, 4015)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (195, 217, 4015)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (196, 210, 4015)
GO

--StudentIDSetup 
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (197, 253, 4015)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (198, 254, 4015)
GO

--_Attendance

INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (199, 301, 303)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (200, 302, 303)
GO

GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (201, 501, 4045)--GrandExamClone id 4045 
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (202, 502, 4045)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (203, 503, 4045)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (204, 504, 4045)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (205, 505, 4045)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (206, 506, 4045)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (207, 507, 4045)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (208, 508, 4045)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (209, 509, 4045)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (210, 510, 4045)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (211, 511, 4045)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (212, 512, 4045)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (213, 513, 4045)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (214, 514, 4045)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (215, 515, 4045)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (216, 516, 4045)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (217, 517, 4045)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (218, 518, 4045)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (219, 519, 4045)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (220, 520, 4043)---GrandExamMarkSetup id 4045
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (221, 521, 4043)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (222, 522, 4043)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (223, 523, 4043)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (224, 524, 4043)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (225, 525, 4043)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (226, 526, 4043)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (227, 527, 4043)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (228, 528, 4043)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (229, 529, 4043)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (230, 530, 4043)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (231, 531, 4043)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (232, 532, 4043)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (233, 533, 4043)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (234, 534, 4043)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (235, 535, 4043)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (236, 536, 4043)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (237, 537, 4043)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (238, 538, 4041)-- GrandExams ID 4041
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (239, 539, 4041)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (240, 540, 4041)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (241, 541, 4042)-- GrandExamsSetup ID 4042
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (242, 542, 4042)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (243, 543, 4042)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (244, 544, 4042)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (245, 545, 4042)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (246, 546, 4042)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (247, 547, 4042)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (248, 548, 4042)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (249, 549, 4042)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (250, 550, 4042)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (251, 551, 4047)--GrandVirtualExam id 4047
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (252, 252, 4047)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (253, 253, 4047)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (254, 254, 4047)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (255, 255, 4047)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (256, 256, 4044)-- GrandSetup id 4044
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (257, 257, 4044)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (258, 558, 4044)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (259, 259, 4044)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (260, 560, 4044)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (261, 561, 4044)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (262, 501, 4046)--GrandConfig id 4046 
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (263, 562, 4046) 
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (264, 563, 4046) 
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (265, 564, 4046) 
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (266, 565, 4046) 
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (267,554 , 4046)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (268, 566, 4046)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (269, 567, 4046) 
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (270, 568, 4046)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (271, 569, 4046) 
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (272, 570, 3021) --GrandProcessResult id 3021
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (273, 571, 3021) 
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (274, 572, 3021) 
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (275, 573, 3021)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (276, 574, 3021) 
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (277, 554, 3021) 
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (278, 575, 3021) --GrandMeritListConfig id 4048
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (279, 576, 4048) 
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (280, 577, 4048) 
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (281, 578, 4048) 
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (282, 579, 4048) 
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (283, 580, 4048) 
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (284, 581, 4048) 
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (285, 582, 4048) 
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (286, 583, 3024)--GrandAssessment id 3024 
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (287, 520, 3024) 
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (288, 584, 3024) 
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (289, 585, 3024) 
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (290, 586, 3024)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (291, 577, 3023) -- GrandMerit id 3023 
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (292, 587, 4044)
GO

INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (301, 554, 303)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (334, 557, 303)
GO
--Employee

--employee list
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (335, 401, 601)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (302, 405, 601)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (303, 431, 601)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (304, 402, 601)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (305, 435, 601)
GO

--Add Employee
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (306, 407, 601)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (307, 408, 601)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (308, 409, 601)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (309, 411, 601)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (310, 412, 601)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (311, 413, 601)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (312, 410, 601)
GO
--category
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (313, 414, 4052)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (314, 417, 4052)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (315, 416, 4052)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (316, 418, 4052)
GO
--Department
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (317, 427, 4056)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (318, 429, 4056)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (319, 428, 4056)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (320, 430, 4056)
GO
--Designation
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (321, 419, 4051)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (322, 421, 4051)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (323, 420, 4051)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (324, 422, 4051)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (325, 415, 4051)
GO
--Status
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (326, 431, 4055)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (327, 433, 4055)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (328, 432, 4055)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (329, 434, 4055)
GO

--subject
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (330, 423, 4053)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (331, 424, 4053)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (332, 426, 4053)
GO
--TeacherSubjectList
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (333, 404, 602)

GO


--Grand Config
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (344, 501, 4046)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (345, 562, 4046)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (336, 563, 4046)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (337, 564, 4046)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (338, 554, 4046)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (339, 565, 4046)

GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (340, 566, 4046)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (341, 567, 4046)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (342, 568, 4046)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (343, 569, 4046)
GO



--Roles
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (346, 803, 503)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (347, 802, 503)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (348, 801, 503)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (349, 804, 503)
GO
--User
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (350, 806, 501)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (351, 805, 501)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (352, 801, 501)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (353, 807, 501)
GO
--QuickAddStudent 
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (370, 126, 2021)
GO
INSERT [dbo].[AspNetPageApis] ([PageApiId], [ApiId], [PageId]) VALUES (371, 131, 2021)
GO

SET IDENTITY_INSERT [dbo].[AspNetPageApis] OFF