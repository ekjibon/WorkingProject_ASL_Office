namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addColoumn : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.HR_SalaryStructure", "CurrentSalary", c => c.String());
            AlterColumn("dbo.HR_SalaryStructure", "GradeId", c => c.Int());
        }
        
        public override void Down()
        {
            AlterColumn("dbo.HR_SalaryStructure", "GradeId", c => c.Int(nullable: false));
            DropColumn("dbo.HR_SalaryStructure", "CurrentSalary");
        }
    }
}
