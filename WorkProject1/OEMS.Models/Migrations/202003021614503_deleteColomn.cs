namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class deleteColomn : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("dbo.Fees_Student", "FeesAdjustHistory_FeesAdjustId", "dbo.FeesAdjustHistories");
            DropForeignKey("dbo.Fees_Student", "FeesAdjustHistory_FeesAdjustId1", "dbo.FeesAdjustHistories");
            DropIndex("dbo.Fees_Student", new[] { "FeesAdjustHistory_FeesAdjustId" });
            DropIndex("dbo.Fees_Student", new[] { "FeesAdjustHistory_FeesAdjustId1" });
            AddColumn("dbo.SecurityDepositDetails", "IsRefund", c => c.Boolean(nullable: false));
            AddColumn("dbo.SecurityDepositDetails", "IsResolved", c => c.Boolean(nullable: false));
            DropColumn("dbo.FeesAdjustHistories", "EmpId");
            DropColumn("dbo.FeesAdjustHistories", "IsVerification");
            DropColumn("dbo.FeesAdjustHistories", "AppVerificationNo");
            DropColumn("dbo.FeesAdjustHistories", "AutomatedDays");
            DropColumn("dbo.FeesAdjustHistories", "AutomatedConsecutiveDays");
            DropColumn("dbo.FeesAdjustHistories", "IsPublished");
            DropColumn("dbo.FeesAdjustHistories", "IsLatePayPublished");
            DropColumn("dbo.FeesAdjustHistories", "IsLatePay");
            DropColumn("dbo.FeesAdjustHistories", "Year");
            DropColumn("dbo.Fees_Student", "FeesAdjustHistory_FeesAdjustId");
            DropColumn("dbo.Fees_Student", "FeesAdjustHistory_FeesAdjustId1");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Fees_Student", "FeesAdjustHistory_FeesAdjustId1", c => c.Long());
            AddColumn("dbo.Fees_Student", "FeesAdjustHistory_FeesAdjustId", c => c.Long());
            AddColumn("dbo.FeesAdjustHistories", "Year", c => c.Int(nullable: false));
            AddColumn("dbo.FeesAdjustHistories", "IsLatePay", c => c.Boolean(nullable: false));
            AddColumn("dbo.FeesAdjustHistories", "IsLatePayPublished", c => c.Boolean(nullable: false));
            AddColumn("dbo.FeesAdjustHistories", "IsPublished", c => c.Boolean(nullable: false));
            AddColumn("dbo.FeesAdjustHistories", "AutomatedConsecutiveDays", c => c.Int(nullable: false));
            AddColumn("dbo.FeesAdjustHistories", "AutomatedDays", c => c.Int(nullable: false));
            AddColumn("dbo.FeesAdjustHistories", "AppVerificationNo", c => c.String());
            AddColumn("dbo.FeesAdjustHistories", "IsVerification", c => c.Boolean());
            AddColumn("dbo.FeesAdjustHistories", "EmpId", c => c.String());
            DropColumn("dbo.SecurityDepositDetails", "IsResolved");
            DropColumn("dbo.SecurityDepositDetails", "IsRefund");
            CreateIndex("dbo.Fees_Student", "FeesAdjustHistory_FeesAdjustId1");
            CreateIndex("dbo.Fees_Student", "FeesAdjustHistory_FeesAdjustId");
            AddForeignKey("dbo.Fees_Student", "FeesAdjustHistory_FeesAdjustId1", "dbo.FeesAdjustHistories", "FeesAdjustId");
            AddForeignKey("dbo.Fees_Student", "FeesAdjustHistory_FeesAdjustId", "dbo.FeesAdjustHistories", "FeesAdjustId");
        }
    }
}
