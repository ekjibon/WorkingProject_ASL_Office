namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class EnrollmentFieldadd : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Fees_HeadAmountConfig", "IsEnrollment", c => c.Boolean(nullable: false));
            AddColumn("dbo.Fees_HeadAmountConfig", "DueMonth", c => c.Int(nullable: true));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Fees_HeadAmountConfig", "DueMonth");
            DropColumn("dbo.Fees_HeadAmountConfig", "IsEnrollment");
        }
    }
}
