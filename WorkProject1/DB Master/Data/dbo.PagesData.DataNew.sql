GO
Truncate table [AspNetPages]
GO
SET IDENTITY_INSERT [dbo].[AspNetPages] ON 
GO
 ----------------------------------------------------------------------------------------------------------------------------------------------------
 INSERT [dbo].[AspNetPages] ([PageID], [ParentID], [NameOption_En], [NameOption_Bn], [Controller], [Action], [Area], [IconClass], [ActiveLi], [Status], [Displayorder], [IsParent]) VALUES
(2, 0, N'Student ', N'b', NULL, NULL, NULL, N'fa fa-graduation-cap', NULL, N'A', 1, 1),
(3, 0, N'Result', N'b', NULL, NULL, NULL, N'fa fa-newspaper-o', NULL, N'A', 2, 1),
(4, 0, N'Setup', N'b', NULL, NULL, NULL, N'fa fa-cog', NULL, N'A', 3, 1),
(5, 0, N'User Management', N'b', NULL, NULL, NULL, N'fa fa-user-plus', NULL, N'A', 5, 1),
(6, 0, N'Employee', N'b', NULL, NULL, NULL, N'fa fa-user', NULL, N'A', 4, 1),
(7, 0, N'Fees', N'b', NULL, NULL, NULL, N'fa fa-user', NULL, N'A', 6, 1),
(8, 0, N'SMS', N'b', NULL, NULL, NULL, N'fa fa-user', NULL, N'A', 7, 1),
(9, 0, N'Archive', N'b', NULL, NULL, NULL, N'fa fa-file-archive-o', NULL, N'A', 7, 1),
(10, 0, N'Accounts', N'b', NULL, NULL, NULL, N'fa fa-user', NULL, N'A', 9, 1),

--------------------------------------------------------------------------------------------------
(201, 2, N'Bulk Student Upload', N'b', N'Student', N'StuBulkUpload', NULL, N'fa fa-upload', NULL, N'A', 1, 0),
(202, 2, N'Student Record', N'b', NULL, N'', NULL, N'fa fa-address-card-o', NULL, N'A', 2, 0),
(203, 2, N'Reports', N'b', NULL, N'', NULL, N'fa fa-columns', NULL, N'A', 8, 0),
(204, 2, N'Academic Info', N'b', NULL, N'', NULL, N'fa fa-address-card-o', NULL, N'A', 3, 0),

(201, 2, N'Student Entry', N'b', NULL, N'', NULL, N'fa fa-address-card-o', NULL, N'A', 1, 0),
(202, 2, N'Student List', N'b', N'Student', N'StudentInfo', NULL, N'fa fa-address-card-o', NULL, N'A', 2, 0),
(203, 2, N'Advance Search', N'b', N'Student', N'StudentSearch',  NULL, N'fa fa-address-card-o', NULL, N'A', 3, 0),
(204, 2, N'Certificates', N'b', NULL, N'', NULL, N'fa fa-address-card-o', NULL, N'A', 4, 0),
(205, 2, N'Reports', N'b', NULL, N'', NULL, N'fa fa-address-card-o', NULL, N'A', 5, 0),
(206, 2, N'Attendance', N'b', NULL, N'', NULL, N'fa fa-address-card-o', NULL, N'A', 6, 0),
(207, 2, N'Attendance Report', N'b', NULL, N'', NULL, N'fa fa-address-card-o', NULL, N'A', 7, 0),
(208, 2, N'Student Transfer', N'b', N'Student', N'StudentTransfer',  NULL, N'fa fa-address-card-o', NULL, N'A', 8, 0),
(209, 2, N'Send Notification', N'b', N'Student', N'SendNotificationToStudent',  NULL, N'fa fa-address-card-o', NULL, N'A', 9, 0),

(301, 3, N'Main Exam', N'b', NULL, NULL, NULL, N'fa fa-folder-o', NULL, N'A', 6, 0),
(302, 3, N'Grand Exam', N'b', NULL, NULL, NULL, N'fa fa-folder-o', NULL, N'A', 6, 0),
(303, 3, N'Exam Attendance', N'b', N'Result', N'MainExamResultAttendanceSetup', NULL, N'fa fa-folder-o', NULL, N'A', 8, 0),
(304, 3, N'Promotion', N'b', NULL, NULL, NULL, N'fa fa-folder-o', NULL, N'A', 9, 0),
(305, 3, N'StaticReport-MGSC', N'b', N'Result', N'StaticReport', NULL, N'fa fa-folder-o', NULL, N'A', 8, 0),

(401, 4, N'Institution Setup', N'b', NULL, NULL, NULL, N'fa fa-edit', NULL, N'A', 1, 0),
(402, 4, N'Academic', N'b', NULL, NULL, NULL, N'fa fa-calendar-o', NULL, N'A', 2, 0),
(403, 4, N'Main Exam', N'b', NULL, NULL, NULL, N'fa fa-calendar-o', NULL, N'A', 3, 0),
(404, 4, N'Grand Exam', N'b', NULL, NULL, NULL, N'fa fa-calendar-o', NULL, N'A', 4, 0),
(405, 4, N'Employee Setup', N'b', NULL, NULL, NULL, N'fa fa-users', NULL, N'A', 5, 0),
(406, 4, N'Student Attendance', N'b', NULL, NULL, NULL, N'fa fa-users', NULL, N'A', 6, 0),
(407, 4, N'Routine', N'b', NULL, NULL, NULL, N'fa fa-users', NULL, N'A', 7, 0),
(408, 4, N'Fees', N'b', NULL, NULL, NULL, N'fa fa-users', NULL, N'A', 8, 0),
(409, 4, N'Attendance', N'b', NULL, NULL, NULL, N'fa fa-users', NULL, N'A', 9, 0),
(412, 4, N'Accounts', N'b', NULL, NULL, NULL, N'fa fa-users', NULL, N'A', 10, 0),

