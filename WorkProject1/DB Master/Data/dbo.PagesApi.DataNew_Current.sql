
truncate table [dbo].[AspNetPages]

--SET IDENTITY_INSERT [dbo].[AspNetPages] ON 

------------------------------------------------------------------------------- Student 
INSERT INTO [dbo].[AspNetPages](PageID,[ParentID],[NameOption_En], [NameOption_Bn],[Controller],[Action],[IconClass],[Displayorder],[IsParent],[IsModule],[ModuleId])VALUES
(1,0,N'HR & Payroll', N'b', 'Employee', 'Dashboard','module-hr',1,1,1,1),-- Module 

(101,0,N'Quick Add Employee', N'b', 'Employee', N'QuickAddEmployee','Quick-Add',1,0,0,1), -- Main Manu
(102,0,N'Employee List', N'b', N'Employee', N'EmployeeList','Employee-List',2,0,0,1),-- Main Manu
(103,0,N'Employee ID Card', N'b', N'Employee', N'EmployeeIdCard','Employee-ID',3,0,0,1),-- Main Manu
(104,0, N'My Profile', N'b', N'Employee', N'EmployeeProfile','My-Profile',4,0,0,1),-- Main Manu
--(105,0, N'Leave List', N'b', N'Employee', N'ApproveOrRejectLvApp','My-Profile',5,0,0,1),-- Main Manu

(106,0, N'Request', N'b', NULL, NULL, N'Request',6,1,0,1),-- Main Manu
(1041,106, N'All Request', N'b', N'Employee', N'GetAllEmployeeRequest','F',1,0,0,1),
(1042,106, N'Meeting', N'b', N'Employee', N'MeetingList','F',2,0,0,1),

(107,0, N'Basic Setup', N'b', NULL, NULL, N'Set-Up',7,1,0,1),-- Main Manu
(1071,107,N'Department', N'b',  N'Employee', N'Department', N'F',1,0,0,1),
(1072,107, N'Designation', N'b',  N'Employee', N'Designation','F',2,0,0,1),
(1073,107,N'Category', N'b',  N'Employee', N'Category', N'F',3,0,0,1),
(1074,107, N'Calendar Setup', N'b', N'AttendanceV', N'EmpCalenderSetup','F',4,0,0,1),
(1075,107,  N'Modify Request', N'b', N'AttendanceV', N'LeaveModificationType',N'F',5,0,0,1),
(1076,107,N'Subject', N'b',  N'Employee', N'Subject', N'F',6,0,0,1),
(1077,107,N'Employee Status', N'b',  N'Employee', N'Status', N'F',7,0,0,1),

--(1076,107, N'Meeting Person Assign', N'b',  N'Employee', N'MeetingPersonAssign', N'fa fa-edit', 6,0,0,1),
--(1077,107, N'Period Teacher Assign', N'b', N'RoutineV', N'PeriodTeacherAssign',N'F',7,0,0,1),

--(10710,107, N'LIEO', N'b', N'Employee', N'EMPLateInEarlyOut',N'F',10,0,0,1),
--(10711,107, N'Accounts Integration', N'b', N'AccountV', N'AccountsIntegration',N'F',11,0,0,1),


--(10714,107,N'Roster Setup', N'b', N'AttendanceV', N'RosterSetup','F',13,0,0,1),
--(10715,107,N'Roster Approve', N'b', N'AttendanceV', N'RosterApproval','F',14,0,0,1),

--(10717,107, N'Modify Attendance(Absent)', N'b', N'AttendanceV', N'ModifyAttendanceAbsent','F',16,0,0,1),

--(10719,107, N'Modify Attendance Approve(Absent)', N'b', N'AttendanceV', N'ModifyAttendanceAbsentApproval','F',18,0,0,1),
--(10720,107, N'Submit Attendance', N'b', N'AttendanceV', N'SubmitEmployeeAttendance','F',19,0,0,1),




(108,0, N'Attendance', N'b', NULL, NULL, N'Set-Up',8,1,0,1),-- Main Manu
(1081,108 ,N'Calendar Config', N'b', N'AttendanceV', N'EmpCalenderConfig','F',1,0,0,1),
(1082,108, N'Emp Calender Config', N'b', N'AttendanceV', N'EmpAcademicCalenderConfigDetails','F',2,0,0,1),
(1083,108, N'Modify Attendance', N'b', N'AttendanceV', N'ModifyAttendance','F',3,0,0,1),
(1084,108, N'Modify Attendance Approve', N'b', N'AttendanceV', N'ModifyAttendanceApproval','F',4,0,0,1),
(1085,108, N'Attendance Process', N'b', N'AttendanceV', N'AttendanceDeviceSync','F',5,0,0,1),

