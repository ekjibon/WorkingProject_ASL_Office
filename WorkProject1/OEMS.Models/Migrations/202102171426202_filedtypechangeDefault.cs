namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class filedtypechangeDefault : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Att_EmpAcademicCalendar", "DefaultLITime", c => c.Int());
            AddColumn("dbo.Att_EmpAcademicCalendar", "DefaultEOTime", c => c.Int());
            DropColumn("dbo.Att_EmpAcademicCalendar", "DefaultLateInTime");
            DropColumn("dbo.Att_EmpAcademicCalendar", "DefaultEarlyOutTime");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Att_EmpAcademicCalendar", "DefaultEarlyOutTime", c => c.Time(nullable: false, precision: 7));
            AddColumn("dbo.Att_EmpAcademicCalendar", "DefaultLateInTime", c => c.Time(nullable: false, precision: 7));
            DropColumn("dbo.Att_EmpAcademicCalendar", "DefaultEOTime");
            DropColumn("dbo.Att_EmpAcademicCalendar", "DefaultLITime");
        }
    }
}
