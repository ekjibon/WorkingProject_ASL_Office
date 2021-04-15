namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class EmpRosterAddColomn : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Att_EmpRoster", "Day", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Att_EmpRoster", "Day");
        }
    }
}