(109,0, N'Leave', N'b', NULL, NULL, N'Set-Up', 9,1,0,1),-- Main Manu
(1091,109, N'Leave Routing Config', N'b', N'Employee', N'LeaveRoutingConfig','F',1,0,0,1),
(1092,109, N'Leave Quota', N'b', N'Employee', N'LeaveQuota',N'F',2,0,0,1),
(1099,109,  N'Leave Approval', N'b', N'Employee', N'LeaveApporval',N'F',3,0,0,1),

(1010,0, N'Salary Setup', N'b', NULL, NULL, N'Set-Up', 10,1,0,1),-- Main Manu
(10101,1010, N'Salary Head', N'b', N'Employee', N'SalaryHead',N'F',1,0,0,1),
(10102,1010, N'Salary Year', N'b', N'Employee', N'SalaryYear',N'F',2,0,0,1),
(10103,1010, N'Tax Year Setup', N'b', N'Employee', N'SalaryTax',N'F',3,0,0,1),
(10104,1010, N'Salary Period', N'b', N'Employee', N'SalaryPeriod',N'F',4,0,0,1),
(10105,1010, N'Head Wise Config', N'b', N'Employee', N'SalaryHeadWiseConfig',N'F',5,0,0,1),
(10106,1010, N'Salary Hold', N'b', N'Employee', N'SalaryHold',N'F',6,0,0,1),
(10107,1010, N'Salary Hold Refund', N'b', N'Employee', N'SalaryHoldRefund',N'F',7,0,0,1),
(10108,1010, N'Reward Entry', N'b', N'Employee', N'RewardEntry',N'F',8,0,0,1),
(10109,1010, N'Income Tax Setup', N'b', N'Employee', N'IncomeTaxConfig',N'F',9,0,0,1),
(101010,1010, N'Salary Increment', N'b', N'Employee', N'SalaryIncrement',N'F',10,0,0,1),
(101011,1010, N'Advance Salary', N'b', N'Employee', N'AdvanceSalary',N'F',11,0,0,1),
(101012,1010, N'Salary Process', N'b', N'Employee', N'SalaryProcess',N'F',12,0,0,1),
(101013,1010, N'Salary View And Modification', N'b', N'Employee', N'SalaryViewAndModification',N'F',13,0,0,1),


(1011,0,N'Report', N'b', NULL, N'','Reports',11,1,0,1),-- Main Manu
(10111,1011, N'Attendance Summary', N'b', N'AttendanceV', N'EmployeeAttendanceSummaryReport',N'F',1,0,0,1),
(10112,1011, N'Attendance Details', N'b', N'AttendanceV', N'EmployeeAttendanceDetailsReport',N'F',2,0,0,1),
(10113,1011, N'Individual Employee Attendance Report', N'b', N'AttendanceV', N'IndividualEmployeeAttendanceReport',N'F',3,0,0,1),  
(10114,1011, N'Salary Sheet', N'b', N'Employee', N'SalarySheet',N'F',4,0,0,1),
(10115,1011, N'Generate Payslip', N'b', N'Employee', N'GeneratePayrol',N'F',5,0,0,1),
(10116,1011, N'Cheque Payment Summary', N'b', N'Employee', N'SalaryReportChequePayment',N'F',6,0,0,1),
(10117,1011, N'Deduction Report', N'b', N'Employee', N'SalaryDeductionReport',N'F',7,0,0,1),
(10118,1011, N'Salary Advice', N'b', N'Employee', N'SalaryAdviceReport',N'F',8,0,0,1), 
(10119,1011, N'Salary Hold', N'b', N'Employee', N'SalaryHoldReport',N'F',9,0,0,1),
(101110,1011, N'Salary Hold Refund Reports', N'b', N'Employee', N'SalaryHoldRefundReports',N'F',10,0,0,1),
(101111,1011, N'Unethical Exit Report', N'b', N'Employee', N'UnethicalExitReport',N'F',11,0,0,1),

(1012,0,N'My Leave', N'b', 'Employee', N'EmployeeRequest','',12,1,0,1),-- Main Manu
(1013,0,N'My Attendance', N'b', 'Employee', N'EmpAttendance','',13,1,0,1),-- Main Manu

