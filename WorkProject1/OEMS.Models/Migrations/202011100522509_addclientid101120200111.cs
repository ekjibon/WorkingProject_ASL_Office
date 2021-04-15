namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addclientid101120200111 : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.CRM_Client", "ClientId", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.CRM_Client", "ClientId");
        }
    }
}
