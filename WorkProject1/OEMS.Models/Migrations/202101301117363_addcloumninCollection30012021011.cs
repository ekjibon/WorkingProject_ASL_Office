namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addcloumninCollection30012021011 : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Invoice_CollectionDetails", "AdjustmentAmount", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Invoice_CollectionDetails", "CollectionNarration", c => c.String());
            AddColumn("dbo.Invoice_CollectionMaster", "AdjustmentAmount", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Invoice_InvoiceGenerate", "AdjustmentAmount", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Invoice_InvoiceGenerate", "CollectionNarration", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Invoice_InvoiceGenerate", "CollectionNarration");
            DropColumn("dbo.Invoice_InvoiceGenerate", "AdjustmentAmount");
            DropColumn("dbo.Invoice_CollectionMaster", "AdjustmentAmount");
            DropColumn("dbo.Invoice_CollectionDetails", "CollectionNarration");
            DropColumn("dbo.Invoice_CollectionDetails", "AdjustmentAmount");
        }
    }
}
