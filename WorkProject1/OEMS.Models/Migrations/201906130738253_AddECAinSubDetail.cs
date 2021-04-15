namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddECAinSubDetail : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Res_MainExamResultSubjectDetails", "IsECA", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Res_MainExamResultSubjectDetails", "IsECA");
        }
    }
}
