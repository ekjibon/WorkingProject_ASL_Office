namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class sectionIdfieldadd : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Res_SubExam", "SectionId", c => c.Int(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Res_SubExam", "SectionId");
        }
    }
}
