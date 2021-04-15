namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addEmpAcademicCalendarfieldadd : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Att_EmpAcademicCalendar",
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
            
        }
        
        public override void Down()
        {
            DropTable("dbo.Att_EmpAcademicCalendar");
        }
    }
}
