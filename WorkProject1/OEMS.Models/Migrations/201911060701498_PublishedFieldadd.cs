namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class PublishedFieldadd : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Res_MainExamResult", "IsPublished", c => c.Boolean(nullable: false));
            AlterColumn("dbo.Fees_HeadAmountConfig", "DueMonth", c => c.DateTime(nullable: false));
        }
        
        public override void Down()
        {
            AlterColumn("dbo.Fees_HeadAmountConfig", "DueMonth", c => c.Int(nullable: false));
            DropColumn("dbo.Res_MainExamResult", "IsPublished");
        }
    }
}
