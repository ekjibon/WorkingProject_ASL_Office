namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addlogrollback2302202111 : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Invoice_InvoiceLog",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        InvoiceNo = c.String(),
                        ClientId = c.Int(),
                        CollectionAmount = c.Decimal(precision: 18, scale: 2),
                        LogType = c.String(),
                        LogStatus = c.String(),
                        Description = c.String(),
                        LogDate = c.DateTime(nullable: false),
                        UserId = c.String(),
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
            
            AddColumn("dbo.ACC_Transaction", "CollectionMasterId", c => c.Int());
        }
        
        public override void Down()
        {
            DropColumn("dbo.ACC_Transaction", "CollectionMasterId");
            DropTable("dbo.Invoice_InvoiceLog");
        }
    }
}
