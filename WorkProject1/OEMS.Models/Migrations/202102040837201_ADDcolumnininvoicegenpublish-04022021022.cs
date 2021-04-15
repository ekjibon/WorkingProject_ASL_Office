namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ADDcolumnininvoicegenpublish04022021022 : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Invoice_InvoiceGenerate", "IsPublish", c => c.Boolean());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Invoice_InvoiceGenerate", "IsPublish");
        }
    }
}