------------------------------------------------------------------------------- Attendence------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 
(2,0,N'Attendance', N'b', 'AttendanceV', 'Dashboard','module-attendance',2,1,1,2), -- Module 
(201,0,N'Section Wise', N'b', N'AttendanceV', N'StdSectionWiseAttendance','Section-Wise',1,0,0,2),-- Main Manu
(202,0,N'Period Wise', N'b', N'AttendanceV', N'StdPeriodWiseAttnSingleDay','Period-Wise',2,0,0,2),-- Main Manu
(203,0, N'Leave Apply', N'b', N'AttendanceV', N'StdLeaveApply','Leave-Apply',3,0,0,2),-- Main Manu
(204,0, N'Leave List', N'b', N'AttendanceV', N'StdLeaveList','Leave-List',4,0,0,2),-- Main Manu
--(205,0,N'Section Wise (Teacher),', N'b', N'AttendanceV', N'TeacherStdAttnListSectoinWise','Section-Wise',5,0,0,2),-- Main Manu
(206,0, N'Student Absconding', N'b', N'AttendanceV', N'StdAbscondingAttendance',' Student-Absconding',6,0,0,2),-- Main Manu

(207,0, N'Report', N'b', NULL, N'',' Attendance-Report',7,1,0,2),-- Main Manu
(2071,207,N'Daily Report', N'b', N'AttendanceV', N'StdDailyAttendanceReportPeriodWise','F',1,0,0,2),
(2072,207,N'LIEO Report', N'b', N'AttendanceV', N'StdLIOReport','F',2,0,0,2),
(2073,207,N'Summary Report (Daily),', N'b', N'AttendanceV', N'StdAttendanceSummaryReport','F',3,0,0,2),
(2074,207, N'Monthly Summary Report', N'b', N'AttendanceV', N'StdMonthlyAttendanceReport','F',4,0,0,2),
(2075,207, N'Dynamic Attendance Report', N'b', N'AttendanceV', N'StdDynamicAttendanceReport','F',5,0,0,2),
(2076,207, N'Attendance Summary (Date Range wise),', N'b', N'AttendanceV', N'AttndSummRange','F',6,0,0,2),
(2077,207,N'Monthly Detail', N'b', N'AttendanceV', N'MonthlyAttendance','F',7,0,0,2),
(2078,207, N'Section Wise & Leave Report', N'b', N'AttendanceV', N'SectionWaysAbscondingLeaveAttendance','F',8,0,0,2),
(2079,207,N'Single Student Summery', N'b', N'AttendanceV', N'SingleStudentSummeryReport','F',9,0,0,2),
(2070,207, N'Student Summery', N'b', N'AttendanceV', N'StudentSummeryReportSW','F',10,0,0,2),
(2087,207, N'Daily Attendance Report', N'b', N'AttendanceV', N'DailyAttendance','F',11,0,0,2),
(2088,207, N'Monthly Attendance Report', N'b', N'AttendanceV', N'MonthlyStuAttendance','F',12,0,0,2),

(208,0, N'Set Up', N'b', NULL, N'','Set-Up',8,1,0,2),-- Main Manu
(2081,208, N'Leave Type', N'b', N'AttendanceV', N'LeaveType','F',1,0,0,2),
(2082,208,N'Academic Calendar Setup', N'b', N'AttendanceV', N'StdAcademicCalendarSetup','F',2,0,0,2),
(2083,208, N'Student Late in Early Out', N'b', N'AttendanceV', N'StdLateinEarlyOut','F',3,0,0,2),
(2084,208, N'Period Teacher Assign', N'b', N'RoutineV', N'PeriodTeacherAssign','F',4,0,0,2),
(2085,208, N'Class Period Setup', N'b', N'RoutineV', N'ClassPeriod','F',5,0,0,2),
(2086,208,N'Emp Academic Calendar', N'b', N'AttendanceV', N'EmpAcademicCalendarSetup','F',6,0,0,2),



