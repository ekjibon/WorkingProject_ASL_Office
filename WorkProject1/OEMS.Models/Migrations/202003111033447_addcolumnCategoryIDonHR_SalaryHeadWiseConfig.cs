namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addcolumnCategoryIDonHR_SalaryHeadWiseConfig : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.HR_SalaryHeadWiseConfig", "CategoryID", c => c.Int(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.HR_SalaryHeadWiseConfig", "CategoryID");
        }
    }
}
