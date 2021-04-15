namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddAutumn : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "AutumnMarks", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "AutumnFullMarks", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "AutumnMarksPersentage", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "WithAutumnMarks", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "WinterTotalMarks", c => c.Decimal(precision: 18, scale: 2));
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "WinterMarks");
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "WinterFullMarks");
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "SummerTotalMarks");
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "SummerMarksPersentage");
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "WithSummerMarks");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "WithSummerMarks", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "SummerMarksPersentage", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "SummerTotalMarks", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "WinterFullMarks", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "WinterMarks", c => c.Decimal(precision: 18, scale: 2));
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "WinterTotalMarks");
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "WithAutumnMarks");
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "AutumnMarksPersentage");
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "AutumnFullMarks");
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "AutumnMarks");
        }
    }
}
