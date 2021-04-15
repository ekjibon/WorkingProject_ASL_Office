
truncate table [dbo].[AspNetPages]
GO
SET IDENTITY_INSERT [dbo].[AspNetPages] ON 
GO
------------------------------------------------------------------------------- Student 
INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1,0,N'Student', N'b', 'Student', 'Dashboard','module-student',1,1,1,1)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(101,0,N'Student Entry', N'b', NULL, N'','Student-Entry',1,1,0,1)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1103,101, N'Quick Add Student', N'b', N'Student', N'QuickAddStudent','F',1,0,0,1)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1102,101,N'Bulk Student Update', N'b', N'Student', N'BulkStudentUpdate','F',2,0,0,1)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1101,101,N'Bulk Student Upload', N'b', N'Student', N'StuBulkUpload','F',3,0,0,1)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1104,101,N'Update Student', N'b', N'Student', N'EditStudent/0','F',4,0,0,1)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(102,0,N'Student List', N'b', N'Student', N'StudentInfo','Student-List',2,0,0,1)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(103,0,N'Advance Search', N'b', N'Student', N'StudentSearch','Advance-Search',3,0,0,1)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(104,0,N'Certificates', N'b', NULL, N'','Certificate',3,1,0,1)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1401,104, N'Admit Card', N'b', N'Student', N'StudentAdmitCard','F',1,0,0,1)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1402,104, N'ID Card', N'b', N'Student', N'StudentIDCard','F',2,0,0,1)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1403,104, N'Seat Card', N'b', N'Student', N'StudentSeatCard','F',3,0,0,1)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1404,104, N'Testimonial', N'b', N'Student', N'Testimonial','F',4,0,0,1)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1405,104,N'Character Certificate ', N'b', N'Student', N'CharacterCertificate', 'F',5,0,0,1)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1406,104,N'Transfer Certificate ', N'b', N'Student', N'TransferCertificate','F',6,0,0,1)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1407,104,N'TC Approve ', N'b', N'Student', N'TransferCertificateforApprove','F',7,0,0,1)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1408,104,N'NOC and TC ', N'b', N'Student', N'StudentNOCAndTC','F',8,0,0,1)

GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(105,0, N'Student Transfer', N'b', N'Student', N'StudentTransfer','Student-Transfer',5,0,0,1)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(106,0, N'Send Notification', N'b', N'Student', N'SendNotificationToStudent','Send-Notification',6,0,0,1)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(107,0,N'Request', N'b', NULL, N'','Request',7,1,0,1)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1701,107,N'All Request', N'b', N'Request', N'RequestList','F',1,0,0,1)
		GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1702,107,N'For Meeting', N'b', N'Request', N'ForMeetingList','F',2,0,0,1)
		GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1703,107,N'For Tailor', N'b', N'Request', N'ForTailorList','F',3,0,0,1)
		Go
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(108,0,N'Report', N'b', NULL, N'','Reports',8,1,0,1)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1801,108, N'Dynamic Reports', N'b', N'Student', N'StudentReport','F',1,0,0,1)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1802,108,  N'Statistical Reports', N'b', N'Student', N'StatisticalReport','F',2,0,0,1)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1803,108,  N'Other Reports', N'b', N'Student', N'AccdemicUseVairousType','F',3,0,0,1)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(109,0,N'Set Up', N'b', NULL, N'','Set-Up',9,1,0,1)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1901,109,N'Admit Card Setup', N'b', N'InstitutionSetup', N'AdmitCardSetup','F',1,0,0,1)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1902,109,N'Seat Card Setup', N'b', N'InstitutionSetup', N'SeatCardSetup','F',2,0,0,1)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1903,109,N'Auto Signature Setup', N'b', N'InstitutionSetup', N'SignatureSetup','F',3,0,0,1)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1904,109, N'Route Setup', N'b', N'Student', N'RouteSetup','F',4,0,0,1)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1905,109, N'TTC Template', N'b', N'InstitutionSetup', N'TTCTemplate','F',5,0,0,1)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1906,109, N'Student ID Config', N'b', N'InstitutionSetup', N'StudentIDSetup','F',6,0,0,1)


					GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(112,0,N'CS', N'b', N'InstitutionSetup', N'CS','Eca',10,1,0,1)

			GO

			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(111,0,N'ECA', N'b', NULL, N'','Eca',10,1,0,1)
	GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(11001,111,N'Create Club', N'b', N'InstitutionSetup', N'ECAClub','F',1,0,0,1)
		GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(11002,111,N'Club Config', N'b', N'InstitutionSetup', N'ClubConfig','F',2,0,0,1)
	Go

	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(11004,111,N'Attendance', N'b', N'Request', N'ECAAttendance','F',4,0,0,1)
	GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(11005,111,N'Requests List', N'b', N'Request', N'ECARequestList','F',5,0,0,1)
	GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(11006,111,N'Changing Requests', N'b', N'Request', N'ECAChangingRequest','F',6,0,0,1)
