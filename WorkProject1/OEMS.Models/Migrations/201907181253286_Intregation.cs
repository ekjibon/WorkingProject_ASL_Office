namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Intregation : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.ACC_Intregation",
                c => new
                    {
                        IntregationId = c.Int(nullable: false, identity: true),
                        FeesGroupId = c.Int(nullable: false),
                        FeesLegderId = c.Int(nullable: false),
                        EmpGroupId = c.Int(nullable: false),
                        EmpLedgerid = c.Int(nullable: false),
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
                .PrimaryKey(t => t.IntregationId);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.ACC_Intregation");
        }
    }
}
