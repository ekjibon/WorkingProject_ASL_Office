namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class change : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("dbo.Res_VirtualExamSetup", "ClassId", "dbo.Ins_ClassInfo");
            DropForeignKey("dbo.Res_VirtualExamSetup", "SessionId", "dbo.Ins_Session");
            DropIndex("dbo.Res_VirtualExamSetup", new[] { "SessionId" });
            DropIndex("dbo.Res_VirtualExamSetup", new[] { "ClassId" });
            DropPrimaryKey("dbo.Res_MainExamMarks");
            AddColumn("dbo.AspNetPages", "IsModule", c => c.Boolean(nullable: false));
            AddColumn("dbo.AspNetPages", "ModuleId", c => c.Int(nullable: false));
            AddColumn("dbo.Res_MainExamMarkSetup", "TermId", c => c.Int(nullable: false));
            AlterColumn("dbo.Res_AssessmentClassSetUp", "Name", c => c.String());
            AddPrimaryKey("dbo.Res_MainExamMarks", new[] { "MarksId", "StudentIID", "SubjectID" });
            CreateIndex("dbo.Res_MainExamMarkSetup", "TermId");
            AddForeignKey("dbo.Res_MainExamMarkSetup", "TermId", "dbo.Res_Terms", "TermId", cascadeDelete: true);
            DropColumn("dbo.Res_MainExamMarks", "DividedExamID");
            DropColumn("dbo.Res_MainExamMarks", "DividedExamType");
          
            DropTable("dbo.Res_VirtualExamSetup");
        }
        
        public override void Down()
        {
            CreateTable(
                "dbo.Res_VirtualExamSetup",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        SessionId = c.Int(nullable: false),
                        ClassId = c.Int(nullable: false),
                        MainExamID = c.Int(nullable: false),
                        SubjectID = c.Int(nullable: false),
                        SubExamID = c.Int(nullable: false),
                        DivExamTypeVirtual1 = c.String(),
                        VirtualPassMark1 = c.Decimal(nullable: false, precision: 18, scale: 2),
                        VirtualPassMarkIsPercent1 = c.Boolean(nullable: false),
                        DivExamTypeVirtual2 = c.String(),
                        VirtualPassMarkIsPercent2 = c.Boolean(nullable: false),
                        VirtualPassMark2 = c.Decimal(nullable: false, precision: 18, scale: 2),
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
            
           
            AddColumn("dbo.Res_MainExamMarks", "DividedExamType", c => c.String());
            AddColumn("dbo.Res_MainExamMarks", "DividedExamID", c => c.Int(nullable: false));
            DropForeignKey("dbo.Res_MainExamMarkSetup", "TermId", "dbo.Res_Terms");
            DropIndex("dbo.Res_MainExamMarkSetup", new[] { "TermId" });
            DropPrimaryKey("dbo.Res_MainExamMarks");
            AlterColumn("dbo.Res_AssessmentClassSetUp", "Name", c => c.Int(nullable: false));
            DropColumn("dbo.Res_MainExamMarkSetup", "TermId");
            DropColumn("dbo.AspNetPages", "ModuleId");
            DropColumn("dbo.AspNetPages", "IsModule");
            AddPrimaryKey("dbo.Res_MainExamMarks", new[] { "MarksId", "StudentIID", "DividedExamID", "SubjectID" });
            CreateIndex("dbo.Res_VirtualExamSetup", "ClassId");
            CreateIndex("dbo.Res_VirtualExamSetup", "SessionId");
            AddForeignKey("dbo.Res_VirtualExamSetup", "SessionId", "dbo.Ins_Session", "SessionId", cascadeDelete: true);
            AddForeignKey("dbo.Res_VirtualExamSetup", "ClassId", "dbo.Ins_ClassInfo", "ClassId", cascadeDelete: true);
        }
    }
}