GO
------------------------------------------------------------------------------- Attendence 
INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(2,0,N'Attendance', N'b', 'AttendanceV', 'Dashboard','module-attendance',2,1,1,2)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(201,0,N'Section Wise', N'b', N'AttendanceV', N'StdSectionWiseAttendance','Section-Wise',1,0,0,2)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(202,0,N'Period Wise', N'b', N'AttendanceV', N'StdPeriodWiseAttnSingleDay','Period-Wise',2,0,0,2)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(203,0, N'Leave Apply', N'b', N'AttendanceV', N'StdLeaveApply','Leave-Apply',3,0,0,2)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(204,0, N'Leave List', N'b', N'AttendanceV', N'StdLeaveList','Leave-List',4,0,0,2)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(205,0,N'Section Wise (Teacher)', N'b', N'AttendanceV', N'TeacherStdAttnListSectoinWise','Section-Wise',5,0,0,2)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(206,0, N'Student Absconding', N'b', N'AttendanceV', N'StdAbscondingAttendance',' Student-Absconding',6,0,0,2)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(207,0, N'Report', N'b', NULL, N'',' Attendance-Report',7,1,0,2)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(2701,207,N'Daily Report', N'b', N'AttendanceV', N'StdDailyAttendanceReportPeriodWise','F',1,0,0,2)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(2702,207,N'LIEO Report', N'b', N'AttendanceV', N'StdLIOReport','F',2,0,0,2)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(2703,207,N'Summary Report (Daily)', N'b', N'AttendanceV', N'StdAttendanceSummaryReport','F',3,0,0,2)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(2704,207, N'Monthly Summary Report', N'b', N'AttendanceV', N'StdMonthlyAttendanceReport','F',4,0,0,2)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(2705,207, N'Dynamic Attendance Report', N'b', N'AttendanceV', N'StdDynamicAttendanceReport','F',5,0,0,2)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(2706,207, N'Attendance Summary (Date Range wise)', N'b', N'AttendanceV', N'AttndSummRange','F',6,0,0,2)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(2707,207,N'Monthly Detail', N'b', N'AttendanceV', N'MonthlyAttendance','F',7,0,0,2)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(2708,207, N'Section Wise & Leave Report', N'b', N'AttendanceV', N'SectionWaysAbscondingLeaveAttendance','F',8,0,0,2)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(2709,207,N'Single Student Summery', N'b', N'AttendanceV', N'SingleStudentSummeryReport','F',9,0,0,2)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(2710,207, N'Student Summery', N'b', N'AttendanceV', N'StudentSummeryReportSW','F',10,0,0,2)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(208,0, N'Set Up', N'b', NULL, N'','Set-Up',8,1,0,2)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(2801,208, N'Leave Type', N'b', N'AttendanceV', N'LeaveType','F',1,0,0,2)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(2802,208,N'Academic Calendar Setup', N'b', N'AttendanceV', N'StdAcademicCalendarSetup','F',2,0,0,2)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(2803,208, N'Student Late in Early Out', N'b', N'AttendanceV', N'StdLateinEarlyOut','F',3,0,0,2)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(2804,208, N'Period Teacher Assign', N'b', N'RoutineV', N'PeriodTeacherAssign','F',4,0,0,2)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(2805,208, N'Class Period Setup', N'b', N'RoutineV', N'ClassPeriod','F',5,0,0,2)
GO
------------------------------------------------------------------------------- Result 
INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3,0,N'Result', N'b', 'Result', 'Dashboard','module-result',3,1,1,3)
  GO
  INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(301,0,N'Exam', N'b', NULL, NULL,' Main-Exam',1,1,0,3)
		GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3101,301,N'Result Advance Search', N'b',N'Result',N'AdvanceResultStatistic',N'fa fa-folder-o',1,0,0,3)
		GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3102,301,N'Statistics Report', N'b', N'Result',N'MainExamStatisticReport',N'fa fa-folder-o',2,0,0,3)
		GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3103,301,N'Subject Wise Process', N'b', N'Result', N'SubWiseResultProcess',N'fa fa-folder-o',3,0,0,3)
			GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3104,301,N'Class Wise Process', N'b', N'Result', N'ClassResultProcess',N'fa fa-folder-o',4,0,0,3)
		GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3105,301,N'Subject Wise Result', N'b',N'Result', N'GenerateResultSubWise',N'fa fa-folder-o',5,0,0,3)
				GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3106,301,N'Class Wise Result', N'b',N'Result', N'GenerateResultClassWise',N'fa fa-folder-o',6,0,0,3)
		GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3107,301,N'Merit List', N'b', N'Result', N'Merit',N'fa fa-folder-o',7,0,0,3)
		GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3108,301,N'Marks Entry', N'b', N'Result', N'MarksEntry',N'fa fa-folder-o',8,0,0,3)
		GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3109,301,N'Teacher Marks Entry', N'b', N'Result', N'TeacherMarksEntry',N'fa fa-folder-o',9,0,0,3)
		GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3110,301,N'Marks Upload', N'b', N'Result', N'MarksUpload',N'fa fa-folder-o',10,0,0,3)
		GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3111,301,N'Universal Marks Entry', N'b', N'Result', N'UniversalDynamicMarksEntryPanel',N'fa fa-folder-o',11,0,0,3)
				GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3112,301,N'Term Wise Result', N'b', N'Result', N'TermResult',N'fa fa-folder-o',12,0,0,3)
		--				GO
		--INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3113,301,N'Class Wise Result', N'b', N'Result', N'ResultClassWiseReport',N'fa fa-folder-o',13,0,0,3)
		GO
		--INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3114,301,N'Set Up', N'b', NULL, NULL,N'fa fa-folder-o',14,1,0,3)
						
						GO
  INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(302,0,N'Assessment', N'b',  null, null,'Exam-Attendance',2,0,0,3)
  GO
  	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3204,302,  N'Assessment Options', N'b',  N'Result', N'AssesmentDropdownSetup','F',4,0,0,3)
	
  	GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3201,302,N'Subject Wise', N'b', N'Result', N'AssessmentSubWise',N'fa fa-folder-o',1,0,0,3)
		GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3203,302,N'Class Wise', N'b', N'Result', N'AssessmentClassWise',N'fa fa-folder-o',3,0,0,3)
		  	GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3202,302,N'Student Subject Wise', N'b', N'Result', N'AssementStudentSubjectWise',N'fa fa-folder-o',2,0,0,3)
		GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3205,302,N'Student Class Wise', N'b', N'Result', N'AssementStudentClassWise',N'fa fa-folder-o',5,0,0,3)
				GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3206,302,N'Subject Wise Comments', N'b', N'Result', N'SubjectWiseComments',N'fa fa-folder-o',6,0,0,3)
		GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3207,302,N'Teacher Comments', N'b', N'Result', N'ClassWiseTercherComment',N'fa fa-folder-o',7,0,0,3)
		GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3208,302,N'Head Teacher Comments', N'b', N'Result', N'ClassWiseHeadTercherComment',N'fa fa-folder-o',8,0,0,3)

					                                                                                         --Grand Exam Sub Menu End--
  GO
  INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(303,0,N'Exam Attendance', N'b',  N'Result', N'MainExamResultAttendanceSetup','Exam-Attendance',3,0,0,3)
  GO
  INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(304,0,N'Promotion', N'b', NULL, NULL,'Promotion ',4,0,0,3)
         GO
         INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3401,304,N'Pass Promotion', N'b', N'Promotion', N'PassStudentPromotion', N'fa fa-folder-o',1,0,0,3)
		 GO
         INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3402,304,N'Fail Promotion', N'b',  N'Promotion', N'FailStudentPromotion', N'fa fa-folder-o',2,0,0,3)
		 GO
         INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3403,304,N'Bypass Promotion', N'b',  N'Promotion', N'ByPassPromotion', N'fa fa-folder-o',3,0,0,3)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(305,0,N'Set Up', N'b', NULL, NULL,'Set-Up',5,0,0,3)
		  Go
		  INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3501,305,N'Subject Setup', N'b', N'Result', N'SubjectSetup',  N'fa fa-cogs',1,0,0,3)
		  Go
		  INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3502,305,N'Student Subject', N'b', N'Result', N'StudentSubject',  N'fa fa-cogs',2,0,0,3)
		  Go
		  INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3506,305,N'Grade Policy', N'b', N'Result', N'GradeSetup',  N'fa fa-cogs',6,0,0,3)
		  Go
		  INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3507,305, N'Rounding Rule', N'b', N'Result', N'MarksMigratedSetup',  N'fa fa-cogs',7,0,0,3)
		    Go
		  INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3508,305,N'Highest Mark Policy', N'b', N'Result', N'HighestMarkSetup',  N'fa fa-cogs',8,0,0,3)
		    Go
		  INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3509,305,N'Report Config', N'b', N'Result', N'ReportConfig',  N'fa fa-cogs',9,0,0,3)
		  GO
		                INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3503,305,N'Exam', N'b', N'Result', N'MainExam', N'fa fa-cogs',3,0,0,3)
												GO
		                INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3504,305,N'Exam Subject List', N'b', N'Result', N'ExamSetup',N'fa fa-cogs',4,0,0,3)
						GO
		                INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3505,305,N'Exam Mark Setup', N'b', N'Result', N'MainExamMarkSetup',N'fa fa-cogs',5,0,0,3)
		  --  Go
		  --INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3507,305,N'Grade Policy', N'b', N'Result', N'GradeSetup', N'fa fa-cogs',7,0,0,3)
		  --  Go
		  --INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3508,305,N'Merit Config', N'b', N'Result', N'MeritListConfig', N'fa fa-cogs',8,0,0,3)
		  --  Go
		  --INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3509,305,N'Highest Mark Policy', N'b', N'Result', N'HighestMarkSetup',  N'fa fa-cogs',9,0,0,3)
		  -- Go
		  --INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3510,305,N'Report Config', N'b', N'Result', N'ReportConfig',  N'fa fa-cogs',10,0,0,3)
		   --Go
		  --INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3511,305,N'Subject List', N'b', N'Result', N'SubjectDetail',  N'fa fa-cogs',11,0,0,3)
		  -- Go
		 -- INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3512,305, N'Class Subject Config', N'b',  N'InstitutionSetup', N'ClassSubjectConfig',  N'fa fa-cogs',12,0,0,3)
		                                                                                                         --Promotion Sub Menu End--
  --GO
  --INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(306,0,N'Archive', N'b', NULL, NULL,'Archive ',6,0,0,3)
	 -- GO
  --    INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3601,306,N'MainExamResult', N'b', N'archive', N'MainExamArchive', N'fa fa-clipboard',1,0,0,3)
	 -- GO
  --    INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3602,306,N'MainExamTab', N'b', N'archive', N'MainExamTabArchive', N'fa fa-clipboard',2,0,0,3)
		--           GO
  --    INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3603,306,N'MainExamMerit', N'b', N'archive', N'MainExamMeritArchive', N'fa fa-clipboard',3,0,0,3)
		--          GO
  --       INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3604,306,N'GrandExamResult', N'b', N'archive', N'GrandExamArchive', N'fa fa-clipboard',4,0,0,3)
		-- 		          GO
  --       INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3605,306,N'GrandExamTab', N'b', N'archive', N'GrandExamTabArchive', N'fa fa-clipboard',5,0,0,3)
		--          GO
  --       INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(3606,306,N'GrandExamMerit', N'b', N'archive', N'GrandExamMeritArchive', N'fa fa-clipboard',6,0,0,3)
