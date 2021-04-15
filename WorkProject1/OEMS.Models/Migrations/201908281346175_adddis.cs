namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class adddis : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Inv_AssetDisposal",
                c => new
                    {
                        DisposalId = c.Int(nullable: false, identity: true),
                        DisposalType = c.String(),
                        SellingPrice = c.Decimal(nullable: false, precision: 18, scale: 2),
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
                .PrimaryKey(t => t.DisposalId);
            
            CreateTable(
                "dbo.Inv_Distribution",
                c => new
                    {
                        DistributionId = c.Int(nullable: false, identity: true),
                        ProductId = c.Int(nullable: false),
                        Qty = c.Decimal(nullable: false, precision: 18, scale: 2),
                        EmployeeId = c.Int(nullable: false),
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
                .PrimaryKey(t => t.DistributionId);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.Inv_Distribution");
            DropTable("dbo.Inv_AssetDisposal");
        }
    }
}
