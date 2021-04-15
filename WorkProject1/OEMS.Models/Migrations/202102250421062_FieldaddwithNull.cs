namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class FieldaddwithNull : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Emp_Attendance", "SoftwareResult", c => c.String());
            AlterColumn("dbo.Emp_Attendance", "InTime", c => c.DateTime());
        }
        
        public override void Down()
        {
            AlterColumn("dbo.Emp_Attendance", "InTime", c => c.DateTime(nullable: false));
            DropColumn("dbo.Emp_Attendance", "SoftwareResult");
        }
    }
}
