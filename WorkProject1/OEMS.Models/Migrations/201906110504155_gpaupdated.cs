namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class gpaupdated : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("dbo.Res_MainExamMarkSetup", "GroupInfo_GroupId", "dbo.Ins_Group");
            DropForeignKey("dbo.Ins_Section", "GroupId", "dbo.Ins_Group");
            DropIndex("dbo.Res_MainExamMarkSetup", new[] { "GroupInfo_GroupId" });
            DropIndex("dbo.Ins_Section", new[] { "GroupId" });
            AddColumn("dbo.Res_MainExamResult", "TotalWithECA", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResult", "TotalWithOutECA", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResult", "TotalWithECAPercent", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResult", "TotalWithOutECAPercent", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            DropColumn("dbo.Res_MainExamMarkSetup", "MainExamIsPassDepend");
            DropColumn("dbo.Ins_Section", "GroupId");
           
            DropTable("dbo.Ins_Group");
          
        }
        
        public override void Down()
        {
            CreateTable(
                "dbo.Res_MEResultDetails",
                c => new
                    {
                        MarksDetailsID = c.Int(nullable: false, identity: true),
                        ResultSubjectDetailsId = c.Long(nullable: false),
                        SubjectID = c.Int(nullable: false),
                        MainExamId = c.Int(nullable: false),
                        SubExamId = c.Int(nullable: false),
                        StudentIID = c.Long(nullable: false),
                        WrittenObt1 = c.Double(nullable: false),
                        WrittenConv1 = c.Double(nullable: false),
                        WrittenFrac1 = c.Double(nullable: false),
                        WrittenIsPass1 = c.Boolean(nullable: false),
                        WrittenIsAbsent1 = c.Boolean(nullable: false),
                        WrittenObt2 = c.Decimal(nullable: false, precision: 18, scale: 2),
                        WrittenConv2 = c.Decimal(nullable: false, precision: 18, scale: 2),
                        WrittenFrac2 = c.Decimal(nullable: false, precision: 18, scale: 2),
                        WrittenIsPass2 = c.Boolean(nullable: false),
                        WrittenIsAbsent2 = c.Boolean(nullable: false),
                        WrittenObt3 = c.Decimal(nullable: false, precision: 18, scale: 2),
                        WrittenConv3 = c.Decimal(nullable: false, precision: 18, scale: 2),
                        WrittenFrac3 = c.Decimal(nullable: false, precision: 18, scale: 2),
                        WrittenIsPass3 = c.Boolean(nullable: false),
                        WrittenIsAbsent3 = c.Boolean(nullable: false),
                        SubjectiveObt = c.Decimal(nullable: false, precision: 18, scale: 2),
                        SubjectiveConv = c.Decimal(nullable: false, precision: 18, scale: 2),
                        SubjectiveFrac = c.Decimal(nullable: false, precision: 18, scale: 2),
                        SubjectiveIsPass = c.Boolean(nullable: false),
                        SubjectiveIsAbsent = c.Boolean(nullable: false),
                        ObjectiveObt = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ObjectiveConv = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ObjectiveFrac = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ObjectiveIsPass = c.Boolean(nullable: false),
                        ObjectiveIsAbsent = c.Boolean(nullable: false),
                        PracticalObt = c.Decimal(nullable: false, precision: 18, scale: 2),
                        PracticalConv = c.Decimal(nullable: false, precision: 18, scale: 2),
                        PracticalFrac = c.Decimal(nullable: false, precision: 18, scale: 2),
                        PracticalIsPass = c.Boolean(nullable: false),
                        PracticalIsAbsent = c.Boolean(nullable: false),
                        SOPTotalObt = c.Decimal(nullable: false, precision: 18, scale: 2),
                        SOPTotalConv = c.Decimal(nullable: false, precision: 18, scale: 2),
                        SOPTotalFrac = c.Decimal(nullable: false, precision: 18, scale: 2),
                        SubExamOriginalTotalObt = c.Decimal(nullable: false, precision: 18, scale: 2),
                        SubExamTotalObt = c.Decimal(nullable: false, precision: 18, scale: 2),
                        SubExamTotalConv = c.Decimal(nullable: false, precision: 18, scale: 2),
                        SubExamTotalFrac = c.Decimal(nullable: false, precision: 18, scale: 2),
                        SubExamIsPass = c.Boolean(nullable: false),
                        SubExamIsAbsent = c.Boolean(nullable: false),
                    })
                .PrimaryKey(t => t.MarksDetailsID);
            
            CreateTable(
                "dbo.Ins_Group",
                c => new
                    {
                        GroupId = c.Int(nullable: false, identity: true),
                        GroupName = c.String(nullable: false),
                        Group_Code = c.String(),
                        Group_Status = c.String(),
                    })
                .PrimaryKey(t => t.GroupId);
            
            AddColumn("dbo.Res_MainExamResult", "MeritSubjectMarks3", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResult", "MeritSubjectId3", c => c.Int(nullable: false));
            AddColumn("dbo.Res_MainExamResult", "MeritSubjectMarks2", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResult", "MeritSubjectId2", c => c.Int(nullable: false));
            AddColumn("dbo.Res_MainExamResult", "MeritSubjectMarks1", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResult", "MeritSubjectId1", c => c.Int(nullable: false));
            AddColumn("dbo.Res_MainExamResult", "MyProperty", c => c.Int(nullable: false));
            AddColumn("dbo.Res_MainExamResult", "Handwriting", c => c.String());
            AddColumn("dbo.Res_MainExamResult", "Conduct", c => c.String());
            AddColumn("dbo.Res_MainExamResult", "TeacherComments", c => c.String());
            AddColumn("dbo.Res_MainExamResult", "ClassWiseMerit", c => c.Int(nullable: false));
            AddColumn("dbo.Res_MainExamResult", "ShiftWiseMerit", c => c.Int(nullable: false));
            AddColumn("dbo.Res_MainExamResult", "SectionWiseMerit", c => c.Int(nullable: false));
            AddColumn("dbo.Res_MainExamResult", "OverAllMerit", c => c.Int(nullable: false));
            AddColumn("dbo.Res_MainExamResult", "IsPass", c => c.Boolean(nullable: false));
            AddColumn("dbo.Res_MainExamResult", "TotalGPWithOut4Sub", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResult", "TotalGP", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResult", "FailStudentGPA", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResult", "GPAWithOut4Sub", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResult", "TotalConvertedMarksFraction", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResult", "TotalConvertedMarks", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResult", "SubExamId", c => c.Int(nullable: false));
            AddColumn("dbo.Ins_Section", "GroupId", c => c.Int());
            AddColumn("dbo.Res_MainExamMarkSetup", "GroupInfo_GroupId", c => c.Int());
            AddColumn("dbo.Res_MainExamMarkSetup", "MainExamIsPassDepend", c => c.Boolean(nullable: false));
            DropColumn("dbo.Res_MainExamResult", "TotalWithOutECAPercent");
            DropColumn("dbo.Res_MainExamResult", "TotalWithECAPercent");
            DropColumn("dbo.Res_MainExamResult", "TotalWithOutECA");
            DropColumn("dbo.Res_MainExamResult", "TotalWithECA");
            DropTable("dbo.Res_MERSubExamResult");
            CreateIndex("dbo.Ins_Section", "GroupId");
            CreateIndex("dbo.Res_MainExamMarkSetup", "GroupInfo_GroupId");
            AddForeignKey("dbo.Ins_Section", "GroupId", "dbo.Ins_Group", "GroupId");
            AddForeignKey("dbo.Res_MainExamMarkSetup", "GroupInfo_GroupId", "dbo.Ins_Group", "GroupId");
        }
    }
}
