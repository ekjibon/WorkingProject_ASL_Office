namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CSPayrol : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Ins_CSInfo",
                c => new
                    {
                        CSId = c.Int(nullable: false, identity: true),
                        StudentId = c.Int(),
                        CSType = c.String(),
                        DonateItem = c.String(),
                        CSVisitDateTime = c.DateTime(),
                        VolunteerName = c.String(),
                        VolunteerDate = c.String(),
                        Relation = c.String(),
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
                .PrimaryKey(t => t.CSId);
            
            CreateTable(
                "dbo.HR_SalaryStructurePeriod",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        PeriodId = c.Int(nullable: false),
                        HeadId = c.Int(nullable: false),
                        EmpId = c.Int(nullable: false),
                        GradeId = c.Int(nullable: false),
                        TaxYearId = c.Int(),
                        Amount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ProccessDate = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.Id);
            
            AlterColumn("dbo.HR_SalaryHead", "Category", c => c.Int(nullable: false));
        }
        
        public override void Down()
        {
            AlterColumn("dbo.HR_SalaryHead", "Category", c => c.Int());
            DropTable("dbo.HR_SalaryStructurePeriod");
            DropTable("dbo.Ins_CSInfo");
        }
    }
}
