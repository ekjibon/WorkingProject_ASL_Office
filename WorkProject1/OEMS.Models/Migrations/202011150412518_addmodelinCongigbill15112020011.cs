namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addmodelinCongigbill15112020011 : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Invoice_BillingHeadConfig", "Quantity", c => c.Int());
            AddColumn("dbo.Invoice_BillingHeadConfig", "TotalAmount", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Invoice_BillingHeadConfig", "ProcessAmount", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Invoice_BillingHeadConfig", "TotalStudent", c => c.Int());
            AddColumn("dbo.Invoice_BillingHeadConfig", "TotalSMS", c => c.Int());
            AddColumn("dbo.Invoice_BillingHeadConfig", "TotalEmail", c => c.Int());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Invoice_BillingHeadConfig", "TotalEmail");
            DropColumn("dbo.Invoice_BillingHeadConfig", "TotalSMS");
            DropColumn("dbo.Invoice_BillingHeadConfig", "TotalStudent");
            DropColumn("dbo.Invoice_BillingHeadConfig", "ProcessAmount");
            DropColumn("dbo.Invoice_BillingHeadConfig", "TotalAmount");
            DropColumn("dbo.Invoice_BillingHeadConfig", "Quantity");
        }
    }
}
