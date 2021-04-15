namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class modifycolumnprintmasterpaymnetStatus0803202111 : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Invoice_InvoicePrintMaster", "PaymentStatus", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Invoice_InvoicePrintMaster", "PaymentStatus");
        }
    }
}
