namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addeca : DbMigration
    {
        public override void Up()
        {
           
        }
        
        public override void Down()
        {
            AddColumn("dbo.Student_Request", "CurriculamUsed", c => c.String());
            AlterColumn("dbo.Student_Request", "StudentId", c => c.Int());
            DropColumn("dbo.Student_Request", "MeetingIssue");
            DropTable("dbo.Stu_ClubsHistory");
            DropTable("dbo.Stu_Clubs");
            DropTable("dbo.Portal_Document");
            DropTable("dbo.Emp_MeetingConfig");
            DropTable("dbo.Ins_ECAClub");
            DropTable("dbo.Stu_ECAAttendance");
            DropTable("dbo.Ins_ECAClubConfig");
        }
    }
}
