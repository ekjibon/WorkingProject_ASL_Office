namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addAdvancesalayHoldMonthadd26042020 : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.HR_AdvanceSalary", "Year", c => c.Int());
            AddColumn("dbo.HR_AdvanceSalary", "Month", c => c.Int());
            AddColumn("dbo.HR_AdvanceSalary", "MonthName", c => c.String());
            AddColumn("dbo.HR_SalaryHold", "Year", c => c.Int());
            AddColumn("dbo.HR_SalaryHold", "Month", c => c.Int());
            AddColumn("dbo.HR_SalaryHold", "MonthName", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.HR_SalaryHold", "MonthName");
            DropColumn("dbo.HR_SalaryHold", "Month");
            DropColumn("dbo.HR_SalaryHold", "Year");
            DropColumn("dbo.HR_AdvanceSalary", "MonthName");
            DropColumn("dbo.HR_AdvanceSalary", "Month");
            DropColumn("dbo.HR_AdvanceSalary", "Year");
        }
    }
}