(501, 5, N'Users', N'b', N'Users', N'Users', NULL, N'fa fa-user', NULL, N'A', 1, 0),
(502, 5, N'Subject Assign', N'b', N'Result', N'AssignSubjectsToTeacher', NULL, N'fa fa-user', NULL, N'A', 2, 0),
(503, 5, N'Roles', N'b', N'Users', N'Roles', NULL, N'fa fa-check-square-o', NULL, N'A', 3, 0),

(701, 7, N'Collection', N'b', NULL, NULL, NULL, N'fa fa-clipboard', NULL, N'A', 1, 0),
(701, 7, N'POS/Live Collection', N'b', N'FeesV', N'FeesCollection', NULL, N'fa fa-clipboard', NULL, N'A', 1, 0),
(702, 7, N'Process', N'b', N'FeesV', N'FeesProcess', NULL, N'fa fa-clipboard', NULL, N'A', 8, 0),
(704, 7, N'Without Process Collection', N'b', N'FeesV', N'FeesCollectionWithoutProcess', NULL, N'fa fa-clipboard', NULL, N'A', 3, 0),
(705, 7, N'Report', N'b', NULL, NULL, NULL, N'fa fa-clipboard', NULL, N'A', 9, 0),
(706, 7, N'Modify Processed Fees', N'b', N'FeesV', N'ModifyProcessedFees', NULL, N'fa fa-clipboard', NULL, N'A', 6, 0),
(707, 7, N'Modify Money Receipt', N'b', N'FeesV', N'ModifyMoneyReceipt', NULL, N'fa fa-clipboard', NULL, N'A', 7, 0),
(708, 7, N'Admin Collection', N'b', N'FeesV', N'BulkFeesCollection', NULL, N'fa fa-clipboard', NULL, N'A', 2, 0),
(709, 7, N'Bulk Collection', N'b', N'FeesV', N'FeesCollectionBulkUpload', NULL, N'fa fa-clipboard', NULL, N'A', 4, 0),
(710, 7, N'Online Collection', N'b', N'FeesV', N'OnlineFeesCollection', NULL, N'fa fa-clipboard', NULL, N'A', 5, 0),


(602, 6, N'Employee List', N'b', N'Employee', N'EmployeeList', NULL, N'fa fa-user', NULL, N'A', 1, 0),
(601, 6, N'Quick Add Employee', N'b', N'Employee', N'QuickAddEmployee', NULL, N'fa fa-user', NULL, N'A', 2, 0),
(603, 6, N'Subject List', N'b', N'Employee', N'TeacherSubjectList', NULL, N'fa fa-user', NULL, N'A', 3, 0),
(604, 6, N'Subject List', N'b', N'Employee', N'TeacherMarksEntrySubjectList', NULL, N'fa fa-user', NULL, N'A', 4, 0),
(605, 6, N'Employee ID Card', N'b', N'Employee', N'EmployeeIdCard', NULL, N'fa fa-user', NULL, N'A', 5, 0),
(606, 6, N'My Profile', N'b', N'Employee', N'EmployeeProfile', NULL, N'fa fa-user', NULL, N'A', 6, 0),
(607, 6, N'Update Employee', N'b', N'Employee', N'UpdateEmployeeProfile', NULL, N'fa fa-user', NULL, N'A', 7, 0),


--------------------------------------------------------------------------------------------------
(2021, 201, N'Bulk Student Upload', N'b', N'Student', N'StuBulkUpload', NULL, N'fa fa-clipboard', NULL, N'A', 1, 0),
(2022, 201, N'Bulk Student Update', N'b', N'Student', N'BulkStudentUpdate', NULL, N'fa fa-clipboard', NULL, N'A', 2, 0),
(2023, 201, N'Quick Add Student', N'b', N'Student', N'QuickAddStudent', NULL, N'fa fa-clipboard', NULL, N'A', 3, 0),
(2024, 201, N'Update Student', N'b', N'Student', N'EditStudent/0', NULL, N'fa fa-clipboard', NULL, N'A', 4, 0),

(2021, 202, N'Quick Add Student', N'b', N'Student', N'QuickAddStudent', NULL, N'fa fa-user-circle', NULL, N'A', 1, 0),
(2023, 202, N'Update Student', N'b', N'Student', N'UpdateStudentInfo', NULL, N'fa fa-user-circle', NULL, N'A', 2, 0),
(2022, 202, N'Student List', N'b', N'Student', N'StudentInfo', NULL, N'fa fa-user-plus', NULL, N'A', 3, 0),
(2024, 202, N'Bulk Student Update', N'b', N'Student', N'BulkStudentUpdate', NULL, N'fa fa-user-circle', NULL, N'A', 4, 0),
(2037, 202, N'Advance Search', N'b', N'Student', N'StudentSearch', NULL, N'fa fa-search', NULL, N'A', 9, 0),