------------------------------------------------------------------------------- Task Management 
(3,0,N'Task Management',  N'b', 'TaskManagementV', 'Board','module-result',3,1,1,3),
(301,0,N'Dashboard',  N'b', 'TaskManagementV', 'Board','',1,0,0,3),
(302,0,N'Set Up', N'b', N'', N'','Set-Up',2,0,0,3),
(3021,302,N'Category', N'b', N'TaskManagementV', N'ProjectCategory',N'F',1,0,0,3),
(3022,302,N'Project', N'b', N'TaskManagementV', N'Project',N'F',2,0,0,3),
(3023,302,N'Sprint', N'b', N'TaskManagementV', N'Sprint',N'F',3,0,0,3),
--(3013,301,N'Selective Subject Setup', N'b', N'Result', N'SelectiveSubject',N'F',3,0,0,3),
--(3014,301, N'Optional Subject Setup', N'b', N'Result', N'OptionalSubject',N'F',4,0,0,3),
--(3015,301,N'Fouth Subject Rules', N'b', N'Result', N'FouthSubjectRules',N'F',5,0,0,3),
--(3016,301,N'Rounding Rule', N'b', N'Result', N'MarksMigratedSetup',N'F',6,0,0,3),
--(3017,301,N'Grade Policy', N'b', N'Result', N'GradeSetup', N'F',7,0,0,3),
--(3018,301,N'Merit Config', N'b', N'Result', N'MeritListConfig', N'F',8,0,0,3),
--(3019,301,N'Highest Mark Policy', N'b', N'Result', N'HighestMarkSetup',N'F',9,0,0,3),
--(30110,301,N'Report Config', N'b', N'Result', N'ReportConfig',N'F',10,0,0,3),
--(30111,301,N'Subject List', N'b', N'Result', N'SubjectDetail',N'F',11,0,0,3),
--(30112,301, N'Class Subject Config', N'b',N'InstitutionSetup', N'ClassSubjectConfig',N'F',12,0,0,3),

(303,0,N'Issue', N'b', NULL, NULL,'Main-Exam',3,0,0,3),
(3031,303,N'Issue List', N'b',N'TaskManagementV',N'Issue',N'F',1,0,0,3),
(3032,303,N'Backlog', N'b', N'TaskManagementV',N'IssueBackLog',N'F',2,0,0,3),
(3033,303,N'My Issue', N'b', N'Employee',N'IssueList',N'F',3,0,0,3),
(304,0,N'Report', N'b', N'TaskManagementV',N'IssueReport',N'Reports',4,0,0,3),



--------------------------------------------------------------------------------------------------- Invoice 
(4,0,N'CRM', N'b', 'InvoiceV',N'Dashboard','module-fees',4,1,1,4),       -- Module
(401,0, N'Dashboard', N'b', N'InvoiceV', N'Dashboard', N'',  1,0,0,4),-- Main Manu
(402, 0, N'Process', N'b', NULL, NULL, N'Process',2,1,0,4),-- Main Manu
(4021, 402, N'Billing Process', N'b', N'InvoiceV', N'BillingProcessPanel',N'',1,0,0,4),
(4022, 402, N'Invoice Modification', N'b', N'InvoiceV', N'InvoiceModification',N'F',2,0,0,4),
(4023, 402, N'Invoice Collection', N'b', N'InvoiceV', N'InvoicePayment',N'F',3,0,0,4),
(4024, 402, N'Phone Call', N'b', N'InvoiceV', N'PhoneCallMaintain',N'F',4,0,0,4),
(4025, 402, N'Invoice Discount', N'b', N'InvoiceV', N'InvoiceDiscount',N'F',5,0,0,4),

--(403, 0, N'Modify Processed Fees', N'b', N'FeesV', N'ModifyProcessedFees', N' Processed-Fees',4,0,0,4),-- Main Manu
--(404, 0, N'Tuition Fee Collection', N'b', N'FeesV', N'BulkFeesCollection', N'Admin-Collection', 6,0,0,4),-- Main Manu

