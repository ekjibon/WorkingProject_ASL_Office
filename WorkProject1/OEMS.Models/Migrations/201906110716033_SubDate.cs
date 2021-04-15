namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class SubDate : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Res_SubExam", "ExamDate", c => c.DateTime(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Res_SubExam", "ExamDate");
        }
    }
}
