namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class TemporaryFieldAddEmpRoster : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Att_EmpRoster", "IsTemporary", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Att_EmpRoster", "IsTemporary");
        }
    }
}
