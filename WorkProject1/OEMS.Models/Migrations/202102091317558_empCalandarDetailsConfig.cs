namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class empCalandarDetailsConfig : DbMigration
    {
        public override void Up()
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
            
            AddColumn("dbo.Att_EmpAcademicCalendar", "EmpBranchId", c => c.Int(nullable: false,defaultValue:0));
            AddColumn("dbo.Att_EmpAcademicCalendar", "Year", c => c.Int(nullable: false, defaultValue: 0));
            AddColumn("dbo.Att_EmpAcademicCalendar", "WeekendDay", c => c.String());
            AddColumn("dbo.Att_EmpAcademicCalendar", "InTime", c => c.Time(nullable: false, precision: 7, defaultValue: TimeSpan.Zero));
            AddColumn("dbo.Att_EmpAcademicCalendar", "OutTime", c => c.Time(nullable: false, precision: 7, defaultValue: TimeSpan.Zero));
            AddColumn("dbo.Att_EmpAcademicCalendar", "DefaultLateInTime", c => c.Time(nullable: false, precision: 7, defaultValue: TimeSpan.Zero));
            AddColumn("dbo.Att_EmpAcademicCalendar", "DefaultEarlyOutTime", c => c.Time(nullable: false, precision: 7, defaultValue: TimeSpan.Zero));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Att_EmpAcademicCalendar", "DefaultEarlyOutTime");
            DropColumn("dbo.Att_EmpAcademicCalendar", "DefaultLateInTime");
            DropColumn("dbo.Att_EmpAcademicCalendar", "OutTime");
            DropColumn("dbo.Att_EmpAcademicCalendar", "InTime");
            DropColumn("dbo.Att_EmpAcademicCalendar", "WeekendDay");
            DropColumn("dbo.Att_EmpAcademicCalendar", "Year");
            DropColumn("dbo.Att_EmpAcademicCalendar", "EmpBranchId");
            DropTable("dbo.Att_EmpAcademicCalandarConfig");
        }
    }
}