GO
if((SELECT DB_NAME() AS [Current Database]) ='mgsc_new_2018')
BEGIN
         INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(307,0,N'StaticReport-MGSC', N'b', N'Result', N'StaticReport', N'fa fa-clipboard',6,0,0,3)
END
GO
------------------------------------------------------------------------------- Fees 
INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(4,0,N'Fees', N'b', 'FeesV', 'Dashboard','module-fees',4,1,1,4)
GO
	  INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES(401,0, N'POS/Live Collection', N'b', N'FeesV', N'FeesCollection', N'POS-Live',  1,0,0,4)
	  GO
	  INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (402, 0, N'Process', N'b', N'FeesV', N'FeesProcess', N'Process',2,1,0,4)
	  GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (4201, 402, N'Process', N'b', N'FeesV', N'FeesProcess',N'',1,0,0,4)
			GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (4202, 402, N'Fees Book', N'b', N'FeesV', N'FeesBook',N'F',2,0,0,4)
		--	GO
	 --INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (403, 0, N'Without Process Collection', N'b', N'FeesV', N'FeesCollectionWithoutProcess', N'Process-Collection', 3,0,0,4)
	 GO
	 
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (404, 0, N'Modify Processed Fees', N'b', N'FeesV', N'ModifyProcessedFees', N' Processed-Fees',4,0,0,4)
	--GO
	--INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (405, 0, N'Modify Money Receipt', N'b', N'FeesV', N'ModifyMoneyReceipt', N' Money-Receipt',5,0,0,4)
	GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (406, 0, N'Admin Collection', N'b', N'FeesV', N'BulkFeesCollection', N'Admin-Collection', 6,0,0,4)
	--GO
	--INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (407, 0, N'Bulk Collection', N'b', N'FeesV', N'FeesCollectionBulkUpload', N'Bulk-Collection',7,0,0,4)
	--GO
	--INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (408, 0, N'Online Collection', N'b', N'FeesV', N'OnlineFeesCollection', N'Online-Collection', 8,0,0,4)
	GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (409, 0, N'Report', N'b', NULL, NULL, N'Reports', 9,1,0,4)
	 GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (4901, 409, N'Fees Collection Report', N'b', N'FeesV', N'FeesCollectionReport',N'F',1,0,0,4)
			GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (4902, 409, N'Individual Student', N'b', N'FeesV', N'IndividualStudentReport',N'F', 2,0,0,4)
			GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (4903, 409, N'FeesDueReport', N'b', N'FeesV', N'FeesDueReport',N'F', 3,0,0,4)
			GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (4904, 409, N'Money Receipt Print', N'b', N'FeesV', N'MoneyReceiptView',N'F',4,0,0,4)
			GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(4010,0,N'Setup', N'b', NULL, NULL,'Set-Up',10,1,0,4)
	  GO
			 --INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (41011, 4010, N'Fees Booth', N'b', N'InstitutionSetup', N'FeesBooth',N'F',1,0,0,4)
			 GO
			 INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (41013, 4010, N'Student Fees Config', N'b', N'FeesV', N'CommonFees',N'F',  3,0,0,4)
			 GO
			 INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (41012, 4010, N'Fees Process Setup', N'b', N'FeesV', N'FeesProcessSetup',N'F', 2,0,0,4)
			GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (41011, 4010, N'Fees Head Setup', N'b', N'FeesV', N'FeesHeadSetup',N'F',1,0,0,4)
			GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (41016, 4010, N'Scholarship', N'b', N'FeesV', N'StudentScholarship',N'F', 6,0,0,4)
			GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (41017, 4010, N'Scholarship Type', N'b', N'FeesV', N'ScholarshipType',N'F',7,0,0,4)
			GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (41014, 4010, N'Automated Fees', N'b', N'FeesV', N'AutomatedFeesConfig',N'F',4,0,0,4)
			GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (41018, 4010, N'Fees Setting', N'b', N'FeesV', N'FeesSetting',N'F', 8,0,0,4)
			--GO
			-- INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (41019, 4010, N'Fees Transport Config', N'b', N'FeesV', N'FeesTransportConfig',N'F', 9,0,0,4)
			--GO
			--INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (41110, 4010, N'Fees Group Setup', N'b', N'FeesV', N'FeesHeadDisplayGroupSetup',N'F',10,0,0,4)
			--GO
			--	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (41111, 4010, N'Fiscal Session Setup', N'b', N'FeesV', N'FeesSession',N'F',11,0,0,4)
			GO
