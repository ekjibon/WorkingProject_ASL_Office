namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addcolDayAndDayTypeOnEmpRoster : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Att_EmpRoster", "Day", c => c.Int(nullable: false));
            AddColumn("dbo.Att_EmpRoster", "DayType", c => c.String(maxLength: 20));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Att_EmpRoster", "DayType");
            DropColumn("dbo.Att_EmpRoster", "Day");
        }
    }
}