(2031, 203, N'Dynamic List Reports', N'b', N'Student', N'DynamicListReport', NULL, N'fa fa-clipboard', NULL, N'A', 3, 0),
(2032, 203, N'Statistical Reports', N'b', N'Student', N'StatisticalReport', NULL, N'fa fa-clipboard', NULL, N'A', 4, 0),
(2038, 203, N'Student Dynamic Reports', N'b', N'Student', N'StudentReport', NULL, N'fa fa-bars', NULL, N'A', 10, 0),
(2039, 203, N'Addmission Status Summary', N'b', N'Report', N'AddmissionStatusSummary', NULL, N'fa fa-clipboard', NULL, N'A', 11, 0),
(2040, 203, N'Admit Card', N'b', N'Student', N'StudentAdmitCard', NULL, N'fa fa-clipboard', NULL, N'A', 12, 0),
(2041, 203, N'TOT List', N'b', N'Student', N'TOTList', NULL, N'fa fa-clipboard', NULL, N'A', 13, 0),
(2042, 203, N'Seat Card', N'b', N'Student', N'StudentSeatCard', NULL, N'fa fa-clipboard', NULL, N'A', 14, 0),
(2043, 203, N'ID Card', N'b', N'Student', N'StudentIDCard', NULL, N'fa fa-clipboard', NULL, N'A', 15, 0),
(2044, 203, N'Academic Use Vairous Type', N'b', N'Student', N'AcademicUseVairousType', NULL, N'fa fa-clipboard', NULL, N'A', 16, 0),

(2031, 204, N'Admit Card', N'b', N'Student', N'StudentAdmitCard', NULL, N'fa fa-clipboard', NULL, N'A', 1, 0),
(2032, 204, N'ID Card', N'b', N'Student', N'StudentIDCard', NULL, N'fa fa-clipboard', NULL, N'A', 2, 0),	
(2033, 204, N'Seat Card', N'b', N'Student', N'StudentSeatCard', NULL, N'fa fa-clipboard', NULL, N'A', 3, 0),
(2034, 204, N'Testimonial', N'b', N'Student', N'Testimonial', NULL, N'fa fa-clipboard', NULL, N'A', 4, 0),	 
(2035, 204, N'Character Certificate ', N'b', N'Student', N'CharacterCertificate', NULL, N'fa fa-clipboard', NULL, N'A', 5, 0),	
(2036, 204, N'Transfer Certificate ', N'b', N'Student', N'TransferCertificate', NULL, N'fa fa-clipboard', NULL, N'A', 6, 0),	
(2037, 204, N'TC Approve ', N'b', N'Student', N'TransferCertificateforApprove', NULL, N'fa fa-clipboard', NULL, N'A', 7, 0),	
(2038, 204, N'NOC and TC ', N'b', N'Student', N'StudentNOCAndTC', NULL, N'fa fa-clipboard', NULL, N'A', 8, 0),
(2033, 204, N'Testimonial', N'b', N'Student', N'Testimonial', NULL, N'fa fa-clipboard', NULL, N'A', 5, 0),
(2034, 204, N'Transfer Certificate ', N'b', N'Student', N'TransferCertificate', NULL, N'fa fa-clipboard', NULL, N'A', 6, 0),
(2035, 204, N'Character Certificate ', N'b', N'Student', N'CharacterCertificate', NULL, N'fa fa-clipboard', NULL, N'A', 7, 0),
(2036, 204, N'TC Approve ', N'b', N'Student', N'TransferCertificateforApprove', NULL, N'fa fa-clipboard', NULL, N'A', 8, 0),

(2041, 205, N'Dynamic Reports', N'b', N'Student', N'StudentReport', NULL, N'fa fa-bars', NULL, N'A', 1, 0),
(2042, 205, N'Statistical Reports', N'b', N'Student', N'StatisticalReport', NULL, N'fa fa-clipboard', NULL, N'A', 2, 0),
(2045, 205, N'Other Reports', N'b', N'Student', N'AccdemicUseVairousType', NULL, N'fa fa-clipboard', NULL, N'A', 4, 0),

(2051, 206, N'Section Wise', N'b', N'AttendanceV', N'StdSectionWiseAttendance', NULL, N'fa fa-clipboard', NULL, N'A', 17, 0),
(2052, 206, N'Period Wise (Monthly),', N'b', N'AttendanceV', N'StdPeriodWiseAttendance', NULL, N'fa fa-clipboard', NULL, N'A', 18, 0),
(2053, 206, N'Period Wise', N'b', N'AttendanceV', N'StdPeriodWiseAttnSingleDay', NULL, N'fa fa-clipboard', NULL, N'A', 19, 0),
(2054, 206, N'Leave Apply', N'b', N'AttendanceV', N'StdLeaveApply', NULL, N'fa fa-clipboard', NULL, N'A', 21, 0),
(2055, 206, N'Leave List', N'b', N'AttendanceV', N'StdLeaveList', NULL, N'fa fa-clipboard', NULL, N'A', 22, 0),
(2056, 206, N'Section Wise (Teacher),', N'b', N'AttendanceV', N'TeacherStdAttnListSectoinWise', NULL, N'fa fa-clipboard', NULL, N'A', 23, 0),
(2057, 206, N'Student Absconding', N'b', N'AttendanceV', N'StdAbscondingAttendance', NULL, N'fa fa-clipboard', NULL, N'A', 24, 0),
(2070, 206, N'Leave Report', N'b', N'AttendanceV', N'SectionWaysAbscondingLeaveAttendance', NULL, N'fa fa-clipboard', NULL, N'A', 32, 0),



