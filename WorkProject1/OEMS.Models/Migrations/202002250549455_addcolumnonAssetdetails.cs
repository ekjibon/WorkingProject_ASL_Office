namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addcolumnonAssetdetails : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.FA_AssetDetails", "PurchseValue", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("dbo.FA_AssetDetails", "CurrentValue", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("dbo.FA_AssetDetails", "Brand", c => c.String());
            AddColumn("dbo.FA_AssetDetails", "BranchID", c => c.String());
            AddColumn("dbo.FA_AssetDetails", "SalvageValue", c => c.Decimal(nullable: false, precision: 18, scale: 2));
        }
        
        public override void Down()
        {
            DropColumn("dbo.FA_AssetDetails", "SalvageValue");
            DropColumn("dbo.FA_AssetDetails", "BranchID");
            DropColumn("dbo.FA_AssetDetails", "Brand");
            DropColumn("dbo.FA_AssetDetails", "CurrentValue");
            DropColumn("dbo.FA_AssetDetails", "PurchseValue");
        }
    }
}
