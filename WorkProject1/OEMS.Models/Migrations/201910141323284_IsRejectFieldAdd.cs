namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class IsRejectFieldAdd : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.ACC_Transaction", "IsReject", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.ACC_Transaction", "IsReject");
        }
    }
}
