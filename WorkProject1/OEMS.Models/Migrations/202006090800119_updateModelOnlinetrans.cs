namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class updateModelOnlinetrans : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Fees_OnlineTrans",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        TillMonth = c.Int(nullable: false),
                        TillYear = c.Int(nullable: false),
                        StudentID = c.Int(nullable: false),
                        InvoiceNumber = c.String(),
                        HeadDetails = c.String(),
                        PayMode = c.String(),
                        ChaqueNumber = c.String(),
                        Amount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        bKashCharge = c.Decimal(nullable: false, precision: 18, scale: 2),
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
            
        }
        
        public override void Down()
        {
            DropTable("dbo.Fees_OnlineTrans");
        }
    }
}
