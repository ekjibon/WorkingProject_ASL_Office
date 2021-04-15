namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class csfiledadd : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Ins_CSInfo", "ReferenceId", c => c.Int());
            AddColumn("dbo.Ins_CSInfo", "RefTypeId", c => c.Int());
            DropColumn("dbo.Ins_CSInfo", "StudentId");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Ins_CSInfo", "StudentId", c => c.Int());
            DropColumn("dbo.Ins_CSInfo", "RefTypeId");
            DropColumn("dbo.Ins_CSInfo", "ReferenceId");
        }
    }
}
