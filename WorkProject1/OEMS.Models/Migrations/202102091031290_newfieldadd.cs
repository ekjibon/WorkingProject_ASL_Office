namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class newfieldadd : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.HR_EmpLeaveQuota", "RoutingId", c => c.Int(nullable: false,defaultValue:0));
        }
        
        public override void Down()
        {
            DropColumn("dbo.HR_EmpLeaveQuota", "RoutingId");
        }
    }
}
