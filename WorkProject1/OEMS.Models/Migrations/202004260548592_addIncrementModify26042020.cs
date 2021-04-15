namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addIncrementModify26042020 : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.HR_SalaryIncrement", "SalaryYearId", c => c.Int());
            AddColumn("dbo.HR_SalaryIncrement", "GrossSalary", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.HR_SalaryIncrement", "AmountAfterIncrement", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.HR_SalaryIncrement", "IncrementPercentage", c => c.Decimal(precision: 18, scale: 2));
        }
        
        public override void Down()
        {
            DropColumn("dbo.HR_SalaryIncrement", "IncrementPercentage");
            DropColumn("dbo.HR_SalaryIncrement", "AmountAfterIncrement");
            DropColumn("dbo.HR_SalaryIncrement", "GrossSalary");
            DropColumn("dbo.HR_SalaryIncrement", "SalaryYearId");
        }
    }
}
