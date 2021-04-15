namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class LeaveRouteConfigDetailsModelAdd : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.HR_LeaveRoutingConfigDetails",
                c => new
                    {
                        DetailsId = c.Int(nullable: false, identity: true),
                        RoutingId = c.Int(nullable: false),
                        NextApproval = c.String(),
                        SerialNo = c.Int(nullable: false),
                        IsMandatory = c.Boolean(nullable: false),
                        IsFinalApprove = c.Boolean(nullable: false),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.DetailsId);
            
            AddColumn("dbo.HR_LeaveQuota", "RoutingId", c => c.Int(nullable: false));
            AddColumn("dbo.HR_LeaveRoutingConfig", "RouteName", c => c.String());
            AddColumn("dbo.HR_LeaveRoutingConfig", "DesignationId", c => c.Int(nullable: false));
            AddColumn("dbo.HR_LeaveRoutingConfig", "DisplayOrder", c => c.Int(nullable: false));
            DropColumn("dbo.HR_LeaveRoutingConfig", "EmpId");
            DropColumn("dbo.HR_LeaveRoutingConfig", "NextApproval");
            DropColumn("dbo.HR_LeaveRoutingConfig", "SerialNo");
            DropColumn("dbo.HR_LeaveRoutingConfig", "IsMandatory");
            DropColumn("dbo.HR_LeaveRoutingConfig", "IsFinalApprove");
        }
        
        public override void Down()
        {
            AddColumn("dbo.HR_LeaveRoutingConfig", "IsFinalApprove", c => c.Boolean(nullable: false));
            AddColumn("dbo.HR_LeaveRoutingConfig", "IsMandatory", c => c.Boolean(nullable: false));
            AddColumn("dbo.HR_LeaveRoutingConfig", "SerialNo", c => c.Int(nullable: false));
            AddColumn("dbo.HR_LeaveRoutingConfig", "NextApproval", c => c.String());
            AddColumn("dbo.HR_LeaveRoutingConfig", "EmpId", c => c.Int(nullable: false));
            DropColumn("dbo.HR_LeaveRoutingConfig", "DisplayOrder");
            DropColumn("dbo.HR_LeaveRoutingConfig", "DesignationId");
            DropColumn("dbo.HR_LeaveRoutingConfig", "RouteName");
            DropColumn("dbo.HR_LeaveQuota", "RoutingId");
            DropTable("dbo.HR_LeaveRoutingConfigDetails");
        }
    }
}
