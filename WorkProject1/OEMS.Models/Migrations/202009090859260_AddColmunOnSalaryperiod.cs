namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddColmunOnSalaryperiod : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.HR_SalaryPeriod", "PeriodStartDate", c => c.DateTime());
            AddColumn("dbo.HR_SalaryPeriod", "PeriodEndDate", c => c.DateTime());
        }
        
        public override void Down()
        {
            DropColumn("dbo.HR_SalaryPeriod", "PeriodEndDate");
            DropColumn("dbo.HR_SalaryPeriod", "PeriodStartDate");
        }
    }
}
