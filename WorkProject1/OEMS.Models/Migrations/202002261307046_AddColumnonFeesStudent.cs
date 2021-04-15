namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddColumnonFeesStudent : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Fees_Student", "Stutype", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Fees_Student", "Stutype");
        }
    }
}
