namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AssesmentSpelling : DbMigration
    {
        public override void Up()
        {
            RenameTable(name: "dbo.Res_AssesmentClassSetUp", newName: "Res_AssessmentClassSetUp");
            RenameTable(name: "dbo.Res_AssesmentClassStudent", newName: "Res_AssessmentClassStudent");
            CreateTable(
                "dbo.Res_AssessmentSubSetup",
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
            
            DropTable("dbo.Res_AssesmentSubSetup");
        }
        
        public override void Down()
        {
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
            
            DropTable("dbo.Res_AssessmentSubSetup");
            RenameTable(name: "dbo.Res_AssessmentClassStudent", newName: "Res_AssesmentClassStudent");
            RenameTable(name: "dbo.Res_AssessmentClassSetUp", newName: "Res_AssesmentClassSetUp");
        }
    }
}
