namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addcolumnprintmodify06032021122 : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Invoice_InvoicePrintDetails", "BillingHeadName", c => c.String());
            AddColumn("dbo.Invoice_InvoicePrintDetails", "DiscountHeadName", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Invoice_InvoicePrintDetails", "DiscountHeadName");
            DropColumn("dbo.Invoice_InvoicePrintDetails", "BillingHeadName");
        }
    }
}
