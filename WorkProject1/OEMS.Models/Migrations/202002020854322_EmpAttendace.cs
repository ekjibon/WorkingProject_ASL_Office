namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class EmpAttendace : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Emp_Attendance", "IsRejected", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Emp_Attendance", "IsRejected");
        }
    }
}
