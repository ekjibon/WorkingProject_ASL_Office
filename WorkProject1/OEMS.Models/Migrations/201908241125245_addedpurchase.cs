namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addedpurchase : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Inv_PurchaseOrder",
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
                "dbo.Inv_PurchaseOrderDetails",
                c => new
                    {
                        PODetailsId = c.Int(nullable: false, identity: true),
                        POId = c.Int(nullable: false),
                        ProductId = c.Int(nullable: false),
                        Quantity = c.Decimal(nullable: false, precision: 18, scale: 2),
                        UnitPrice = c.Decimal(nullable: false, precision: 18, scale: 2),
                        TotalPrice = c.Decimal(nullable: false, precision: 18, scale: 2),
                        Discount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ReceiveQuantity = c.Decimal(nullable: false, precision: 18, scale: 2),
                    })
                .PrimaryKey(t => t.PODetailsId);
            
            CreateTable(
                "dbo.Inv_Sales",
                c => new
                    {
                        SalesId = c.Int(nullable: false, identity: true),
                        CustomerName = c.String(),
                        MobileNo = c.String(),
                        SubTotal = c.Decimal(nullable: false, precision: 18, scale: 2),
                        Discount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        Vat = c.Decimal(nullable: false, precision: 18, scale: 2),
                        NetPayable = c.Decimal(nullable: false, precision: 18, scale: 2),
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
                .PrimaryKey(t => t.SalesId);
            
            CreateTable(
                "dbo.Inv_SalesDetails",
                c => new
                    {
                        SalesDetailsId = c.Int(nullable: false, identity: true),
                        SalesId = c.Int(nullable: false),
                        ProductId = c.Int(nullable: false),
                        Quantity = c.Decimal(nullable: false, precision: 18, scale: 2),
                        UnitPrice = c.Decimal(nullable: false, precision: 18, scale: 2),
                        SubTotal = c.Decimal(nullable: false, precision: 18, scale: 2),
                        Discount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        Vat = c.Decimal(nullable: false, precision: 18, scale: 2),
                        NetPayable = c.Decimal(nullable: false, precision: 18, scale: 2),
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
                .PrimaryKey(t => t.SalesDetailsId);
            
            AddColumn("dbo.Res_ClassResultComments", "COComments", c => c.String());
            AddColumn("dbo.Student_BasicInfo", "PPExpireDate", c => c.DateTime(nullable: false));
            AddColumn("dbo.Student_GuardianInfo", "F_PPExpireDate", c => c.DateTime(nullable: false));
            AddColumn("dbo.Student_GuardianInfo", "M_PPExpireDate", c => c.DateTime(nullable: false));
            AddColumn("dbo.Student_GuardianInfo", "LG4_Name", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG4_Relation", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG4_Address", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG4_Mobile", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG4_Email", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG4_TIN", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG4_NIDNo", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG4_GuardianImage", c => c.Binary());
            AddColumn("dbo.Student_GuardianInfo", "LG4_GuardianSignature", c => c.Binary());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Student_GuardianInfo", "LG4_GuardianSignature");
            DropColumn("dbo.Student_GuardianInfo", "LG4_GuardianImage");
            DropColumn("dbo.Student_GuardianInfo", "LG4_NIDNo");
            DropColumn("dbo.Student_GuardianInfo", "LG4_TIN");
            DropColumn("dbo.Student_GuardianInfo", "LG4_Email");
            DropColumn("dbo.Student_GuardianInfo", "LG4_Mobile");
            DropColumn("dbo.Student_GuardianInfo", "LG4_Address");
            DropColumn("dbo.Student_GuardianInfo", "LG4_Relation");
            DropColumn("dbo.Student_GuardianInfo", "LG4_Name");
            DropColumn("dbo.Student_GuardianInfo", "M_PPExpireDate");
            DropColumn("dbo.Student_GuardianInfo", "F_PPExpireDate");
            DropColumn("dbo.Student_BasicInfo", "PPExpireDate");
            DropColumn("dbo.Res_ClassResultComments", "COComments");
            DropTable("dbo.Inv_SalesDetails");
            DropTable("dbo.Inv_Sales");
            DropTable("dbo.Inv_PurchaseOrderDetails");
            DropTable("dbo.Inv_PurchaseOrder");
        }
    }
}
