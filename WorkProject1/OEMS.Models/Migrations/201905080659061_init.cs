namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class init : DbMigration
    {
        public override void Up()
        {
            
            
           
            
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.Res_VirtualExamSetup", "SessionId", "dbo.Ins_Session");
            DropForeignKey("dbo.Res_VirtualExamSetup", "ClassId", "dbo.Ins_ClassInfo");
            DropForeignKey("dbo.Student_OthersInfo", "StudentIID", "dbo.Student_BasicInfo");
            DropForeignKey("dbo.Student_SiblingInfo", "StudentIID", "dbo.Student_BasicInfo");
            DropForeignKey("dbo.Student_ContactInfo", "StudentIID", "dbo.Student_BasicInfo");
            DropForeignKey("dbo.Student_AcademicInfo", "StudentIID", "dbo.Student_BasicInfo");
            DropForeignKey("dbo.Ins_Shift", "StudentBasicInfo_StudentIID", "dbo.Student_BasicInfo");
            DropForeignKey("dbo.Res_MarksMigratedSetup", "ClassID", "dbo.Ins_ClassInfo");
            DropForeignKey("dbo.Res_GradingSystem", "ClassID", "dbo.Ins_ClassInfo");
            DropForeignKey("dbo.Fees_FeesSessionYear", "MonthId", "dbo.Fees_FeesMonth");
            DropForeignKey("dbo.Fees_CollectionDetails", "MasterID", "dbo.Fees_CollectionMaster");
            DropForeignKey("dbo.Common_PoliceStation", "DistrictId", "dbo.Common_District");
            DropForeignKey("dbo.Res_ConvertedPositionSetup", "ClassID", "dbo.Ins_ClassInfo");
            DropForeignKey("dbo.Ins_ClassInfo", "VersionId", "dbo.Ins_Version");
            DropForeignKey("dbo.Res_SubExam", "MainExamId", "dbo.Res_MainExam");
            DropForeignKey("dbo.Res_MainExam", "SessionId", "dbo.Ins_Session");
            DropForeignKey("dbo.Res_MainExamMarkSetup", "VersionId", "dbo.Ins_Version");
            DropForeignKey("dbo.Res_MainExamMarkSetup", "MainExamSubjectID", "dbo.Res_SubjectSetup");
            DropForeignKey("dbo.Res_SubExamMarkSetup", "MainExamMarkSetupId", "dbo.Res_MainExamMarkSetup");
            DropForeignKey("dbo.Res_MainExamMarkSetup", "SessionId", "dbo.Ins_Session");
            DropForeignKey("dbo.Res_MainExamMarkSetup", "GroupId", "dbo.Ins_Group");
            DropForeignKey("dbo.Ins_Section", "ShiftId", "dbo.Ins_Shift");
            DropForeignKey("dbo.Ins_Section", "GroupId", "dbo.Ins_Group");
            DropForeignKey("dbo.Ins_Section", "ClassId", "dbo.Ins_ClassInfo");
            DropForeignKey("dbo.Res_MainExam", "ClassId", "dbo.Ins_ClassInfo");
            DropForeignKey("dbo.Ins_Shift", "BranchId", "dbo.Ins_Branch");
            DropForeignKey("dbo.AspNetPagesRoles", "RoleId", "dbo.AspNetRoles");
            DropForeignKey("dbo.AspNetUserAspNetRoles", "AspNetRole_Id", "dbo.AspNetRoles");
            DropForeignKey("dbo.AspNetUserAspNetRoles", "AspNetUser_Id", "dbo.AspNetUsers");
            DropForeignKey("dbo.AspNetPagesRoles", "PageId", "dbo.AspNetPages");
            DropForeignKey("dbo.Ins_AcademicProgram", "AcaProCateId", "dbo.Ins_AcaProCategory");
            DropForeignKey("dbo.Ins_AcademicProgram", "AcaDeptId", "dbo.Ins_AcademicDepartment");
            DropIndex("dbo.AspNetUserAspNetRoles", new[] { "AspNetRole_Id" });
            DropIndex("dbo.AspNetUserAspNetRoles", new[] { "AspNetUser_Id" });
            DropIndex("dbo.Res_VirtualExamSetup", new[] { "ClassId" });
            DropIndex("dbo.Res_VirtualExamSetup", new[] { "SessionId" });
            DropIndex("dbo.Student_SiblingInfo", new[] { "StudentIID" });
            DropIndex("dbo.Student_ContactInfo", new[] { "StudentIID" });
            DropIndex("dbo.Student_AcademicInfo", new[] { "StudentIID" });
            DropIndex("dbo.Student_OthersInfo", new[] { "StudentIID" });
            DropIndex("dbo.Res_MarksMigratedSetup", new[] { "ClassID" });
            DropIndex("dbo.Res_GradingSystem", new[] { "ClassID" });
            DropIndex("dbo.Fees_FeesSessionYear", new[] { "MonthId" });
            DropIndex("dbo.Fees_CollectionDetails", new[] { "MasterID" });
            DropIndex("dbo.Common_PoliceStation", new[] { "DistrictId" });
            DropIndex("dbo.Res_ConvertedPositionSetup", new[] { "ClassID" });
            DropIndex("dbo.Res_SubExam", new[] { "MainExamId" });
            DropIndex("dbo.Res_SubExamMarkSetup", new[] { "MainExamMarkSetupId" });
            DropIndex("dbo.Ins_Section", new[] { "ShiftId" });
            DropIndex("dbo.Ins_Section", new[] { "GroupId" });
            DropIndex("dbo.Ins_Section", new[] { "ClassId" });
            DropIndex("dbo.Res_MainExamMarkSetup", new[] { "MainExamSubjectID" });
            DropIndex("dbo.Res_MainExamMarkSetup", new[] { "GroupId" });
            DropIndex("dbo.Res_MainExamMarkSetup", new[] { "SessionId" });
            DropIndex("dbo.Res_MainExamMarkSetup", new[] { "VersionId" });
            DropIndex("dbo.Res_MainExam", new[] { "ClassId" });
            DropIndex("dbo.Res_MainExam", new[] { "SessionId" });
            DropIndex("dbo.Ins_ClassInfo", new[] { "VersionId" });
            DropIndex("dbo.Ins_Shift", new[] { "StudentBasicInfo_StudentIID" });
            DropIndex("dbo.Ins_Shift", new[] { "BranchId" });
            DropIndex("dbo.AspNetPagesRoles", new[] { "RoleId" });
            DropIndex("dbo.AspNetPagesRoles", new[] { "PageId" });
            DropIndex("dbo.Ins_AcademicProgram", new[] { "AcaProCateId" });
            DropIndex("dbo.Ins_AcademicProgram", new[] { "AcaDeptId" });
            DropTable("dbo.AspNetUserAspNetRoles");
            DropTable("dbo.Res_VirtualExamSetup");
            DropTable("dbo.ACC_TransactionDetail");
            DropTable("dbo.ACC_Transaction");
            DropTable("dbo.Ins_TC_Template");
            DropTable("dbo.ACC_Tags");
            DropTable("dbo.Res_Tabulation");
            DropTable("dbo.Res_TabConfig");
            DropTable("dbo.SystemLogs");
            DropTable("dbo.Ins_StudentType");
            DropTable("dbo.Res_StudentSubject");
            DropTable("dbo.Student_Request");
            DropTable("dbo.Student_PormotionHistory");
            DropTable("dbo.Att_StudentPeriodLeave");
            DropTable("dbo.Att_StudentPeriodAtten");
            DropTable("dbo.Att_StudentLIEO");
            DropTable("dbo.Att_StudentLeave");
            DropTable("dbo.Student_Image");
            DropTable("dbo.Ins_House");
            DropTable("dbo.Student_GuardianInfo");
            DropTable("dbo.Student_Detail");
            DropTable("dbo.Stu_ClubsHistory");
            DropTable("dbo.Stu_Clubs");
            DropTable("dbo.Att_StudentAttendance");
            DropTable("dbo.SMS_SMSTempTag");
            DropTable("dbo.SMS_SMSTemplate");
            DropTable("dbo.SMS_Settings");
            DropTable("dbo.SMS_SMSSendHistroy");
            DropTable("dbo.SMS_SMSExtNumbers");
            DropTable("dbo.SMS_SMSExtGroup");
            DropTable("dbo.Ins_Signature");
            DropTable("dbo.Ins_SeatCardSetup");
            DropTable("dbo.SchoolSetups");
            DropTable("dbo.Ins_ScholarshipType");
            DropTable("dbo.SMS_ScheduleSMSConfig");
            DropTable("dbo.HR_SalaryTaxYear");
            DropTable("dbo.HR_SalaryStructure");
            DropTable("dbo.HR_SalaryPeriod");
            DropTable("dbo.HR_SalaryPayDetails");
            DropTable("dbo.HR_SalaryIncrement");
            DropTable("dbo.HR_SalaryHeadWiseConfig");
            DropTable("dbo.HR_SalaryHead");
            DropTable("dbo.HR_SalaryGrade");
            DropTable("dbo.HR_SalaryEmployee");
            DropTable("dbo.Ins_Route");
            DropTable("dbo.ACC_RootGroup");
            DropTable("dbo.Arch_ResultArchive");
            DropTable("dbo.Res_Reports");
            DropTable("dbo.Ins_ReportHeader");
            DropTable("dbo.Res_ReportConfig");
            DropTable("dbo.Portal_Document");
            DropTable("dbo.Rtn_PeriodTeacher");
            DropTable("dbo.Fees_pay2feeTransection");
            DropTable("dbo.Student_SiblingInfo");
            DropTable("dbo.Student_ContactInfo");
            DropTable("dbo.Student_AcademicInfo");
            DropTable("dbo.Student_BasicInfo");
            DropTable("dbo.Student_OthersInfo");
            DropTable("dbo.Ins_NoticeInfo");
            DropTable("dbo.Ins_NoticeDetails");
            DropTable("dbo.Res_MeritListConfig");
            DropTable("dbo.Res_MEResultDetails");
            DropTable("dbo.Res_MarksMigratedSetup");
            DropTable("dbo.Res_MainExamResultSubjectDetails");
            DropTable("dbo.Res_MainExamResult");
            DropTable("dbo.Res_MainExamMarks");
            DropTable("dbo.Res_MainExamLeaveStudent");
            DropTable("dbo.Res_MainExamAssessment");
            DropTable("dbo.ACC_Ledgers");
            DropTable("dbo.ACC_Groups");
            DropTable("dbo.Att_LeaveTypes");
            DropTable("dbo.HR_LeaveQuota");
            DropTable("dbo.HR_LeaveCategory");
            DropTable("dbo.HR_LeaveApplication");
            DropTable("dbo.Ins_IDConfig");
            DropTable("dbo.Res_HighestMarkConfig");
            DropTable("dbo.Fees_HeadPriority");
            DropTable("dbo.Res_GradingSystem");
            DropTable("dbo.Res_FouthSubjectRules");
            DropTable("dbo.ACC_FiscalYear");
            DropTable("dbo.Fees_TempCollection");
            DropTable("dbo.Fees_StudentArchive");
            DropTable("dbo.Fees_Student");
            DropTable("dbo.Fees_Setting");
            DropTable("dbo.Fees_ScholarshipType");
            DropTable("dbo.Fees_ScholarshipDetails");
            DropTable("dbo.Fees_ScholarshipMaster");
            DropTable("dbo.Fees_ReceiptSettingDetails");
            DropTable("dbo.Fees_ReceiptSetting");
            DropTable("dbo.Fees_ProcessDetails");
            DropTable("dbo.Fees_Process");
            DropTable("dbo.Fees_FeesSessionYear");
            DropTable("dbo.Fees_FeesMonth");
            DropTable("dbo.Fees_FeesModifyLog");
            DropTable("dbo.Fees_FeesLatePaySlab");
            DropTable("dbo.Fees_HeadDefault");
            DropTable("dbo.Fees_HeadAmountConfig");
            DropTable("dbo.Fees_Head");
            DropTable("dbo.Fees_DisplayGroupDetails");
            DropTable("dbo.Fees_DisplayGroup");
            DropTable("dbo.Fees_CollectionMaster");
            DropTable("dbo.Fees_CollectionDetails");
            DropTable("dbo.Fees_Category");
            DropTable("dbo.Fees_FeesBooth");
            DropTable("dbo.Fees_AutomatedFeesConfig");
            DropTable("dbo.Res_ExamProccessLog");
            DropTable("dbo.Att_ExamAttendance");
            DropTable("dbo.ACC_EntryTypes");
            DropTable("dbo.ACC_EntryItems");
            DropTable("dbo.ACC_Entries");
            DropTable("dbo.Emp_Training");
            DropTable("dbo.Emp_Subject");
            DropTable("dbo.Emp_Status");
            DropTable("dbo.Emp_Shift");
            DropTable("dbo.Emp_Section");
            DropTable("dbo.Emp_MeetingConfig");
            DropTable("dbo.Emp_Nominee");
            DropTable("dbo.Emp_ExamBoard");
            DropTable("dbo.Emp_ExamName");
            DropTable("dbo.Emp_EducationalInfo");
            DropTable("dbo.Emp_LeaveType");
            DropTable("dbo.Emp_JobHistory");
            DropTable("dbo.Emp_Image");
            DropTable("dbo.Emp_Designation");
            DropTable("dbo.Emp_Department");
            DropTable("dbo.Emp_Category");
            DropTable("dbo.Emp_BasicInfo");
            DropTable("dbo.Ins_ECAClub");
            DropTable("dbo.Stu_ECAAttendance");
            DropTable("dbo.Common_DropDownConfig");
            DropTable("dbo.Common_PoliceStation");
            DropTable("dbo.Common_District");
            DropTable("dbo.Res_ConvertedPositionSetup");
            DropTable("dbo.ACC_COATemp");
            DropTable("dbo.Ins_ECAClubConfig");
            DropTable("dbo.Emp_ClassTeacher");
            DropTable("dbo.Res_ClassSubjectConfig");
            DropTable("dbo.Rtn_ClassPeriod");
            DropTable("dbo.Res_SubExam");
            DropTable("dbo.Ins_Version");
            DropTable("dbo.Res_SubjectSetup");
            DropTable("dbo.Res_SubExamMarkSetup");
            DropTable("dbo.Ins_Section");
            DropTable("dbo.Ins_Group");
            DropTable("dbo.Res_MainExamMarkSetup");
            DropTable("dbo.Ins_Session");
            DropTable("dbo.Res_MainExam");
            DropTable("dbo.Ins_ClassInfo");
            DropTable("dbo.Ins_Shift");
            DropTable("dbo.Ins_Branch");
            DropTable("dbo.Res_AssignSubjectsToTeacher");
            DropTable("dbo.Res_AssessmentSubject");
            DropTable("dbo.AspNetPageApis");
            DropTable("dbo.AspNetUsers");
            DropTable("dbo.AspNetRoles");
            DropTable("dbo.AspNetPagesRoles");
            DropTable("dbo.AspNetPages");
            DropTable("dbo.AspNetApis");
            DropTable("dbo.Ins_AdmitCardSetup");
            DropTable("dbo.Activity_Log");
            DropTable("dbo.ACC_Settings");
            DropTable("dbo.ACC_Logs");
            DropTable("dbo.ACC_Branchs");
            DropTable("dbo.Ins_AcademicSemester");
            DropTable("dbo.Ins_AcaProCategory");
            DropTable("dbo.Ins_AcademicProgram");
            DropTable("dbo.Ins_AcademicDepartment");
            DropTable("dbo.Att_AcademicCalendar");
            DropTable("dbo.Ins_AcademicBatch");
            DropTable("dbo.Att_AbscondingDetails");
        }
    }
}