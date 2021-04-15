namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addPrinttable0603202111 : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Invoice_InvoicePrintDetails",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        MasterId = c.Int(nullable: false),
                        ClientId = c.Int(nullable: false),
                        Year = c.Int(nullable: false),
                        MonthId = c.Int(nullable: false),
                        BillingHeadId = c.Int(nullable: false),
                        Quantity = c.Decimal(precision: 18, scale: 2),
                        Rate = c.Decimal(precision: 18, scale: 2),
                        SubTotalAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        DiscountAmount = c.Decimal(precision: 18, scale: 2),
                        NetTotalAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        DueStatus = c.String(),
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
                "dbo.Invoice_InvoicePrintMaster",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        InvoiceNo = c.String(),
                        InvoiceAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ClientId = c.Int(nullable: false),
                        BillingMonth = c.String(),
                        InvoiceDate = c.DateTime(nullable: false),
                        DueDate = c.DateTime(nullable: false),
                        BillingPeriodStart = c.DateTime(nullable: false),
                        BillingPeriodEnd = c.DateTime(nullable: false),
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
            
            AddColumn("dbo.Invoice_InvoiceGenerate", "DiscountPercentage", c => c.Decimal(precision: 18, scale: 2));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Invoice_InvoiceGenerate", "DiscountPercentage");
            DropTable("dbo.Invoice_InvoicePrintMaster");
            DropTable("dbo.Invoice_InvoicePrintDetails");
        }
    }
}
