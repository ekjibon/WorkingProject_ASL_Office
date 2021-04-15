namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class assetDisposFieldAdd : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Inv_AssetDisposal", "Quantity", c => c.Int(nullable: false));
            AddColumn("dbo.Inv_AssetDisposal", "AccountCode", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Inv_AssetDisposal", "AccountCode");
            DropColumn("dbo.Inv_AssetDisposal", "Quantity");
        }
    }
}
