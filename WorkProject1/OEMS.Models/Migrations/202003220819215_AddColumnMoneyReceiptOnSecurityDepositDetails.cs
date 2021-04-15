namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddColumnMoneyReceiptOnSecurityDepositDetails : DbMigration
    {
        public override void Up()
        {
            RenameTable(name: "dbo.SecurityDepositDetails", newName: "Fees_SecurityDepositDetails");
            AddColumn("dbo.Fees_SecurityDepositDetails", "MoneyReceipt", c => c.String(maxLength: 20));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Fees_SecurityDepositDetails", "MoneyReceipt");
            RenameTable(name: "dbo.Fees_SecurityDepositDetails", newName: "SecurityDepositDetails");
        }
    }
}
