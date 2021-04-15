namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddColumnonSalaryStructurePeriodmodifylog : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.HR_SalaryStructurePeriodModifylog", "PaydetailsId", c => c.Int(nullable: false));
            AddColumn("dbo.HR_SalaryStructurePeriodModifylog", "NetAmount", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("dbo.HR_SalaryStructurePeriodModifylog", "SalaryStructurePeriodId", c => c.Int(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.HR_SalaryStructurePeriodModifylog", "SalaryStructurePeriodId");
            DropColumn("dbo.HR_SalaryStructurePeriodModifylog", "NetAmount");
            DropColumn("dbo.HR_SalaryStructurePeriodModifylog", "PaydetailsId");
        }
    }
}