(2061, 207, N'Daily Report', N'b', N'AttendanceV', N'StdDailyAttendanceReportPeriodWise', NULL, N'fa fa-clipboard', NULL, N'A', 23, 0),
(2062, 207, N'LIEO Report', N'b', N'AttendanceV', N'StdLIOReport', NULL, N'fa fa-clipboard', NULL, N'A', 24, 0),
(2063, 207, N'Summary Report (Daily),', N'b', N'AttendanceV', N'StdAttendanceSummaryReport', NULL, N'fa fa-clipboard', NULL, N'A', 25, 0),
(2064, 207, N'Monthly Summary Report', N'b', N'AttendanceV', N'StdMonthlyAttendanceReport', NULL, N'fa fa-clipboard', NULL, N'A', 26, 0),
(2065, 207, N'Dynamic Attendance Report', N'b', N'AttendanceV', N'StdDynamicAttendanceReport', NULL, N'fa fa-clipboard', NULL, N'A', 27, 0),
(2066, 207, N'Attendance Summary (Date Range wise),', N'b', N'AttendanceV', N'AttndSummRange', NULL, N'fa fa-clipboard', NULL, N'A', 28, 0),
(2067, 207, N'Monthly Detail', N'b', N'AttendanceV', N'MonthlyAttendance', NULL, N'fa fa-clipboard', NULL, N'A', 29, 0),
(2068, 207, N'Section Wise & Leave Report', N'b', N'AttendanceV', N'SectionWaysAbscondingLeaveAttendance', NULL, N'fa fa-clipboard', NULL, N'A', 30, 0),
(2069, 207, N'Device Report', N'b', N'AttendanceV', N'DeviceReport', NULL, N'fa fa-clipboard', NULL, N'A', 31, 0),
(2070, 207, N'Single Student Summery', N'b', N'AttendanceV', N'SingleStudentSummeryReport', NULL, N'fa fa-clipboard', NULL, N'A', 32, 0),
(2071, 207, N'Student Summery', N'b', N'AttendanceV', N'StudentSummeryReportSW', NULL, N'fa fa-clipboard', NULL, N'A', 33, 0),



(3009, 301, N'Result Advance Search', N'b', N'Result', N'AdvanceResultStatistic', NULL, N'fa fa-folder-o', NULL, N'A', 12, 0),
(3010, 301, N'Statistics Report', N'b', N'Result', N'MainExamStatisticReport', NULL, N'fa fa-folder-o', NULL, N'A', 11, 0),
(3013, 301, N'Generate Result', N'b', N'Result', N'MainExamGenerateResult', NULL, N'fa fa-folder-o', NULL, N'A', 3, 0),
(3014, 301, N'Merit List', N'b',  N'Result', N'Merit', NULL, N'fa fa-folder-o', NULL, N'A', 4, 0),
(3015, 301, N'Marks Entry', N'b', N'Result', N'MarksEntry', NULL, N'fa fa-folder-o', NULL, N'A', 5, 0),
(3016, 301, N'Teacher Marks Entry', N'b', N'Result', N'TeacherMarksEntry', NULL, N'fa fa-folder-o', NULL, N'A', 6, 0),
(3017, 301, N'Marks Upload', N'b', N'Result', N'MarksUpload', NULL, N'fa fa-folder-o', NULL, N'A', 7, 0),
(3018, 301, N'Subject Assign Report', N'b', N'Result', N'SubjectAssignReport', NULL, N'fa fa-folder-o', NULL, N'A', 8, 0),
(3018, 301, N'Staticties Report', N'b', N'Result', N'StaticReport', NULL, N'fa fa-folder-o', NULL, N'A', 8, 0),
(3019, 301, N'Universal Marks Entry', N'b', N'Result', N'UniversalDynamicMarksEntryPanel', NULL, N'fa fa-folder-o', NULL, N'A', 9, 0),
(3020, 301, N'Assessment', N'b', N'Result', N'MainExamAssessment', NULL, N'fa fa-folder-o', NULL, N'A', 10, 0),
(3015, 301, N'Teacher Marks Entry', N'b', N'Result', N'TeacherMarksEntry', NULL, N'fa fa-folder-o', NULL, N'A', 9, 0),

