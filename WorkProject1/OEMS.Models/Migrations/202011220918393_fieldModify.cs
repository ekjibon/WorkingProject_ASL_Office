namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class fieldModify : DbMigration
    {
        public override void Up()
        {
            DropColumn("dbo.Task_Sprint", "IsEnd");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Task_Sprint", "IsEnd", c => c.Boolean(nullable: false));
        }
    }
}