(405, 0, N'Report', N'b', NULL, NULL, N'Reports', 9,1,0,4),-- Main Manu
(4051, 405, N'Database Config Report', N'b', N'InvoiceV', N'DatabaseConfig',N'F',1,0,0,4),
(4052, 405, N'Invoice Generate', N'b', N'InvoiceV', N'InvoiceGeneratePanel',N'F', 2,0,0,4),
(4053, 405, N'Generate Report', N'b', N'InvoiceV', N'Collection',N'F', 3,0,0,4),
(4054, 405, N'Money Receipt', N'b', N'InvoiceV', N'MoneyReceiptGenerate',N'F',4,0,0,4),
(4055, 405, N'Invoice Search', N'b', N'InvoiceV', N'InvoiceSearch',N'F',5,0,0,4),
--(4055, 405, N'Money Receipt (Enrollment)', N'b', N'FeesV', N'EnrollmentMoneyReceiptView',N'F',5,0,0,4),
--(4056, 405, N'Money Receipt (Security Deposit)', N'b', N'FeesV', N'SecurityMoneyReceiptView',N'F',6,0,0,4),
--(4057, 405, N'Defaulter Notice', N'b', N'FeesV', N'DefaulterNotice',N'F',7,0,0,4),
--(4058, 405, N'Enrollment Collection Report', N'b', N'FeesV', N'EnrollmentCollectionReport',N'F',8,0,0,4),
--(4059, 405, N'Security Deposit Report', N'b', N'FeesV', N'SecurityDepositReports',N'F',9,0,0,4),
--(40510, 405, N'Advance Report', N'b', N'FeesV', N'StudentAdvancePaymentReport',N'F',10,0,0,4),
--(40511, 405, N'Defaulter Cumulative Report', N'b', N'FeesV', N'StudentTutionFeeLateDueCumReport',N'F',11,0,0,4),
--(40512, 405, N'Collection Report', N'b', N'FeesV', N'CollectionReport',N'F',12,0,0,4),

(406,0,N'Setup', N'b', NULL, NULL,'Set-Up',10,1,0,4),-- Main Manu
(4061, 406, N'Client', N'b', N'Client', N'Client',N'F', 1,0,0,4),
(4062, 406, N'Service', N'b', N'InvoiceV', N'InvoiceService',N'F',  2,0,0,4),
(4063, 406, N'Billing Method', N'b', N'InvoiceV', N'InvoiceBillingMethod',N'F',3,0,0,4),
(4064, 406, N'Billing Head', N'b', N'InvoiceV', N'InvoiceBillingHead',N'F', 4,0,0,4),
(4065, 406, N'Billing Head Config', N'b', N'InvoiceV', N'BillingHeadConfig',N'F',5,0,0,4),
--(4066, 406, N'Billing Process', N'b', N'InvoiceV', N'BillingProcessPanel',N'F',6,0,0,4),
--(4067, 406, N'Scholarship', N'b', N'FeesV', N'StudentScholarship',N'F', 7,0,0,4),
--(4066, 406, N'Tuition Fee Waiver', N'b', N'FeesV', N'TuitionFeeWaiver',N'F',6,0,0,4),
--(4065, 406, N'Individual Fees', N'b', N'FeesV', N'IndividualFees',N'F',5,0,0,4),
--(4068, 406, N'Fees Setting', N'b', N'FeesV', N'FeesSetting',N'F', 8,0,0,4),


--(407,0,N'Admissoin/Other Cash Collection', N'b', 'FeesV', 'Enrollment','F',11,1,0,4),-- Main Manu
--(408,0,N'Security Deposit', N'b', NULL, NULL, 'SecurityDeposit',12,1,0,4),-- Main Manu
--    (4081,408,N'Deposit Collection', N'b', N'FeesV', N'SecurityDeposit',N'F',1,0,0,4),-- Main Manu
--    (4082,408,N'Deposit Adjust', N'b', N'FeesV',  N'SecurityDepositAdjust', N'F',2,0,0,4),-- Main Manu
--    (4083,408,N'Refund/Resolve', N'b', N'FeesV',  N'SecurityDepositRefundResolved', N'F',3,0,0,4),-- Main Manu

			
-------------------------------------------------------------------------------------------------------- SMS 
(5,0,N'SMS', N'b', 'SmsV', 'Dashboard','module-sms-bg',5,1,1,5),    -- Module
(501,0,N'Settings', N'b', N'SmsV', N'GetSmsSettings','Settings',1,0,0,5), -- Main Manu
(502,0,N'SMS Template', N'b', N'SmsV', N'SmsTemplate','SMS-Template',2,0,0,5), -- Main Manu
(503,0,N'SMS Template List', N'b', N'SmsV', N'SmsTemplateList','SMS-Template-List',3,0,0,5), -- Main Manu

(504,0,N'Static SMS', N'b', NULL, NULL,'Static-SMS',4,1,0,5),-- Main Manu
(5041,504, N'Send SMS', N'b', N'SmsV', N'StaticSendSMS','F',1,0,0,5),
(5042,504,  N'Excel Generate', N'b', N'SmsV', N'StaticSMSExcel','F',2,0,0,5),
(5043,504,  N'Filtered SMS', N'b', N'SmsV', N'FilteredSendSMS','F',3,0,0,5),

