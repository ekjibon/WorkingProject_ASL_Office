namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class COcomments : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Res_ClassResultComments", "COComments", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Res_ClassResultComments", "COComments");
        }
    }
}
