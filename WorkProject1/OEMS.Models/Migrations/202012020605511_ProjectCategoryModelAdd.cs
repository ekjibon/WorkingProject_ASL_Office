namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ProjectCategoryModelAdd : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Task_ProjectCategory",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        CategoryName = c.String(),
                        Description = c.String(),
                        IsDeleted = c.Boolean(nullable: false),
                        AddBy = c.String(maxLength: 128),
                        AddDate = c.DateTime(),
                        UpdateBy = c.String(maxLength: 128),
                        UpdateDate = c.DateTime(),
                        Remarks = c.String(maxLength: 100),
                        Status = c.String(maxLength: 20),
                        IP = c.String(maxLength: 50),
                        MacAddress = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.Id);
            
            AddColumn("dbo.Task_Project", "CategoryId", c => c.Int(nullable: false));
            AddColumn("dbo.Task_Project", "DepartmentId", c => c.Int(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("dbo.Task_Project", "DepartmentId");
            DropColumn("dbo.Task_Project", "CategoryId");
            DropTable("dbo.Task_ProjectCategory");
        }
    }
}
