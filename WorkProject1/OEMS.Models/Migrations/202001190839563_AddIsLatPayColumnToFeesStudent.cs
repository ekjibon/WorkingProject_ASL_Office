namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddIsLatPayColumnToFeesStudent : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Fees_Student", "IsLatePay", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Fees_Student", "IsLatePay");
        }
    }
}
