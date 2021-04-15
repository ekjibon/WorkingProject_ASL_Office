namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class SectionIdFieldaddProcesslog : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Res_ExamProccessLog", "SectionId", c => c.Int(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Res_ExamProccessLog", "SectionId");
        }
    }
}
