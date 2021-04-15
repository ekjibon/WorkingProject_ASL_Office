namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addcolumnLeavetype040202111 : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Emp_Request", "LeaveTypeCategory", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Emp_Request", "LeaveTypeCategory");
        }
    }
}
