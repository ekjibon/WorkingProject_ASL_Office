namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddModelHeadComment : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Res_HeadsComment",
                c => new
                    {
                        HeadsCommentID = c.Int(nullable: false, identity: true),
                        SessionID = c.Int(nullable: false),
                        BranchID = c.Int(nullable: false),
                        ShiftID = c.Int(nullable: false),
                        ClassID = c.Int(nullable: false),
                        SectionID = c.Int(nullable: false),
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
                .PrimaryKey(t => t.HeadsCommentID);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.Res_HeadsComment");
        }
    }
}
