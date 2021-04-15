namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class empupdated : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Res_ClassResultComments", "FailSubComments", c => c.String());
            AddColumn("dbo.Emp_LIEO", "EmpId", c => c.Int());
            AlterColumn("dbo.Ins_Section", "LockOut", c => c.DateTime());
            AlterColumn("dbo.Ins_Section", "PickUpTime", c => c.DateTime());
            DropColumn("dbo.Emp_LIEO", "BranchId");
            DropColumn("dbo.Emp_LIEO", "SessionId");
            DropColumn("dbo.Emp_LIEO", "ShiftId");
            DropColumn("dbo.Emp_LIEO", "ClassId");
            DropColumn("dbo.Emp_LIEO", "SectionId");
            DropColumn("dbo.Emp_LIEO", "TypeId");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Emp_LIEO", "TypeId", c => c.Int(nullable: false));
            AddColumn("dbo.Emp_LIEO", "SectionId", c => c.Int());
            AddColumn("dbo.Emp_LIEO", "ClassId", c => c.Int());
            AddColumn("dbo.Emp_LIEO", "ShiftId", c => c.Int());
            AddColumn("dbo.Emp_LIEO", "SessionId", c => c.Int(nullable: false));
            AddColumn("dbo.Emp_LIEO", "BranchId", c => c.Int());
            AlterColumn("dbo.Ins_Section", "PickUpTime", c => c.DateTime(nullable: false));
            AlterColumn("dbo.Ins_Section", "LockOut", c => c.DateTime(nullable: false));
            DropColumn("dbo.Emp_LIEO", "EmpId");
            DropColumn("dbo.Res_ClassResultComments", "FailSubComments");
        }
    }
}
