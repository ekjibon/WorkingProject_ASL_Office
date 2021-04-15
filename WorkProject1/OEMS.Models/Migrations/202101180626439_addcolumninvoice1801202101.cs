namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addcolumninvoice1801202101 : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Invoice_BillingHead", "IsDiscount", c => c.Boolean());
            AddColumn("dbo.Invoice_InvoiceGenerate", "Description", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Invoice_InvoiceGenerate", "Description");
            DropColumn("dbo.Invoice_BillingHead", "IsDiscount");
        }
    }
}
