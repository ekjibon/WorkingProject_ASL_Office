namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class FeesHead : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Fees_Head", "AccCode", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Fees_Head", "AccCode");
        }
    }
}
