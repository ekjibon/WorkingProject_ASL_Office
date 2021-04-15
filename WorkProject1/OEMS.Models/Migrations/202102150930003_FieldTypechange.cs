namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class FieldTypechange : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Emp_Attendance", "EmpRequestId", c => c.Int());
            AlterColumn("dbo.Emp_Attendance", "IsEarlyOut", c => c.Boolean());
            AlterColumn("dbo.Emp_Attendance", "RequestId", c => c.Int());
        }
        
        public override void Down()
        {
            AlterColumn("dbo.Emp_Attendance", "RequestId", c => c.Int(nullable: false));
            AlterColumn("dbo.Emp_Attendance", "IsEarlyOut", c => c.Boolean(nullable: false));
            DropColumn("dbo.Emp_Attendance", "EmpRequestId");
        }
    }
}
