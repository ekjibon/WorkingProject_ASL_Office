namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addIsEnrollmentIsOldStudentIsCashCollectionColumnonfees_Student : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Fees_Student", "IsEnrollment", c => c.Boolean(nullable: false));
            AddColumn("dbo.Fees_Student", "IsOldStudent", c => c.Boolean(nullable: false));
            AddColumn("dbo.Fees_Student", "IsCashCollection", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Fees_Student", "IsCashCollection");
            DropColumn("dbo.Fees_Student", "IsOldStudent");
            DropColumn("dbo.Fees_Student", "IsEnrollment");
        }
    }
}
