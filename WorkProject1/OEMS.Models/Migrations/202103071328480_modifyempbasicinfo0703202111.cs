namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class modifyempbasicinfo0703202111 : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Emp_BasicInfo", "SkypeUsername", c => c.String());
            AddColumn("dbo.Emp_BasicInfo", "WhatsAppNumber", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Emp_BasicInfo", "WhatsAppNumber");
            DropColumn("dbo.Emp_BasicInfo", "SkypeUsername");
        }
    }
}
