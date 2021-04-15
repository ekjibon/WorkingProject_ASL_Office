namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addextracol08020211133 : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Invoice_CollectionDetails", "ExtraCollectionAmount", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Invoice_CollectionMaster", "ExtraCollectionAmount", c => c.Decimal(precision: 18, scale: 2));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Invoice_CollectionMaster", "ExtraCollectionAmount");
            DropColumn("dbo.Invoice_CollectionDetails", "ExtraCollectionAmount");
        }
    }
}
