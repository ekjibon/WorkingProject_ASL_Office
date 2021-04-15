namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddModelSalaryStructurePeriodModifylog : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.HR_SalaryStructurePeriodModifylog",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        CategoryID = c.Int(nullable: false),
                        PeriodId = c.Int(nullable: false),
                        HeadId = c.Int(nullable: false),
                        EmpId = c.Int(nullable: false),
                        GradeId = c.Int(),
                        TaxYearId = c.Int(),
                        Amount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ProccessDate = c.DateTime(nullable: false),
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
                .PrimaryKey(t => t.Id);
            
            AddColumn("dbo.HR_AdvanceSalary", "InvoiceNumber", c => c.Int());
            AddColumn("dbo.HR_SalaryPayDetails", "IsModified", c => c.Boolean());
            AddColumn("dbo.HR_SalaryStructurePeriod", "IsModified", c => c.Boolean());
        }
        
        public override void Down()
        {
            DropColumn("dbo.HR_SalaryStructurePeriod", "IsModified");
            DropColumn("dbo.HR_SalaryPayDetails", "IsModified");
            DropColumn("dbo.HR_AdvanceSalary", "InvoiceNumber");
            DropTable("dbo.HR_SalaryStructurePeriodModifylog");
        }
    }
}