(505,0,N'Dynamic SMS', N'b', NULL, NULL,' Dynamic-SMS',5,1,0,5),-- Main Manu
(5051,505, N'Send Dynamic Sms', N'b', N'smsv', N'DynamicSmsSend','F',1,0,0,5),

(506,0,N'Schedule SMS Config', N'b', N'smsv', N'ScheduleSMSConfig','Schedule-SMS-Config',6,0,0,5),-- Main Manu
(507,0,N'SMS Recharge', N'b', N'smsv', N'SMSRecharge','Schedule-SMS-Config',6,0,0,5),-- Main Manu
(508,0, N'Auto SMS Config', N'b', N'SmsV', N'AutoSMSConfig','Auto-SMS-Config',6,0,0,5),-- Main Manu
(509,0, N'Reports', N'b', NULL, NULL,'Reports',7,1,0,5),                                 
(5091,509, N'SMS History Report', N'b', N'SmsV', N'SmsHistoryReport','F',1,0,0,5),

------------------------------------------------------------------------------- Accounts 
(6,0,N'Accounts', N'b' ,'AccountV', 'Dashboard','module-accounts',6,1,1,6),  --module
(601,0, N'Payment', N'b', N'AccountV', N'Payment','Payment-ac',1,0,0,6),-- Main Manu
(602,0,N'Receive', N'b', N'AccountV', N'Receive','Receive-ac',2,0,0,6),-- Main Manu
(603,0,N'Contra', N'b', N'AccountV', N'Contra','Contra-ac',3,0,0,6),-- Main Manu
(604,0, N'Journal', N'b', N'AccountV', N'Journal','Journal-ac',4,0,0,6),-- Main Manu
(605,0,N'Transactions', N'b', N'AccountV', N'TransactionList','Transactions-ac',5,0,0,6),-- Main Manu
(606,0,N'Report', N'b', NULL, NULL,'Reports',6,0,0,6),-- Main Manu
  (6061,606,N'Generate', N'b', N'AccountV', N'Reports',N'F',1,0,0,6),
  (6062,606,N'Ledger', N'b', N'AccountV', N'AccountsReport',N'F',2,0,0,6),
  (6063,606,N'Cost Center Reports', N'b', N'AccountV', N'CostCenterReports',N'F',3,0,0,6),
(608,0,N'Payment Transactions', N'b', N'AccountV', N'PaymentTransactionList','Transactions-ac',8,0,0,6),-- Main Manu
(609,0,N'Receive Transactions', N'b', N'AccountV', N'ReceiveTransactionList','Transactions-ac',9,0,0,6),-- Main Manu
(6010,0,N'Contra Transactions', N'b', N'AccountV', N'ContraTransactionList','Transactions-ac',10,0,0,6),-- Main Manu

(607,0,N'Set Up', N'b', NULL, NULL,'Set-Up',7,1,0,6),-- Main Manu
(6071,607, N'Fiscal Year', N'b', N'AccountV', N'FiscalYearSetup','F',1,0,0,6),
(6072,607,N'Account Branch', N'b', N'AccountV', N'AcBranchSetup','F',2,0,0,6),
(6073,607, N'Group Setup', N'b', N'AccountV', N'AcGroupSetup','F',3,0,0,6),
(6074,607, N'Ledger Setup', N'b', N'AccountV', N'AcLedgerSetup','F',4,0,0,6),
(6075,607,N'Charts Of Accounts', N'b', N'AccountV', N'COA','F',5,0,0,6),
(6076,607,N'Cost Category', N'b', N'AccountV', N'CostCategory','F',6,0,0,6),
(6077,607,N'Cost Center', N'b', N'AccountV', N'CostCenter','F',7,0,0,6),
--(8076,807,N'Code Setup', N'b', N'AccountV', N'CodeSetup','F',6,0,0,8),
--(8077,807,N'Accounts Integration', N'b', N'AccountV', N'AccountsIntegration','F',7,0,0,8),