------------------------------------------------------------------------------- SMS 
INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(5,0,N'SMS', N'b', 'SmsV', 'Dashboard','module-sms-bg',5,1,1,5)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(501,0,N'Settings', N'b', N'SmsV', N'GetSmsSettings','Settings',1,0,0,5)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(502,0,N'SMS Template', N'b', N'SmsV', N'SmsTemplate','SMS-Template',2,0,0,5)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(503,0,N'SMS Template List', N'b', N'SmsV', N'SmsTemplateList','SMS-Template-List',3,0,0,5)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(504,0,N'Static SMS', N'b', NULL, NULL,'Static-SMS',4,1,0,5)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(5401,504, N'Send SMS', N'b', N'SmsV', N'StaticSendSMS','F',1,0,0,5)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(5402,504,  N'Excel Generate', N'b', N'SmsV', N'StaticSMSExcel','F',2,0,0,5)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(5403,504,  N'Filtered SMS', N'b', N'SmsV', N'FilteredSendSMS','F',3,0,0,5)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(505,0,N'Dynamic SMS', N'b', NULL, NULL,' Dynamic-SMS',5,1,0,5)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(5501,505, N'Send Dynamic Sms', N'b', N'smsv', N'DynamicSmsSend','F',1,0,0,5)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(506,0,N'Schedule SMS Config', N'b', N'smsv', N'ScheduleSMSConfig','Schedule-SMS-Config',6,0,0,5)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(507,0, N'Auto SMS Config', N'b', N'SmsV', N'AutoSMSConfig','Auto-SMS-Config',6,0,0,5)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(508,0, N'Reports', N'b', NULL, NULL,'Reports',7,1,0,5)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(5801,508, N'SMS History Report', N'b', N'SmsV', N'SmsHistoryReport','F',1,0,0,5)
GO
------------------------------------------------------------------------------- Routine 
INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(6,0,N'Routine', N'b', 'RoutineV', 'Dashboard','module-routen',6,1,1,6)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(601,0,N'Class Period Setup', N'b', N'RoutineV', N'ClassPeriod','F',1,0,0,6)
GO
------------------------------------------------------------------------------- LMS 
--INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(7,0,N'LMS', N'b', 'RoutineV', 'Dashboard','module-lms',7,1,1,7)
--GO
------------------------------------------------------------------------------- Accounts 
INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(8,0,N'Accounts', N'b' ,'AccountV', 'Dashboard','module-accounts',8,1,1,8)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(801,0, N'Payment', N'b', N'AccountV', N'Payment','Payment-ac',1,0,0,8)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(802,0,N'Receive', N'b', N'AccountV', N'Receive','Receive-ac',2,0,0,8)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(803,0,N'Contra', N'b', N'AccountV', N'Contra','Contra-ac',3,0,0,8)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(804,0, N'Journal', N'b', N'AccountV', N'Journal','Journal-ac',4,0,0,8)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(805,0,N'Transactions', N'b', N'AccountV', N'TransactionList','Transactions-ac',5,0,0,8)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(806,0,N'Report', N'b', NULL, NULL,'Reports',6,0,0,8)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(807,0,N'Set Up', N'b', NULL, NULL,'Set-Up',7,1,0,8)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(8701,807, N'Fiscal Year', N'b', N'AccountV', N'FiscalYearSetup','F',1,0,0,8)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(8702,807,N'Account Branch', N'b', N'AccountV', N'AcBranchSetup','F',2,0,0,8)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(8703,807, N'Group Setup', N'b', N'AccountV', N'AcGroupSetup','F',3,0,0,8)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(8704,807, N'Ledger Setup', N'b', N'AccountV', N'AcLedgerSetup','F',4,0,0,8)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(8705,807,N'Chartered Of Accounts', N'b', N'AccountV', N'COA','F',5,0,0,8)
GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(8706,807,N'Code Setup', N'b', N'AccountV', N'CodeSetup','F',6,0,0,8)
		GO
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(8707,807,N'Accounts Integration', N'b', N'AccountV', N'AccountsIntegration','F',7,0,0,8)
GO
------------------------------------------------------------------------------- Inventory 
INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(9,0,N'Inventory', N'b', 'InventoryV', 'Dashboard','module-inverntory',9,1,1,9)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId] ) VALUES (901, 0, N'SetUp', N'b', Null, Null, N'Set-Up',1,1,0,9)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (9101, 901, N'Product Category', N'b',  N'InventoryV', N'ProductCategory', N'F',1,0,0,9)
			GO
				INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (9102, 901, N'Product Sub Category', N'b',  N'InventoryV', N'ProductSubCategory', N'F',2,0,0,9)
			GO
				INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (9103, 901, N'Unit Setup', N'b',  N'InventoryV', N'UnitSetup', N'F',3,0,0,9)
			GO
					INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (9104, 901, N'Product List', N'b',  N'InventoryV', N'ProductList', N'F',4,0,0,9)
			GO
