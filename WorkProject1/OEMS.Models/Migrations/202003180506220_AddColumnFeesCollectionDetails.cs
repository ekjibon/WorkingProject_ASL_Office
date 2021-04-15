namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddColumnFeesCollectionDetails : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Fees_CollectionDetails", "Narration", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Fees_CollectionDetails", "Narration");
        }
    }
}
