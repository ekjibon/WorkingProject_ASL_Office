namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class updateproduct_1 : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Inv_Product", "AccCode", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Inv_Product", "AccCode");
        }
    }
}
