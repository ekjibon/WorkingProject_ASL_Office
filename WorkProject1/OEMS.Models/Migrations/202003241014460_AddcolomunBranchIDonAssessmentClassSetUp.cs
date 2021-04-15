namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddcolomunBranchIDonAssessmentClassSetUp : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Res_AssessmentClassSetUp", "BranchID", c => c.Int());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Res_AssessmentClassSetUp", "BranchID");
        }
    }
}
