namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddcolumnDiscountLinkhead0202202101 : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Invoice_CollectionDetails", "DiscountAmount", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Invoice_CollectionMaster", "DiscountAmount", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Invoice_InvoiceGenerate", "DiscountlinkBillingHeadId", c => c.Int());
            AddColumn("dbo.Invoice_InvoiceGenerate", "DiscountAmount", c => c.Decimal(precision: 18, scale: 2));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Invoice_InvoiceGenerate", "DiscountAmount");
            DropColumn("dbo.Invoice_InvoiceGenerate", "DiscountlinkBillingHeadId");
            DropColumn("dbo.Invoice_CollectionMaster", "DiscountAmount");
            DropColumn("dbo.Invoice_CollectionDetails", "DiscountAmount");
        }
    }
}
