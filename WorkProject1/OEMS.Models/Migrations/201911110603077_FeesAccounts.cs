namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class FeesAccounts : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Fees_Accounts",
                c => new
                    {
                        FeesAccountsId = c.Int(nullable: false, identity: true),
                        ProcessId = c.Int(nullable: false),
                        FeesSessionYearId = c.Int(nullable: false),
                        HeadId = c.Int(nullable: false),
                        Amount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        AmountType = c.String(),
                        IsApplied = c.Boolean(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.FeesAccountsId);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.Fees_Accounts");
        }
    }
}
