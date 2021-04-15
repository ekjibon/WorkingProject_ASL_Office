/*
Truncate table 
*/


--Truncate table [dbo].[Res_DividedExam]

ALTER TABLE [Res_SubjectSetup] NOCHECK CONSTRAINT ALL  
ALTER TABLE [Res_SubjectSetup] DISABLE TRIGGER ALL  
DELETE FROM [Res_SubjectSetup]  
ALTER TABLE [Res_SubjectSetup] CHECK CONSTRAINT ALL  
ALTER TABLE [Res_SubjectSetup] ENABLE TRIGGER ALL
IF NOT EXISTS (SELECT *
    FROM SYS.IDENTITY_COLUMNS
    JOIN SYS.TABLES ON SYS.IDENTITY_COLUMNS.Object_ID = SYS.TABLES.Object_ID
    WHERE SYS.TABLES.Object_ID = OBJECT_ID('[Res_SubjectSetup]') AND SYS.IDENTITY_COLUMNS.Last_Value IS NULL)
    AND OBJECTPROPERTY(OBJECT_ID('[Res_SubjectSetup]'), 'TableHasIdentity') = 1
    DBCC CHECKIDENT ('[Res_SubjectSetup]', RESEED, 0) WITH NO_INFOMSGS

--Truncate table [dbo].[Res_StudentSubject]

ALTER TABLE [Res_MainExam] NOCHECK CONSTRAINT ALL  
ALTER TABLE [Res_MainExam] DISABLE TRIGGER ALL  
DELETE FROM [Res_MainExam]  
ALTER TABLE [Res_MainExam] CHECK CONSTRAINT ALL  
ALTER TABLE [Res_MainExam] ENABLE TRIGGER ALL
IF NOT EXISTS (SELECT *
    FROM SYS.IDENTITY_COLUMNS
    JOIN SYS.TABLES ON SYS.IDENTITY_COLUMNS.Object_ID = SYS.TABLES.Object_ID
    WHERE SYS.TABLES.Object_ID = OBJECT_ID('[Res_MainExam]') AND SYS.IDENTITY_COLUMNS.Last_Value IS NULL)
    AND OBJECTPROPERTY(OBJECT_ID('[Res_MainExam]'), 'TableHasIdentity') = 1
    DBCC CHECKIDENT ('[Res_MainExam]', RESEED, 0) WITH NO_INFOMSGS



ALTER TABLE [Res_SubExam] NOCHECK CONSTRAINT ALL  
ALTER TABLE [Res_SubExam] DISABLE TRIGGER ALL  
DELETE FROM [Res_SubExam]  
ALTER TABLE [Res_SubExam] CHECK CONSTRAINT ALL  
ALTER TABLE [Res_SubExam] ENABLE TRIGGER ALL
IF NOT EXISTS (SELECT *
    FROM SYS.IDENTITY_COLUMNS
    JOIN SYS.TABLES ON SYS.IDENTITY_COLUMNS.Object_ID = SYS.TABLES.Object_ID
    WHERE SYS.TABLES.Object_ID = OBJECT_ID('[Res_SubExam]') AND SYS.IDENTITY_COLUMNS.Last_Value IS NULL)
    AND OBJECTPROPERTY(OBJECT_ID('[Res_SubExam]'), 'TableHasIdentity') = 1
    DBCC CHECKIDENT ('[Res_SubExam]', RESEED, 0) WITH NO_INFOMSGS


Truncate table [dbo].[Res_DividedExam]



ALTER TABLE [Res_MainExamMarkSetup] NOCHECK CONSTRAINT ALL  
ALTER TABLE [Res_MainExamMarkSetup] DISABLE TRIGGER ALL  
DELETE FROM [Res_MainExamMarkSetup]  
ALTER TABLE [Res_MainExamMarkSetup] CHECK CONSTRAINT ALL  
ALTER TABLE [Res_MainExamMarkSetup] ENABLE TRIGGER ALL
IF NOT EXISTS (SELECT *
    FROM SYS.IDENTITY_COLUMNS
    JOIN SYS.TABLES ON SYS.IDENTITY_COLUMNS.Object_ID = SYS.TABLES.Object_ID
    WHERE SYS.TABLES.Object_ID = OBJECT_ID('[Res_MainExamMarkSetup]') AND SYS.IDENTITY_COLUMNS.Last_Value IS NULL)
    AND OBJECTPROPERTY(OBJECT_ID('[Res_MainExamMarkSetup]'), 'TableHasIdentity') = 1
    DBCC CHECKIDENT ('[Res_MainExamMarkSetup]', RESEED, 0) WITH NO_INFOMSGS


