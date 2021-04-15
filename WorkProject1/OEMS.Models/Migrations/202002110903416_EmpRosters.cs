namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class EmpRosters : DbMigration
    {
        public override void Up()
        {
            DropColumn("dbo.Att_EmpRoster", "Day");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Att_EmpRoster", "Day", c => c.Int(nullable: false));
        }
    }
}
