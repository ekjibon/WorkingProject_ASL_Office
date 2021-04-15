namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class UpdateFees : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Fees_Student", "InvoiceAmount", c => c.Decimal(nullable: false, precision: 18, scale: 2));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Fees_Student", "InvoiceAmount");
        }
    }
}
