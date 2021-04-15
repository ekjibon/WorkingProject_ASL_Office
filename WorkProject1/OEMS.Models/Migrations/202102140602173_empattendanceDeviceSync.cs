namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class empattendanceDeviceSync : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Emp_DeviceAttendance",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        EmpId = c.Int(nullable: false),
                        DeviceUSERID = c.Int(nullable: false),
                        CHECKTIME = c.DateTime(nullable: false),
                        CHECKTYPE = c.String(),
                        VERIFYCODE = c.Int(nullable: false),
                        SENSORID = c.String(),
                        Memoinfo = c.String(),
                        WorkCode = c.String(),
                        sn = c.String(),
                        UserExtFmt = c.Int(nullable: false),
                        IsSync = c.Boolean(nullable: false),
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
            DropTable("dbo.Emp_DeviceAttendance");
        }
    }
}
