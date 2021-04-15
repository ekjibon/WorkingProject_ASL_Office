namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddColumnBranchIDonMainexam : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Res_MainExam", "BranchID", c => c.Int());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Res_MainExam", "BranchID");
        }
    }
}
