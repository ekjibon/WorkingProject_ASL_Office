namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class EmployeeAttendancModelModify : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Emp_Attendance", "CalanderDetailsId", c => c.Int(nullable: false,defaultValue:0));
            AddColumn("dbo.Emp_Attendance", "DayType", c => c.String());
            AddColumn("dbo.Emp_Attendance", "OfficeInTime", c => c.Time(nullable: false, precision: 7,defaultValue:TimeSpan.Zero));
            AddColumn("dbo.Emp_Attendance", "OfficeOutTime", c => c.Time(nullable: false, precision: 7, defaultValue: TimeSpan.Zero));
            AddColumn("dbo.Emp_Attendance", "DefaultLateInTime", c => c.Time(nullable: false, precision: 7, defaultValue: TimeSpan.Zero));
            AddColumn("dbo.Emp_Attendance", "DefaultEarlyOutTime", c => c.Time(nullable: false, precision: 7, defaultValue: TimeSpan.Zero));
            DropTable("dbo.Att_EmpAcademicCalandarConfig");
        }
        
        public override void Down()
        {
            CreateTable(
                "dbo.Att_EmpAcademicCalandarConfig",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        CalanderDetailsId = c.Int(nullable: false),
                        EmpId = c.Int(nullable: false),
                        DayType = c.String(),
                        InTime = c.Time(nullable: false, precision: 7),
                        OutTime = c.Time(nullable: false, precision: 7),
                        DefaultLateInTime = c.Time(nullable: false, precision: 7),
                        DefaultEarlyOutTime = c.Time(nullable: false, precision: 7),
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
            
            DropColumn("dbo.Emp_Attendance", "DefaultEarlyOutTime");
            DropColumn("dbo.Emp_Attendance", "DefaultLateInTime");
            DropColumn("dbo.Emp_Attendance", "OfficeOutTime");
            DropColumn("dbo.Emp_Attendance", "OfficeInTime");
            DropColumn("dbo.Emp_Attendance", "DayType");
            DropColumn("dbo.Emp_Attendance", "CalanderDetailsId");
        }
    }
}