------------------------------------------------------------------------------- Inventory 
(7,0,N'Inventory', N'b', 'InventoryV', 'Dashboard','module-inverntory',7,1,1,7), --module
(701, 0, N'SetUp', N'b', Null, Null, N'Set-Up',1,1,0,7), -- Main Manu
(7011, 701, N'Product Category', N'b',  N'InventoryV', N'ProductCategory', N'F',1,0,0,7),
(7012, 701, N'Product Sub Category', N'b',  N'InventoryV', N'ProductSubCategory', N'F',2,0,0,7),
(7013, 701, N'Unit Setup', N'b',  N'InventoryV', N'UnitSetup', N'F',3,0,0,7),
(7014, 701, N'Product', N'b',  N'InventoryV', N'ProductList', N'F',4,0,0,7),
(7015, 701, N'Supplier', N'b',  N'InventoryV', N'Supplier', N'F',5,0,0,7),
			
(702, 0, N'Requisition', N'b', Null, Null, N'requssion',1,1,0,7), -- Main Manu
  (7021, 702, N'Requisition Entry', N'b',  N'InventoryV', N'RequisitionEntry', N'F',1,0,0,7),
  (7022, 702, N'Requisition List', N'b',  N'InventoryV', N'RequisitionList', N'F',2,0,0,7),

  (703, 0, N'Quotation', N'b', Null, Null, N'quotation',1,1,0,7), -- Main Manu
  (7031, 703, N'Quotation Entry', N'b',  N'InventoryV', N'QuotationEntry', N'F',1,0,0,7), 
  (7032, 703, N'Quotation List', N'b',  N'InventoryV', N'QuotationList', N'F',2,0,0,7),

(704, 0, N'Purchase', N'b', Null, Null, N'purchase1',1,1,0,7), -- Main Manu
  (7041, 704, N'Purchase Entry', N'b',  N'InventoryV', N'PurchaseOrderEntry', N'F',1,0,0,7), 
  (7042, 704, N'Purchase List', N'b',  N'InventoryV', N'PurchaseOrderList', N'F',2,0,0,7),
  (7043, 704, N'Purchase Receive', N'b',  N'InventoryV', N'PurchaseOrderReceive', N'F',3,0,0,7),

(705, 0, N'Sales', N'b', Null, Null, N'sell',1,1,0,7), -- Main Manu
  (7051, 705, N'Sales Entry', N'b',  N'InventoryV', N'SalesEntry', N'F',1,0,0,7), 

(706, 0, N'Distribution', N'b', N'InventoryV', N'Distribution', N'distribution',1,1,0,7), -- Main Manu
(707, 0, N'Asset Disposal', N'b', N'InventoryV', N'AssetDisposal', N'asse',1,1,0,7), -- Main Manu

(708, 0, N'Report', N'b', N'', N'', N'Reports',1,1,0,7), -- Main Manu
  (7081, 708, N'Asset Tagging', N'b',  N'InventoryV', N'AssetTagging', N'F',1,0,0,7), 
  (7082, 708, N'Product List', N'b',  N'InventoryV', N'Report', N'F',2,0,0,7), 

(709, 0, N'Fixed Asset', N'b', N'', N'', N'Reports',1,1,0,7), -- Main Manu
  (7091, 709, N'Supplier', N'b',  N'InventoryV', N'Supplier', N'F',1,0,0,7), 
  (7092, 709, N'Asset Category', N'b',  N'InventoryV', N'AssetCategory', N'F',2,0,0,7),
  (7093, 709, N'Assest Sub Category', N'b',  N'InventoryV', N'AssestSubCategory', N'F',2,0,0,7),
  (7094, 709, N'UnitSetup', N'b',  N'InventoryV', N'AssestUnitSetup', N'F',2,0,0,7),
  (7095, 709, N'Asset', N'b',  N'InventoryV', N'AssetList', N'F',2,0,0,7),
  (7096, 709, N'Add Existing Asset', N'b',  N'InventoryV', N'AddExistingAsset', N'F',2,0,0,7),
	



	
------------------------------------------------------------------------------- User Management 
(12,0,N'User', N'b', NULL, NULL,'',12,1,1,12),   --module
(1201,0,N'User Management', N'b', NULL, NULL,'',12,1,0,12),  -- Main Manu
(12011,1201, N'Users', N'b', N'Users', N'Users','',1,0,0,12),
(12012,1201,N'Roles', N'b', N'Users', N'Roles','',2,0,0,12),

------------------------------------------------------------------------------- Institute SetUp 

