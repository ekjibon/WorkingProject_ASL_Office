namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class EmpBasicInfo_Updated : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Emp_BasicInfo", "JoiningSalary", c => c.String());
            AddColumn("dbo.Emp_BasicInfo", "ConfirmationSalary", c => c.String());
            AddColumn("dbo.Emp_BasicInfo", "CurrentSalary", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Emp_BasicInfo", "CurrentSalary");
            DropColumn("dbo.Emp_BasicInfo", "ConfirmationSalary");
            DropColumn("dbo.Emp_BasicInfo", "JoiningSalary");
        }
    }
}
