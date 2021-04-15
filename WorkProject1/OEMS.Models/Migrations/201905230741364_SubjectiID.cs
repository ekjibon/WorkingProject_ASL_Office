namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class SubjectiID : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Res_SubExam", "SubjectId", c => c.Int(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Res_SubExam", "SubjectId");
        }
    }
}
