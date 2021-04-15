namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddcolumnonSecurityDepositDetails : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.HR_AdvanceSalaryPayment",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        EmpId = c.Int(nullable: false),
                        SalaryPeriodId = c.Int(),
                        AdvanceSalaryId = c.Int(),
                        PaymentAmount = c.Decimal(precision: 18, scale: 2),
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
            
            CreateTable(
                "dbo.HR_SalaryHold",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        EmpId = c.Int(nullable: false),
                        GrossSalary = c.Decimal(precision: 18, scale: 2),
                        HoldPerMonthAmount = c.Decimal(precision: 18, scale: 2),
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
            
            AddColumn("dbo.Fees_SecurityDepositDetails", "Installment", c => c.Int());
            AddColumn("dbo.Fees_SecurityDepositDetails", "InstallmentAmount", c => c.Decimal(precision: 18, scale: 2));
            AlterColumn("dbo.HR_SalaryPayDetails", "CategoryID", c => c.Int(nullable: false));
            AlterColumn("dbo.HR_SalaryPayDetails", "GrossAmount", c => c.Decimal(nullable: false, precision: 18, scale: 2));
        }
        
        public override void Down()
        {
            AlterColumn("dbo.HR_SalaryPayDetails", "GrossAmount", c => c.Decimal(precision: 18, scale: 2));
            AlterColumn("dbo.HR_SalaryPayDetails", "CategoryID", c => c.Int());
            DropColumn("dbo.Fees_SecurityDepositDetails", "InstallmentAmount");
            DropColumn("dbo.Fees_SecurityDepositDetails", "Installment");
            DropTable("dbo.HR_SalaryHold");
            DropTable("dbo.HR_AdvanceSalaryPayment");
        }
    }
}
