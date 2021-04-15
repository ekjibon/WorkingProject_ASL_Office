namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class newfieldadd1 : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Emp_Attendance", "AttStatusType", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Emp_Attendance", "AttStatusType");
        }
    }
}
