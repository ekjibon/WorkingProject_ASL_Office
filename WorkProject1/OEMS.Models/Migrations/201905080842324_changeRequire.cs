namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class changeRequire : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Res_MainExam", "TermId", c => c.Int(nullable: false));
            AddColumn("dbo.Res_SubjectSetup", "TermId", c => c.Int(nullable: false));
            AddColumn("dbo.Res_SubExam", "IsMidYear", c => c.Boolean(nullable: false));
            AddColumn("dbo.Res_SubExam", "IsFinal", c => c.Boolean(nullable: false));
            AddColumn("dbo.Res_GradingSystem", "TermId", c => c.Int(nullable: false));
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "TotalExamNo", c => c.Int(nullable: false));
            AddColumn("dbo.Res_MarksMigratedSetup", "TermId", c => c.Int(nullable: false));
            AddColumn("dbo.Res_StudentSubject", "TermId", c => c.Int(nullable: false));
            DropColumn("dbo.Res_SubjectSetup", "NoEffectOnExam");
            DropColumn("dbo.Res_SubjectSetup", "ImpactOnMeritPosition");
            DropColumn("dbo.Res_SubjectSetup", "IsThird");
            DropColumn("dbo.Res_SubjectSetup", "IsFourth");
            DropColumn("dbo.Res_SubjectSetup", "IsReligious");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Res_SubjectSetup", "IsReligious", c => c.Boolean(nullable: false));
            AddColumn("dbo.Res_SubjectSetup", "IsFourth", c => c.Boolean(nullable: false));
            AddColumn("dbo.Res_SubjectSetup", "IsThird", c => c.Boolean(nullable: false));
            AddColumn("dbo.Res_SubjectSetup", "ImpactOnMeritPosition", c => c.Boolean(nullable: false));
            AddColumn("dbo.Res_SubjectSetup", "NoEffectOnExam", c => c.Boolean(nullable: false));
            DropColumn("dbo.Res_StudentSubject", "TermId");
            DropColumn("dbo.Res_MarksMigratedSetup", "TermId");
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "TotalExamNo");
            DropColumn("dbo.Res_GradingSystem", "TermId");
            DropColumn("dbo.Res_SubExam", "IsFinal");
            DropColumn("dbo.Res_SubExam", "IsMidYear");
            DropColumn("dbo.Res_SubjectSetup", "TermId");
            DropColumn("dbo.Res_MainExam", "TermId");
        }
    }
}
