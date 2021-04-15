namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addDueDate : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Inv_Quotation", "DueDate", c => c.DateTime(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Inv_Quotation", "DueDate");
        }
    }
}
