namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class requestdype : DbMigration
    {
        public override void Up()
        {
            AlterColumn("dbo.Ins_ECAClubConfig", "FromTime", c => c.DateTime());
            AlterColumn("dbo.Ins_ECAClubConfig", "ToTime", c => c.DateTime());
            AlterColumn("dbo.Student_Request", "Time", c => c.DateTime());
        }
        
        public override void Down()
        {
            AlterColumn("dbo.Student_Request", "Time", c => c.Time(precision: 7));
            AlterColumn("dbo.Ins_ECAClubConfig", "ToTime", c => c.Time(nullable: false, precision: 7));
            AlterColumn("dbo.Ins_ECAClubConfig", "FromTime", c => c.Time(nullable: false, precision: 7));
        }
    }
}
