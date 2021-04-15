namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddcolumnonSalaryPeriod : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.HR_SalaryHead", "IsEdit", c => c.Boolean());
            AddColumn("dbo.HR_SalaryPeriod", "SalaryTaxYearId", c => c.Int());
            AddColumn("dbo.HR_SalaryPeriod", "IsDeductTax", c => c.Boolean());
            AddColumn("dbo.HR_SalaryPeriod", "IsLongHoliday", c => c.Boolean());
        }
        
        public override void Down()
        {
            DropColumn("dbo.HR_SalaryPeriod", "IsLongHoliday");
            DropColumn("dbo.HR_SalaryPeriod", "IsDeductTax");
            DropColumn("dbo.HR_SalaryPeriod", "SalaryTaxYearId");
            DropColumn("dbo.HR_SalaryHead", "IsEdit");
        }
    }
}
