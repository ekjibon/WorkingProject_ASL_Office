namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class UpdateEmpInfo : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Emp_BasicInfo", "SpouseName", c => c.String());
            AddColumn("dbo.Emp_BasicInfo", "SpouseMobile", c => c.String());
            AddColumn("dbo.Emp_BasicInfo", "Child", c => c.String());
            AddColumn("dbo.Emp_BasicInfo", "BirthCertificate", c => c.String());
            AddColumn("dbo.Emp_BasicInfo", "DrawbackMedicine", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Emp_BasicInfo", "DrawbackMedicine");
            DropColumn("dbo.Emp_BasicInfo", "BirthCertificate");
            DropColumn("dbo.Emp_BasicInfo", "Child");
            DropColumn("dbo.Emp_BasicInfo", "SpouseMobile");
            DropColumn("dbo.Emp_BasicInfo", "SpouseName");
        }
    }
}
