namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class subjectdetail : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "MidYearSubObtMarks", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "MidYearSubConvtMarks", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "WinterMarks", c => c.Decimal(precision: 18, scale: 2));
            AlterColumn("dbo.Emp_MeetingConfig", "StartTime", c => c.String());
            AlterColumn("dbo.Emp_MeetingConfig", "EndTime", c => c.String());
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "AutumnFullMarks");
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "AutumnMarksPersentage");
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "WithAutumnMarks");
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "WinterTotalMarks");
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "WinterMarksPersentage");
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "WithWinterMarks");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "WithWinterMarks", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "WinterMarksPersentage", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "WinterTotalMarks", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "WithAutumnMarks", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "AutumnMarksPersentage", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "AutumnFullMarks", c => c.Decimal(precision: 18, scale: 2));
            AlterColumn("dbo.Emp_MeetingConfig", "EndTime", c => c.Time(nullable: false, precision: 7));
            AlterColumn("dbo.Emp_MeetingConfig", "StartTime", c => c.Time(nullable: false, precision: 7));
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "WinterMarks");
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "MidYearSubConvtMarks");
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "MidYearSubObtMarks");
        }
    }
}
