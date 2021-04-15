namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addPPEDate : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Emp_BasicInfo", "PPExpireDate", c => c.DateTime(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Emp_BasicInfo", "PPExpireDate");
        }
    }
}
