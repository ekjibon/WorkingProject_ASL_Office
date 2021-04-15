namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class updateColumn : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Emp_BasicInfo", "PFACNo", c => c.String());
            AddColumn("dbo.Emp_BasicInfo", "PFBankName", c => c.String());
            AddColumn("dbo.Emp_BasicInfo", "PFBankBranch", c => c.String());
            AddColumn("dbo.Emp_BasicInfo", "WelfareACNo", c => c.String());
            AddColumn("dbo.Emp_BasicInfo", "MembershipNo", c => c.String());
            DropColumn("dbo.Emp_BasicInfo", "IsResignationApplied");
            DropColumn("dbo.Emp_BasicInfo", "ServeDate");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Emp_BasicInfo", "ServeDate", c => c.DateTime());
            AddColumn("dbo.Emp_BasicInfo", "IsResignationApplied", c => c.Boolean());
            DropColumn("dbo.Emp_BasicInfo", "MembershipNo");
            DropColumn("dbo.Emp_BasicInfo", "WelfareACNo");
            DropColumn("dbo.Emp_BasicInfo", "PFBankBranch");
            DropColumn("dbo.Emp_BasicInfo", "PFBankName");
            DropColumn("dbo.Emp_BasicInfo", "PFACNo");
        }
    }
}
