namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addtableHeadcommentsdetails : DbMigration
    {
        public override void Up()
        {
            RenameTable(name: "dbo.Res_HeadsComment", newName: "Res_HeadsCommentMaster");
            CreateTable(
                "dbo.Res_HeadsCommentDetails",
                c => new
                    {
                        ID = c.Int(nullable: false, identity: true),
                        HeadsCommentID = c.Int(nullable: false),
                        Comments = c.String(),
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
                .PrimaryKey(t => t.ID);
            
            DropColumn("dbo.Res_HeadsCommentMaster", "Comments");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Res_HeadsCommentMaster", "Comments", c => c.String());
            DropTable("dbo.Res_HeadsCommentDetails");
            RenameTable(name: "dbo.Res_HeadsCommentMaster", newName: "Res_HeadsComment");
        }
    }
}
