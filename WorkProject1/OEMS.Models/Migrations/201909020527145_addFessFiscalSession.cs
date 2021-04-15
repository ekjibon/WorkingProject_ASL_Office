namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addFessFiscalSession : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Fees_FeesSessionYear", "FeesFiscalSessionId", c => c.Int(nullable: false));
            DropColumn("dbo.Fees_FeesSessionYear", "SessionId");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Fees_FeesSessionYear", "SessionId", c => c.Int(nullable: false));
            DropColumn("dbo.Fees_FeesSessionYear", "FeesFiscalSessionId");
        }
    }
}
