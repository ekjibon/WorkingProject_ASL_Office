namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class StudentClubFieldAdd2 : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Ins_ClassInfo", "IsWholeSession", c => c.Boolean(nullable: false));
            AddColumn("dbo.Ins_ClassInfo", "IsWholeTerm", c => c.Boolean(nullable: false));
            AddColumn("dbo.Ins_ECAClubConfig", "CategoryName", c => c.String());
            AddColumn("dbo.Stu_ECAAttendance", "TermId", c => c.Int(nullable: false));
            AddColumn("dbo.Stu_ECAAttendance", "DayId", c => c.Int(nullable: false));
            AddColumn("dbo.Stu_ECAAttendance", "IsPresent", c => c.Boolean(nullable: false));
            DropColumn("dbo.Ins_ECAClubConfig", "IsRepeatYear");
            DropColumn("dbo.Stu_Clubs", "CategoryName");
            DropColumn("dbo.Stu_Clubs", "DayId");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Stu_Clubs", "DayId", c => c.Int(nullable: false));
            AddColumn("dbo.Stu_Clubs", "CategoryName", c => c.String());
            AddColumn("dbo.Ins_ECAClubConfig", "IsRepeatYear", c => c.Boolean(nullable: false));
            DropColumn("dbo.Stu_ECAAttendance", "IsPresent");
            DropColumn("dbo.Stu_ECAAttendance", "DayId");
            DropColumn("dbo.Stu_ECAAttendance", "TermId");
            DropColumn("dbo.Ins_ECAClubConfig", "CategoryName");
            DropColumn("dbo.Ins_ClassInfo", "IsWholeTerm");
            DropColumn("dbo.Ins_ClassInfo", "IsWholeSession");
        }
    }
}