(1202,0,N'Institution Setup', N'b', NULL, NULL,'',5,1,0,12),-- Main Manu
(12021,1202, N'Branch', N'b', N'InstitutionSetup', N'Branch','',6,0,0,12),
(12022,1202,N'Shift', N'b', N'InstitutionSetup', N'Shift','',4,0,0,12),
(12023,1202,N'Session', N'b', N'InstitutionSetup', N'Session','',5,0,0,12),
(12024,1202, N'Class', N'b', N'InstitutionSetup', N'Class','',6,0,0,12),
(12025,1202,N'Section', N'b', N'InstitutionSetup', N'Section','',7,0,0,12),
(12026,1202, N'Student Type', N'b', N'InstitutionSetup', N'StudentType','',8,0,0,12),
(12027,1202, N'Student House', N'b', N'InstitutionSetup', N'StudentHouse','',9,0,0,12),
(12028,1202, N'Institution Info', N'b', N'InstitutionSetup', N'MyInstitution','',10,0,0,12),
(12029,1202, N'Report Header', N'b',  N'Report', N'ReportHeader','module-library',11,0,0,12),
(120210,1202, N'Student ID Config', N'b', N'InstitutionSetup', N'StudentIDSetup','',12,0,0,12),
(120211,1202, N'Common DropDown', N'b', N'Common', N'DropDownConfig','F',13,0,0,12),
(120212,1202,N'TTC Template', N'b', N'InstitutionSetup', N'TTCTemplate','F',14,0,0,12),
(120213,1202,  N'Term', N'b',  N'InstitutionSetup', N'Term','F',16,0,0,12),
(120214,1202,  N'Fees Booth', N'b',  N'InstitutionSetup', N'FeesBooth','F',17,0,0,12),

(1203,0,N'Document Upload', N'b', N'InstitutionSetup', N'DocumentUpload','Set-Up',6,1,0,12),-- Main Manu
(1204,0,N'My Profile', N'b', 'Account', 'MyProfile','',12,1,0,12) -- Main Manu

--SET IDENTITY_INSERT [dbo].[AspNetPages] OFF 

		--				
--(3113,301,N'Class Wise Result', N'b', N'Result', N'ResultClassWiseReport',N'fa fa-folder-o',13,0,0,3),

--(3114,301,N'Set Up', N'b', NULL, NULL,N'fa fa-folder-o',14,1,0,3),
		



		 --(3507,305,N'Grade Policy', N'b', N'Result', N'GradeSetup', N'fa fa-cogs',7,0,0,3),
		  --  
		  --(3508,305,N'Merit Config', N'b', N'Result', N'MeritListConfig', N'fa fa-cogs',8,0,0,3),
		  --  
		  --(3509,305,N'Highest Mark Policy', N'b', N'Result', N'HighestMarkSetup',  N'fa fa-cogs',9,0,0,3),
		  -- 
		  --(3510,305,N'Report Config', N'b', N'Result', N'ReportConfig',  N'fa fa-cogs',10,0,0,3),
		   --
		  --(3511,305,N'Subject List', N'b', N'Result', N'SubjectDetail',  N'fa fa-cogs',11,0,0,3),
		  -- 
		 -- (3512,305, N'Class Subject Config', N'b',  N'InstitutionSetup', N'ClassSubjectConfig',  N'fa fa-cogs',12,0,0,3),
		                                                                                                         --Promotion Sub Menu End--
  --
  --(306,0,N'Archive', N'b', NULL, NULL,'Archive ',6,0,0,3),
	 -- 
  --    (3601,306,N'MainExamResult', N'b', N'archive', N'MainExamArchive', N'fa fa-clipboard',1,0,0,3),
	 -- 
  --    (3602,306,N'MainExamTab', N'b', N'archive', N'MainExamTabArchive', N'fa fa-clipboard',2,0,0,3),
		--           
  --    (3603,306,N'MainExamMerit', N'b', N'archive', N'MainExamMeritArchive', N'fa fa-clipboard',3,0,0,3),
		--          
  --       (3604,306,N'GrandExamResult', N'b', N'archive', N'GrandExamArchive', N'fa fa-clipboard',4,0,0,3),
		-- 		          
  --       (3605,306,N'GrandExamTab', N'b', N'archive', N'GrandExamTabArchive', N'fa fa-clipboard',5,0,0,3),
		--          
  --       (3606,306,N'GrandExamMerit', N'b', N'archive', N'GrandExamMeritArchive', N'fa fa-clipboard',6,0,0,3),