namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class EmpRosterTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Att_EmpRoster",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        EmpId = c.Int(),
                        EmpCategory = c.Int(),
                        BranchId = c.Int(),
                        CalendarDate = c.DateTime(nullable: false),
                        InTime = c.Time(nullable: false, precision: 7),
                        OutTime = c.Time(nullable: false, precision: 7),
                        IsApproved = c.Boolean(nullable: false),
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
            DropTable("dbo.Att_EmpRoster");
        }
    }
}
