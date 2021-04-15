namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ModelModify : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Task_IssueWebLink",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        IssueId = c.Int(nullable: false),
                        Url = c.String(),
                        Description = c.String(),
                    })
                .PrimaryKey(t => t.Id);
            
            AddColumn("dbo.Task_Comments", "IssueId", c => c.Int(nullable: false));
            AddColumn("dbo.Task_Comments", "ParentId", c => c.Int());
            AlterColumn("dbo.Task_Comments", "Type", c => c.String());
            DropColumn("dbo.Task_Comments", "RefId");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Task_Comments", "RefId", c => c.Int(nullable: false));
            AlterColumn("dbo.Task_Comments", "Type", c => c.Int(nullable: false));
            DropColumn("dbo.Task_Comments", "ParentId");
            DropColumn("dbo.Task_Comments", "IssueId");
            DropTable("dbo.Task_IssueWebLink");
        }
    }
}
