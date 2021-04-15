namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Fieldadd : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Emp_EmpLeaveModify", "IsAdmin", c => c.Boolean(nullable: false,defaultValue:false));
            AddColumn("dbo.Emp_EmpLeaveModify", "IsLate", c => c.Boolean(nullable: false,defaultValue:false));
            AddColumn("dbo.Emp_EmpLeaveModify", "IsEarlyout", c => c.Boolean(nullable: false, defaultValue: false));
            AddColumn("dbo.Emp_EmpLeaveModify", "IsAbsent", c => c.Boolean(nullable: false, defaultValue: false));
            AddColumn("dbo.Emp_EmpLeaveModify", "IsLeave", c => c.Boolean(nullable: false, defaultValue: false));
            AddColumn("dbo.Emp_EmpLeaveModify", "IsNoAction", c => c.Boolean(nullable: false, defaultValue: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Emp_EmpLeaveModify", "IsNoAction");
            DropColumn("dbo.Emp_EmpLeaveModify", "IsLeave");
            DropColumn("dbo.Emp_EmpLeaveModify", "IsAbsent");
            DropColumn("dbo.Emp_EmpLeaveModify", "IsEarlyout");
            DropColumn("dbo.Emp_EmpLeaveModify", "IsLate");
            DropColumn("dbo.Emp_EmpLeaveModify", "IsAdmin");
        }
    }
}
