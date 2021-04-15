namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addinvoicebillGeneretae151120202222 : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Invoice_BillingProcess",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        ClientId = c.Int(),
                        Year = c.Int(),
                        MonthId = c.Int(),
                        BillingHeadId = c.Int(),
                        Quantity = c.Int(),
                        Rate = c.Decimal(precision: 18, scale: 2),
                        TotalAmount = c.Decimal(precision: 18, scale: 2),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Invoice_InvoiceGenerate",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        InvoiceNo = c.String(),
                        InvoiceAmount = c.Decimal(precision: 18, scale: 2),
                        ClientId = c.Int(),
                        Year = c.Int(),
                        MonthId = c.Int(),
                        BillingHeadId = c.Int(),
                        Quantity = c.Int(),
                        Rate = c.Decimal(precision: 18, scale: 2),
                        TotalAmount = c.Decimal(precision: 18, scale: 2),
                        IssueDate = c.DateTime(),
                        DueDate = c.DateTime(),
                        BillingPeriodStart = c.DateTime(),
                        BillingPeriodEnd = c.DateTime(),
                        InvoiceStatus = c.String(),
                        IsPaid = c.Boolean(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.Id);
            
            AlterColumn("dbo.Invoice_BillingHeadConfig", "ClientId", c => c.Int(nullable: false));
            AlterColumn("dbo.Invoice_BillingHeadConfig", "InvoiceServiceId", c => c.Int(nullable: false));
            AlterColumn("dbo.Invoice_BillingHeadConfig", "BillingHeadId", c => c.Int(nullable: false));
            AlterColumn("dbo.Invoice_BillingHeadConfig", "BillingMethodId", c => c.Int(nullable: false));
            AlterColumn("dbo.Invoice_BillingHeadConfig", "Rate", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AlterColumn("dbo.Invoice_BillingHeadConfig", "MinAmount", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AlterColumn("dbo.Invoice_BillingHeadConfig", "MaxAmount", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AlterColumn("dbo.Invoice_BillingHeadConfig", "MaskAmount", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AlterColumn("dbo.Invoice_BillingHeadConfig", "NoMaskAmount", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AlterColumn("dbo.Invoice_BillingHeadConfig", "Year", c => c.Int(nullable: false));
            AlterColumn("dbo.Invoice_BillingHeadConfig", "Quantity", c => c.Int(nullable: false));
            AlterColumn("dbo.Invoice_BillingHeadConfig", "TotalAmount", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AlterColumn("dbo.Invoice_BillingHeadConfig", "ProcessAmount", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AlterColumn("dbo.Invoice_BillingHeadConfig", "TotalStudent", c => c.Int(nullable: false));
            AlterColumn("dbo.Invoice_BillingHeadConfig", "TotalSMS", c => c.Int(nullable: false));
            AlterColumn("dbo.Invoice_BillingHeadConfig", "TotalEmail", c => c.Int(nullable: false));
        }
        
        public override void Down()
        {
            AlterColumn("dbo.Invoice_BillingHeadConfig", "TotalEmail", c => c.Int());
            AlterColumn("dbo.Invoice_BillingHeadConfig", "TotalSMS", c => c.Int());
            AlterColumn("dbo.Invoice_BillingHeadConfig", "TotalStudent", c => c.Int());
            AlterColumn("dbo.Invoice_BillingHeadConfig", "ProcessAmount", c => c.Decimal(precision: 18, scale: 2));
            AlterColumn("dbo.Invoice_BillingHeadConfig", "TotalAmount", c => c.Decimal(precision: 18, scale: 2));
            AlterColumn("dbo.Invoice_BillingHeadConfig", "Quantity", c => c.Int());
            AlterColumn("dbo.Invoice_BillingHeadConfig", "Year", c => c.Int());
            AlterColumn("dbo.Invoice_BillingHeadConfig", "NoMaskAmount", c => c.Decimal(precision: 18, scale: 2));
            AlterColumn("dbo.Invoice_BillingHeadConfig", "MaskAmount", c => c.Decimal(precision: 18, scale: 2));
            AlterColumn("dbo.Invoice_BillingHeadConfig", "MaxAmount", c => c.Decimal(precision: 18, scale: 2));
            AlterColumn("dbo.Invoice_BillingHeadConfig", "MinAmount", c => c.Decimal(precision: 18, scale: 2));
            AlterColumn("dbo.Invoice_BillingHeadConfig", "Rate", c => c.Decimal(precision: 18, scale: 2));
            AlterColumn("dbo.Invoice_BillingHeadConfig", "BillingMethodId", c => c.Int());
            AlterColumn("dbo.Invoice_BillingHeadConfig", "BillingHeadId", c => c.Int());
            AlterColumn("dbo.Invoice_BillingHeadConfig", "InvoiceServiceId", c => c.Int());
            AlterColumn("dbo.Invoice_BillingHeadConfig", "ClientId", c => c.Int());
            DropTable("dbo.Invoice_InvoiceGenerate");
            DropTable("dbo.Invoice_BillingProcess");
        }
    }
}
