namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addcashfollowtype2009202001 : DbMigration
    {
        public override void Up()
        {
            DropIndex("dbo.ACC_Ledgers", new[] { "Code" });
            AddColumn("dbo.ACC_Ledgers", "CashFlowType", c => c.String());
            AddColumn("dbo.HR_SalaryHoldRefund", "SalaryYearId", c => c.Int());
            AlterColumn("dbo.ACC_Ledgers", "Code", c => c.String(maxLength: 500));
            CreateIndex("dbo.ACC_Ledgers", "Code", unique: true);
        }
        
        public override void Down()
        {
            DropIndex("dbo.ACC_Ledgers", new[] { "Code" });
            AlterColumn("dbo.ACC_Ledgers", "Code", c => c.String(maxLength: 50));
            DropColumn("dbo.HR_SalaryHoldRefund", "SalaryYearId");
            DropColumn("dbo.ACC_Ledgers", "CashFlowType");
            CreateIndex("dbo.ACC_Ledgers", "Code", unique: true);
        }
    }
}
