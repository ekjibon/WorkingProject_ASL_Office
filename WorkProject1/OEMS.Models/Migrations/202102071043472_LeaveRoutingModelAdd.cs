namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class LeaveRoutingModelAdd : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.HR_LeaveRequestDetails",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        LeaveId = c.Int(nullable: false),
                        EmpId = c.Int(nullable: false),
                        LeaveCategoryId = c.Int(nullable: false),
                        EligibleLeave = c.Decimal(nullable: false, precision: 18, scale: 2),
                        LeaveAvailable = c.Decimal(nullable: false, precision: 18, scale: 2),
                        LeaveInHand = c.Decimal(nullable: false, precision: 18, scale: 2),
                        AdjustLeave = c.Decimal(nullable: false, precision: 18, scale: 2),
                        WithPayLeave = c.Decimal(nullable: false, precision: 18, scale: 2),
                        WithoutPayLeave = c.Decimal(nullable: false, precision: 18, scale: 2),
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
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.HR_LeaveRoutingConfig",
                c => new
                    {
                        RoutingId = c.Int(nullable: false, identity: true),
                        EmpId = c.Int(nullable: false),
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
                .PrimaryKey(t => t.RoutingId);
            
            CreateTable(
                "dbo.HR_LeaveRoutingHistory",
                c => new
                    {
                        LeaveHistoryId = c.Int(nullable: false, identity: true),
                        RoutingId = c.Int(nullable: false),
                        LeaveId = c.Int(nullable: false),
                        Comments = c.String(),
                        IsApprove = c.Boolean(nullable: false),
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
                .PrimaryKey(t => t.LeaveHistoryId);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.HR_LeaveRoutingHistory");
            DropTable("dbo.HR_LeaveRoutingConfig");
            DropTable("dbo.HR_LeaveRequestDetails");
        }
    }
}
