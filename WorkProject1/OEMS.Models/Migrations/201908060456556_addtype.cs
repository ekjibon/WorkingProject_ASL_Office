namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addtype : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Res_AssessmentSubSetup", "Code", c => c.String());
            AddColumn("dbo.Res_ExamProccessLog", "Type", c => c.Int(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Res_ExamProccessLog", "Type");
            DropColumn("dbo.Res_AssessmentSubSetup", "Code");
        }
    }
}
