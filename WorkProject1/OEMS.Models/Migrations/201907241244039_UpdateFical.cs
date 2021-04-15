namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class UpdateFical : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Fees_FiscalSession", "FiscalSessionName", c => c.String());
            AddColumn("dbo.Fees_FiscalSession", "FiscalSessionCode", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Fees_FiscalSession", "FiscalSessionCode");
            DropColumn("dbo.Fees_FiscalSession", "FiscalSessionName");
        }
    }
}
