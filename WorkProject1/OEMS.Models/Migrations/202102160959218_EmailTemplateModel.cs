namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class EmailTemplateModel : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Com_EmailTemplate",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        EmailType = c.String(),
                        Subject = c.String(),
                        BodyTemplate = c.String(),
                        From = c.String(),
                        FromDisplayName = c.String(),
                        To = c.String(),
                        CC = c.String(),
                        BCC = c.String(),
                        IsBodyHtml = c.Boolean(nullable: false),
                        HasAttachment = c.Boolean(nullable: false),
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
            
        }
        
        public override void Down()
        {
            DropTable("dbo.Com_EmailTemplate");
        }
    }
}
