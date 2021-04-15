namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddICT : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Res_SubjectSetup", "IsICT", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Res_SubjectSetup", "IsICT");
        }
    }
}
