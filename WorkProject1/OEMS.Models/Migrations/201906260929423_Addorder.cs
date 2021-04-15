namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Addorder : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Res_AssesmentClassOptions",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        AssessmentClassSetUId = c.Int(nullable: false),
                        Name = c.String(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.Id);
            
            AddColumn("dbo.Res_AssessmentClassSetUp", "Order", c => c.Int(nullable: false));
            AddColumn("dbo.Res_AssessmentSubSetup", "Order", c => c.Int(nullable: false));
            AddColumn("dbo.Res_ClassResultComments", "ReportGLComments", c => c.String());
            AddColumn("dbo.Ins_ECAClubConfig", "FromTime", c => c.Time(nullable: false, precision: 7));
            AddColumn("dbo.Ins_ECAClubConfig", "ToTime", c => c.Time(nullable: false, precision: 7));
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "WinterMarks", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "WinterFullMarks", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "WinterMarksPersentage", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "WithWinterMarks", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "SummerTotalMarks", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "SummerMarksPersentage", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "WithSummerMarks", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("dbo.Stu_Clubs", "DayId", c => c.Int(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Stu_Clubs", "DayId");
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "WithSummerMarks");
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "SummerMarksPersentage");
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "SummerTotalMarks");
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "WithWinterMarks");
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "WinterMarksPersentage");
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "WinterFullMarks");
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "WinterMarks");
            DropColumn("dbo.Ins_ECAClubConfig", "ToTime");
            DropColumn("dbo.Ins_ECAClubConfig", "FromTime");
            DropColumn("dbo.Res_ClassResultComments", "ReportGLComments");
            DropColumn("dbo.Res_AssessmentSubSetup", "Order");
            DropColumn("dbo.Res_AssessmentClassSetUp", "Order");
            DropTable("dbo.Res_AssesmentClassOptions");
        }
    }
}
