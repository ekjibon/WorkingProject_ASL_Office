namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class FieldAddEmpRoster : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Att_EmpRoster", "TempInTime", c => c.Time(precision: 7));
            AddColumn("dbo.Att_EmpRoster", "TempOutTime", c => c.Time(precision: 7));
            AddColumn("dbo.Att_EmpRoster", "IsTempApproved", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Att_EmpRoster", "IsTempApproved");
            DropColumn("dbo.Att_EmpRoster", "TempOutTime");
            DropColumn("dbo.Att_EmpRoster", "TempInTime");
        }
    }
}
