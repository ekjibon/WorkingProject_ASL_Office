namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddEmpClanderField : DbMigration
    {
        public override void Up()
        {
            RenameTable(name: "dbo.Att_EmpAcademicCalendar", newName: "Emp_AcademicCalendar");
        }
        
        public override void Down()
        {
            RenameTable(name: "dbo.Emp_AcademicCalendar", newName: "Att_EmpAcademicCalendar");
        }
    }
}
