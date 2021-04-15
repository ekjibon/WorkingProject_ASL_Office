namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addModelSalayHoldandPayementAddcolumnSalaryPaymentModeEmpBasicinfo : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.HR_AdvanceSalary",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        EmpId = c.Int(nullable: false),
                        SalaryPeriodId = c.Int(),
                        SanctionDate = c.DateTime(nullable: false),
                        HeadId = c.Int(),
                        NoOfInstallment = c.Int(),
                        AdvanceAmount = c.Decimal(precision: 18, scale: 2),
                        InstallmentAmount = c.Decimal(precision: 18, scale: 2),
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
                "dbo.HR_SalaryHoldPayment",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        EmpId = c.Int(nullable: false),
                        SalaryPeriodId = c.Int(),
                        SalaryHoldId = c.Int(),
                        PaymentAmount = c.Decimal(precision: 18, scale: 2),
                        ToptalPaymentAmount = c.Decimal(precision: 18, scale: 2),
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
            
            AddColumn("dbo.Emp_BasicInfo", "SalaryPaymentMode", c => c.String());
            AddColumn("dbo.HR_SalaryHold", "SalaryPeriodId", c => c.Int());
            AddColumn("dbo.HR_SalaryHold", "HoldDate", c => c.DateTime());
            AddColumn("dbo.HR_SalaryHold", "HeadId", c => c.Int());
            AddColumn("dbo.HR_SalaryHold", "NoOfInstallment", c => c.Int());
            AlterColumn("dbo.Emp_BasicInfo", "IsResignationApplied", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            AlterColumn("dbo.Emp_BasicInfo", "IsResignationApplied", c => c.Boolean());
            DropColumn("dbo.HR_SalaryHold", "NoOfInstallment");
            DropColumn("dbo.HR_SalaryHold", "HeadId");
            DropColumn("dbo.HR_SalaryHold", "HoldDate");
            DropColumn("dbo.HR_SalaryHold", "SalaryPeriodId");
            DropColumn("dbo.Emp_BasicInfo", "SalaryPaymentMode");
            DropTable("dbo.HR_SalaryHoldPayment");
            DropTable("dbo.HR_AdvanceSalary");
        }
    }
}