ALTER TABLE [Res_SubExamMarkSetup] NOCHECK CONSTRAINT ALL  
ALTER TABLE [Res_SubExamMarkSetup] DISABLE TRIGGER ALL  
DELETE FROM [Res_SubExamMarkSetup]  
ALTER TABLE [Res_SubExamMarkSetup] CHECK CONSTRAINT ALL  
ALTER TABLE [Res_SubExamMarkSetup] ENABLE TRIGGER ALL
IF NOT EXISTS (SELECT *
    FROM SYS.IDENTITY_COLUMNS
    JOIN SYS.TABLES ON SYS.IDENTITY_COLUMNS.Object_ID = SYS.TABLES.Object_ID
    WHERE SYS.TABLES.Object_ID = OBJECT_ID('[Res_SubExamMarkSetup]') AND SYS.IDENTITY_COLUMNS.Last_Value IS NULL)
    AND OBJECTPROPERTY(OBJECT_ID('[Res_SubExamMarkSetup]'), 'TableHasIdentity') = 1
    DBCC CHECKIDENT ('[Res_SubExamMarkSetup]', RESEED, 0) WITH NO_INFOMSGS

Truncate table [dbo].[Res_DividedExamMarkSetup]

Truncate table [dbo].[Res_MainExamMarks]

Truncate table [dbo].[Res_MainExamResult]
Truncate table [dbo].[Res_MainExamResultSubjectDetails]
Truncate table [dbo].[Res_MEResultDetails]

Truncate table [dbo].[Res_MeritListConfig]
Truncate table [dbo].[Res_HighestMarkConfig]
Truncate table [dbo].[Res_Tabulation]
Truncate table [dbo].[Res_VirtualExamSetup]
Truncate table [dbo].[Res_ExamProccessLog]
Truncate table [dbo].[Res_TempResult]
Truncate table [dbo].[Res_GradingSystem]

--Truncate table [dbo].[Res_TabConfig]

--------------------------------------

TRUNCATE TABLE Fees_Student
TRUNCATE TABLE Att_StudentAttendance

TRUNCATE TABLE Att_StudentPeriodAtten
TRUNCATE TABLE Fees_HeadAmountConfig
TRUNCATE TABLE Fees_CollectionDetails
TRUNCATE TABLE Fees_CollectionMaster

TRUNCATE TABLE Res_AssignSubjectsToTeacher
TRUNCATE TABLE Fees_FeesSessionYear

TRUNCATE TABLE Att_AcademicCalendar

TRUNCATE TABLE Fees_TempCollection
TRUNCATE TABLE Fees_FeesModifyLog

TRUNCATE TABLE Fees_ProcessDetails

TRUNCATE TABLE Res_MainExamAssessment
TRUNCATE TABLE Fees_AutomatedFeesConfig

TRUNCATE TABLE Fees_Head
TRUNCATE TABLE Fees_DisplayGroupDetails
TRUNCATE TABLE Emp_BasicInfo
TRUNCATE TABLE Fees_FeesLatePaySlab
TRUNCATE TABLE Att_StudentLeave
DELETE Fees_FeesMonth
TRUNCATE TABLE Fees_ScholarshipDetails
TRUNCATE TABLE Rtn_ClassPeriod


TRUNCATE TABLE Fees_HeadDefault

TRUNCATE TABLE Res_FouthSubjectRules
TRUNCATE TABLE Rtn_PeriodTeacher
TRUNCATE TABLE Fees_Process
TRUNCATE TABLE Att_AbscondingDetails
TRUNCATE TABLE Fees_FeesBooth
TRUNCATE TABLE Res_MarksMigratedSetup



TRUNCATE TABLE Emp_Designation
TRUNCATE TABLE Att_StudentLIEO
TRUNCATE TABLE Emp_Category
TRUNCATE TABLE Fees_Category
TRUNCATE TABLE Emp_Subject
TRUNCATE TABLE Fees_ReceiptSettingDetails

TRUNCATE TABLE Res_AssessmentSubject
TRUNCATE TABLE Ins_AdmitCardSetup
TRUNCATE TABLE Emp_ClassTeacher
TRUNCATE TABLE Att_LeaveTypes
TRUNCATE TABLE Fees_DisplayGroup

TRUNCATE TABLE Fees_ScholarshipMaster
TRUNCATE TABLE Fees_ScholarshipType
TRUNCATE TABLE Fees_Setting
TRUNCATE TABLE Fees_ReceiptSetting
TRUNCATE TABLE Ins_SeatCardSetup
TRUNCATE TABLE Res_ReportConfig
TRUNCATE TABLE Res_Reports
TRUNCATE TABLE Emp_Status
TRUNCATE TABLE Emp_Department