(3021, 302, N'Proccess Result', N'b', N'Result', N'GrandProcessResult', NULL, N'fa fa-folder-o', NULL, N'A', 1, 0), 	   
(3022, 302, N'Generate Result', N'b', N'Result', N'GrandGenerateResult', NULL, N'fa fa-folder-o', NULL, N'A', 2, 0), 	   
(3023, 302, N'Merit List', N'b',  N'GrandResult', N'GrandMerit', NULL, N'fa fa-folder-o', NULL, N'A', 3, 0),
(3024, 302, N'Grand Assessment', N'b',  N'GrandResult', N'GrandAssessment', NULL, N'fa fa-folder-o', NULL, N'A', 3, 0),
(3028, 302, N'Statistics Report', N'b',  N'GrandResult', N'GrandStatisticReport', NULL, N'fa fa-folder-o', NULL, N'A', 4, 0),
(3029, 302, N'Advance Result Statistic', N'b',  N'GrandResult', N'GrandAdvanceResultStatistic', NULL, N'fa fa-folder-o', NULL, N'A', 5, 0),


(3025, 304, N'Pass Promotion', N'b', N'Promotion', N'PassStudentPromotion', NULL, N'fa fa-folder-o', NULL, N'A', 1, 0), 	   
(3026, 304, N'Fail Promotion', N'b',  N'Promotion', N'FailStudentPromotion', NULL, N'fa fa-folder-o', NULL, N'A', 2, 0),
(3027, 304, N'Bypass Promotion', N'b',  N'Promotion', N'ByPassPromotion', NULL, N'fa fa-folder-o', NULL, N'A', 3, 0),


(4011, 401, N'Version', N'b', N'InstitutionSetup', N'Version', NULL, N'fa fa-edit', NULL, N'A', 1, 0),
(4012, 401, N'Branch', N'b', N'InstitutionSetup', N'Branch', NULL, N'fa fa-edit', NULL, N'A', 2, 0),
(4013, 401, N'Shift', N'b', N'InstitutionSetup', N'Shift', NULL, N'fa fa-edit', NULL, N'A', 3, 0),
(4014, 401, N'Session', N'b', N'InstitutionSetup', N'Session', NULL, N'fa fa-edit', NULL, N'A', 4, 0),
(4015, 401, N'Class', N'b', N'InstitutionSetup', N'Class', NULL, N'fa fa-edit', NULL, N'A', 5, 0),
(4016, 401, N'Section', N'b', N'InstitutionSetup', N'Section', NULL, N'fa fa-edit', NULL, N'A', 6, 0),
(4017, 401, N'Student Type', N'b', N'InstitutionSetup', N'StudentType', NULL, N'fa fa-edit', NULL, N'A', 8, 0),
(4018, 401, N'Student House', N'b', N'InstitutionSetup', N'StudentHouse', NULL, N'fa fa-edit', NULL, N'A',9, 0),
(4019, 401, N'Institution Info', N'b', N'InstitutionSetup', N'MyInstitution', NULL, N'fa fa-edit', NULL, N'A', 10, 0),
(4020, 401, N'Report Header', N'b',  N'Report', N'ReportHeader', NULL, N'fa fa-edit', NULL, N'A', 11, 0),
(40102, 401, N'Student ID Config', N'b', N'InstitutionSetup', N'StudentIDSetup', NULL, N'fa fa-edit', NULL, N'A', 12, 0),
(40103, 401, N'Common DropDown', N'b', N'Common', N'DropDownConfig', NULL, N'fa fa-edit', NULL, N'A',13, 0),
(40104, 401, N'TTC Template', N'b', N'InstitutionSetup', N'TTCTemplate', NULL, N'fa fa-edit', NULL, N'A', 14, 0),
(40105, 401, N'Fees Booth', N'b', N'InstitutionSetup', N'FeesBooth', NULL, N'fa fa-edit', NULL, N'A', 15, 0),
(40106, 401, N'Group', N'b',  N'InstitutionSetup', N'Group', NULL, N'fa fa-edit', NULL, N'A', 7, 0),
(4070, 401, N'Admit Card Setup', N'b', N'InstitutionSetup', N'AdmitCardSetup', NULL, N'fa fa-edit', NULL, N'A', 10, 0),
(4071, 401, N'Seat Card Setup', N'b', N'InstitutionSetup', N'SeatCardSetup', NULL, N'fa fa-edit', NULL, N'A', 11, 0),
(4072, 401, N'Auto Signature Setup', N'b', N'InstitutionSetup', N'SignatureSetup', NULL, N'fa fa-edit', NULL, N'A', 12, 0),
(4073, 401, N'Route Setup', N'b', N'Student', N'RouteSetup', NULL, N'fa fa-edit', NULL, N'A', 13, 0),

