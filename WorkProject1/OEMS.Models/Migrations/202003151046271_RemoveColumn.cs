namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class RemoveColumn : DbMigration
    {
        public override void Up()
        {
            DropColumn("dbo.Res_HeadsCommentDetails", "IsDeleted");
            DropColumn("dbo.Res_HeadsCommentDetails", "AddBy");
            DropColumn("dbo.Res_HeadsCommentDetails", "AddDate");
            DropColumn("dbo.Res_HeadsCommentDetails", "UpdateBy");
            DropColumn("dbo.Res_HeadsCommentDetails", "UpdateDate");
            DropColumn("dbo.Res_HeadsCommentDetails", "Remarks");
            DropColumn("dbo.Res_HeadsCommentDetails", "Status");
            DropColumn("dbo.Res_HeadsCommentDetails", "IP");
            DropColumn("dbo.Res_HeadsCommentDetails", "MacAddress");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Res_HeadsCommentDetails", "MacAddress", c => c.String(maxLength: 50));
            AddColumn("dbo.Res_HeadsCommentDetails", "IP", c => c.String(maxLength: 50));
            AddColumn("dbo.Res_HeadsCommentDetails", "Status", c => c.String(maxLength: 20));
            AddColumn("dbo.Res_HeadsCommentDetails", "Remarks", c => c.String(maxLength: 100));
            AddColumn("dbo.Res_HeadsCommentDetails", "UpdateDate", c => c.DateTime());
            AddColumn("dbo.Res_HeadsCommentDetails", "UpdateBy", c => c.String(maxLength: 128));
            AddColumn("dbo.Res_HeadsCommentDetails", "AddDate", c => c.DateTime());
            AddColumn("dbo.Res_HeadsCommentDetails", "AddBy", c => c.String(maxLength: 128));
            AddColumn("dbo.Res_HeadsCommentDetails", "IsDeleted", c => c.Boolean(nullable: false));
        }
    }
}
