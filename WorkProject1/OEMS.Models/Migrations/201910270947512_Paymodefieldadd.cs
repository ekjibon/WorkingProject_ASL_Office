namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Paymodefieldadd : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Fees_CollectionMaster", "PayModeNo", c => c.Int());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Fees_CollectionMaster", "PayModeNo");
        }
    }
}
