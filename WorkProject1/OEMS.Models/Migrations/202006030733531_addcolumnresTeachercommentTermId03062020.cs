namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addcolumnresTeachercommentTermId03062020 : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Res_ClassResultComments", "TermId", c => c.Int());
            AddColumn("dbo.HR_EmpLeaveQuota", "CalenderId", c => c.Int());
            AddColumn("dbo.Emp_Request", "AdjustableDay", c => c.Int());
            AddColumn("dbo.Emp_Request", "UnadjustedDay", c => c.Int());
            AddColumn("dbo.Emp_Request", "Withpay", c => c.Int());
            AddColumn("dbo.Emp_Request", "WithOutpay", c => c.Int());
            AddColumn("dbo.Emp_Request", "MaternityLeaveType", c => c.Int());
            AlterColumn("dbo.Emp_BasicInfo", "IsResignationApplied", c => c.Boolean());
        }
        
        public override void Down()
        {
            AlterColumn("dbo.Emp_BasicInfo", "IsResignationApplied", c => c.Boolean(nullable: false));
            DropColumn("dbo.Emp_Request", "MaternityLeaveType");
            DropColumn("dbo.Emp_Request", "WithOutpay");
            DropColumn("dbo.Emp_Request", "Withpay");
            DropColumn("dbo.Emp_Request", "UnadjustedDay");
            DropColumn("dbo.Emp_Request", "AdjustableDay");
            DropColumn("dbo.HR_EmpLeaveQuota", "CalenderId");
            DropColumn("dbo.Res_ClassResultComments", "TermId");
        }
    }
}
