namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddNull : DbMigration
    {
        public override void Up()
        {
            AlterColumn("dbo.Res_MainExamResultSubjectDetails", "WinterMarks", c => c.Decimal(precision: 18, scale: 2));
            AlterColumn("dbo.Res_MainExamResultSubjectDetails", "WinterFullMarks", c => c.Decimal(precision: 18, scale: 2));
            AlterColumn("dbo.Res_MainExamResultSubjectDetails", "WinterMarksPersentage", c => c.Decimal(precision: 18, scale: 2));
            AlterColumn("dbo.Res_MainExamResultSubjectDetails", "WithWinterMarks", c => c.Decimal(precision: 18, scale: 2));
            AlterColumn("dbo.Res_MainExamResultSubjectDetails", "SummerTotalMarks", c => c.Decimal(precision: 18, scale: 2));
            AlterColumn("dbo.Res_MainExamResultSubjectDetails", "SummerMarksPersentage", c => c.Decimal(precision: 18, scale: 2));
            AlterColumn("dbo.Res_MainExamResultSubjectDetails", "WithSummerMarks", c => c.Decimal(precision: 18, scale: 2));
        }
        
        public override void Down()
        {
            AlterColumn("dbo.Res_MainExamResultSubjectDetails", "WithSummerMarks", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AlterColumn("dbo.Res_MainExamResultSubjectDetails", "SummerMarksPersentage", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AlterColumn("dbo.Res_MainExamResultSubjectDetails", "SummerTotalMarks", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AlterColumn("dbo.Res_MainExamResultSubjectDetails", "WithWinterMarks", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AlterColumn("dbo.Res_MainExamResultSubjectDetails", "WinterMarksPersentage", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AlterColumn("dbo.Res_MainExamResultSubjectDetails", "WinterFullMarks", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AlterColumn("dbo.Res_MainExamResultSubjectDetails", "WinterMarks", c => c.Decimal(nullable: false, precision: 18, scale: 2));
        }
    }
}
