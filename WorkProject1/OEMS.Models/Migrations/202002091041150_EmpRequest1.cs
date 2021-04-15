namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class EmpRequest1 : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Emp_Request", "LeaveCategoryId", c => c.Int());
            DropColumn("dbo.Emp_Request", "LeaveTypeId");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Emp_Request", "LeaveTypeId", c => c.Int());
            DropColumn("dbo.Emp_Request", "LeaveCategoryId");
        }
    }
}
