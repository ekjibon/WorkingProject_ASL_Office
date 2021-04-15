namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddModelFeesAdjust : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Fees_Adjust",
                c => new
                    {
                        FeesAdjustId = c.Int(nullable: false, identity: true),
                        StudentIID = c.Long(nullable: false),
                        TotalDepositpaid = c.Decimal(nullable: false, precision: 18, scale: 2),
                        TotalAdjustAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        TotalDueDeposit = c.Decimal(nullable: false, precision: 18, scale: 2),
                    })
                .PrimaryKey(t => t.FeesAdjustId);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.Fees_Adjust");
        }
    }
}
