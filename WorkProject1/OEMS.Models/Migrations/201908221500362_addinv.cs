namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addinv : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Inv_Product",
                c => new
                    {
                        ProductId = c.Int(nullable: false, identity: true),
                        ProductName = c.String(),
                        ProductCode = c.String(),
                        ProductSubCateId = c.Int(nullable: false),
                        UnitId = c.Int(nullable: false),
                        ReOrderLevel = c.Int(nullable: false),
                        IsFixedAsset = c.Boolean(nullable: false),
                        IsDistributed = c.Boolean(nullable: false),
                        Description = c.String(),
                        OpeningBalance = c.Decimal(nullable: false, precision: 10, scale: 2),
                        SellingPrice = c.Decimal(nullable: false, precision: 10, scale: 2),
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
                .PrimaryKey(t => t.ProductId);
            
            CreateTable(
                "dbo.Inv_ProductCategory",
                c => new
                    {
                        ProductCateId = c.Int(nullable: false, identity: true),
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
                .PrimaryKey(t => t.ProductCateId);
            
            CreateTable(
                "dbo.Inv_ProductStocks",
                c => new
                    {
                        StockId = c.Int(nullable: false, identity: true),
                        ProductId = c.Int(nullable: false),
                        Quantity = c.Decimal(nullable: false, precision: 10, scale: 2),
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
                .PrimaryKey(t => t.StockId);
            
            CreateTable(
                "dbo.Inv_ProductSubCategory",
                c => new
                    {
                        ProductSubCatId = c.Int(nullable: false, identity: true),
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
                .PrimaryKey(t => t.ProductSubCatId);
            
            CreateTable(
                "dbo.Inv_Quotation",
                c => new
                    {
                        QuotationId = c.Int(nullable: false, identity: true),
                        QuotationCode = c.String(),
                        SupplierId = c.Int(nullable: false),
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
                "dbo.Inv_QuotationDetails",
                c => new
                    {
                        QuotationDetailsId = c.Int(nullable: false, identity: true),
                        QuotationId = c.Int(nullable: false),
                        ProductId = c.Int(nullable: false),
                        Quantity = c.Decimal(nullable: false, precision: 10, scale: 2),
                        UnitPrice = c.Decimal(nullable: false, precision: 10, scale: 2),
                        Discount = c.Decimal(nullable: false, precision: 10, scale: 2),
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
                "dbo.Inv_Requisition",
                c => new
                    {
                        RequisitionId = c.Int(nullable: false, identity: true),
                        ReqCode = c.String(),
                        DueDate = c.DateTime(nullable: false),
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
                .PrimaryKey(t => t.RequisitionId);
            
            CreateTable(
                "dbo.Inv_RequisitionDetails",
                c => new
                    {
                        ReqDetailsId = c.Int(nullable: false, identity: true),
                        ReqId = c.Int(nullable: false),
                        ProductId = c.Int(nullable: false),
                        Quantity = c.Decimal(nullable: false, precision: 10, scale: 2),
                    })
                .PrimaryKey(t => t.ReqDetailsId);
            
            CreateTable(
                "dbo.Inv_StockTransaction",
                c => new
                    {
                        TransactionId = c.Int(nullable: false, identity: true),
                        ProductId = c.Int(nullable: false),
                        Quantity = c.Decimal(nullable: false, precision: 10, scale: 2),
                        LastStockQty = c.Decimal(nullable: false, precision: 10, scale: 2),
                        TransType = c.String(),
                        TransCategory = c.String(),
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
                .PrimaryKey(t => t.TransactionId);
            
            CreateTable(
                "dbo.Inv_Supplier",
                c => new
                    {
                        SupplierId = c.Int(nullable: false, identity: true),
                        SupplierName = c.String(),
                        SupplierCode = c.String(),
                        CompanyName = c.String(),
                        ContactPersonName = c.String(),
                        ConatactPersonMobileNo = c.String(),
                        Email = c.String(),
                        Address = c.String(),
                        AccountCode = c.String(),
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
                .PrimaryKey(t => t.SupplierId);
            
            CreateTable(
                "dbo.Inv_UnitSetup",
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
            
            DropColumn("dbo.Res_ClassResultComments", "COComments");
            DropColumn("dbo.Student_BasicInfo", "PPExpireDate");
            DropColumn("dbo.Student_GuardianInfo", "F_PPExpireDate");
            DropColumn("dbo.Student_GuardianInfo", "M_PPExpireDate");
            DropColumn("dbo.Student_GuardianInfo", "LG4_Name");
            DropColumn("dbo.Student_GuardianInfo", "LG4_Relation");
            DropColumn("dbo.Student_GuardianInfo", "LG4_Address");
            DropColumn("dbo.Student_GuardianInfo", "LG4_Mobile");
            DropColumn("dbo.Student_GuardianInfo", "LG4_Email");
            DropColumn("dbo.Student_GuardianInfo", "LG4_TIN");
            DropColumn("dbo.Student_GuardianInfo", "LG4_NIDNo");
            DropColumn("dbo.Student_GuardianInfo", "LG4_GuardianImage");
            DropColumn("dbo.Student_GuardianInfo", "LG4_GuardianSignature");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Student_GuardianInfo", "LG4_GuardianSignature", c => c.Binary());
            AddColumn("dbo.Student_GuardianInfo", "LG4_GuardianImage", c => c.Binary());
            AddColumn("dbo.Student_GuardianInfo", "LG4_NIDNo", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG4_TIN", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG4_Email", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG4_Mobile", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG4_Address", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG4_Relation", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG4_Name", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "M_PPExpireDate", c => c.DateTime(nullable: false));
            AddColumn("dbo.Student_GuardianInfo", "F_PPExpireDate", c => c.DateTime(nullable: false));
            AddColumn("dbo.Student_BasicInfo", "PPExpireDate", c => c.DateTime(nullable: false));
            AddColumn("dbo.Res_ClassResultComments", "COComments", c => c.String());
            DropTable("dbo.Inv_UnitSetup");
            DropTable("dbo.Inv_Supplier");
            DropTable("dbo.Inv_StockTransaction");
            DropTable("dbo.Inv_RequisitionDetails");
            DropTable("dbo.Inv_Requisition");
            DropTable("dbo.Inv_QuotationDetails");
            DropTable("dbo.Inv_Quotation");
            DropTable("dbo.Inv_ProductSubCategory");
            DropTable("dbo.Inv_ProductStocks");
            DropTable("dbo.Inv_ProductCategory");
            DropTable("dbo.Inv_Product");
        }
    }
}
