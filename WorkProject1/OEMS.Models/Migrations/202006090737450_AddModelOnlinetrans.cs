namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddModelOnlinetrans : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Res_SubjectWiseComment", "TermId", c => c.Int());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Res_SubjectWiseComment", "TermId");
        }
    }
}
