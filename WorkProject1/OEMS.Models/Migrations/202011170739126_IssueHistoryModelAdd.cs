namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class IssueHistoryModelAdd : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Task_IssueHistory",
                c => new
                    {
                        HistoryId = c.Long(nullable: false, identity: true),
                        UserId = c.String(),
                        Type = c.String(),
                        Description = c.String(),
                        IssueId = c.Int(nullable: false),
                        ParentId = c.Int(),
                        SprinttId = c.Int(),
                        ModifyDate = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.HistoryId);
            
            AddColumn("dbo.Task_Issue", "StatusId", c => c.Int());
            AddColumn("dbo.Task_Sprint", "Goal", c => c.String());
            AddColumn("dbo.Task_Sprint", "PersonId", c => c.String());
            AddColumn("dbo.Task_Sprint", "IsStart", c => c.Boolean(nullable: false));
            AddColumn("dbo.Task_Sprint", "IsEnd", c => c.Boolean(nullable: false));
            AddColumn("dbo.Task_TaskActivityLog", "StatusId", c => c.Int());
            DropColumn("dbo.Task_Issue", "BugAttachmentId");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Task_Issue", "BugAttachmentId", c => c.Int());
            DropColumn("dbo.Task_TaskActivityLog", "StatusId");
            DropColumn("dbo.Task_Sprint", "IsEnd");
            DropColumn("dbo.Task_Sprint", "IsStart");
            DropColumn("dbo.Task_Sprint", "PersonId");
            DropColumn("dbo.Task_Sprint", "Goal");
            DropColumn("dbo.Task_Issue", "StatusId");
            DropTable("dbo.Task_IssueHistory");
        }
    }
}
