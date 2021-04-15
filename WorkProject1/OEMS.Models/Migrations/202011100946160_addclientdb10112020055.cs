namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addclientdb10112020055 : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.CRM_Clients_db",
                c => new
                    {
                        ClientsDbId = c.Int(nullable: false, identity: true),
                        ClientId = c.Int(nullable: false),
                        Host = c.String(nullable: false, maxLength: 30),
                        DbName = c.String(),
                        DbUserName = c.String(),
                        DbPass = c.String(),
                        Type = c.String(nullable: false, maxLength: 5),
                        IsDefault = c.Boolean(nullable: false),
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
                .PrimaryKey(t => t.ClientsDbId)
                .ForeignKey("dbo.CRM_Client", t => t.ClientId, cascadeDelete: true)
                .Index(t => t.ClientId);
            
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.CRM_Clients_db", "ClientId", "dbo.CRM_Client");
            DropIndex("dbo.CRM_Clients_db", new[] { "ClientId" });
            DropTable("dbo.CRM_Clients_db");
        }
    }
}