------------------------------------------------------------------------------- HR & Payrol 
INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId] ) VALUES(10,0,N'HR & Payrol', N'b', 'Employee', 'Dashboard','module-hr',10,1,1,10)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId] ) VALUES (1001, 0, N'Quick Add Employee', N'b', N'Employee', N'QuickAddEmployee', N'Quick-Add',1,0,0,10)
	GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId] ) VALUES (1002, 0, N'Employee List', N'b', N'Employee', N'EmployeeList', N'Employee-List', 2,0,0,10)
	--GO
	--INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId] ) VALUES (1003, 0, N'Subject List', N'b', N'Employee', N'TeacherSubjectList', N'Subject-List',3,0,0,10)
	GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId] ) VALUES (1004, 0, N'Subject Mark Entry', N'b', N'Employee', N'TeacherMarksEntrySubjectList', N'Subject-Mark',4,0,0,10)
	GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId] ) VALUES (1005, 0, N'Employee ID Card', N'b', N'Employee', N'EmployeeIdCard', N'Employee-ID', 5,0,0,10)
	GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId] ) VALUES (1006, 0, N'My Profile', N'b', N'Employee', N'EmployeeProfile', N'My-Profile', 6,0,0,10)
		GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId] ) VALUES (1007, 0, N'Leave List', N'b', N'Employee', N'ApproveOrRejectLvApp', N'My-Profile', 7,0,0,10)
		GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (1008, 0, N'HRM Setup', N'b', NULL, NULL, N'Set-Up', 8,1,0,10)
	GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (10701, 1008, N'Designation', N'b',  N'Employee', N'Designation', N'F',1,0,0,10)
			GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (10702, 1008, N'Category', N'b',  N'Employee', N'Category', N'F', 2,0,0,10)
			GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (10703, 1008, N'Subject', N'b',  N'Employee', N'Subject', N'F', 3,0,0,10)
			GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (10704, 1008, N'Employee Status', N'b',  N'Employee', N'Status', N'F', 4,0,0,10)
			GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (10705, 1008, N'Department', N'b',  N'Employee', N'Department', N'F', 5,0,0,10)
			GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (10706, 1008, N' Class Teacher Assign', N'b',  N'Employee', N'ClassTeacherAssign', N'F', 6,0,0,10)
			GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (10707, 1008, N'Meeting Person Assign', N'b',  N'Employee', N'MeetingPersonAssign', N'fa fa-edit', 7,0,0,10)
			GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (10708, 1008, N'Period Teacher Assign', N'b', N'RoutineV', N'PeriodTeacherAssign',N'F',8,0,0,10)
			GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (10710, 1008, N'Leave', N'b', N'Employee', N'Leave',N'F',10,0,0,10)
						GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (10711, 1008, N'Leave Category', N'b', N'Employee', N'LeaveCategory',N'F',11,0,0,10)
						GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (10712, 1008, N'Leave Quota', N'b', N'Employee', N'LeaveQuota',N'F',12,0,0,10)
									GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (10713, 1008, N'LIEO', N'b', N'Employee', N'EMPLateInEarlyOut',N'F',13,0,0,10)
			GO
			
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (1009, 0, N'Salary Setup', N'b', NULL, NULL, N'Set-Up', 9,1,0,10)
	GO
	GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (10801, 1009, N'Salary Grade', N'b', N'Employee', N'SalaryGrade',N'F',1,0,0,10)
			GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (10802, 1009, N'Salary Head', N'b', N'Employee', N'SalaryHead',N'F',2,0,0,10)
			GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (10803, 1009, N'Head Wise Config', N'b', N'Employee', N'SalaryHeadWiseConfig',N'F',3,0,0,10)
			--GO
			--INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (10804, 1008, N'Salary Increment', N'b', N'Employee', N'SalaryIncrement',N'F',4,0,0,10)
			--GO
			--INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (10805, 1008, N'Salary Pay Details', N'b', N'Employee', N'SalaryPayDetails',N'F',5,0,0,10)
			GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (10806, 1009, N'Salary Period', N'b', N'Employee', N'SalaryPeriod',N'F',6,0,0,10)
			GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (10807, 1009, N'Salary Structure', N'b', N'Employee', N'SalaryStructure',N'F',7,0,0,10)
			GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (10808, 1009, N'Tax Year', N'b', N'Employee', N'SalaryTax',N'F',8,0,0,10)
			GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (10809, 1009, N'Salary Process', N'b', N'Employee', N'SalaryProcess',N'F',9,0,0,10) 
			GO
			INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (10810, 1009, N'Generate Payslip', N'b', N'Employee', N'GeneratePayrol',N'F',10,0,0,10)
			GO
					
			
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId]) VALUES (10811, 1008, N'Accounts Integration', N'b', N'AccountV', N'AccountsIntegration',N'F',11,0,0,10)
	GO
