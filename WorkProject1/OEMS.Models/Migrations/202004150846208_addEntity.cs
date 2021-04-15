namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addEntity : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.HR_SalaryStructurePeriod", "IsDeleted", c => c.Boolean(nullable: false));
            AddColumn("dbo.HR_SalaryStructurePeriod", "AddBy", c => c.String(maxLength: 128));
            AddColumn("dbo.HR_SalaryStructurePeriod", "AddDate", c => c.DateTime());
            AddColumn("dbo.HR_SalaryStructurePeriod", "UpdateBy", c => c.String(maxLength: 128));
            AddColumn("dbo.HR_SalaryStructurePeriod", "UpdateDate", c => c.DateTime());
            AddColumn("dbo.HR_SalaryStructurePeriod", "Remarks", c => c.String(maxLength: 100));
            AddColumn("dbo.HR_SalaryStructurePeriod", "Status", c => c.String(maxLength: 20));
            AddColumn("dbo.HR_SalaryStructurePeriod", "IP", c => c.String(maxLength: 50));
            AddColumn("dbo.HR_SalaryStructurePeriod", "MacAddress", c => c.String(maxLength: 50));
        }
        
        public override void Down()
        {
            DropColumn("dbo.HR_SalaryStructurePeriod", "MacAddress");
            DropColumn("dbo.HR_SalaryStructurePeriod", "IP");
            DropColumn("dbo.HR_SalaryStructurePeriod", "Status");
            DropColumn("dbo.HR_SalaryStructurePeriod", "Remarks");
            DropColumn("dbo.HR_SalaryStructurePeriod", "UpdateDate");
            DropColumn("dbo.HR_SalaryStructurePeriod", "UpdateBy");
            DropColumn("dbo.HR_SalaryStructurePeriod", "AddDate");
            DropColumn("dbo.HR_SalaryStructurePeriod", "AddBy");
            DropColumn("dbo.HR_SalaryStructurePeriod", "IsDeleted");
        }
    }
}
