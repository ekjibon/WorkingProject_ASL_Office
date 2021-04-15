namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class modifycolumnduration04022021333 : DbMigration
    {
        public override void Up()
        {
            AlterColumn("dbo.Emp_Request", "Duration", c => c.Decimal(precision: 18, scale: 2));
        }
        
        public override void Down()
        {
            AlterColumn("dbo.Emp_Request", "Duration", c => c.Int());
        }
    }
}
