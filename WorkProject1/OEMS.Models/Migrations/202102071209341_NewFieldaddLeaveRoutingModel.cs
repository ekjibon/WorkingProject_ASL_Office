namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class NewFieldaddLeaveRoutingModel : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.HR_LeaveRoutingHistory", "IsReject", c => c.Boolean(nullable: false));
            AddColumn("dbo.HR_LeaveRoutingHistory", "RejectedBy", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.HR_LeaveRoutingHistory", "RejectedBy");
            DropColumn("dbo.HR_LeaveRoutingHistory", "IsReject");
        }
    }
}
