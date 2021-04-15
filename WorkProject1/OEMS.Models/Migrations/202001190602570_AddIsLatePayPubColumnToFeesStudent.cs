namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddIsLatePayPubColumnToFeesStudent : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Fees_Student", "IsLatePayPublished", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Fees_Student", "IsLatePayPublished");
        }
    }
}
