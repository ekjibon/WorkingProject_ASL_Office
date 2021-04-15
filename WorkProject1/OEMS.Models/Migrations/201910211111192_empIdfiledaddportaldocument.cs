namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class empIdfiledaddportaldocument : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Portal_Document", "EmpId", c => c.Int());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Portal_Document", "EmpId");
        }
    }
}
