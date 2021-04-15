namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addColumnIsResignation : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Emp_BasicInfo", "IsResignationApplied", c => c.Boolean());
            AddColumn("dbo.Emp_BasicInfo", "ServeDate", c => c.DateTime());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Emp_BasicInfo", "ServeDate");
            DropColumn("dbo.Emp_BasicInfo", "IsResignationApplied");
        }
    }
}
