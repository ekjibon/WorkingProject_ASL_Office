namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class removeIsEnrollmentonFeesHeadConfig : DbMigration
    {
        public override void Up()
        {
            DropColumn("dbo.Fees_HeadAmountConfig", "IsEnrollment");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Fees_HeadAmountConfig", "IsEnrollment", c => c.Boolean(nullable: false));
        }
    }
}
