namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addmodelClients03100202001 : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.CRM_Client",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        FullName = c.String(),
                        ShortName = c.String(),
                        Code = c.String(),
                        Address = c.String(),
                        BaseUrl = c.String(),
                        Apps = c.String(),
                        WebPortal = c.String(),
                        SMS = c.String(),
                        Subscription = c.String(),
                        ActivityStatus = c.String(),
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
            DropTable("dbo.CRM_Client");
        }
    }
}
