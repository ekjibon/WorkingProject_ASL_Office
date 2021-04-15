namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class FixedAssetInventoryTblAdd : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.FA_Asset",
                c => new
                    {
                        AssetId = c.Int(nullable: false, identity: true),
                        AssetName = c.String(),
                        AssetCode = c.String(),
                        AssetSubCatId = c.Int(nullable: false),
                        UnitId = c.Int(nullable: false),
                        AssetTypeId = c.Int(nullable: false),
                        Description = c.String(),
                        Amount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        SellingPrice = c.Decimal(nullable: false, precision: 18, scale: 2),
                        AccCode = c.String(),
                        DeprcAmount = c.Int(nullable: false),
                        IsPercentage = c.Boolean(nullable: false),
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
                .PrimaryKey(t => t.AssetId);
            
            CreateTable(
                "dbo.FA_AssetCategory",
                c => new
                    {
                        AssetCateId = c.Int(nullable: false, identity: true),
                        CategoryName = c.String(),
                        CategoryCode = c.String(),
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
                .PrimaryKey(t => t.AssetCateId);
            
            CreateTable(
                "dbo.FA_AssetDetails",
                c => new
                    {
                        DetailId = c.Int(nullable: false, identity: true),
                        AssetIId = c.Int(nullable: false),
                        AssetID = c.String(),
                        Building = c.String(),
                        Room = c.String(),
                        Location = c.String(),
                        AssetLifeTime = c.String(),
                        Quantity = c.Int(nullable: false),
                        SerialNo = c.Int(nullable: false),
                        DisposedBy = c.String(),
                        IsDispose = c.Boolean(nullable: false),
                        IsExisting = c.Boolean(nullable: false),
                        DisposComment = c.String(),
                        warrentyPeriod = c.String(),
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
                .PrimaryKey(t => t.DetailId);
            
            CreateTable(
                "dbo.FA_AssetPurchaseOrder",
                c => new
                    {
                        POId = c.Int(nullable: false, identity: true),
                        POCode = c.String(),
                        SupplierId = c.Int(nullable: false),
                        DueDate = c.DateTime(nullable: false),
                        Description = c.String(),
                        TotalPrice = c.Decimal(nullable: false, precision: 18, scale: 2),
                        IsReceived = c.Boolean(nullable: false),
                        ReceivedBy = c.String(),
                        ReceiverComments = c.String(),
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
                .PrimaryKey(t => t.POId);
            
            CreateTable(
                "dbo.FA_AssetPurchaseOrderDetails",
                c => new
                    {
                        PODetailsId = c.Int(nullable: false, identity: true),
                        POId = c.Int(nullable: false),
                        ProductId = c.Int(nullable: false),
                        Quantity = c.Decimal(nullable: false, precision: 18, scale: 2),
                        UnitPrice = c.Decimal(nullable: false, precision: 18, scale: 2),
                        TotalPrice = c.Decimal(nullable: false, precision: 18, scale: 2),
                        Building = c.String(),
                        Room = c.String(),
                        Location = c.String(),
                        AssetLifeTime = c.String(),
                        Discount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ReceiveQuantity = c.Decimal(nullable: false, precision: 18, scale: 2),
                    })
                .PrimaryKey(t => t.PODetailsId);
            
            CreateTable(
                "dbo.FA_AssetQuotation",
                c => new
                    {
                        QuotationId = c.Int(nullable: false, identity: true),
                        QuotationCode = c.String(),
                        SupplierId = c.Int(nullable: false),
                        DueDate = c.DateTime(nullable: false),
                        Description = c.String(),
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
                .PrimaryKey(t => t.QuotationId);
            
            CreateTable(
                "dbo.FA_AssetQuotationDetails",
                c => new
                    {
                        QuotationDetailsId = c.Int(nullable: false, identity: true),
                        QuotationId = c.Int(nullable: false),
                        ProductId = c.Int(nullable: false),
                        Quantity = c.Decimal(nullable: false, precision: 18, scale: 2),
                        UnitPrice = c.Decimal(nullable: false, precision: 18, scale: 2),
                        Discount = c.Decimal(nullable: false, precision: 18, scale: 2),
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
                .PrimaryKey(t => t.QuotationDetailsId);
            
            CreateTable(
                "dbo.FA_AssetRequisition",
                c => new
                    {
                        AssetRequisitionId = c.Int(nullable: false, identity: true),
                        ReqCode = c.String(),
                        DueDate = c.DateTime(nullable: false),
                        EventDate = c.DateTime(nullable: false),
                        Description = c.String(),
                        IsApproved = c.Boolean(nullable: false),
                        ApprovedBy = c.String(),
                        ApprovedComments = c.String(),
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
                .PrimaryKey(t => t.AssetRequisitionId);
            
            CreateTable(
                "dbo.FA_AssetRequisitionDetails",
                c => new
                    {
                        ReqDetailsId = c.Int(nullable: false, identity: true),
                        ReqId = c.Int(nullable: false),
                        ProductId = c.Int(nullable: false),
                        Quantity = c.Decimal(nullable: false, precision: 18, scale: 2),
                        Price = c.Decimal(nullable: false, precision: 18, scale: 2),
                    })
                .PrimaryKey(t => t.ReqDetailsId);
            
            CreateTable(
                "dbo.FA_AssetSubCategory",
                c => new
                    {
                        AssetSubCatId = c.Int(nullable: false, identity: true),
                        CategoryId = c.Int(nullable: false),
                        SubCategoryName = c.String(),
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
                .PrimaryKey(t => t.AssetSubCatId);
            
            CreateTable(
                "dbo.FA_AssetUnitSetup",
                c => new
                    {
                        UnitSetupId = c.Int(nullable: false, identity: true),
                        UnitName = c.String(),
                        UnitCode = c.String(),
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
                .PrimaryKey(t => t.UnitSetupId);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.FA_AssetUnitSetup");
            DropTable("dbo.FA_AssetSubCategory");
            DropTable("dbo.FA_AssetRequisitionDetails");
            DropTable("dbo.FA_AssetRequisition");
            DropTable("dbo.FA_AssetQuotationDetails");
            DropTable("dbo.FA_AssetQuotation");
            DropTable("dbo.FA_AssetPurchaseOrderDetails");
            DropTable("dbo.FA_AssetPurchaseOrder");
            DropTable("dbo.FA_AssetDetails");
            DropTable("dbo.FA_AssetCategory");
            DropTable("dbo.FA_Asset");
        }
    }
}
