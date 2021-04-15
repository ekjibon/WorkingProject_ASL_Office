namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class IssueHistoryFieldAdd : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Task_IssueHistory", "PreviousId", c => c.Int());
            AddColumn("dbo.Task_IssueHistory", "PresentId", c => c.Int());
            DropColumn("dbo.Invoice_InvoiceGenerate", "Status");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Invoice_InvoiceGenerate", "Status", c => c.String(maxLength: 20));
            DropColumn("dbo.Task_IssueHistory", "PresentId");
            DropColumn("dbo.Task_IssueHistory", "PreviousId");
        }
    }
}
