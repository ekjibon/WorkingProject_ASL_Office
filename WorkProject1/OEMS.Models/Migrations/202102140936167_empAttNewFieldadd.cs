namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class empAttNewFieldadd : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Emp_Attendance", "AdminStatus", c => c.String());
            AddColumn("dbo.Emp_Attendance", "ApproveBy", c => c.String());
            AddColumn("dbo.Emp_Attendance", "ApproveNarration", c => c.String());
            AddColumn("dbo.Emp_Attendance", "FinalStatus", c => c.String());
            AddColumn("dbo.Emp_Attendance", "FinalNarration", c => c.String());
            AddColumn("dbo.Emp_Attendance", "RequestId", c => c.Int(nullable: false,defaultValue:0));
            AddColumn("dbo.Emp_Attendance", "Reason", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Emp_Attendance", "Reason");
            DropColumn("dbo.Emp_Attendance", "RequestId");
            DropColumn("dbo.Emp_Attendance", "FinalNarration");
            DropColumn("dbo.Emp_Attendance", "FinalStatus");
            DropColumn("dbo.Emp_Attendance", "ApproveNarration");
            DropColumn("dbo.Emp_Attendance", "ApproveBy");
            DropColumn("dbo.Emp_Attendance", "AdminStatus");
        }
    }
}
