namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class empleavepropadd : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.HR_EmpLeaveQuota",
                c => new
                    {
                        EmpLeaveQuotaId = c.Int(nullable: false, identity: true),
                        EmpId = c.Int(nullable: false),
                        BranchId = c.Int(nullable: false),
                        EmpCategory = c.Int(nullable: false),
                        AnnualLeaveDay = c.Int(nullable: false),
                        SickLeaveDay = c.Int(nullable: false),
                        AdvanceLeaveDay = c.Int(nullable: false),
                        MaternityLeaveDay = c.Int(nullable: false),
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
                .PrimaryKey(t => t.EmpLeaveQuotaId);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.HR_EmpLeaveQuota");
        }
    }
}
