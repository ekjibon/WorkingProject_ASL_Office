namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Assesment : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("dbo.Ins_ClassInfo", "Version_VersionId", "dbo.Ins_Version");
            DropForeignKey("dbo.Res_MainExamMarkSetup", "VersionInfo_VersionId", "dbo.Ins_Version");
            DropIndex("dbo.Ins_ClassInfo", new[] { "Version_VersionId" });
            DropIndex("dbo.Res_MainExamMarkSetup", new[] { "VersionInfo_VersionId" });
            CreateTable(
                "dbo.Res_AssesmentClassSetUp",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        Name = c.Int(nullable: false),
                        ClassId = c.Int(nullable: false),
                        TermId = c.Int(nullable: false),
                        MainExamId = c.Int(nullable: false),
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
                "dbo.Res_AssesmentClassStudent",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        MainExamId = c.Int(nullable: false),
                        StudentId = c.Int(nullable: false),
                        AssesmentClassId = c.Int(nullable: false),
                        TeacherComments = c.String(),
                        Grade = c.String(),
                        HeadTeacherComments = c.String(),
                        Academic = c.String(),
                        Behaviroul = c.String(),
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
                "dbo.Res_AssesmentSubSetup",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        Name = c.Int(nullable: false),
                        SubjectId = c.Int(nullable: false),
                        TermId = c.Int(nullable: false),
                        MainExamId = c.Int(nullable: false),
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
            
            AddColumn("dbo.Ins_ECAClubConfig", "CategoryName", c => c.String());
            CreateIndex("dbo.Res_MainExam", "TermId");
            AddForeignKey("dbo.Res_MainExam", "TermId", "dbo.Res_Terms", "TermId", cascadeDelete: true);
            DropColumn("dbo.AspNetPages", "IsModule");
            DropColumn("dbo.AspNetPages", "ModuleId");
            DropColumn("dbo.Ins_ClassInfo", "Version_VersionId");
            DropColumn("dbo.Res_MainExamMarkSetup", "VersionInfo_VersionId");
            DropColumn("dbo.Ins_ECAClubConfig", "IsRepeatYear");
            DropColumn("dbo.Stu_Clubs", "CategoryName");
            DropColumn("dbo.Stu_Clubs", "DayId");
            DropTable("dbo.Ins_Version");
        }
        
        public override void Down()
        {
            CreateTable(
                "dbo.Ins_Version",
                c => new
                    {
                        VersionId = c.Int(nullable: false, identity: true),
                        VersionName = c.String(nullable: false),
                        VersionCode = c.String(),
                        IsActive = c.Boolean(nullable: false),
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
                .PrimaryKey(t => t.VersionId);
            
            AddColumn("dbo.Stu_Clubs", "DayId", c => c.Int(nullable: false));
            AddColumn("dbo.Stu_Clubs", "CategoryName", c => c.String());
            AddColumn("dbo.Ins_ECAClubConfig", "IsRepeatYear", c => c.Boolean(nullable: false));
            AddColumn("dbo.Res_MainExamMarkSetup", "VersionInfo_VersionId", c => c.Int());
            AddColumn("dbo.Ins_ClassInfo", "Version_VersionId", c => c.Int());
            AddColumn("dbo.AspNetPages", "ModuleId", c => c.Int(nullable: false));
            AddColumn("dbo.AspNetPages", "IsModule", c => c.Boolean(nullable: false));
            DropForeignKey("dbo.Res_MainExam", "TermId", "dbo.Res_Terms");
            DropIndex("dbo.Res_MainExam", new[] { "TermId" });
            DropColumn("dbo.Ins_ECAClubConfig", "CategoryName");
            DropTable("dbo.Res_AssessmentStudent");
            DropTable("dbo.Res_AssesmentSubSetup");
            DropTable("dbo.Res_AssesmentClassStudent");
            DropTable("dbo.Res_AssesmentClassSetUp");
            CreateIndex("dbo.Res_MainExamMarkSetup", "VersionInfo_VersionId");
            CreateIndex("dbo.Ins_ClassInfo", "Version_VersionId");
            AddForeignKey("dbo.Res_MainExamMarkSetup", "VersionInfo_VersionId", "dbo.Ins_Version", "VersionId");
            AddForeignKey("dbo.Ins_ClassInfo", "Version_VersionId", "dbo.Ins_Version", "VersionId");
        }
    }
}
