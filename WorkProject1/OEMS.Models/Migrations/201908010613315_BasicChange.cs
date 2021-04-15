namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class BasicChange : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Ins_Section", "LockOut", c => c.DateTime(nullable: false));
            AddColumn("dbo.Ins_Section", "PickUpTime", c => c.DateTime(nullable: false));
            AddColumn("dbo.Student_BasicInfo", "BirthCertificate", c => c.String());
            AddColumn("dbo.Student_BasicInfo", "RS_MUN", c => c.String());
            AddColumn("dbo.Student_BasicInfo", "MedicalAdvice", c => c.String());
            AddColumn("dbo.Student_BasicInfo", "PPNumber", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Student_BasicInfo", "PPNumber");
            DropColumn("dbo.Student_BasicInfo", "MedicalAdvice");
            DropColumn("dbo.Student_BasicInfo", "RS_MUN");
            DropColumn("dbo.Student_BasicInfo", "BirthCertificate");
            DropColumn("dbo.Ins_Section", "PickUpTime");
            DropColumn("dbo.Ins_Section", "LockOut");
        }
    }
}