------------------------------------------------------------------------------- Library 
--INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(11,0,N'Library', N'b','Library', 'Dashboard','module-library',11,1,1,11)
--GO
------------------------------------------------------------------------------- User Management 
INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(12,0,N'User', N'b', NULL, NULL,'',12,1,1,12)
GO

INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(141,0,N'User Management', N'b', NULL, NULL,'',12,1,0,12)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(121,141, N'Users', N'b', N'Users', N'Users','',1,0,0,12)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(122,141,N'Subject Assign', N'b' ,N'Result', N'AssignSubjectsToTeacher','',2,0,0,12)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(123,141,N'Roles', N'b', N'Users', N'Roles','',3,0,0,12)
GO
------------------------------------------------------------------------------- Institute SetUp 

	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(131,0,N'Institution Setup', N'b', NULL, NULL,'',5,1,0,12)
--GO
--	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1301,131, N'Version', N'b', N'InstitutionSetup', N'Version','',6,0,0,12)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1302,131, N'Branch', N'b', N'InstitutionSetup', N'Branch','',6,0,0,12)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1303,131,N'Shift', N'b', N'InstitutionSetup', N'Shift','',4,0,0,12)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1304,131,N'Session', N'b', N'InstitutionSetup', N'Session','',5,0,0,12)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1305,131, N'Class', N'b', N'InstitutionSetup', N'Class','',6,0,0,12)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1306,131,N'Section', N'b', N'InstitutionSetup', N'Section','',7,0,0,12)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1307,131, N'Student Type', N'b', N'InstitutionSetup', N'StudentType','',8,0,0,12)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1308,131, N'Student House', N'b', N'InstitutionSetup', N'StudentHouse','',9,0,0,12)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1309,131, N'Institution Info', N'b', N'InstitutionSetup', N'MyInstitution','',10,0,0,12)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1310,131, N'Report Header', N'b',  N'Report', N'ReportHeader','module-library',11,0,0,12)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1311,131, N'Student ID Config', N'b', N'InstitutionSetup', N'StudentIDSetup','',12,0,0,12)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1312,131, N'Common DropDown', N'b', N'Common', N'DropDownConfig','F',13,0,0,12)
GO
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1313,131,N'TTC Template', N'b', N'InstitutionSetup', N'TTCTemplate','F',14,0,0,12)
--GO
--	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1314,131, N'Fees Booth', N'b', N'InstitutionSetup', N'FeesBooth','f',15,0,0,12)
GO  --Saul Vai order Arif
	INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(1315,131,  N'Term', N'b',  N'InstitutionSetup', N'Term','F',16,0,0,12)
GO
							
		INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES(132,0,N'Document Upload', N'b', N'InstitutionSetup', N'DocumentUpload','Set-Up',6,1,0,12)

		GO
