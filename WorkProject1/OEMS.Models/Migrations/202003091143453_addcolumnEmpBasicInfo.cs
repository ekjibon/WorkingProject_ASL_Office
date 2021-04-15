namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addcolumnEmpBasicInfo : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Emp_BasicInfo", "IsResignationApplied", c => c.Boolean());
            AddColumn("dbo.Emp_BasicInfo", "ServeDate", c => c.DateTime());
            DropColumn("dbo.Emp_BasicInfo", "PFACNo");
            DropColumn("dbo.Emp_BasicInfo", "PFBankName");
            DropColumn("dbo.Emp_BasicInfo", "PFBankBranch");
            DropColumn("dbo.Emp_BasicInfo", "WelfareACNo");
            DropColumn("dbo.Emp_BasicInfo", "MembershipNo");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Emp_BasicInfo", "MembershipNo", c => c.String());
            AddColumn("dbo.Emp_BasicInfo", "WelfareACNo", c => c.String());
            AddColumn("dbo.Emp_BasicInfo", "PFBankBranch", c => c.String());
            AddColumn("dbo.Emp_BasicInfo", "PFBankName", c => c.String());
            AddColumn("dbo.Emp_BasicInfo", "PFACNo", c => c.String());
            DropColumn("dbo.Emp_BasicInfo", "ServeDate");
            DropColumn("dbo.Emp_BasicInfo", "IsResignationApplied");
        }
    }
}
