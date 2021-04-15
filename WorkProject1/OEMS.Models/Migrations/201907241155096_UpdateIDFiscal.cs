namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class UpdateIDFiscal : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Fees_FeesSessionYear", "FeesFiscalSessionId", c => c.Int(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Fees_FeesSessionYear", "FeesFiscalSessionId");
        }
    }
}
