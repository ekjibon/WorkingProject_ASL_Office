namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class changetype : DbMigration
    {
        public override void Up()
        {
            AlterColumn("dbo.Res_AssessmentSubSetup", "Name", c => c.String());
        }
        
        public override void Down()
        {
            AlterColumn("dbo.Res_AssessmentSubSetup", "Name", c => c.Int(nullable: false));
        }
    }
}
