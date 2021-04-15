namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class modificatoinmodels : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.HR_SalaryPayDetails", "CategoryID", c => c.Int(nullable: false));
            AddColumn("dbo.HR_SalaryStructure", "CategoryID", c => c.Int(nullable: false));
            AddColumn("dbo.HR_SalaryStructurePeriod", "CategoryID", c => c.Int(nullable: false));
            AlterColumn("dbo.HR_SalaryPayDetails", "SalaryPeriodId", c => c.Int(nullable: false));
            AlterColumn("dbo.HR_SalaryStructurePeriod", "GradeId", c => c.Int());
        }
        
        public override void Down()
        {
            AlterColumn("dbo.HR_SalaryStructurePeriod", "GradeId", c => c.Int(nullable: false));
            AlterColumn("dbo.HR_SalaryPayDetails", "SalaryPeriodId", c => c.String());
            DropColumn("dbo.HR_SalaryStructurePeriod", "CategoryID");
            DropColumn("dbo.HR_SalaryStructure", "CategoryID");
            DropColumn("dbo.HR_SalaryPayDetails", "CategoryID");
        }
    }
}