(4021, 402, N'Subject Setup', N'b', N'Result', N'SubjectSetup', NULL, N'fa fa-cogs', NULL, N'A', 1, 0),
(4022, 402, N'Subject Process', N'b', N'Result', N'SubjectProcess', NULL, N'fa fa-cogs', NULL, N'A', 2, 0),
(4023, 402, N'Selective Subject Setup', N'b', N'Result', N'SelectiveSubject', NULL, N'fa fa-cogs', NULL, N'A', 3, 0),
(4024, 402, N'Optional Subject Setup', N'b', N'Result', N'OptionalSubject', NULL, N'fa fa-cogs', NULL, N'A', 4, 0),
(4025, 402, N'Fouth Subject Rules', N'b', N'Result', N'FouthSubjectRules', NULL, N'fa fa-cogs', NULL, N'A', 5, 0),
(4026, 402, N'Rounding Rule', N'b', N'Result', N'MarksMigratedSetup', NULL, N'fa fa-cogs', NULL, N'A', 6, 0),
(4027, 402, N'Grade Policy', N'b', N'Result', N'GradeSetup', NULL, N'fa fa-cogs', NULL, N'A', 7, 0),
(4028, 402, N'Merit Config', NULL, N'Result', N'MeritListConfig', NULL, N'fa fa-cogs', NULL, N'A', 8, 0),
(4029, 402, N'Highest Mark Policy', N'b', N'Result', N'HighestMarkSetup', NULL, N'fa fa-cogs', NULL, N'A', 9, 0),
(4030, 402, N'Report Config', NULL, N'Result', N'ReportConfig', NULL, N'fa fa-cogs', NULL, N'A', 10, 0),
(4031, 402, N'Subject List', N'b', N'Result', N'SubjectDetail', NULL, N'fa fa-cogs', NULL, N'A', 11, 0),
(4040, 402, N'Class Subject Config', N'b',  N'InstitutionSetup', N'ClassSubjectConfig', NULL, N'fa fa-cogs', NULL, N'A', 1, 0),

(4032, 403, N'Exam List', N'b', N'Result', N'ExamList', NULL, N'fa fa-cogs', NULL, N'A', 1, 0),
(4033, 403, N'Main Exam Mark Setup', N'b', N'Result', N'MainExamMarkSetup', NULL, N'fa fa-cogs', NULL, N'A', 2, 0),
(4036, 403, N'Virtual Config', N'b', N'Result', N'VirtualExam', NULL, N'fa fa-cogs', NULL, N'A', 6, 0),
(4037, 403, N'Tab Config', N'b',  N'Result', N'TabConfig', NULL, N'fa fa-cogs', NULL, N'A', 7, 0),
(4038, 403, N'Tab Header', N'b',  N'Result', N'TabHeaderSetup', NULL, N'fa fa-cogs', NULL, N'A', 8, 0),
(4039, 403, N'Main Exam Clone', N'b',  N'Result', N'CloneMainExam', NULL, N'fa fa-cogs', NULL, N'A', 9, 0),

(4041, 404, N'Grand Exam List', N'b',  N'GrandResult', N'GrandExams', NULL, N'fa fa-cogs', NULL, N'A', 1, 0),
(4042, 404, N'Grand Exam Setup', N'b',  N'GrandResult', N'GrandExamsSetup', NULL, N'fa fa-cogs', NULL, N'A', 2, 0),
(4043, 404, N'Grand ExamMark Setup', N'b',  N'GrandResult', N'GrandExamMarkSetup', NULL, N'fa fa-cogs', NULL, N'A', 3, 0),
(4044, 404, N'Grand Mark Percent', N'b',  N'GrandResult', N'GrandSetup', NULL, N'fa fa-cogs', NULL, N'A', 4, 0),
(4045, 404, N'Grand Exam Clone', N'b',  N'GrandResult', N'GrandExamClone', NULL, N'fa fa-cogs', NULL, N'A', 5, 0),
(4046, 404, N'Grand Config', N'b',  N'GrandResult', N'GrandConfig', NULL, N'fa fa-cogs', NULL, N'A', 6, 0),
(4047, 404, N'Grand Virtual Exam', N'b',  N'GrandResult', N'GrandVirtualExam', NULL, N'fa fa-cogs', NULL, N'A', 7, 0),
(4048, 404, N'Grand Merit Config', N'b',  N'GrandResult', N'GrandMeritListConfig', NULL, N'fa fa-cogs', NULL, N'A', 8, 0),
(4049, 404, N'Leave Student', N'b',  N'Result', N'MainExamLeave', NULL, N'fa fa-cogs', NULL, N'A', 8, 0),

(4051, 405, N'Designation', N'b',  N'Employee', N'Designation', NULL, N'fa fa-cogs', NULL, N'A', 1, 0),
(4052, 405, N'Category', N'b',  N'Employee', N'Category', NULL, N'fa fa-cogs', NULL, N'A', 2, 0),
(4053, 405, N'Subject', N'b',  N'Employee', N'Subject', NULL, N'fa fa-cogs', NULL, N'A', 3, 0),
(4055, 405, N'Employee Status', N'b',  N'Employee', N'Status', NULL, N'fa fa-cogs', NULL, N'A', 5, 0),
(4056, 405, N'Department', N'b',  N'Employee', N'Department', NULL, N'fa fa-cogs', NULL, N'A', 6, 0),
(4057, 405, N' Class Teacher Assign', N'b',  N'Employee', N'ClassTeacherAssign', NULL, N'fa fa-cogs', NULL, N'A', 7, 0),
(4058, 405, N'Leave', N'b',  N'Employee', N'Leave', NULL, N'fa fa-cogs', NULL, N'A', 7, 0),






(4081, 406, N'Academic Calendar Setup', N'b', N'AttendanceV', N'StdAcademicCalendarSetup', NULL, N'fa fa-edit', NULL, N'A', 13, 0),
(4082, 406, N'Student Late in Early Out', N'b', N'AttendanceV', N'StdLateinEarlyOut', NULL, N'fa fa-edit', NULL, N'A', 14, 0),
(4083, 406, N'Teacher Period Setup', N'b', N'AttendanceV', N'StdTeacherPeriodSetup', NULL, N'fa fa-edit', NULL, N'A', 15, 0),

