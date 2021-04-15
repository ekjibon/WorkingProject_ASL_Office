namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class FieldAddEmpAttendance : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Emp_Attendance", "IsChangedStatus", c => c.Boolean(nullable: false));
            AddColumn("dbo.Emp_Attendance", "IsApproved", c => c.Boolean(nullable: false));
            DropColumn("dbo.Att_EmpRoster", "IsModifyApproved");
            DropColumn("dbo.Att_EmpRoster", "ModifyStatus");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Att_EmpRoster", "ModifyStatus", c => c.String());
            AddColumn("dbo.Att_EmpRoster", "IsModifyApproved", c => c.Boolean(nullable: false));
            DropColumn("dbo.Emp_Attendance", "IsApproved");
            DropColumn("dbo.Emp_Attendance", "IsChangedStatus");
        }
    }
}
