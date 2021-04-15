namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddColumnMoneyReceiptOnSecurity : DbMigration
    {
        public override void Up()
        {
            AlterColumn("dbo.Fees_SecurityDepositDetails", "IsRefund", c => c.Boolean());
            AlterColumn("dbo.Fees_SecurityDepositDetails", "IsResolved", c => c.Boolean());
        }
        
        public override void Down()
        {
            AlterColumn("dbo.Fees_SecurityDepositDetails", "IsResolved", c => c.Boolean(nullable: false));
            AlterColumn("dbo.Fees_SecurityDepositDetails", "IsRefund", c => c.Boolean(nullable: false));
        }
    }
}
