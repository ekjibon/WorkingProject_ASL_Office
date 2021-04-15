namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class term : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Res_Terms",
                c => new
                    {
                        TermId = c.Int(nullable: false, identity: true),
                        SessionId = c.Int(nullable: false),
                        BranchId = c.Int(nullable: false),
                        ClassId = c.Int(nullable: false),
                        Name = c.String(),
                        startDate = c.DateTime(nullable: false),
                        endDate = c.DateTime(nullable: false),
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
                .PrimaryKey(t => t.TermId);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.Res_Terms");
        }
    }
}
