namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class acccodefieldadd : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Fees_Head", "AccCode1", c => c.String());
            AddColumn("dbo.Fees_Head", "AccCode2", c => c.String());
            DropColumn("dbo.Fees_Head", "AccCode");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Fees_Head", "AccCode", c => c.String());
            DropColumn("dbo.Fees_Head", "AccCode2");
            DropColumn("dbo.Fees_Head", "AccCode1");
        }
    }
}
