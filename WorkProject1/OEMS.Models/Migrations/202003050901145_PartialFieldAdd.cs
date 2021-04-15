namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class PartialFieldAdd : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Fees_Student", "PartialAmount", c => c.Decimal(precision: 18, scale: 2));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Fees_Student", "PartialAmount");
        }
    }
}
