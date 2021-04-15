namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Addcolumnextraamount0702202111 : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Invoice_InvoiceGenerate", "ExtraCollectionAmount", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.ACC_Transaction", "InvoiceTransType", c => c.Int());
        }
        
        public override void Down()
        {
            DropColumn("dbo.ACC_Transaction", "InvoiceTransType");
            DropColumn("dbo.Invoice_InvoiceGenerate", "ExtraCollectionAmount");
        }
    }
}
