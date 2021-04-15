namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Emplconfig : DbMigration
    {
        public override void Up()
        {
            AlterColumn("dbo.Emp_MeetingConfig", "StartTime", c => c.DateTime());
            AlterColumn("dbo.Emp_MeetingConfig", "EndTime", c => c.DateTime());
        }
        
        public override void Down()
        {
            AlterColumn("dbo.Emp_MeetingConfig", "EndTime", c => c.String());
            AlterColumn("dbo.Emp_MeetingConfig", "StartTime", c => c.String());
        }
    }
}
