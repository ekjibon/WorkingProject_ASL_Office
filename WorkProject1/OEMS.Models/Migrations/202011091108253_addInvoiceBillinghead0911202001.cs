namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addInvoiceBillinghead0911202001 : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Invoice_BillingHeadConfig",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        ClientId = c.Int(),
                        InvoiceServiceId = c.Int(),
                        BillingHeadId = c.Int(),
                        BillingHeadType = c.String(),
                        BillingMethodId = c.Int(),
                        Rate = c.Decimal(precision: 18, scale: 2),
                        MinAmount = c.Decimal(precision: 18, scale: 2),
                        MaxAmount = c.Decimal(precision: 18, scale: 2),
                        MaskAmount = c.Decimal(precision: 18, scale: 2),
                        NoMaskAmount = c.Decimal(precision: 18, scale: 2),
                        Year = c.Int(),
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
                "dbo.Invoice_BillingHeadConfigDetails",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        BillingHeadConfigId = c.Int(),
                        Year = c.Int(),
                        MonthId = c.Int(),
                        MonthName = c.String(),
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
                "dbo.Invoice_BillingHead",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        BillingHeadName = c.String(),
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
                "dbo.Invoice_BillingMethod",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        BillingMethodName = c.String(),
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
                "dbo.Invoice_Service",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        ServiceName = c.String(),
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
            
        }
        
        public override void Down()
        {
            DropTable("dbo.Invoice_Service");
            DropTable("dbo.Invoice_BillingMethod");
            DropTable("dbo.Invoice_BillingHead");
            DropTable("dbo.Invoice_BillingHeadConfigDetails");
            DropTable("dbo.Invoice_BillingHeadConfig");
        }
    }
}
