namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addtaxkissue12112020112 : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Task_Issue",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        ProjectId = c.Int(),
                        IssueTypeId = c.Int(),
                        BugAttachmentId = c.Int(),
                        SprintId = c.Int(),
                        AssigneeId = c.Int(),
                        ReporterId = c.Int(),
                        ClientId = c.Int(),
                        Title = c.String(),
                        Description = c.String(),
                        Priority = c.String(),
                        AlertRule = c.String(),
                        DueDate = c.DateTime(),
                        ParentId = c.Int(),
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
                "dbo.Task_IssueType",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        IssueTypeName = c.String(),
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
                "dbo.Task_Status",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        StatusName = c.String(),
                        ColorCode = c.String(),
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
            
            AddColumn("dbo.Invoice_BillingHead", "BillingHeadType", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Invoice_BillingHead", "BillingHeadType");
            DropTable("dbo.Task_Status");
            DropTable("dbo.Task_IssueType");
            DropTable("dbo.Task_Issue");
        }
    }
}
