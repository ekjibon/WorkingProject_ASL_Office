namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class DayIdFieldadd : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Emp_MeetingConfig", "DayId", c => c.Int());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Emp_MeetingConfig", "DayId");
        }
    }
}
