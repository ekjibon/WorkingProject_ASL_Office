namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class PPExpired : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Student_BasicInfo", "PPExpireDate", c => c.DateTime(nullable: false));
            AddColumn("dbo.Student_GuardianInfo", "F_PPExpireDate", c => c.DateTime(nullable: false));
            AddColumn("dbo.Student_GuardianInfo", "M_PPExpireDate", c => c.DateTime(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Student_GuardianInfo", "M_PPExpireDate");
            DropColumn("dbo.Student_GuardianInfo", "F_PPExpireDate");
            DropColumn("dbo.Student_BasicInfo", "PPExpireDate");
        }
    }
}
