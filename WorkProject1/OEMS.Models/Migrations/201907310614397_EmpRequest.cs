namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class EmpRequest : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Emp_Request",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        EmpId = c.Int(nullable: false),
                        RequestType = c.Int(nullable: false),
                        CategoryId = c.Int(),
                        DesignationId = c.Int(),
                        Date = c.DateTime(),
                        Reason = c.String(),
                        Time = c.DateTime(),
                        Description = c.String(),
                        MeetingIssue = c.String(),
                        NOCType = c.Int(nullable: false),
                        TravelDesination = c.String(),
                        TravelTo = c.DateTime(),
                        TravelFrom = c.DateTime(),
                        LeaveDate = c.DateTime(),
                        LeaveTypeId = c.Int(),
                        FromDate = c.DateTime(nullable: false),
                        ToDate = c.DateTime(nullable: false),
                        Duration = c.Int(),
                        RequestOn = c.DateTime(),
                        File = c.Binary(),
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
            DropTable("dbo.Emp_Request");
        }
    }
}
