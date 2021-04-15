namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addmodelEmptaxSetup : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.HR_EmployeeTaxSetup",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        YearName = c.String(),
                        FromDate = c.DateTime(nullable: false),
                        ToDate = c.DateTime(nullable: false),
                        EmpBasicInfoID = c.Int(nullable: false),
                        CurrentSalary = c.String(),
                        TaxAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
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
            DropTable("dbo.HR_EmployeeTaxSetup");
        }
    }
}
