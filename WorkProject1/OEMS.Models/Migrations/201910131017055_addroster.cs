namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addroster : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Att_EmpAcademicCalendarDetails",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        CalendarId = c.Int(nullable: false),
                        Year = c.Int(nullable: false),
                        Month = c.Int(nullable: false),
                        Day = c.Int(nullable: false),
                        CalendarDate = c.DateTime(nullable: false),
                        DayType = c.String(maxLength: 20),
                        HolidayName = c.String(maxLength: 300),
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
            
            AddColumn("dbo.Emp_Attendance", "UpdatedStatus", c => c.String());
            AddColumn("dbo.Emp_Attendance", "IsPriApproved", c => c.Boolean(nullable: false));
            AddColumn("dbo.Emp_Attendance", "IsFinalApproved", c => c.Boolean(nullable: false));
            DropTable("dbo.Emp_AcademicCalendar");
        }
        
        public override void Down()
        {
            CreateTable(
                "dbo.Emp_AcademicCalendar",
                c => new
                    {
                        CalendarId = c.Int(nullable: false, identity: true),
                        Year = c.Int(nullable: false),
                        Month = c.Int(nullable: false),
                        Day = c.Int(nullable: false),
                        CalendarDate = c.DateTime(nullable: false),
                        DayType = c.String(maxLength: 20),
                        HolidayName = c.String(maxLength: 300),
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
                .PrimaryKey(t => t.CalendarId);
            
            DropColumn("dbo.Emp_Attendance", "IsFinalApproved");
            DropColumn("dbo.Emp_Attendance", "IsPriApproved");
            DropColumn("dbo.Emp_Attendance", "UpdatedStatus");
            DropTable("dbo.Att_EmpAcademicCalendarDetails");
        }
    }
}
