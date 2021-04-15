namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addledgeridinClinets0302021011 : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.CRM_Client", "LedgerId", c => c.Int());
            AddColumn("dbo.Invoice_BillingHead", "LedgerId", c => c.Int());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Invoice_BillingHead", "LedgerId");
            DropColumn("dbo.CRM_Client", "LedgerId");
        }
    }
}
