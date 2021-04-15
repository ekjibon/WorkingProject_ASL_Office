namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ModelDesignModify : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("dbo.Ins_AcademicProgram", "AcaDeptId", "dbo.Ins_AcademicDepartment");
            DropForeignKey("dbo.Ins_AcademicProgram", "AcaProCateId", "dbo.Ins_AcaProCategory");
            DropForeignKey("dbo.Ins_Shift", "BranchId", "dbo.Ins_Branch");
            DropForeignKey("dbo.Res_MainExam", "ClassId", "dbo.Ins_ClassInfo");
            DropForeignKey("dbo.Res_MainExamMarkSetup", "SessionId", "dbo.Ins_Session");
            DropForeignKey("dbo.Res_SubExamMarkSetup", "MainExamMarkSetupId", "dbo.Res_MainExamMarkSetup");
            DropForeignKey("dbo.Res_MainExamMarkSetup", "MainExamSubjectID", "dbo.Res_SubjectSetup");
            DropForeignKey("dbo.Res_MainExamMarkSetup", "TermId", "dbo.Res_Terms");
            DropForeignKey("dbo.Res_MainExam", "SessionId", "dbo.Ins_Session");
            DropForeignKey("dbo.Res_SubExam", "MainExamId", "dbo.Res_MainExam");
            DropForeignKey("dbo.Res_MainExam", "TermId", "dbo.Res_Terms");
            DropForeignKey("dbo.Ins_Section", "ClassId", "dbo.Ins_ClassInfo");
            DropForeignKey("dbo.Ins_Section", "ShiftId", "dbo.Ins_Shift");
            DropForeignKey("dbo.Res_ConvertedPositionSetup", "ClassID", "dbo.Ins_ClassInfo");
            DropForeignKey("dbo.Fees_CollectionDetails", "MasterID", "dbo.Fees_CollectionMaster");
            DropForeignKey("dbo.Fees_FeesSessionYear", "MonthId", "dbo.Fees_FeesMonth");
            DropForeignKey("dbo.Fees_Student", "FeesStudent_FeesStudentId", "dbo.Fees_Student");
            DropForeignKey("dbo.Res_GradingSystem", "ClassID", "dbo.Ins_ClassInfo");
            DropForeignKey("dbo.Res_MarksMigratedSetup", "ClassID", "dbo.Ins_ClassInfo");
            DropForeignKey("dbo.Ins_Shift", "StudentBasicInfo_StudentIID", "dbo.Student_BasicInfo");
            DropForeignKey("dbo.Student_AcademicInfo", "StudentIID", "dbo.Student_BasicInfo");
            DropForeignKey("dbo.Student_ContactInfo", "StudentIID", "dbo.Student_BasicInfo");
            DropForeignKey("dbo.Student_SiblingInfo", "StudentIID", "dbo.Student_BasicInfo");
            DropForeignKey("dbo.Student_OthersInfo", "StudentIID", "dbo.Student_BasicInfo");
            DropIndex("dbo.Ins_AcademicProgram", new[] { "AcaDeptId" });
            DropIndex("dbo.Ins_AcademicProgram", new[] { "AcaProCateId" });
            DropIndex("dbo.Ins_Shift", new[] { "BranchId" });
            DropIndex("dbo.Ins_Shift", new[] { "StudentBasicInfo_StudentIID" });
            DropIndex("dbo.Res_MainExam", new[] { "SessionId" });
            DropIndex("dbo.Res_MainExam", new[] { "ClassId" });
            DropIndex("dbo.Res_MainExam", new[] { "TermId" });
            DropIndex("dbo.Res_MainExamMarkSetup", new[] { "SessionId" });
            DropIndex("dbo.Res_MainExamMarkSetup", new[] { "TermId" });
            DropIndex("dbo.Res_MainExamMarkSetup", new[] { "MainExamSubjectID" });
            DropIndex("dbo.Res_SubExamMarkSetup", new[] { "MainExamMarkSetupId" });
            DropIndex("dbo.Res_SubExam", new[] { "MainExamId" });
            DropIndex("dbo.Ins_Section", new[] { "ClassId" });
            DropIndex("dbo.Ins_Section", new[] { "ShiftId" });
            DropIndex("dbo.Res_ConvertedPositionSetup", new[] { "ClassID" });
            DropIndex("dbo.Fees_CollectionDetails", new[] { "MasterID" });
            DropIndex("dbo.Fees_FeesSessionYear", new[] { "MonthId" });
            DropIndex("dbo.Fees_Student", new[] { "FeesStudent_FeesStudentId" });
            DropIndex("dbo.Res_GradingSystem", new[] { "ClassID" });
            DropIndex("dbo.Res_MarksMigratedSetup", new[] { "ClassID" });
            DropIndex("dbo.Student_OthersInfo", new[] { "StudentIID" });
            DropIndex("dbo.Student_AcademicInfo", new[] { "StudentIID" });
            DropIndex("dbo.Student_ContactInfo", new[] { "StudentIID" });
            DropIndex("dbo.Student_SiblingInfo", new[] { "StudentIID" });
            AddColumn("dbo.Ins_Branch", "DisOrder", c => c.Int(nullable: false));
            AddColumn("dbo.Emp_Department", "DisOrder", c => c.Int(nullable: false));
            AddColumn("dbo.Task_Issue", "EstimatedTime", c => c.Int(nullable: false));
            AddColumn("dbo.Task_Issue", "EstimatedType", c => c.String());
            DropTable("dbo.Ins_AcademicBatch");
            DropTable("dbo.Att_AcademicCalendar");
            DropTable("dbo.Ins_AcademicDepartment");
            DropTable("dbo.Ins_AcademicProgram");
            DropTable("dbo.Ins_AcaProCategory");
            DropTable("dbo.Ins_AcademicSemester");
            DropTable("dbo.Activity_Log");
            DropTable("dbo.Ins_AdmitCardSetup");
            DropTable("dbo.Res_AssesmentClassOptions");
            DropTable("dbo.Res_AssessmentClassSetUp");
            DropTable("dbo.Res_AssessmentClassStudent");
            DropTable("dbo.Res_AssessmentSubSetup");
            DropTable("dbo.Res_AssessmentStudent");
            DropTable("dbo.Res_AssessmentSubject");
            DropTable("dbo.Res_AssignSubjectsToTeacher");
            DropTable("dbo.Ins_Shift");
            DropTable("dbo.Ins_ClassInfo");
            //DropTable("dbo.Res_MainExam");
            DropTable("dbo.Ins_Session");
            DropTable("dbo.Res_MainExamMarkSetup");
            DropTable("dbo.Res_SubExamMarkSetup");
            DropTable("dbo.Res_SubjectSetup");
            DropTable("dbo.Res_Terms");
            //DropTable("dbo.Res_SubExam");
            //DropTable("dbo.Ins_Section");
            DropTable("dbo.Rtn_ClassPeriod");
            DropTable("dbo.Res_ClassResultComments");
            DropTable("dbo.Res_ClassSubjectConfig");
            //DropTable("dbo.Res_ConvertedPositionSetup");
            DropTable("dbo.Ins_CSInfo");
            DropTable("dbo.Res_ExamProccessLog");
            DropTable("dbo.Fees_Accounts");
            DropTable("dbo.Fees_Adjust");
            DropTable("dbo.FeesAdjustHistories");
            DropTable("dbo.Fees_AutomatedFeesConfig");
            DropTable("dbo.Fees_FeesBooth");
            DropTable("dbo.Fees_Category");
            DropTable("dbo.Fees_CollectionDetails");
            DropTable("dbo.Fees_CollectionMaster");
            DropTable("dbo.Fees_DisplayGroup");
            DropTable("dbo.Fees_DisplayGroupDetails");
            DropTable("dbo.Fees_FiscalSession");
            DropTable("dbo.Fees_Head");
            DropTable("dbo.Fees_HeadAmountConfig");
            DropTable("dbo.Fees_HeadDefault");
            DropTable("dbo.Fees_FeesLatePaySlab");
            DropTable("dbo.Fees_FeesModifyLog");
            DropTable("dbo.Fees_FeesMonth");
            DropTable("dbo.Fees_FeesSessionYear");
            DropTable("dbo.Fees_Process");
            DropTable("dbo.Fees_ProcessDetails");
            DropTable("dbo.Fees_ReceiptSetting");
            DropTable("dbo.Fees_ReceiptSettingDetails");
            DropTable("dbo.Fees_ScholarshipMaster");
            DropTable("dbo.Fees_ScholarshipDetails");
            DropTable("dbo.Fees_ScholarshipType");
            DropTable("dbo.Fees_Setting");
            DropTable("dbo.Fees_Student");
            DropTable("dbo.Fees_StudentArchive");
            DropTable("dbo.Fees_TempCollection");
            DropTable("dbo.Res_FouthSubjectRules");
            //DropTable("dbo.Res_GradingSystem");
            DropTable("dbo.Fees_HeadPriority");
            DropTable("dbo.Res_HeadsCommentMaster");
            DropTable("dbo.Res_HeadsCommentDetails");
            DropTable("dbo.Res_HighestMarkConfig");
            DropTable("dbo.Ins_IDConfig");
            DropTable("dbo.Res_MainExamAssessment");
            DropTable("dbo.Res_MainExamLeaveStudent");
            DropTable("dbo.Res_MainExamMarks");
            DropTable("dbo.Res_MainExamResult");
            DropTable("dbo.Res_MainExamResultSubjectDetails");
            //DropTable("dbo.Res_MarksMigratedSetup");
            DropTable("dbo.Res_MeritListConfig");
            DropTable("dbo.Res_MERSubExamResult");
            DropTable("dbo.Student_OthersInfo");
            DropTable("dbo.Student_BasicInfo");
            DropTable("dbo.Student_AcademicInfo");
            DropTable("dbo.Student_ContactInfo");
            DropTable("dbo.Student_SiblingInfo");
            DropTable("dbo.Rtn_PeriodTeacher");
            DropTable("dbo.Res_ReportConfig");
            DropTable("dbo.Res_Reports");
            DropTable("dbo.Arch_ResultArchive");
            DropTable("dbo.Ins_Route");
            DropTable("dbo.Ins_ScholarshipType");
            DropTable("dbo.Ins_SeatCardSetup");
            DropTable("dbo.Fees_SecurityDepositDetails");
            DropTable("dbo.Ins_Signature");
            DropTable("dbo.Att_StudentAttendance");
            DropTable("dbo.Student_Detail");
            DropTable("dbo.Student_GuardianInfo");
            DropTable("dbo.Ins_House");
            DropTable("dbo.Student_Image");
            DropTable("dbo.Att_StudentLeave");
            DropTable("dbo.Att_StudentLIEO");
            DropTable("dbo.Att_StudentPeriodAtten");
            DropTable("dbo.Att_StudentPeriodLeave");
            DropTable("dbo.Student_PormotionHistory");
            DropTable("dbo.Student_Request");
            DropTable("dbo.Res_StudentSubject");
            DropTable("dbo.Ins_StudentType");
            DropTable("dbo.Res_SubjectWiseComment");
            DropTable("dbo.Res_TabConfig");
            DropTable("dbo.Res_Tabulation");
            DropTable("dbo.Ins_TC_Template");
        }
        
        public override void Down()
        {
            CreateTable(
                "dbo.Ins_TC_Template",
                c => new
                    {
                        TC_TemplateId = c.Int(nullable: false, identity: true),
                        ClassId = c.Int(nullable: false),
                        Title1 = c.String(),
                        Title2 = c.String(),
                        Text = c.String(),
                        SignatureId = c.Int(nullable: false),
                        BG_Image = c.Binary(),
                        Type = c.String(nullable: false, maxLength: 5),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.TC_TemplateId);
            
            CreateTable(
                "dbo.Res_Tabulation",
                c => new
                    {
                        TabulationId = c.Long(nullable: false, identity: true),
                        SessionId = c.Int(nullable: false),
                        BranchID = c.Int(nullable: false),
                        ShiftID = c.Int(nullable: false),
                        ClassId = c.Int(nullable: false),
                        SectionId = c.Int(nullable: false),
                        StudentId = c.Int(nullable: false),
                        SubjectId = c.Int(nullable: false),
                        GrandExamId = c.Int(nullable: false),
                        MainExamId = c.Int(nullable: false),
                        SubExamId = c.Int(nullable: false),
                        ExamName = c.String(),
                        TotalMarks = c.String(),
                        IsPass = c.Boolean(nullable: false),
                        ExamSerial = c.Int(nullable: false),
                    })
                .PrimaryKey(t => t.TabulationId);
            
            CreateTable(
                "dbo.Res_TabConfig",
                c => new
                    {
                        TabConfigId = c.Int(nullable: false, identity: true),
                        MainExamId = c.Int(nullable: false),
                        SubExamId = c.Int(nullable: false),
                        WrittenObt1 = c.Boolean(nullable: false),
                        WrittenConv1 = c.Boolean(nullable: false),
                        WrittenFrac1 = c.Boolean(nullable: false),
                        WrittenObt2 = c.Boolean(nullable: false),
                        WrittenConv2 = c.Boolean(nullable: false),
                        WrittenFrac2 = c.Boolean(nullable: false),
                        WrittenObt3 = c.Boolean(nullable: false),
                        WrittenConv3 = c.Boolean(nullable: false),
                        WrittenFrac3 = c.Boolean(nullable: false),
                        SubjectiveObt = c.Boolean(nullable: false),
                        SubjectiveConv = c.Boolean(nullable: false),
                        SubjectiveFrac = c.Boolean(nullable: false),
                        ObjectiveObt = c.Boolean(nullable: false),
                        ObjectiveConv = c.Boolean(nullable: false),
                        ObjectiveFrac = c.Boolean(nullable: false),
                        PracticalObt = c.Boolean(nullable: false),
                        PracticalConv = c.Boolean(nullable: false),
                        PracticalFrac = c.Boolean(nullable: false),
                        SubExamTotalObt = c.Boolean(nullable: false),
                        SubExamTotalConv = c.Boolean(nullable: false),
                        SubExamTotalFrac = c.Boolean(nullable: false),
                        SubjectObtMarks = c.Boolean(nullable: false),
                        SubjectConvertedMarks = c.Boolean(nullable: false),
                        SubjectGP = c.Boolean(nullable: false),
                        SubjectGL = c.Boolean(nullable: false),
                        SOPTotal = c.Boolean(nullable: false),
                        Virtual1 = c.Boolean(nullable: false),
                        Virtual2 = c.Boolean(nullable: false),
                        DisplayOrder = c.Int(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.TabConfigId);
            
            CreateTable(
                "dbo.Res_SubjectWiseComment",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        MainExamId = c.Int(nullable: false),
                        SubjectId = c.Int(nullable: false),
                        StudentId = c.Int(nullable: false),
                        Comments = c.String(),
                        TermId = c.Int(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Ins_StudentType",
                c => new
                    {
                        StudentTypeId = c.Int(nullable: false, identity: true),
                        StudentTypeName = c.String(nullable: false),
                        StudentTypeCode = c.String(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.StudentTypeId);
            
            CreateTable(
                "dbo.Res_StudentSubject",
                c => new
                    {
                        ID = c.Int(nullable: false, identity: true),
                        SessionId = c.Int(nullable: false),
                        BranchID = c.Int(nullable: false),
                        ClassId = c.Int(nullable: false),
                        TermId = c.Int(nullable: false),
                        SubjectID = c.Int(nullable: false),
                        StudentID = c.Int(nullable: false),
                        SubjectType = c.String(nullable: false),
                        OptionalType = c.String(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.ID);
            
            CreateTable(
                "dbo.Student_Request",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        StudentId = c.Int(nullable: false),
                        RequestType = c.Int(nullable: false),
                        CategoryId = c.Int(),
                        DesignationId = c.Int(),
                        Date = c.DateTime(),
                        Reason = c.String(),
                        Time = c.DateTime(),
                        Description = c.String(),
                        MeetingIssue = c.String(),
                        NOCType = c.Int(nullable: false),
                        TravelDesination = c.String(),
                        TravelTo = c.DateTime(),
                        TravelFrom = c.DateTime(),
                        LeaveDate = c.DateTime(),
                        LeaveTypeId = c.Int(),
                        FromDate = c.DateTime(nullable: false),
                        ToDate = c.DateTime(nullable: false),
                        Duration = c.Int(),
                        RequestOn = c.DateTime(),
                        File = c.Binary(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Student_PormotionHistory",
                c => new
                    {
                        PID = c.Long(nullable: false, identity: true),
                        StudentIID = c.Long(nullable: false),
                        SessionId = c.Int(nullable: false),
                        BranchID = c.Int(nullable: false),
                        ShiftID = c.Int(nullable: false),
                        ClassId = c.Int(nullable: false),
                        SectionId = c.Int(nullable: false),
                        RollNo = c.Int(nullable: false),
                        RegiNo = c.String(),
                        PromotedSessionId = c.Int(nullable: false),
                        PromotedBranchID = c.Int(nullable: false),
                        PromotedShiftID = c.Int(nullable: false),
                        PromotedClassId = c.Int(nullable: false),
                        PromotedSectionId = c.Int(nullable: false),
                        PromotedRollNo = c.Int(nullable: false),
                        PromotedRegiNo = c.String(),
                        StudentInsID = c.String(),
                        FullName = c.String(),
                        SMSNotificationNo = c.String(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.PID);
            
            CreateTable(
                "dbo.Att_StudentPeriodLeave",
                c => new
                    {
                        LeaveId = c.Int(nullable: false, identity: true),
                        StudentIId = c.Long(nullable: false),
                        startPeriodId = c.Int(nullable: false),
                        endPeriodId = c.Int(nullable: false),
                        LeaveTypeId = c.Int(nullable: false),
                        LeaveDate = c.DateTime(nullable: false),
                        LeaveRequest = c.DateTime(nullable: false),
                        RequestBy = c.String(),
                        Description = c.String(),
                        File = c.Binary(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.LeaveId);
            
            CreateTable(
                "dbo.Att_StudentPeriodAtten",
                c => new
                    {
                        PeriodAttendId = c.Long(nullable: false, identity: true),
                        StudentId = c.Long(nullable: false),
                        PeriodId = c.Int(nullable: false),
                        AttenTime = c.DateTime(nullable: false),
                        IsPresent = c.Boolean(nullable: false),
                        IsLeave = c.Boolean(nullable: false),
                        IsAbsconding = c.Boolean(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.PeriodAttendId);
            
            CreateTable(
                "dbo.Att_StudentLIEO",
                c => new
                    {
                        LIEOId = c.Int(nullable: false, identity: true),
                        BranchId = c.Int(),
                        SessionId = c.Int(nullable: false),
                        ShiftId = c.Int(),
                        ClassId = c.Int(),
                        SectionId = c.Int(),
                        TypeId = c.Int(nullable: false),
                        StartTime = c.Time(nullable: false, precision: 7),
                        LateInTime = c.Time(nullable: false, precision: 7),
                        EndTime = c.Time(nullable: false, precision: 7),
                        EarlyOutTime = c.Time(nullable: false, precision: 7),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.LIEOId);
            
            CreateTable(
                "dbo.Att_StudentLeave",
                c => new
                    {
                        LeaveId = c.Int(nullable: false, identity: true),
                        StudentIId = c.Long(nullable: false),
                        LeaveTypeId = c.Int(nullable: false),
                        FromDate = c.DateTime(nullable: false),
                        ToDate = c.DateTime(nullable: false),
                        Duration = c.Int(nullable: false),
                        RequestOn = c.DateTime(nullable: false),
                        Description = c.String(),
                        File = c.Binary(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.LeaveId);
            
            CreateTable(
                "dbo.Student_Image",
                c => new
                    {
                        ImageId = c.Int(nullable: false, identity: true),
                        StudentIID = c.Long(nullable: false),
                        Photo = c.Binary(),
                        ImageName = c.String(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.ImageId);
            
            CreateTable(
                "dbo.Ins_House",
                c => new
                    {
                        HouseId = c.Int(nullable: false, identity: true),
                        HouseName = c.String(),
                        HouseCode = c.String(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.HouseId);
            
            CreateTable(
                "dbo.Student_GuardianInfo",
                c => new
                    {
                        GuardianInfoId = c.Int(nullable: false, identity: true),
                        StudentIID = c.Long(nullable: false),
                        F_Qualification = c.String(),
                        F_Profession = c.String(),
                        F_MonthlyIncome = c.String(),
                        F_OfficeAddress = c.String(),
                        F_Mobile = c.String(),
                        F_Email = c.String(),
                        F_TIN = c.String(),
                        F_NIDNo = c.String(),
                        F_PassportNo = c.String(),
                        F_PPExpireDate = c.DateTime(),
                        F_GuardianImage = c.Binary(),
                        F_GuardianSignature = c.Binary(),
                        M_Qualification = c.String(),
                        M_Profession = c.String(),
                        M_MonthlyIncome = c.String(),
                        M_OfficeAddress = c.String(),
                        M_Mobile = c.String(),
                        M_Email = c.String(),
                        M_TIN = c.String(),
                        M_NIDNo = c.String(),
                        M_PassportNo = c.String(),
                        M_PPExpireDate = c.DateTime(),
                        M_GuardianImage = c.Binary(),
                        M_GuardianSignature = c.Binary(),
                        LG_Name = c.String(),
                        LG_Relation = c.String(),
                        LG_Address = c.String(),
                        LG_Mobile = c.String(),
                        LG_Email = c.String(),
                        LG_TIN = c.String(),
                        LG_NIDNo = c.String(),
                        LG_GuardianImage = c.Binary(),
                        LG_GuardianSignature = c.Binary(),
                        LG2_Name = c.String(),
                        LG2_Relation = c.String(),
                        LG2_Address = c.String(),
                        LG2_Mobile = c.String(),
                        LG2_Email = c.String(),
                        LG2_TIN = c.String(),
                        LG2_NIDNo = c.String(),
                        LG2_GuardianImage = c.Binary(),
                        LG2_GuardianSignature = c.Binary(),
                        LG3_Name = c.String(),
                        LG3_Relation = c.String(),
                        LG3_Address = c.String(),
                        LG3_Mobile = c.String(),
                        LG3_Email = c.String(),
                        LG3_TIN = c.String(),
                        LG3_NIDNo = c.String(),
                        LG3_GuardianImage = c.Binary(),
                        LG3_GuardianSignature = c.Binary(),
                        LG4_Name = c.String(),
                        LG4_Relation = c.String(),
                        LG4_Address = c.String(),
                        LG4_Mobile = c.String(),
                        LG4_Email = c.String(),
                        LG4_TIN = c.String(),
                        LG4_NIDNo = c.String(),
                        LG4_GuardianImage = c.Binary(),
                        LG4_GuardianSignature = c.Binary(),
                        E_Name = c.String(),
                        E_Relation = c.String(),
                        E_Address = c.String(),
                        E_Mobile = c.String(),
                        E_NIDNo = c.String(),
                        E_Email = c.String(),
                        E_GuardianImage = c.Binary(),
                        E_GuardianSignature = c.Binary(),
                        G1_Name = c.String(),
                        G1_Qualification = c.String(),
                        G1_Profession = c.String(),
                        G1_MonthlyIncome = c.String(),
                        G1_OfficeAddress = c.String(),
                        G1_Mobile = c.String(),
                        G1_Email = c.String(),
                        G1_TIN = c.String(),
                        G1_NIDNo = c.String(),
                        G1_PassportNo = c.String(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.GuardianInfoId);
            
            CreateTable(
                "dbo.Student_Detail",
                c => new
                    {
                        StudentIID = c.Int(nullable: false, identity: true),
                        PlaceOfBirth = c.String(),
                        PassportNo = c.String(),
                        Email = c.String(),
                        RSMUNInfo = c.String(),
                        IsPhysicalDrawback = c.Boolean(),
                        PhyDrawbackDescription = c.String(),
                        TransportFacility = c.String(),
                        RegularMedicineInstruction = c.String(),
                        Height = c.String(),
                        Weight = c.String(),
                        NoOfChildren = c.Int(),
                        StudentPositionInChildren = c.Int(),
                        CurrentResidenceType = c.String(),
                        PreInsInfoName = c.String(),
                        PreInsInfoClass = c.String(),
                        PreInsInfoSection = c.String(),
                        PreInsInfoGroup = c.String(),
                        PreInsInfoSession = c.String(),
                        PreInsInfoVersion = c.String(),
                        PreInsInfoRollNo = c.String(),
                        PreInsInfoGPAResult = c.String(),
                        PreInsInfoTCNo = c.String(),
                        PreInsInfoDate = c.String(),
                        FirstAdmittedinClass = c.String(),
                        Quota = c.String(),
                    })
                .PrimaryKey(t => t.StudentIID);
            
            CreateTable(
                "dbo.Att_StudentAttendance",
                c => new
                    {
                        AttendId = c.Long(nullable: false, identity: true),
                        StudentId = c.Long(nullable: false),
                        InTime = c.DateTime(nullable: false),
                        OutTime = c.DateTime(),
                        IsPresent = c.Boolean(nullable: false),
                        IsLeave = c.Boolean(nullable: false),
                        LeaveId = c.Int(),
                        IsAbsconding = c.Boolean(nullable: false),
                        AbscondingPeriod = c.String(maxLength: 30),
                        IsLate = c.Boolean(nullable: false),
                        LateTime = c.Int(),
                        IsEarlyOut = c.Boolean(nullable: false),
                        EarlyOutTime = c.Int(),
                        Device_SerialNo = c.String(maxLength: 25),
                        Device_UserID = c.String(maxLength: 25),
                        Device_CardNo = c.String(maxLength: 25),
                        EntryType = c.String(maxLength: 2),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.AttendId);
            
            CreateTable(
                "dbo.Ins_Signature",
                c => new
                    {
                        ID = c.Int(nullable: false, identity: true),
                        PersonName1 = c.String(),
                        PersonName2 = c.String(),
                        PersonName3 = c.String(),
                        PersonName4 = c.String(),
                        Designation1 = c.String(),
                        Designation2 = c.String(),
                        Designation3 = c.String(),
                        Designation4 = c.String(),
                        Type1 = c.Int(),
                        Type2 = c.Int(),
                        Type3 = c.Int(),
                        Type4 = c.Int(),
                        BranchID = c.Int(nullable: false),
                        ShiftID = c.Int(nullable: false),
                        ClassID = c.Int(nullable: false),
                        SignatureImg1 = c.Binary(),
                        SignatureImg2 = c.Binary(),
                        SignatureImg3 = c.Binary(),
                        SignatureImg4 = c.Binary(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.ID);
            
            CreateTable(
                "dbo.Fees_SecurityDepositDetails",
                c => new
                    {
                        SecurityDepositDetailsId = c.Int(nullable: false, identity: true),
                        StudentIID = c.Long(nullable: false),
                        FeesHeadId = c.Int(nullable: false),
                        DepositAmont = c.Decimal(nullable: false, precision: 18, scale: 2),
                        TotalAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ReceiveAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        Narration = c.String(),
                        BankDate = c.DateTime(nullable: false),
                        PostingDate = c.DateTime(nullable: false),
                        MoneyReceipt = c.String(maxLength: 20),
                        Installment = c.Int(),
                        InstallmentAmount = c.Decimal(precision: 18, scale: 2),
                        IsAdjusted = c.Boolean(),
                        IsRefund = c.Boolean(),
                        IsResolved = c.Boolean(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.SecurityDepositDetailsId);
            
            CreateTable(
                "dbo.Ins_SeatCardSetup",
                c => new
                    {
                        ID = c.Int(nullable: false, identity: true),
                        Title = c.String(nullable: false),
                        SessionID = c.Int(nullable: false),
                        BranchID = c.Int(nullable: false),
                        ShiftID = c.Int(nullable: false),
                        ClassID = c.Int(nullable: false),
                        SignatureID_1 = c.Boolean(nullable: false),
                        SignatureID_2 = c.Boolean(nullable: false),
                        SignatureID_3 = c.Boolean(nullable: false),
                        SignatureID_4 = c.Boolean(nullable: false),
                        TemplateId = c.Int(),
                        WatermarkImage = c.Binary(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.ID);
            
            CreateTable(
                "dbo.Ins_ScholarshipType",
                c => new
                    {
                        ScholarshipTypeId = c.Int(nullable: false, identity: true),
                        ScholarshipTypeName = c.String(nullable: false),
                        ScholarshipTypeCode = c.String(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.ScholarshipTypeId);
            
            CreateTable(
                "dbo.Ins_Route",
                c => new
                    {
                        RouteId = c.Int(nullable: false, identity: true),
                        RouteName = c.String(),
                        VehicleType = c.String(maxLength: 100),
                        Amount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        StartLocation = c.String(maxLength: 100),
                        EndLocation = c.String(maxLength: 100),
                        Via = c.String(maxLength: 200),
                        Startlatitude = c.String(maxLength: 50),
                        Startlongitude = c.String(maxLength: 50),
                        Endlatitude = c.String(maxLength: 50),
                        Endlongitude = c.String(maxLength: 50),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.RouteId);
            
            CreateTable(
                "dbo.Arch_ResultArchive",
                c => new
                    {
                        ResultArchiveId = c.Int(nullable: false, identity: true),
                        SessionId = c.Int(nullable: false),
                        BranchID = c.Int(nullable: false),
                        ShiftID = c.Int(nullable: false),
                        ClassId = c.Int(nullable: false),
                        SectionId = c.Int(nullable: false),
                        FileOrgName = c.String(),
                        FileName = c.String(),
                        FileExt = c.String(),
                        FilePath = c.String(),
                        Type = c.String(),
                        ExamId = c.Int(nullable: false),
                        IsGrand = c.Boolean(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.ResultArchiveId);
            
            CreateTable(
                "dbo.Res_Reports",
                c => new
                    {
                        ReportId = c.Int(nullable: false, identity: true),
                        ReportName = c.String(),
                        Path = c.String(),
                        SPName = c.String(),
                        Type = c.String(),
                    })
                .PrimaryKey(t => t.ReportId);
            
            CreateTable(
                "dbo.Res_ReportConfig",
                c => new
                    {
                        ReportConfigId = c.Int(nullable: false, identity: true),
                        ClassId = c.Int(nullable: false),
                        ReportId = c.Int(nullable: false),
                        Type = c.String(),
                    })
                .PrimaryKey(t => t.ReportConfigId);
            
            CreateTable(
                "dbo.Rtn_PeriodTeacher",
                c => new
                    {
                        ID = c.Int(nullable: false, identity: true),
                        SessionId = c.Int(nullable: false),
                        BranchId = c.Int(),
                        ShiftId = c.Int(),
                        ClassId = c.Int(),
                        SectionId = c.Int(),
                        Period = c.Int(),
                        TeacherId = c.Int(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.ID);
            
            CreateTable(
                "dbo.Student_SiblingInfo",
                c => new
                    {
                        SiblingInfoId = c.Int(nullable: false, identity: true),
                        StudentIID = c.Long(nullable: false),
                        SiblingStudentIID = c.Long(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.SiblingInfoId);
            
            CreateTable(
                "dbo.Student_ContactInfo",
                c => new
                    {
                        ContactIID = c.Int(nullable: false, identity: true),
                        StudentIID = c.Long(nullable: false),
                        Pre_PSId = c.Int(nullable: false),
                        Pre_DisId = c.Int(nullable: false),
                        Pre_Address = c.String(),
                        Pre_PostOffice = c.String(),
                        Pre_PostalCode = c.String(),
                        Par_PSId = c.Int(nullable: false),
                        Par_DisId = c.Int(nullable: false),
                        Par_Address = c.String(),
                        Par_PostOffice = c.String(),
                        Par_PostalCode = c.String(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.ContactIID);
            
            CreateTable(
                "dbo.Student_AcademicInfo",
                c => new
                    {
                        AcademicId = c.Int(nullable: false, identity: true),
                        StudentIID = c.Long(nullable: false),
                        ExamName = c.String(nullable: false),
                        InstituteName = c.String(),
                        InstituteAddress = c.String(),
                        DistrictThana = c.String(),
                        Center = c.String(),
                        ExamGroup = c.String(),
                        ExamYear = c.String(),
                        PassYear = c.String(),
                        ExamSession = c.String(),
                        ExamRoll = c.String(),
                        ExamRegNo = c.String(),
                        Board = c.String(),
                        GPA = c.Decimal(precision: 18, scale: 2),
                        GPAWithOut4thSubject = c.Decimal(precision: 18, scale: 2),
                        Grade = c.String(),
                        Comment = c.String(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.AcademicId);
            
            CreateTable(
                "dbo.Student_BasicInfo",
                c => new
                    {
                        StudentIID = c.Long(nullable: false, identity: true),
                        SessionId = c.Int(nullable: false),
                        BranchID = c.Int(nullable: false),
                        ShiftID = c.Int(nullable: false),
                        ClassId = c.Int(nullable: false),
                        SectionId = c.Int(nullable: false),
                        RouteId = c.Int(),
                        ECAClubId = c.Int(),
                        StudentInsID = c.String(),
                        RollNo = c.Int(nullable: false),
                        RegiNo = c.String(),
                        FullName = c.String(),
                        NameBangla = c.String(),
                        FatherName = c.String(),
                        MotherName = c.String(),
                        SMSNotificationNo = c.String(),
                        DateOfBirth = c.DateTime(),
                        Age = c.Int(),
                        Gender = c.String(maxLength: 10),
                        Nationality = c.String(maxLength: 20),
                        Religion = c.String(maxLength: 20),
                        BloodGroup = c.String(maxLength: 10),
                        IsPhysicalDrawback = c.Boolean(),
                        IsEnrollment = c.Boolean(nullable: false),
                        PhyDrawbackDescription = c.String(),
                        TransportFacility = c.String(),
                        RegularMedicineInstruction = c.String(),
                        Height = c.String(),
                        Weight = c.String(),
                        NoOfChildren = c.Int(),
                        StudentPositionInChildren = c.Int(),
                        CurrentResidenceType = c.String(),
                        PreInsInfoName = c.String(),
                        PreInsInfoClass = c.String(),
                        PreInsInfoSection = c.String(),
                        PreInsInfoGroup = c.String(),
                        PreInsInfoSession = c.String(),
                        PreInsInfoVersion = c.String(),
                        PreInsInfoRollNo = c.String(),
                        PreInsInfoGPAResult = c.String(),
                        PreInsInfoTCNo = c.String(),
                        PreInsInfoDate = c.String(),
                        FirstAdmittedinClass = c.String(),
                        FirstAdmittedDate = c.DateTime(),
                        StudentTypeID = c.Int(nullable: false),
                        HouseID = c.Int(nullable: false),
                        Quota = c.String(),
                        AdmissionDate = c.DateTime(),
                        AddmissionEntryType = c.String(maxLength: 2),
                        AddmissionStatus = c.String(maxLength: 2),
                        IsTC = c.Boolean(),
                        TCCauses = c.String(),
                        TCStatus = c.String(maxLength: 2),
                        TCDate = c.DateTime(),
                        TCBy = c.String(),
                        TCApprovedBy = c.String(),
                        TestimonialIssueDate = c.DateTime(),
                        TestimonialIssueBy = c.String(),
                        BirthCertificate = c.String(),
                        RS_MUN = c.String(),
                        MedicalAdvice = c.String(),
                        PPNumber = c.String(),
                        PPExpireDate = c.DateTime(),
                        CurrentStudentId = c.String(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.StudentIID);
            
            CreateTable(
                "dbo.Student_OthersInfo",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        StudentIID = c.Long(nullable: false),
                        ExtraActivity = c.String(nullable: false),
                        From = c.DateTime(),
                        To = c.DateTime(),
                        TillNow = c.Boolean(nullable: false),
                        Type = c.String(nullable: false),
                        AchievementPicture = c.Binary(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Res_MERSubExamResult",
                c => new
                    {
                        MarksDetailsID = c.Int(nullable: false, identity: true),
                        ResultSubjectDetailsId = c.Long(nullable: false),
                        SubjectID = c.Int(nullable: false),
                        MainExamId = c.Int(nullable: false),
                        SubExamId = c.Int(nullable: false),
                        StudentIID = c.Long(nullable: false),
                        SubExamTotalObt = c.Decimal(nullable: false, precision: 18, scale: 2),
                        SubExamTotalConv = c.Decimal(nullable: false, precision: 18, scale: 2),
                        SubExamTotalFrac = c.Decimal(nullable: false, precision: 18, scale: 2),
                        SubExamIsPass = c.Boolean(nullable: false),
                        SubExamIsAbsent = c.Boolean(nullable: false),
                    })
                .PrimaryKey(t => t.MarksDetailsID);
            
            CreateTable(
                "dbo.Res_MeritListConfig",
                c => new
                    {
                        MeritListConfigId = c.Int(nullable: false, identity: true),
                        SessionId = c.Int(nullable: false),
                        ClassId = c.Int(nullable: false),
                        SortSerialByGPAWith4th = c.Int(nullable: false),
                        SortSerialByGPAWithout4th = c.Int(nullable: false),
                        SortSerialByTotalMark = c.Int(nullable: false),
                        SortSerialByRoll = c.Int(nullable: false),
                        SortSerialByName = c.Int(nullable: false),
                        SubjectId1 = c.Int(nullable: false),
                        SortSerialBySubjectId1 = c.Int(nullable: false),
                        SubjectId2 = c.Int(nullable: false),
                        SortSerialBySubjectId2 = c.Int(nullable: false),
                        SubjectId3 = c.Int(nullable: false),
                        SortSerialBySubjectId3 = c.Int(nullable: false),
                        TotalMarkSameMerit = c.Boolean(nullable: false),
                        TotalIsFraction = c.Boolean(nullable: false),
                        IsGrand = c.Boolean(nullable: false),
                        BranchWise = c.Boolean(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.MeritListConfigId);
            
            CreateTable(
                "dbo.Res_MarksMigratedSetup",
                c => new
                    {
                        ID = c.Int(nullable: false, identity: true),
                        SessionID = c.Int(nullable: false),
                        ClassID = c.Int(nullable: false),
                        BodyCalculationRule = c.String(),
                        TotalCalculatuonRule = c.String(),
                        TermId = c.Int(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.ID);
            
            CreateTable(
                "dbo.Res_MainExamResultSubjectDetails",
                c => new
                    {
                        ResultSubjectDetailsId = c.Int(nullable: false, identity: true),
                        ResultId = c.Long(nullable: false),
                        StudentIID = c.Long(nullable: false),
                        SubjectID = c.Int(nullable: false),
                        MainExamId = c.Int(nullable: false),
                        SubjectOriginalObtMarks = c.Decimal(nullable: false, precision: 18, scale: 2),
                        SubjectObtMarks = c.Decimal(nullable: false, precision: 18, scale: 2),
                        SubjectConvertedMarks = c.Decimal(nullable: false, precision: 18, scale: 2),
                        SubjectConvertedMarksFraction = c.Decimal(nullable: false, precision: 18, scale: 2),
                        SubjectGP = c.Decimal(nullable: false, precision: 18, scale: 2),
                        SubjectGL = c.String(),
                        SubjectHighestMark = c.Decimal(nullable: false, precision: 18, scale: 2),
                        SubjectIsPass = c.Boolean(nullable: false),
                        SubjectIsAbsent = c.Boolean(nullable: false),
                        IsECA = c.Boolean(nullable: false),
                        TotalExamNo = c.Int(nullable: false),
                        MidYearSubObtMarks = c.Decimal(precision: 18, scale: 2),
                        MidYearSubConvtMarks = c.Decimal(precision: 18, scale: 2),
                        AutumnMarks = c.Decimal(precision: 18, scale: 2),
                        WinterMarks = c.Decimal(precision: 18, scale: 2),
                        FinalYearSubObtMarks2 = c.Decimal(precision: 18, scale: 2),
                        FinalYearSubConvtMarks2 = c.Decimal(precision: 18, scale: 2),
                    })
                .PrimaryKey(t => t.ResultSubjectDetailsId);
            
            CreateTable(
                "dbo.Res_MainExamResult",
                c => new
                    {
                        ResultId = c.Long(nullable: false, identity: true),
                        MainExamId = c.Int(nullable: false),
                        StudentIID = c.Long(nullable: false),
                        TotalMarks = c.Decimal(nullable: false, precision: 18, scale: 2),
                        TotalWithECA = c.Decimal(nullable: false, precision: 18, scale: 2),
                        TotalWithOutECA = c.Decimal(nullable: false, precision: 18, scale: 2),
                        TotalWithECAPercent = c.Decimal(nullable: false, precision: 18, scale: 2),
                        TotalWithOutECAPercent = c.Decimal(nullable: false, precision: 18, scale: 2),
                        GPA = c.Decimal(nullable: false, precision: 18, scale: 2),
                        GradeLetter = c.String(),
                        GLWithOutECA = c.String(),
                        IsPublished = c.Boolean(nullable: false),
                    })
                .PrimaryKey(t => t.ResultId);
            
            CreateTable(
                "dbo.Res_MainExamMarks",
                c => new
                    {
                        MarksId = c.Int(nullable: false),
                        StudentIID = c.Long(nullable: false),
                        SubjectID = c.Int(nullable: false),
                        SessionId = c.Int(nullable: false),
                        ShiftId = c.Int(nullable: false),
                        ClassId = c.Int(nullable: false),
                        SectionId = c.Int(nullable: false),
                        MainExamID = c.Int(nullable: false),
                        SubExamID = c.Int(nullable: false),
                        ObtainMarks = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ConvertedMarks = c.Decimal(nullable: false, precision: 18, scale: 2),
                        IsAbsent = c.Boolean(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => new { t.MarksId, t.StudentIID, t.SubjectID });
            
            CreateTable(
                "dbo.Res_MainExamLeaveStudent",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        SessionId = c.Int(nullable: false),
                        BranchId = c.Int(nullable: false),
                        ClassId = c.Int(nullable: false),
                        ShiftId = c.Int(nullable: false),
                        SectionId = c.Int(nullable: false),
                        StudentIID = c.Long(nullable: false),
                        ISStudentWise = c.Boolean(nullable: false),
                        GrandExamId = c.Int(nullable: false),
                        SubjectID = c.Int(nullable: false),
                        NumberOfExam = c.Int(nullable: false),
                        Remurks = c.String(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Res_MainExamAssessment",
                c => new
                    {
                        ID = c.Long(nullable: false, identity: true),
                        SessionID = c.Int(nullable: false),
                        BranchID = c.Int(nullable: false),
                        ShiftID = c.Int(nullable: false),
                        ClassID = c.Int(nullable: false),
                        SectionID = c.Int(nullable: false),
                        MainExamId = c.Int(nullable: false),
                        StudentID = c.Long(nullable: false),
                        SubjectId = c.Int(nullable: false),
                        HandWriting = c.Int(nullable: false),
                        PicReading = c.Int(nullable: false),
                        Recitation = c.Int(nullable: false),
                        Conversation = c.Int(nullable: false),
                        ColourSense = c.Int(nullable: false),
                        Art = c.Int(nullable: false),
                        Music = c.Int(nullable: false),
                        ParticipationInGames = c.Int(nullable: false),
                        Obedience = c.Int(nullable: false),
                        Tolerance = c.Int(nullable: false),
                        SelfReliance = c.Int(nullable: false),
                        Leadership = c.Int(nullable: false),
                        Interaction_with_Teachers_and_Peers = c.Int(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.ID);
            
            CreateTable(
                "dbo.Ins_IDConfig",
                c => new
                    {
                        ConfigId = c.Int(nullable: false, identity: true),
                        ConfigName = c.String(),
                        IsSelected = c.Boolean(nullable: false),
                        Prefix = c.String(),
                        Length = c.Int(nullable: false),
                        Postfix = c.String(),
                        IsReset = c.Boolean(nullable: false),
                        Order = c.Int(nullable: false),
                        Seperator = c.String(),
                        ConfigType = c.String(),
                        LastDigit = c.Int(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.ConfigId);
            
            CreateTable(
                "dbo.Res_HighestMarkConfig",
                c => new
                    {
                        HighestMarkConfigId = c.Int(nullable: false, identity: true),
                        SessionId = c.Int(nullable: false),
                        ClassId = c.Int(nullable: false),
                        BranchWise = c.Boolean(nullable: false),
                        VersionWise = c.Boolean(nullable: false),
                        ClassWise = c.Boolean(nullable: false),
                        ShiftWise = c.Boolean(nullable: false),
                        SectionWise = c.Boolean(nullable: false),
                        IsOverall = c.Boolean(nullable: false),
                        IsGrand = c.Boolean(nullable: false),
                        IsFrac = c.Boolean(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.HighestMarkConfigId);
            
            CreateTable(
                "dbo.Res_HeadsCommentDetails",
                c => new
                    {
                        ID = c.Int(nullable: false, identity: true),
                        HeadsCommentID = c.Int(nullable: false),
                        Comments = c.String(),
                    })
                .PrimaryKey(t => t.ID);
            
            CreateTable(
                "dbo.Res_HeadsCommentMaster",
                c => new
                    {
                        HeadsCommentID = c.Int(nullable: false, identity: true),
                        SessionID = c.Int(nullable: false),
                        BranchID = c.Int(nullable: false),
                        ShiftID = c.Int(nullable: false),
                        ClassID = c.Int(nullable: false),
                        SectionID = c.Int(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.HeadsCommentID);
            
            CreateTable(
                "dbo.Fees_HeadPriority",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        SessionId = c.Int(nullable: false),
                        BranchId = c.Int(),
                        ClassId = c.Int(nullable: false),
                        FeesHeadId = c.Int(nullable: false),
                        AdvancePriority = c.Int(),
                        AdvanceMax = c.Decimal(precision: 18, scale: 2),
                        DiscountPriority = c.Int(),
                        PartialPriority = c.Int(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Res_GradingSystem",
                c => new
                    {
                        ID = c.Int(nullable: false, identity: true),
                        SessionID = c.Int(nullable: false),
                        ClassID = c.Int(nullable: false),
                        Marks_From = c.Decimal(nullable: false, precision: 18, scale: 2),
                        Marks_To = c.Decimal(nullable: false, precision: 18, scale: 2),
                        GL = c.String(),
                        GP = c.Decimal(nullable: false, precision: 18, scale: 2),
                        TermId = c.Int(nullable: false),
                        IsFailGrade = c.Boolean(nullable: false),
                        Comments = c.String(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.ID);
            
            CreateTable(
                "dbo.Res_FouthSubjectRules",
                c => new
                    {
                        ID = c.Int(nullable: false, identity: true),
                        SessionID = c.Int(nullable: false),
                        ClassID = c.Int(nullable: false),
                        IsFailImpact = c.Boolean(nullable: false),
                        DeductMarks = c.Decimal(nullable: false, precision: 18, scale: 2),
                        DeductGP = c.Decimal(nullable: false, precision: 18, scale: 2),
                        AttendancePassFailimpact = c.Boolean(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.ID);
            
            CreateTable(
                "dbo.Fees_TempCollection",
                c => new
                    {
                        FeesStudentId = c.Long(nullable: false, identity: true),
                        ProcessId = c.Int(nullable: false),
                        SessionId = c.Int(nullable: false),
                        MonthId = c.Int(nullable: false),
                        StudentIID = c.Long(nullable: false),
                        HeadId = c.Int(nullable: false),
                        TotalAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        DueAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        NoModifiedDueAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ScholarshipAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        DiscountAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        PaidAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        AdvanceAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        IsPaid = c.Boolean(nullable: false),
                        IsCompleted = c.Boolean(nullable: false),
                        Narration = c.String(),
                        FeesBookNo = c.String(maxLength: 20),
                        ProcessType = c.String(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.FeesStudentId);
            
            CreateTable(
                "dbo.Fees_StudentArchive",
                c => new
                    {
                        FeesStudentId = c.Long(nullable: false, identity: true),
                        ProcessId = c.Int(nullable: false),
                        SessionId = c.Int(nullable: false),
                        MonthId = c.Int(nullable: false),
                        StudentIID = c.Long(nullable: false),
                        HeadId = c.Int(nullable: false),
                        FeesSessionYearId = c.Int(nullable: false),
                        TotalAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        DueAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ScholarshipAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        DiscountAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        NoModifiedDueAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        PaidAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        AdvanceAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        IsPaid = c.Boolean(nullable: false),
                        IsCompleted = c.Boolean(nullable: false),
                        Narration = c.String(),
                        processTime = c.DateTime(nullable: false),
                        FeesBookNo = c.String(maxLength: 20),
                        ProcessType = c.String(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.FeesStudentId);
            
            CreateTable(
                "dbo.Fees_Student",
                c => new
                    {
                        FeesStudentId = c.Long(nullable: false, identity: true),
                        ProcessId = c.Int(nullable: false),
                        SessionId = c.Int(nullable: false),
                        MonthId = c.Int(nullable: false),
                        StudentIID = c.Long(nullable: false),
                        HeadId = c.Int(nullable: false),
                        FeesSessionYearId = c.Int(nullable: false),
                        TotalAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ProcessedAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        DueAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        NoModifiedDueAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ScholarshipAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        DiscountAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        PaidAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        PartialAmount = c.Decimal(precision: 18, scale: 2),
                        AdvanceAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        IsEnrollment = c.Boolean(nullable: false),
                        IsOldStudent = c.Boolean(nullable: false),
                        IsCashCollection = c.Boolean(nullable: false),
                        InvoiceAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        IsPaid = c.Boolean(nullable: false),
                        IsCompleted = c.Boolean(nullable: false),
                        IsAdjust = c.Boolean(),
                        IsRefund = c.Boolean(),
                        IsResolved = c.Boolean(),
                        Narration = c.String(),
                        Stutype = c.String(),
                        EmpId = c.String(),
                        IsVerification = c.Boolean(),
                        AppVerificationNo = c.String(),
                        FeesBookNo = c.String(maxLength: 20),
                        ProcessType = c.String(),
                        AutomatedDays = c.Int(nullable: false),
                        AutomatedConsecutiveDays = c.Int(nullable: false),
                        IsPublished = c.Boolean(nullable: false),
                        IsLatePayPublished = c.Boolean(nullable: false),
                        IsLatePay = c.Boolean(nullable: false),
                        Year = c.Int(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                        FeesStudent_FeesStudentId = c.Long(),
                    })
                .PrimaryKey(t => t.FeesStudentId);
            
            CreateTable(
                "dbo.Fees_Setting",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        IsAdvance = c.Boolean(nullable: false),
                        IsFullPay = c.Boolean(nullable: false),
                        IsPartial = c.Boolean(nullable: false),
                        IsDiscount = c.Boolean(nullable: false),
                        IsAutomatedProcess = c.Boolean(nullable: false),
                        Day = c.Int(),
                        Time = c.Int(),
                        IsNoEffectHead = c.Boolean(nullable: false),
                        IsBarCode = c.Boolean(nullable: false),
                        IsOnlyCollection = c.Boolean(nullable: false),
                        IsVat = c.Boolean(nullable: false),
                        VatPercent = c.Decimal(precision: 18, scale: 2),
                        VatStartDate = c.DateTime(),
                        VatEndDate = c.DateTime(),
                        IsStudentId = c.Boolean(nullable: false),
                        IsBankDate = c.Boolean(nullable: false),
                        IsPostingDate = c.Boolean(nullable: false),
                        Image = c.Binary(),
                        FeesBookPart = c.Int(),
                        PartText1 = c.String(),
                        PartText2 = c.String(),
                        PartText3 = c.String(),
                        PartText4 = c.String(),
                        ShowingPosition = c.String(),
                        FBSignature = c.Int(),
                        FBSignature1 = c.String(),
                        FBSignature2 = c.String(),
                        FBSignature3 = c.String(),
                        FBSignature4 = c.String(),
                        Date = c.Int(),
                        Date1 = c.Boolean(),
                        Date2 = c.Boolean(),
                        Date3 = c.Boolean(),
                        Date4 = c.Boolean(),
                        FooterText1 = c.String(),
                        FooterText2 = c.String(),
                        IsEnableMarketing = c.Boolean(),
                        FeesHeadHasGroup = c.Boolean(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Fees_ScholarshipType",
                c => new
                    {
                        ScholarshipTypeId = c.Int(nullable: false, identity: true),
                        ScholarshipType = c.String(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.ScholarshipTypeId);
            
            CreateTable(
                "dbo.Fees_ScholarshipDetails",
                c => new
                    {
                        ScholarshipDetailsId = c.Int(nullable: false, identity: true),
                        ScholarshipMasterId = c.Int(nullable: false),
                        SessionYearId = c.Int(nullable: false),
                    })
                .PrimaryKey(t => t.ScholarshipDetailsId);
            
            CreateTable(
                "dbo.Fees_ScholarshipMaster",
                c => new
                    {
                        ScholarshipConfigId = c.Int(nullable: false, identity: true),
                        ScholarshipTypeId = c.Int(nullable: false),
                        StudentId = c.Long(nullable: false),
                        FeesHeadId = c.Int(nullable: false),
                        Amount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        IsPercentage = c.Boolean(nullable: false),
                        Command = c.String(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.ScholarshipConfigId);
            
            CreateTable(
                "dbo.Fees_ReceiptSettingDetails",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        MonthMergeId = c.Int(nullable: false),
                        ReceiptMonth = c.Int(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Fees_ReceiptSetting",
                c => new
                    {
                        MergeId = c.Int(nullable: false, identity: true),
                        SessionId = c.Int(nullable: false),
                        ClassId = c.Int(nullable: false),
                        MergeName = c.String(),
                        ReceiptFormat = c.Int(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.MergeId);
            
            CreateTable(
                "dbo.Fees_ProcessDetails",
                c => new
                    {
                        ProcessDetailsId = c.Int(nullable: false, identity: true),
                        ProcessId = c.Int(nullable: false),
                        SessionYearId = c.Int(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.ProcessDetailsId);
            
            CreateTable(
                "dbo.Fees_Process",
                c => new
                    {
                        FeesProcessId = c.Int(nullable: false, identity: true),
                        SessionId = c.Int(nullable: false),
                        ProcessName = c.String(nullable: false),
                        ProcessType = c.Boolean(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.FeesProcessId);
            
            CreateTable(
                "dbo.Fees_FeesSessionYear",
                c => new
                    {
                        FeesSessionYearId = c.Int(nullable: false, identity: true),
                        FeesFiscalSessionId = c.Int(nullable: false),
                        Year = c.Int(nullable: false),
                        MonthId = c.Int(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.FeesSessionYearId);
            
            CreateTable(
                "dbo.Fees_FeesMonth",
                c => new
                    {
                        FeesMonthId = c.Int(nullable: false, identity: true),
                        MonthName = c.String(nullable: false),
                    })
                .PrimaryKey(t => t.FeesMonthId);
            
            CreateTable(
                "dbo.Fees_FeesModifyLog",
                c => new
                    {
                        FeesModifyLogId = c.Long(nullable: false, identity: true),
                        StudentId = c.Long(nullable: false),
                        ProcessId = c.Int(),
                        FeesSessionYearId = c.Int(nullable: false),
                        YearId = c.Int(nullable: false),
                        MonthId = c.Int(nullable: false),
                        HeadId = c.Int(nullable: false),
                        PreviousAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ChangeAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        UpdateType = c.String(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.FeesModifyLogId);
            
            CreateTable(
                "dbo.Fees_FeesLatePaySlab",
                c => new
                    {
                        SlabId = c.Int(nullable: false, identity: true),
                        AutomatedId = c.Int(nullable: false),
                        FromDate = c.Int(nullable: false),
                        ToDate = c.Int(nullable: false),
                        LatePayPeriod = c.Int(nullable: false),
                        IsAcademicDate = c.Boolean(nullable: false),
                        Amount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.SlabId);
            
            CreateTable(
                "dbo.Fees_HeadDefault",
                c => new
                    {
                        HeadId = c.Int(nullable: false, identity: true),
                        HeadName = c.String(nullable: false),
                        CategoryId = c.Int(nullable: false),
                        ShowOrder = c.Int(),
                        HasPolicy = c.Boolean(nullable: false),
                        PolicyName = c.String(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.HeadId);
            
            CreateTable(
                "dbo.Fees_HeadAmountConfig",
                c => new
                    {
                        HeadAmountConfigId = c.Long(nullable: false, identity: true),
                        ProcessId = c.Int(nullable: false),
                        HeadId = c.Int(nullable: false),
                        SessionId = c.Int(nullable: false),
                        BranchId = c.Int(),
                        ShiftId = c.Int(),
                        ClassId = c.Int(),
                        SectionId = c.Int(),
                        FessGroupId = c.Int(),
                        StudentIID = c.Int(),
                        Amount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        IsAllBranch = c.Boolean(nullable: false),
                        IsAllShift = c.Boolean(nullable: false),
                        DueMonth = c.DateTime(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.HeadAmountConfigId);
            
            CreateTable(
                "dbo.Fees_Head",
                c => new
                    {
                        FeesHeadId = c.Int(nullable: false, identity: true),
                        HeadName = c.String(nullable: false),
                        CategoryId = c.Int(nullable: false),
                        ShowOrder = c.Int(),
                        HasPolicy = c.Boolean(nullable: false),
                        PolicyName = c.String(),
                        HeadCode = c.String(),
                        AccCode1 = c.String(),
                        AccCode2 = c.String(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.FeesHeadId);
            
            CreateTable(
                "dbo.Fees_FiscalSession",
                c => new
                    {
                        FeesFiscalSessionId = c.Int(nullable: false, identity: true),
                        SessionId = c.Int(nullable: false),
                        ClassId = c.Int(nullable: false),
                        FiscalSessionName = c.String(),
                        FiscalSessionCode = c.String(),
                        Session_StartDate = c.DateTime(nullable: false),
                        Session_EndDate = c.DateTime(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.FeesFiscalSessionId);
            
            CreateTable(
                "dbo.Fees_DisplayGroupDetails",
                c => new
                    {
                        DeatailsId = c.Int(nullable: false, identity: true),
                        GroupId = c.Int(nullable: false),
                        HeadId = c.Int(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.DeatailsId);
            
            CreateTable(
                "dbo.Fees_DisplayGroup",
                c => new
                    {
                        DisplayGroupId = c.Int(nullable: false, identity: true),
                        GroupName = c.String(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.DisplayGroupId);
            
            CreateTable(
                "dbo.Fees_CollectionMaster",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        MonthId = c.Int(nullable: false),
                        SessionId = c.Int(nullable: false),
                        StudentIID = c.Long(nullable: false),
                        MoneyReceipt = c.String(maxLength: 20),
                        PaymentDate = c.DateTime(nullable: false),
                        TotalAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ReceivedAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        TotalDiscountAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        PaymentMonth = c.Int(nullable: false),
                        PaymentType = c.Int(nullable: false),
                        ChequeNo = c.String(),
                        BankName = c.String(),
                        Narration = c.String(),
                        IsPosted = c.Boolean(nullable: false),
                        BoothID = c.Int(nullable: false),
                        ScrollNumber = c.String(),
                        IsAdjust = c.Boolean(),
                        IsRefund = c.Boolean(),
                        IsResolved = c.Boolean(),
                        IsEnrollment = c.Boolean(),
                        IsOldStudent = c.Boolean(),
                        IsCashCollection = c.Boolean(),
                        BankCollectionDate = c.DateTime(),
                        TrxID = c.String(),
                        PayModeNo = c.Int(),
                        PCS_BankName = c.String(),
                        PCS_TrxID = c.String(),
                        VAT = c.Decimal(precision: 18, scale: 2),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Fees_CollectionDetails",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        MasterID = c.Int(nullable: false),
                        HeadId = c.Int(nullable: false),
                        Amount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        DueAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        AdvanceAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ScholarshipAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        DiscountAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ReceiveAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        IsLateFine = c.Boolean(nullable: false),
                        MonthId = c.Int(nullable: false),
                        Narration = c.String(),
                        Year = c.Int(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Fees_Category",
                c => new
                    {
                        FeesCategoryId = c.Int(nullable: false, identity: true),
                        CategoryName = c.String(nullable: false),
                    })
                .PrimaryKey(t => t.FeesCategoryId);
            
            CreateTable(
                "dbo.Fees_FeesBooth",
                c => new
                    {
                        BoothId = c.Int(nullable: false, identity: true),
                        BoothBranchId = c.Int(nullable: false),
                        BoothName = c.String(nullable: false),
                        BoothCode = c.String(maxLength: 20),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.BoothId);
            
            CreateTable(
                "dbo.Fees_AutomatedFeesConfig",
                c => new
                    {
                        AutomatedConfigId = c.Int(nullable: false, identity: true),
                        FeesSessionYearId = c.Int(nullable: false),
                        FeesFiscalSessionId = c.Int(nullable: false),
                        LateDate = c.DateTime(nullable: false),
                        Amount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        IsConfigChecked = c.Boolean(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.AutomatedConfigId);
            
            CreateTable(
                "dbo.FeesAdjustHistories",
                c => new
                    {
                        FeesAdjustId = c.Long(nullable: false, identity: true),
                        ProcessId = c.Int(nullable: false),
                        SessionId = c.Int(nullable: false),
                        MonthId = c.Int(nullable: false),
                        StudentIID = c.Long(nullable: false),
                        HeadId = c.Int(nullable: false),
                        FeesSessionYearId = c.Int(nullable: false),
                        TotalAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ProcessedAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        DueAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        NoModifiedDueAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ScholarshipAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        DiscountAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        PaidAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        AdvanceAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        IsEnrollment = c.Boolean(nullable: false),
                        IsOldStudent = c.Boolean(nullable: false),
                        IsCashCollection = c.Boolean(nullable: false),
                        InvoiceAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        IsPaid = c.Boolean(nullable: false),
                        IsCompleted = c.Boolean(nullable: false),
                        IsAdjust = c.Boolean(nullable: false),
                        IsRefund = c.Boolean(nullable: false),
                        IsResolved = c.Boolean(nullable: false),
                        Narration = c.String(),
                        Stutype = c.String(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.FeesAdjustId);
            
            CreateTable(
                "dbo.Fees_Adjust",
                c => new
                    {
                        FeesAdjustId = c.Int(nullable: false, identity: true),
                        StudentIID = c.Long(nullable: false),
                        TotalDepositpaid = c.Decimal(nullable: false, precision: 18, scale: 2),
                        TotalAdjustAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        TotalDueDeposit = c.Decimal(nullable: false, precision: 18, scale: 2),
                        IsRefund = c.Boolean(),
                        IsResolved = c.Boolean(),
                    })
                .PrimaryKey(t => t.FeesAdjustId);
            
            CreateTable(
                "dbo.Fees_Accounts",
                c => new
                    {
                        FeesAccountsId = c.Int(nullable: false, identity: true),
                        ProcessId = c.Int(nullable: false),
                        FeesSessionYearId = c.Int(nullable: false),
                        HeadId = c.Int(nullable: false),
                        Amount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        AmountType = c.String(),
                        IsApplied = c.Boolean(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.FeesAccountsId);
            
            CreateTable(
                "dbo.Res_ExamProccessLog",
                c => new
                    {
                        LogId = c.Int(nullable: false, identity: true),
                        SessionId = c.Int(nullable: false),
                        ShiftID = c.Int(),
                        ClassId = c.Int(nullable: false),
                        MainExamId = c.Int(nullable: false),
                        SectionId = c.Int(nullable: false),
                        SubjectId = c.Int(),
                        PId = c.String(),
                        LogTime = c.DateTime(nullable: false),
                        Msg = c.String(),
                        AddBy = c.String(),
                    })
                .PrimaryKey(t => t.LogId);
            
            CreateTable(
                "dbo.Ins_CSInfo",
                c => new
                    {
                        CSId = c.Int(nullable: false, identity: true),
                        ReferenceId = c.Int(),
                        RefTypeId = c.Int(),
                        CSType = c.String(),
                        DonateItem = c.String(),
                        CSVisitDateTime = c.DateTime(),
                        VolunteerName = c.String(),
                        VolunteerDate = c.DateTime(),
                        Relation = c.String(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.CSId);
            
            CreateTable(
                "dbo.Res_ConvertedPositionSetup",
                c => new
                    {
                        ID = c.Int(nullable: false, identity: true),
                        SessionID = c.Int(nullable: false),
                        ClassID = c.Int(nullable: false),
                        IsConvertedOfSum = c.Boolean(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.ID);
            
            CreateTable(
                "dbo.Res_ClassSubjectConfig",
                c => new
                    {
                        ClassSubConfigId = c.Int(nullable: false, identity: true),
                        SessionId = c.Int(nullable: false),
                        ClassId = c.Int(nullable: false),
                        TotalSub = c.Int(nullable: false),
                        TotalCompolsary = c.Int(nullable: false),
                        TotalSelective = c.Int(nullable: false),
                        TotalForth = c.Int(nullable: false),
                        TotalThird = c.Int(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.ClassSubConfigId);
            
            CreateTable(
                "dbo.Res_ClassResultComments",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        MainExamId = c.Int(nullable: false),
                        StudentId = c.Int(nullable: false),
                        TeacherComments = c.String(),
                        HeadTeacherComments = c.String(),
                        FailSubComments = c.String(),
                        COComments = c.String(),
                        ReportGLComments = c.String(),
                        TermId = c.Int(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Rtn_ClassPeriod",
                c => new
                    {
                        PeriodId = c.Int(nullable: false, identity: true),
                        ShiftId = c.Int(nullable: false),
                        ClassId = c.Int(nullable: false),
                        PeriodName = c.String(),
                        IsAttendance = c.Boolean(nullable: false),
                        ShowOrder = c.Int(nullable: false),
                        PeriodShortCode = c.Int(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.PeriodId);
            
            CreateTable(
                "dbo.Ins_Section",
                c => new
                    {
                        SectionId = c.Int(nullable: false, identity: true),
                        ClassId = c.Int(nullable: false),
                        ShiftId = c.Int(nullable: false),
                        NoOfSeat = c.Int(nullable: false),
                        SectionName = c.String(nullable: false),
                        SectionCode = c.String(),
                        LockOut = c.DateTime(),
                        PickUpTime = c.DateTime(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.SectionId);
            
            CreateTable(
                "dbo.Res_SubExam",
                c => new
                    {
                        SubExamId = c.Int(nullable: false, identity: true),
                        MainExamId = c.Int(nullable: false),
                        SubExamName = c.String(nullable: false),
                        SubExamOrder = c.Int(),
                        ExamDate = c.DateTime(nullable: false),
                        IsConvertLayer = c.Boolean(nullable: false),
                        IsMidYear = c.Boolean(nullable: false),
                        IsFinal = c.Boolean(nullable: false),
                        SubjectId = c.Int(nullable: false),
                        SectionId = c.Int(nullable: false),
                        MockType = c.String(),
                        IsLock = c.Boolean(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.SubExamId);
            
            CreateTable(
                "dbo.Res_Terms",
                c => new
                    {
                        TermId = c.Int(nullable: false, identity: true),
                        SessionId = c.Int(nullable: false),
                        BranchId = c.Int(nullable: false),
                        ClassId = c.Int(nullable: false),
                        Name = c.String(),
                        startDate = c.DateTime(nullable: false),
                        endDate = c.DateTime(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.TermId);
            
            CreateTable(
                "dbo.Res_SubjectSetup",
                c => new
                    {
                        SubID = c.Int(nullable: false, identity: true),
                        SessionId = c.Int(nullable: false),
                        ClassId = c.Int(nullable: false),
                        SubjectName = c.String(nullable: false),
                        ShortName = c.String(),
                        SubjectCode = c.String(),
                        ReportSerialNo = c.Int(nullable: false),
                        SpecialSubject = c.Boolean(nullable: false),
                        SubjectType = c.String(),
                        IsCompulsory = c.Boolean(nullable: false),
                        IsECA = c.Boolean(nullable: false),
                        IsICT = c.Boolean(nullable: false),
                        IsPair = c.Boolean(nullable: false),
                        FirstPairSubID = c.Int(nullable: false),
                        SecondPairSubID = c.Int(nullable: false),
                        TermId = c.Int(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.SubID);
            
            CreateTable(
                "dbo.Res_SubExamMarkSetup",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        MainExamMarkSetupId = c.Int(nullable: false),
                        SubExamId = c.Int(nullable: false),
                        SubExamFullMarks = c.Decimal(nullable: false, precision: 18, scale: 2),
                        SubExamExamMarks = c.Decimal(nullable: false, precision: 18, scale: 2),
                        SubExamIsPassDepend = c.Boolean(nullable: false),
                        SubExamPassMark = c.Decimal(nullable: false, precision: 18, scale: 2),
                        SubExamPassMarkIsPercent = c.Boolean(nullable: false),
                        SubExamIsEnable = c.Boolean(nullable: false),
                        SubExamDefaultPercent = c.Decimal(nullable: false, precision: 18, scale: 2),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Res_MainExamMarkSetup",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        SessionId = c.Int(nullable: false),
                        TermId = c.Int(nullable: false),
                        ClassId = c.Int(nullable: false),
                        MainExamId = c.Int(nullable: false),
                        MainExamSubjectID = c.Int(nullable: false),
                        MainExamFullMarks = c.Decimal(nullable: false, precision: 18, scale: 2),
                        MainExamPassMark = c.Decimal(nullable: false, precision: 18, scale: 2),
                        MainExamPassMarkIsPercent = c.Boolean(nullable: false),
                        MainExamDefaultPercent = c.Decimal(nullable: false, precision: 18, scale: 2),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Ins_Session",
                c => new
                    {
                        SessionId = c.Int(nullable: false, identity: true),
                        SessionName = c.String(nullable: false),
                        SessionCode = c.String(),
                        Session_ForSchool = c.Boolean(nullable: false),
                        Session_ForCollege = c.Boolean(nullable: false),
                        Session_ForUniversity = c.Boolean(nullable: false),
                        Session_StartDate = c.DateTime(nullable: false),
                        Session_EndDate = c.DateTime(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.SessionId);
            
            CreateTable(
                "dbo.Res_MainExam",
                c => new
                    {
                        MainExamId = c.Int(nullable: false, identity: true),
                        MainExamName = c.String(nullable: false),
                        SessionId = c.Int(nullable: false),
                        ClassId = c.Int(nullable: false),
                        BranchID = c.Int(),
                        MainExamIsGrand = c.Boolean(nullable: false),
                        MainExamGrandShowOrder = c.Int(nullable: false),
                        IsEnableForMakrsEntry = c.Boolean(nullable: false),
                        TermId = c.Int(nullable: false),
                        IsLock = c.Boolean(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.MainExamId);
            
            CreateTable(
                "dbo.Ins_ClassInfo",
                c => new
                    {
                        ClassId = c.Int(nullable: false, identity: true),
                        ClassName = c.String(nullable: false),
                        CalssCode = c.String(),
                        Class_HasGroup = c.Boolean(nullable: false),
                        Class_ForCollege = c.Boolean(nullable: false),
                        DisplayOrder = c.Int(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.ClassId);
            
            CreateTable(
                "dbo.Ins_Shift",
                c => new
                    {
                        ShiftId = c.Int(nullable: false, identity: true),
                        BranchId = c.Int(nullable: false),
                        ShiftName = c.String(nullable: false),
                        ShiftCode = c.String(),
                        ShiftStartTime = c.DateTime(),
                        ShiftEndTime = c.DateTime(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                        StudentBasicInfo_StudentIID = c.Long(),
                    })
                .PrimaryKey(t => t.ShiftId);
            
            CreateTable(
                "dbo.Res_AssignSubjectsToTeacher",
                c => new
                    {
                        AssignSubID = c.Int(nullable: false, identity: true),
                        SessionID = c.Int(nullable: false),
                        BranchID = c.Int(nullable: false),
                        ShiftID = c.Int(nullable: false),
                        ClassID = c.Int(nullable: false),
                        GroupID = c.Int(nullable: false),
                        SectionID = c.Int(nullable: false),
                        TeacherID = c.Int(nullable: false),
                        SubjectID = c.Int(nullable: false),
                        MainExamID = c.Int(nullable: false),
                        SubExamID = c.Int(nullable: false),
                        DivideExamID = c.Int(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.AssignSubID);
            
            CreateTable(
                "dbo.Res_AssessmentSubject",
                c => new
                    {
                        AId = c.Int(nullable: false, identity: true),
                        SubjectName = c.String(nullable: false),
                        SessionId = c.Int(nullable: false),
                        ClassId = c.Int(nullable: false),
                        GroupId = c.Int(nullable: false),
                        Label = c.String(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.AId);
            
            CreateTable(
                "dbo.Res_AssessmentStudent",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        MainExamId = c.Int(nullable: false),
                        SubjectId = c.Int(nullable: false),
                        StudentId = c.Int(nullable: false),
                        AssessmentId = c.Int(nullable: false),
                        Comments = c.String(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Res_AssessmentSubSetup",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        Name = c.String(),
                        Code = c.String(),
                        SubjectId = c.Int(nullable: false),
                        TermId = c.Int(nullable: false),
                        MainExamId = c.Int(nullable: false),
                        Order = c.Int(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Res_AssessmentClassStudent",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        MainExamId = c.Int(nullable: false),
                        StudentId = c.Int(nullable: false),
                        AssesmentClassId = c.Int(nullable: false),
                        Grade = c.String(),
                        Academic = c.String(),
                        Behaviroul = c.String(),
                        Comments = c.String(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Res_AssessmentClassSetUp",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        Name = c.String(),
                        BranchID = c.Int(),
                        ClassId = c.Int(nullable: false),
                        TermId = c.Int(nullable: false),
                        MainExamId = c.Int(nullable: false),
                        Order = c.Int(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Res_AssesmentClassOptions",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        AssessmentClassSetUId = c.Int(nullable: false),
                        Name = c.String(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Ins_AdmitCardSetup",
                c => new
                    {
                        ID = c.Int(nullable: false, identity: true),
                        Title = c.String(nullable: false),
                        SessionID = c.Int(nullable: false),
                        BranchID = c.Int(nullable: false),
                        ShiftID = c.Int(nullable: false),
                        ClassID = c.Int(nullable: false),
                        SignatureID_1 = c.Boolean(nullable: false),
                        SignatureID_2 = c.Boolean(nullable: false),
                        SignatureID_3 = c.Boolean(nullable: false),
                        SignatureID_4 = c.Boolean(nullable: false),
                        TemplateId = c.Int(),
                        IssueDate = c.DateTime(),
                        WatermarkImage = c.Binary(),
                        RoutineImage = c.Binary(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.ID);
            
            CreateTable(
                "dbo.Activity_Log",
                c => new
                    {
                        LogId = c.Long(nullable: false, identity: true),
                        UserId = c.String(),
                        RefId = c.Int(nullable: false),
                        LogDate = c.DateTime(nullable: false),
                        Description = c.String(),
                        NamesSpace = c.String(),
                    })
                .PrimaryKey(t => t.LogId);
            
            CreateTable(
                "dbo.Ins_AcademicSemester",
                c => new
                    {
                        AcaSemesterId = c.Int(nullable: false, identity: true),
                        AcaSemesterName = c.String(nullable: false),
                        AcaSemesterCode = c.String(maxLength: 20),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.AcaSemesterId);
            
            CreateTable(
                "dbo.Ins_AcaProCategory",
                c => new
                    {
                        AcaProgramCategoryId = c.Int(nullable: false, identity: true),
                        AcaProCateName = c.String(nullable: false),
                        AcaProCateCode = c.String(maxLength: 20),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.AcaProgramCategoryId);
            
            CreateTable(
                "dbo.Ins_AcademicProgram",
                c => new
                    {
                        AcaProgramId = c.Int(nullable: false, identity: true),
                        AcaDeptId = c.Int(nullable: false),
                        AcaProCateId = c.Int(nullable: false),
                        AcaProName = c.String(nullable: false),
                        AcaProCode = c.String(maxLength: 20),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.AcaProgramId);
            
            CreateTable(
                "dbo.Ins_AcademicDepartment",
                c => new
                    {
                        AcademicDepartmentId = c.Int(nullable: false, identity: true),
                        AcaDeptName = c.String(nullable: false),
                        AcaDeptCode = c.String(maxLength: 20),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.AcademicDepartmentId);
            
            CreateTable(
                "dbo.Att_AcademicCalendar",
                c => new
                    {
                        CalendarId = c.Int(nullable: false, identity: true),
                        Year = c.Int(nullable: false),
                        Month = c.Int(nullable: false),
                        Day = c.Int(nullable: false),
                        CalendarDate = c.DateTime(nullable: false),
                        DayType = c.String(maxLength: 20),
                        HolidayName = c.String(maxLength: 300),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.CalendarId);
            
            CreateTable(
                "dbo.Ins_AcademicBatch",
                c => new
                    {
                        AcademicBatchId = c.Int(nullable: false, identity: true),
                        AcaBatchName = c.String(nullable: false),
                        AcaBatchCode = c.String(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.AcademicBatchId);
            
            DropColumn("dbo.Task_Issue", "EstimatedType");
            DropColumn("dbo.Task_Issue", "EstimatedTime");
            DropColumn("dbo.Emp_Department", "DisOrder");
            DropColumn("dbo.Ins_Branch", "DisOrder");
            CreateIndex("dbo.Student_SiblingInfo", "StudentIID");
            CreateIndex("dbo.Student_ContactInfo", "StudentIID");
            CreateIndex("dbo.Student_AcademicInfo", "StudentIID");
            CreateIndex("dbo.Student_OthersInfo", "StudentIID");
            CreateIndex("dbo.Res_MarksMigratedSetup", "ClassID");
            CreateIndex("dbo.Res_GradingSystem", "ClassID");
            CreateIndex("dbo.Fees_Student", "FeesStudent_FeesStudentId");
            CreateIndex("dbo.Fees_FeesSessionYear", "MonthId");
            CreateIndex("dbo.Fees_CollectionDetails", "MasterID");
            CreateIndex("dbo.Res_ConvertedPositionSetup", "ClassID");
            CreateIndex("dbo.Ins_Section", "ShiftId");
            CreateIndex("dbo.Ins_Section", "ClassId");
            CreateIndex("dbo.Res_SubExam", "MainExamId");
            CreateIndex("dbo.Res_SubExamMarkSetup", "MainExamMarkSetupId");
            CreateIndex("dbo.Res_MainExamMarkSetup", "MainExamSubjectID");
            CreateIndex("dbo.Res_MainExamMarkSetup", "TermId");
            CreateIndex("dbo.Res_MainExamMarkSetup", "SessionId");
            CreateIndex("dbo.Res_MainExam", "TermId");
            CreateIndex("dbo.Res_MainExam", "ClassId");
            CreateIndex("dbo.Res_MainExam", "SessionId");
            CreateIndex("dbo.Ins_Shift", "StudentBasicInfo_StudentIID");
            CreateIndex("dbo.Ins_Shift", "BranchId");
            CreateIndex("dbo.Ins_AcademicProgram", "AcaProCateId");
            CreateIndex("dbo.Ins_AcademicProgram", "AcaDeptId");
            AddForeignKey("dbo.Student_OthersInfo", "StudentIID", "dbo.Student_BasicInfo", "StudentIID", cascadeDelete: true);
            AddForeignKey("dbo.Student_SiblingInfo", "StudentIID", "dbo.Student_BasicInfo", "StudentIID", cascadeDelete: true);
            AddForeignKey("dbo.Student_ContactInfo", "StudentIID", "dbo.Student_BasicInfo", "StudentIID", cascadeDelete: true);
            AddForeignKey("dbo.Student_AcademicInfo", "StudentIID", "dbo.Student_BasicInfo", "StudentIID", cascadeDelete: true);
            AddForeignKey("dbo.Ins_Shift", "StudentBasicInfo_StudentIID", "dbo.Student_BasicInfo", "StudentIID");
            AddForeignKey("dbo.Res_MarksMigratedSetup", "ClassID", "dbo.Ins_ClassInfo", "ClassId", cascadeDelete: true);
            AddForeignKey("dbo.Res_GradingSystem", "ClassID", "dbo.Ins_ClassInfo", "ClassId", cascadeDelete: true);
            AddForeignKey("dbo.Fees_Student", "FeesStudent_FeesStudentId", "dbo.Fees_Student", "FeesStudentId");
            AddForeignKey("dbo.Fees_FeesSessionYear", "MonthId", "dbo.Fees_FeesMonth", "FeesMonthId", cascadeDelete: true);
            AddForeignKey("dbo.Fees_CollectionDetails", "MasterID", "dbo.Fees_CollectionMaster", "Id", cascadeDelete: true);
            AddForeignKey("dbo.Res_ConvertedPositionSetup", "ClassID", "dbo.Ins_ClassInfo", "ClassId", cascadeDelete: true);
            AddForeignKey("dbo.Ins_Section", "ShiftId", "dbo.Ins_Shift", "ShiftId", cascadeDelete: true);
            AddForeignKey("dbo.Ins_Section", "ClassId", "dbo.Ins_ClassInfo", "ClassId", cascadeDelete: true);
            AddForeignKey("dbo.Res_MainExam", "TermId", "dbo.Res_Terms", "TermId", cascadeDelete: true);
            AddForeignKey("dbo.Res_SubExam", "MainExamId", "dbo.Res_MainExam", "MainExamId", cascadeDelete: true);
            AddForeignKey("dbo.Res_MainExam", "SessionId", "dbo.Ins_Session", "SessionId", cascadeDelete: true);
            AddForeignKey("dbo.Res_MainExamMarkSetup", "TermId", "dbo.Res_Terms", "TermId", cascadeDelete: true);
            AddForeignKey("dbo.Res_MainExamMarkSetup", "MainExamSubjectID", "dbo.Res_SubjectSetup", "SubID", cascadeDelete: true);
            AddForeignKey("dbo.Res_SubExamMarkSetup", "MainExamMarkSetupId", "dbo.Res_MainExamMarkSetup", "Id", cascadeDelete: true);
            AddForeignKey("dbo.Res_MainExamMarkSetup", "SessionId", "dbo.Ins_Session", "SessionId", cascadeDelete: true);
            AddForeignKey("dbo.Res_MainExam", "ClassId", "dbo.Ins_ClassInfo", "ClassId", cascadeDelete: true);
            AddForeignKey("dbo.Ins_Shift", "BranchId", "dbo.Ins_Branch", "BranchId", cascadeDelete: true);
            AddForeignKey("dbo.Ins_AcademicProgram", "AcaProCateId", "dbo.Ins_AcaProCategory", "AcaProgramCategoryId", cascadeDelete: true);
            AddForeignKey("dbo.Ins_AcademicProgram", "AcaDeptId", "dbo.Ins_AcademicDepartment", "AcademicDepartmentId", cascadeDelete: true);
        }
    }
}
