namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class unqcol : DbMigration
    {
        public override void Up()
        {
            AlterColumn("dbo.ACC_Ledgers", "Name", c => c.String(maxLength: 100));
            AlterColumn("dbo.ACC_Ledgers", "Code", c => c.String(maxLength: 50));
            CreateIndex("dbo.ACC_Ledgers", "Name", unique: true);
            CreateIndex("dbo.ACC_Ledgers", "Code", unique: true);
        }
        
        public override void Down()
        {
            DropIndex("dbo.ACC_Ledgers", new[] { "Code" });
            DropIndex("dbo.ACC_Ledgers", new[] { "Name" });
            AlterColumn("dbo.ACC_Ledgers", "Code", c => c.String());
            AlterColumn("dbo.ACC_Ledgers", "Name", c => c.String());
        }
    }
}
