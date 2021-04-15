namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddModelSalaryHoldRefund : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.HR_SalaryHoldRefund",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        EmpId = c.Int(),
                        Installment = c.Int(),
                        SalaryPeriodId = c.Int(),
                        InstallmentAmount = c.Decimal(precision: 18, scale: 2),
                        HoldedAmount = c.Decimal(precision: 18, scale: 2),
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
            
        }
        
        public override void Down()
        {
            DropTable("dbo.HR_SalaryHoldRefund");
        }
    }
}
