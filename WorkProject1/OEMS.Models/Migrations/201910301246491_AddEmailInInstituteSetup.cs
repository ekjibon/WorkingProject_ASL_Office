namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddEmailInInstituteSetup : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.SchoolSetups", "Email_1", c => c.String(maxLength: 150));
        }
        
        public override void Down()
        {
            DropColumn("dbo.SchoolSetups", "Email_1");
        }
    }
}
