namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddcolumnIsAdjustinSecurityDetails : DbMigration
    {
        public override void Up()
        {
            AlterColumn("dbo.Fees_SecurityDepositDetails", "IsAdjusted", c => c.Boolean());
        }
        
        public override void Down()
        {
            AlterColumn("dbo.Fees_SecurityDepositDetails", "IsAdjusted", c => c.Int());
        }
    }
}
