namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddECGL : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Res_MainExamResult", "GLWithOutECA", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Res_MainExamResult", "GLWithOutECA");
        }
    }
}
