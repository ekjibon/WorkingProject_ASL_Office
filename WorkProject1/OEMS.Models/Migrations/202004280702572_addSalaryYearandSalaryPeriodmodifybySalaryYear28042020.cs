namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addSalaryYearandSalaryPeriodmodifybySalaryYear28042020 : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.HR_SalaryYear",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        YearName = c.String(),
                        FromDate = c.DateTime(nullable: false),
                        ToDate = c.DateTime(nullable: false),
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
            
            AddColumn("dbo.HR_SalaryPeriod", "SalaryYearId", c => c.Int());
        }
        
        public override void Down()
        {
            DropColumn("dbo.HR_SalaryPeriod", "SalaryYearId");
            DropTable("dbo.HR_SalaryYear");
        }
    }
}
