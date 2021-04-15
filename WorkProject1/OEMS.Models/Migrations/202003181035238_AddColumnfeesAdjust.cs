namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddColumnfeesAdjust : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Fees_Adjust", "IsRefund", c => c.Boolean());
            AddColumn("dbo.Fees_Adjust", "IsResolved", c => c.Boolean());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Fees_Adjust", "IsResolved");
            DropColumn("dbo.Fees_Adjust", "IsRefund");
        }
    }
}
