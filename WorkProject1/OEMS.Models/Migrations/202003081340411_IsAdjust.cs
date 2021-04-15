namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class IsAdjust : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Fees_Student", "PartialAmount", c => c.Decimal(precision: 18, scale: 2));
            AlterColumn("dbo.Fees_Student", "IsAdjust", c => c.Boolean());
            AlterColumn("dbo.Fees_Student", "IsRefund", c => c.Boolean());
            AlterColumn("dbo.Fees_Student", "IsResolved", c => c.Boolean());
        }
        
        public override void Down()
        {
            AlterColumn("dbo.Fees_Student", "IsResolved", c => c.Boolean(nullable: false));
            AlterColumn("dbo.Fees_Student", "IsRefund", c => c.Boolean(nullable: false));
            AlterColumn("dbo.Fees_Student", "IsAdjust", c => c.Boolean(nullable: false));
            DropColumn("dbo.Fees_Student", "PartialAmount");
        }
    }
}
