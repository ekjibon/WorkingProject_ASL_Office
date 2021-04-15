namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddColumnOnPayDetails : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.HR_EmployeeTaxSetup", "EmpId", c => c.Int(nullable: false));
            AddColumn("dbo.HR_EmployeeTaxSetup", "TaxYearId", c => c.Int(nullable: false));
            AddColumn("dbo.HR_EmployeeTaxSetup", "CategoryID", c => c.Int(nullable: false));
            AddColumn("dbo.HR_SalaryPayDetails", "DesignationName", c => c.String());
            DropColumn("dbo.HR_EmployeeTaxSetup", "YearName");
            DropColumn("dbo.HR_EmployeeTaxSetup", "FromDate");
            DropColumn("dbo.HR_EmployeeTaxSetup", "ToDate");
            DropColumn("dbo.HR_EmployeeTaxSetup", "EmpBasicInfoID");
        }
        
        public override void Down()
        {
            AddColumn("dbo.HR_EmployeeTaxSetup", "EmpBasicInfoID", c => c.Int(nullable: false));
            AddColumn("dbo.HR_EmployeeTaxSetup", "ToDate", c => c.DateTime(nullable: false));
            AddColumn("dbo.HR_EmployeeTaxSetup", "FromDate", c => c.DateTime(nullable: false));
            AddColumn("dbo.HR_EmployeeTaxSetup", "YearName", c => c.String());
            DropColumn("dbo.HR_SalaryPayDetails", "DesignationName");
            DropColumn("dbo.HR_EmployeeTaxSetup", "CategoryID");
            DropColumn("dbo.HR_EmployeeTaxSetup", "TaxYearId");
            DropColumn("dbo.HR_EmployeeTaxSetup", "EmpId");
        }
    }
}
