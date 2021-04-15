namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class LogProcess : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Res_ExamProccessLog", "SubjectId", c => c.Int());
            AlterColumn("dbo.Res_ExamProccessLog", "ShiftID", c => c.Int());
            DropColumn("dbo.Res_ExamProccessLog", "Type");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Res_ExamProccessLog", "Type", c => c.Int(nullable: false));
            AlterColumn("dbo.Res_ExamProccessLog", "ShiftID", c => c.Int(nullable: false));
            DropColumn("dbo.Res_ExamProccessLog", "SubjectId");
        }
    }
}
