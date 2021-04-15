namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class modifyInvoiceQuantity24122020111 : DbMigration
    {
        public override void Up()
        {
            AlterColumn("dbo.Invoice_BillingProcess", "Quantity", c => c.Decimal(precision: 18, scale: 2));
            AlterColumn("dbo.Invoice_CollectionDetails", "Quantity", c => c.Decimal(precision: 18, scale: 2));
            AlterColumn("dbo.Invoice_InvoiceGenerate", "Quantity", c => c.Decimal(precision: 18, scale: 2));
        }
        
        public override void Down()
        {
            AlterColumn("dbo.Invoice_InvoiceGenerate", "Quantity", c => c.Int(nullable: false));
            AlterColumn("dbo.Invoice_CollectionDetails", "Quantity", c => c.Int());
            AlterColumn("dbo.Invoice_BillingProcess", "Quantity", c => c.Int());
        }
    }
}
