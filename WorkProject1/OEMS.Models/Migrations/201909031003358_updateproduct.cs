namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class updateproduct : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Inv_Product", "ProductTypeId", c => c.Int(nullable: false));
            AddColumn("dbo.Inv_Product", "Amount", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            DropColumn("dbo.Inv_Product", "IsFixedAsset");
            DropColumn("dbo.Inv_Product", "IsDistributed");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Inv_Product", "IsDistributed", c => c.Boolean(nullable: false));
            AddColumn("dbo.Inv_Product", "IsFixedAsset", c => c.Boolean(nullable: false));
            DropColumn("dbo.Inv_Product", "Amount");
            DropColumn("dbo.Inv_Product", "ProductTypeId");
        }
    }
}
