namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ProjectIdAddSprintModel : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Task_Sprint", "ProjectId", c => c.Int(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Task_Sprint", "ProjectId");
        }
    }
}
