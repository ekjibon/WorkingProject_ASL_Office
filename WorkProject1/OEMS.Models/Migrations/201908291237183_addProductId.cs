namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addProductId : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Inv_AssetDisposal", "ProductId", c => c.Int(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Inv_AssetDisposal", "ProductId");
        }
    }
}