(4063, 407, N'Period Setup', N'b', N'AttendanceV', N'PeriodSetup', NULL, N'fa fa-edit', NULL, N'A', 15, 0),
(4064, 407, N'Period Teacher Assign', N'b', N'RoutineV', N'PeriodTeacherAssign', NULL, N'fa fa-edit', NULL, N'A', 16, 0),
(4065, 407, N'Class Period Setup', N'b', N'RoutineV', N'ClassPeriod', NULL, N'fa fa-edit', NULL, N'A', 17, 0),


(4100, 408, N'Student Fees Config', N'b', N'FeesV', N'CommonFees', NULL, N'fa fa-edit', NULL, N'A', 3, 0),
(4102, 408, N'Individual Fees', N'b', N'FeesV', N'IndividualFees', NULL, N'fa fa-edit', NULL, N'A', 21, 0),
(4103, 408, N'Session Year Setup', N'b', N'FeesV', N'SessionYearSetup', NULL, N'fa fa-edit', NULL, N'A', 20, 0),
(4103, 408, N'Session Year Setup', N'b', N'FeesV', N'SessionYearSetup', NULL, N'fa fa-edit', NULL, N'A', 20, 0),
(4104, 408, N'Fees Process Setup', N'b', N'FeesV', N'FeesProcessSetup', NULL, N'fa fa-edit', NULL, N'A', 2, 0),
(4105, 408, N'Fees Head Setup', N'b', N'FeesV', N'FeesHeadSetup', NULL, N'fa fa-edit', NULL, N'A', 1, 0),
(4106, 408, N'Scholarship', N'b', N'FeesV', N'StudentScholarship', NULL, N'fa fa-edit', NULL, N'A', 7, 0),
(4107, 408, N'Scholarship Type', N'b', N'FeesV', N'ScholarshipType', NULL, N'fa fa-edit', NULL, N'A', 6, 0),
(4108, 408, N'Automated Fees', N'b', N'FeesV', N'AutomatedFeesConfig', NULL, N'fa fa-edit', NULL, N'A', 5, 0),
(4109, 408, N'Add Automated Fees', N'b', N'FeesV', N'AddAutomatedFees', NULL, N'fa fa-plus', NULL, N'A', 26, 0),
(4110, 408, N'Fees Setting', N'b', N'FeesV', N'FeesSetting', NULL, N'fa fa-edit', NULL, N'A', 8, 0),
(4111, 408, N'FeesTransportConfig', N'b', N'FeesV', N'FeesTransportConfig', NULL, N'fa fa-edit', NULL, N'A', 4, 0),
(4112, 408, N'Fees Group Setup', N'b', N'FeesV', N'FeesHeadDisplayGroupSetup', NULL, N'fa fa-edit', NULL, N'A', 9, 0),

(4091, 409, N'Leave Type', N'b', N'AttendanceV', N'LeaveType', NULL, N'fa fa-edit', NULL, N'A', 20, 0),


(4120, 412, N'Fiscal Year', N'b', N'AccountV', N'FiscalYearSetup', NULL, N'fa fa-edit', NULL, N'A', 4, 0),
(4121, 412, N'Account Branch', N'b', N'AccountV', N'AcBranchSetup', NULL, N'fa fa-edit', NULL, N'A', 1, 0),
(4122, 412, N'Group Setup', N'b', N'AccountV', N'AcGroupSetup', NULL, N'fa fa-edit', NULL, N'A', 5, 0),
(4123, 412, N'Ledger Setup', N'b', N'AccountV', N'AcLedgerSetup', NULL, N'fa fa-edit', NULL, N'A', 6, 0),
(4124, 412, N'Chartered Of Accounts', N'b', N'AccountV', N'COA', NULL, N'fa fa-edit', NULL, N'A', 3, 0),
(4125, 412, N'Code Setup', N'b', N'AccountV', N'CodeSetup', NULL, N'fa fa-edit', NULL, N'A', 2, 0),

(8001, 701, N'POS/Live Collection', N'b', N'FeesV', N'FeesCollection', NULL, N'fa fa-clipboard', NULL, N'A', 1, 0),
(8002, 701, N'Without Process Collection', N'b', N'FeesV', N'FeesCollectionWithoutProcess', NULL, N'fa fa-clipboard', NULL, N'A', 3, 0),
(8003, 701, N'Admin Collection', N'b', N'FeesV', N'BulkFeesCollection', NULL, N'fa fa-clipboard', NULL, N'A', 2, 0),
(8004, 701, N'Bulk Collection', N'b', N'FeesV', N'FeesCollectionBulkUpload', NULL, N'fa fa-clipboard', NULL, N'A', 4, 0),
(8005, 701, N'Online Collection', N'b', N'FeesV', N'OnlineFeesCollection', NULL, N'fa fa-clipboard', NULL, N'A', 5, 0),

(7001, 702, N'Process', N'b', N'FeesV', N'FeesProcess', NULL, N'fa fa-edit', NULL, N'A', 21, 0),
(7002, 702, N'Fees Book', N'b', N'FeesV', N'FeesBook', NULL, N'fa fa-edit', NULL, N'A', 22, 0),



