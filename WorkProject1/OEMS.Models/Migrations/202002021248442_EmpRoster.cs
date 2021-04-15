namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class EmpRoster : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Att_EmpRoster", "IsRejected", c => c.Boolean(nullable: false));
            AddColumn("dbo.Att_EmpRoster", "IsTempRejected", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Att_EmpRoster", "IsTempRejected");
            DropColumn("dbo.Att_EmpRoster", "IsRejected");
        }
    }
}
