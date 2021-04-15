namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class FieldTypechange2 : DbMigration
    {
        public override void Up()
        {
            AlterColumn("dbo.Emp_Attendance", "IsLate", c => c.Boolean());
        }
        
        public override void Down()
        {
            AlterColumn("dbo.Emp_Attendance", "IsLate", c => c.Boolean(nullable: false));
        }
    }
}
