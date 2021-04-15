namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class filedtypechangeDefaultAttendance : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Emp_Attendance", "DefaultLITime", c => c.Int());
            AddColumn("dbo.Emp_Attendance", "DefaultEOTime", c => c.Int());
            DropColumn("dbo.Emp_Attendance", "DefaultLateInTime");
            DropColumn("dbo.Emp_Attendance", "DefaultEarlyOutTime");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Emp_Attendance", "DefaultEarlyOutTime", c => c.Time(nullable: false, precision: 7));
            AddColumn("dbo.Emp_Attendance", "DefaultLateInTime", c => c.Time(nullable: false, precision: 7));
            DropColumn("dbo.Emp_Attendance", "DefaultEOTime");
            DropColumn("dbo.Emp_Attendance", "DefaultLITime");
        }
    }
}
