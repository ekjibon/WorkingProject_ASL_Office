namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addInvoiceCollection1911202001 : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Invoice_CollectionDetails",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        MasterID = c.Int(nullable: false),
                        Year = c.Int(),
                        MonthId = c.Int(),
                        BillingHeadId = c.Int(),
                        Quantity = c.Int(),
                        Rate = c.Decimal(precision: 18, scale: 2),
                        TotalAmount = c.Decimal(precision: 18, scale: 2),
                        DueAmount = c.Decimal(precision: 18, scale: 2),
                        CollectionAmount = c.Decimal(precision: 18, scale: 2),
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
                "dbo.Invoice_CollectionMaster",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        InvoiceNo = c.String(),
                        InvoiceAmount = c.Decimal(precision: 18, scale: 2),
                        ClientId = c.Int(),
                        Year = c.Int(),
                        MonthId = c.Int(),
                        CollectionDate = c.DateTime(),
                        CollectionAmount = c.Decimal(precision: 18, scale: 2),
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
                "dbo.Task_IssueAttachment",
                c => new
                    {
                        AttachmentId = c.Int(nullable: false, identity: true),
                        IssueId = c.Int(nullable: false),
                        FileName = c.String(),
                        FileType = c.String(),
                        ImageUrl = c.String(),
                    })
                .PrimaryKey(t => t.AttachmentId);
            
            AddColumn("dbo.Invoice_InvoiceGenerate", "DueAmount", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Invoice_InvoiceGenerate", "CollectionAmount", c => c.Decimal(precision: 18, scale: 2));
            AlterColumn("dbo.Invoice_InvoiceGenerate", "InvoiceAmount", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AlterColumn("dbo.Invoice_InvoiceGenerate", "ClientId", c => c.Int(nullable: false));
            AlterColumn("dbo.Invoice_InvoiceGenerate", "Year", c => c.Int(nullable: false));
            AlterColumn("dbo.Invoice_InvoiceGenerate", "MonthId", c => c.Int(nullable: false));
            AlterColumn("dbo.Invoice_InvoiceGenerate", "BillingHeadId", c => c.Int(nullable: false));
            AlterColumn("dbo.Invoice_InvoiceGenerate", "Quantity", c => c.Int(nullable: false));
            AlterColumn("dbo.Invoice_InvoiceGenerate", "Rate", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AlterColumn("dbo.Invoice_InvoiceGenerate", "TotalAmount", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AlterColumn("dbo.Invoice_InvoiceGenerate", "IssueDate", c => c.DateTime(nullable: false));
            AlterColumn("dbo.Invoice_InvoiceGenerate", "DueDate", c => c.DateTime(nullable: false));
            AlterColumn("dbo.Invoice_InvoiceGenerate", "BillingPeriodStart", c => c.DateTime(nullable: false));
            AlterColumn("dbo.Invoice_InvoiceGenerate", "BillingPeriodEnd", c => c.DateTime(nullable: false));
            AlterColumn("dbo.Invoice_InvoiceGenerate", "IsPaid", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            AlterColumn("dbo.Invoice_InvoiceGenerate", "IsPaid", c => c.Boolean());
            AlterColumn("dbo.Invoice_InvoiceGenerate", "BillingPeriodEnd", c => c.DateTime());
            AlterColumn("dbo.Invoice_InvoiceGenerate", "BillingPeriodStart", c => c.DateTime());
            AlterColumn("dbo.Invoice_InvoiceGenerate", "DueDate", c => c.DateTime());
            AlterColumn("dbo.Invoice_InvoiceGenerate", "IssueDate", c => c.DateTime());
            AlterColumn("dbo.Invoice_InvoiceGenerate", "TotalAmount", c => c.Decimal(precision: 18, scale: 2));
            AlterColumn("dbo.Invoice_InvoiceGenerate", "Rate", c => c.Decimal(precision: 18, scale: 2));
            AlterColumn("dbo.Invoice_InvoiceGenerate", "Quantity", c => c.Int());
            AlterColumn("dbo.Invoice_InvoiceGenerate", "BillingHeadId", c => c.Int());
            AlterColumn("dbo.Invoice_InvoiceGenerate", "MonthId", c => c.Int());
            AlterColumn("dbo.Invoice_InvoiceGenerate", "Year", c => c.Int());
            AlterColumn("dbo.Invoice_InvoiceGenerate", "ClientId", c => c.Int());
            AlterColumn("dbo.Invoice_InvoiceGenerate", "InvoiceAmount", c => c.Decimal(precision: 18, scale: 2));
            DropColumn("dbo.Invoice_InvoiceGenerate", "CollectionAmount");
            DropColumn("dbo.Invoice_InvoiceGenerate", "DueAmount");
            DropTable("dbo.Task_IssueAttachment");
            DropTable("dbo.Invoice_CollectionMaster");
            DropTable("dbo.Invoice_CollectionDetails");
        }
    }
}
