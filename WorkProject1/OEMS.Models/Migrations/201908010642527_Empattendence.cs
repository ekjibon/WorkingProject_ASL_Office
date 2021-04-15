namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Empattendence : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Emp_Attendance",
                c => new
                    {
                        AttendId = c.Long(nullable: false, identity: true),
                        EmpId = c.Long(nullable: false),
                        InTime = c.DateTime(nullable: false),
                        OutTime = c.DateTime(),
                        IsPresent = c.Boolean(nullable: false),
                        IsLeave = c.Boolean(nullable: false),
                        LeaveId = c.Int(),
                        IsLate = c.Boolean(nullable: false),
                        LateTime = c.Int(),
                        IsEarlyOut = c.Boolean(nullable: false),
                        EarlyOutTime = c.Int(),
                        Device_SerialNo = c.String(maxLength: 25),
                        Device_UserID = c.String(maxLength: 25),
                        Device_CardNo = c.String(maxLength: 25),
                        EntryType = c.String(maxLength: 2),
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
                .PrimaryKey(t => t.AttendId);
            
            CreateTable(
                "dbo.Emp_LIEO",
                c => new
                    {
                        LIEOId = c.Int(nullable: false, identity: true),
                        BranchId = c.Int(),
                        SessionId = c.Int(nullable: false),
                        ShiftId = c.Int(),
                        ClassId = c.Int(),
                        SectionId = c.Int(),
                        TypeId = c.Int(nullable: false),
                        StartTime = c.Time(nullable: false, precision: 7),
                        LateInTime = c.Time(nullable: false, precision: 7),
                        EndTime = c.Time(nullable: false, precision: 7),
                        EarlyOutTime = c.Time(nullable: false, precision: 7),
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
                .PrimaryKey(t => t.LIEOId);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.Emp_LIEO");
            DropTable("dbo.Emp_Attendance");
        }
    }
}
