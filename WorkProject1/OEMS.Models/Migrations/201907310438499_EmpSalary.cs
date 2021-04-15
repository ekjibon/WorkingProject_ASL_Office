namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class EmpSalary : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.HR_EmployeeSalary",
                c => new
                    {
                        EmployeeSalaryId = c.Int(nullable: false, identity: true),
                        EmpId = c.Int(nullable: false),
                        PeriodId = c.Int(nullable: false),
                        HeadId = c.Int(nullable: false),
                        Amount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        DisburseDate = c.DateTime(),
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
                .PrimaryKey(t => t.EmployeeSalaryId);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.HR_EmployeeSalary");
        }
    }
}
