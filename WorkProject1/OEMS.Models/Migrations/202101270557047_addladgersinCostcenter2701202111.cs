namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addladgersinCostcenter2701202111 : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.ACC_CostCenter", "LedgerId", c => c.Int());
        }
        
        public override void Down()
        {
            DropColumn("dbo.ACC_CostCenter", "LedgerId");
        }
    }
}