(7010, 705, N'Fees Collection Report', N'b', N'FeesV', N'FeesCollectionReport', NULL, N'fa fa-edit', NULL, N'A', 1, 0),
(7011, 705, N'Individual Student', N'b', N'FeesV', N'IndividualStudentReport', NULL, N'fa fa-edit', NULL, N'A', 2, 0),
(7012, 705, N'Money Receipt Print', N'b', N'FeesV', N'MoneyReceiptView', NULL, N'fa fa-edit', NULL, N'A', 3, 0),
(7013, 705, N'Fees Due Report', N'b', N'FeesV', N'FeesDueReport', NULL, N'fa fa-edit', NULL, N'A', 4, 0),
(7014, 705, N'Fees Modify Report', N'b', N'FeesV', N'FeesModifyReport', NULL, N'fa fa-edit', NULL, N'A', 5, 0),



(40109, 40108, N'Setup', N'b', NULL, N'', NULL, N'fa fa-clipboard', NULL, N'A', 3, 0),

(40110, 40109, N'Settings', N'b', N'SmsV', N'GetSmsSettings', NULL, N'fa fa-clipboard', NULL, N'A', 2, 0),

(40111, 40109, N'SMS Template', N'b', N'SmsV', N'SmsTemplate', NULL, N'fa fa-clipboard', NULL, N'A', 1, 0),

(40112, 40109, N'SMS Template List', N'b', N'SmsV', N'SmsTemplateList', NULL, N'fa fa-clipboard', NULL, N'A', 3, 0),

(40113, 40114, N'Send SMS', N'b', N'SmsV', N'StaticSendSMS', NULL, N'fa fa-clipboard', NULL, N'A', 3, 0),

(40114, 40108, N'Static SMS', N'b', NULL, N'', NULL, N'fa fa-clipboard', NULL, N'A', 3, 0),

(40115, 40114, N'Excel Generate', N'b', N'SmsV', N'StaticSMSExcel', NULL, N'fa fa-clipboard', NULL, N'A', 3, 0),

(40116, 40108, N'Dynamic SMS', N'b', NULL, N'', NULL, N'fa fa-clipboard', NULL, N'A', 3, 0),

(40117, 40116, N'Send Dynamic Sms', N'b', N'smsv', N'DynamicSmsSend', NULL, N'fa fa-clipboard', NULL, N'A', 3, 0),

(40118, 40109, N'Schedule SMS Config', N'b', N'smsv', N'ScheduleSMSConfig', NULL, N'fa fa-clipboard', NULL, N'A', 4, 0),

(40119, 40108, N'Reports', N'b', NULL, N'', NULL, N'fa fa-clipboard', NULL, N'A', 5, 0),

(40120, 40119, N'SMS History Report', N'b', N'SmsV', N'SmsHistoryReport', NULL, N'fa fa-clipboard', NULL, N'A', 1, 0),

(40121, 40114, N'Filtered SMS', N'b', N'SmsV', N'FilteredSendSMS', NULL, N'fa fa-clipboard', NULL, N'A', 3, 0),

(40122, 40109, N'Auto SMS Config', N'b', N'SmsV', N'AutoSMSConfig', NULL, N'fa fa-clipboard', NULL, N'A', 5, 0),

(50001, 9, N'MainExamResult', N'b', N'archive', N'MainExamArchive', NULL, N'fa fa-clipboard', NULL, N'A', 5, 0),

(50002, 9, N'MainExamTab', N'b', N'archive', N'MainExamTabArchive', NULL, N'fa fa-clipboard', NULL, N'A', 5, 0),

(50003, 9, N'MainExamMerit', N'b', N'archive', N'MainExamMeritArchive', NULL, N'fa fa-clipboard', NULL, N'A', 5, 0),

(50004, 9, N'GrandExamResult', N'b', N'archive', N'GrandExamArchive', NULL, N'fa fa-clipboard', NULL, N'A', 5, 0),

(50005, 9, N'GrandExamTab', N'b', N'archive', N'GrandExamTabArchive', NULL, N'fa fa-clipboard', NULL, N'A', 5, 0),

(50006, 9, N'GrandExamMerit', N'b', N'archive', N'GrandExamMeritArchive', NULL, N'fa fa-clipboard', NULL, N'A', 5, 0),

(1001, 10, N'Payment', N'b', N'AccountV', N'Payment', NULL, N'fa fa-edit', NULL, N'A', 1, 0),

(1002, 10, N'Receive', N'b', N'AccountV', N'Receive', NULL, N'fa fa-edit', NULL, N'A', 2, 0),

(1003, 10, N'Contra', N'b', N'AccountV', N'Contra', NULL, N'fa fa-edit', NULL, N'A', 3, 0),

(1004, 10, N'Journal', N'b', N'AccountV', N'Journal', NULL, N'fa fa-edit', NULL, N'A', 4, 0),

(1005, 10, N'Transactions', N'b', N'AccountV', N'TransactionList', NULL, N'fa fa-edit', NULL, N'A', 5, 0),

(1006, 10, N'Reports', N'b', N'AccountV', N'Reports', NULL, N'fa fa-edit', NULL, N'A', 6, 0),

SET IDENTITY_INSERT [dbo].[AspNetPages] OFF
GO
