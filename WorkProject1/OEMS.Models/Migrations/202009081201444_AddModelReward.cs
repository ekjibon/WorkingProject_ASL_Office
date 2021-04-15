namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddModelReward : DbMigration
    {
        public override void Up()
        {
            DropIndex("dbo.ACC_Ledgers", new[] { "Name" });
            CreateTable(
                "dbo.HR_Reward",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        EmpId = c.Int(nullable: false),
                        RewardAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
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
            
            AlterColumn("dbo.ACC_Ledgers", "Name", c => c.String(maxLength: 1000));
            CreateIndex("dbo.ACC_Ledgers", "Name", unique: true);
        }
        
        public override void Down()
        {
            DropIndex("dbo.ACC_Ledgers", new[] { "Name" });
            AlterColumn("dbo.ACC_Ledgers", "Name", c => c.String(maxLength: 100));
            DropTable("dbo.HR_Reward");
            CreateIndex("dbo.ACC_Ledgers", "Name", unique: true);
        }
    }
}
