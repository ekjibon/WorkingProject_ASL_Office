namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addColumnIsPriRejectOnEmpRequest : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Res_SubExam", "MockType", c => c.String());
            AddColumn("dbo.Emp_Attendance", "IsDutyOff", c => c.Boolean());
            AddColumn("dbo.Emp_Attendance", "IsECAabsent", c => c.Boolean());
            AddColumn("dbo.Emp_Attendance", "IsEarlyOut5Years", c => c.Boolean());
            AddColumn("dbo.Emp_Attendance", "IsPresentInHoliday", c => c.Boolean());
            AddColumn("dbo.Emp_Attendance", "IsPriReject", c => c.Boolean());
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "FinalYearSubObtMarks2", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "FinalYearSubConvtMarks2", c => c.Decimal(precision: 18, scale: 2));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "FinalYearSubConvtMarks2");
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "FinalYearSubObtMarks2");
            DropColumn("dbo.Emp_Attendance", "IsPriReject");
            DropColumn("dbo.Emp_Attendance", "IsPresentInHoliday");
            DropColumn("dbo.Emp_Attendance", "IsEarlyOut5Years");
            DropColumn("dbo.Emp_Attendance", "IsECAabsent");
            DropColumn("dbo.Emp_Attendance", "IsDutyOff");
            DropColumn("dbo.Res_SubExam", "MockType");
        }
    }
}
