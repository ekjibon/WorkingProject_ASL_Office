namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class fieldaddIsEnrollment : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Student_BasicInfo", "IsEnrollment", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Student_BasicInfo", "IsEnrollment");
        }
    }
}
