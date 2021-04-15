namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ClasseResultComments : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Res_ClassResultComments",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        MainExamId = c.Int(nullable: false),
                        StudentId = c.Int(nullable: false),
                        TeacherComments = c.String(),
                        HeadTeacherComments = c.String(),
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
            
            AddColumn("dbo.Res_AssessmentClassStudent", "Comments", c => c.String());
            DropColumn("dbo.Res_AssessmentClassStudent", "TeacherComments");
            DropColumn("dbo.Res_AssessmentClassStudent", "HeadTeacherComments");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Res_AssessmentClassStudent", "HeadTeacherComments", c => c.String());
            AddColumn("dbo.Res_AssessmentClassStudent", "TeacherComments", c => c.String());
            DropColumn("dbo.Res_AssessmentClassStudent", "Comments");
            DropTable("dbo.Res_ClassResultComments");
        }
    }
}
