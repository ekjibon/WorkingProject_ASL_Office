namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddcolumnOnEmpAttendance : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Emp_Attendance", "IsWithPay", c => c.Boolean());
            AddColumn("dbo.Emp_Attendance", "IsWithOutPay", c => c.Boolean());
            AddColumn("dbo.Emp_Attendance", "IsHalfDay", c => c.Boolean());
            AddColumn("dbo.Emp_Attendance", "IsAbsetLongHoliday", c => c.Boolean());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Emp_Attendance", "IsAbsetLongHoliday");
            DropColumn("dbo.Emp_Attendance", "IsHalfDay");
            DropColumn("dbo.Emp_Attendance", "IsWithOutPay");
            DropColumn("dbo.Emp_Attendance", "IsWithPay");
        }
    }
}
