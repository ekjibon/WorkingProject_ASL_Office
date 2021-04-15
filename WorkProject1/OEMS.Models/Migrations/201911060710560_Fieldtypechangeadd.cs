namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Fieldtypechangeadd : DbMigration
    {
        public override void Up()
        {
            AlterColumn("dbo.Fees_HeadAmountConfig", "DueMonth", c => c.DateTime());
        }
        
        public override void Down()
        {
            AlterColumn("dbo.Fees_HeadAmountConfig", "DueMonth", c => c.DateTime(nullable: false));
        }
    }
}
