namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class TaskModelModify : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Emp_BasicInfo", "TeamId", c => c.Int(nullable: false));
            AddColumn("dbo.Task_Issue", "StartDate", c => c.DateTime());
            AddColumn("dbo.Task_Issue", "EndDate", c => c.DateTime());
            AddColumn("dbo.Task_Project", "IsSupport", c => c.Boolean(nullable: false));
            AddColumn("dbo.Task_Sprint", "IsSupport", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Task_Sprint", "IsSupport");
            DropColumn("dbo.Task_Project", "IsSupport");
            DropColumn("dbo.Task_Issue", "EndDate");
            DropColumn("dbo.Task_Issue", "StartDate");
            DropColumn("dbo.Emp_BasicInfo", "TeamId");
        }
    }
}
