namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddSecurityDepositDetailsModel1 : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.SecurityDepositDetails",
                c => new
                    {
                        SecurityDepositDetailsId = c.Int(nullable: false, identity: true),
                        StudentIID = c.Long(nullable: false),
                        FeesHeadId = c.Int(nullable: false),
                        DepositAmont = c.Decimal(nullable: false, precision: 18, scale: 2),
                        TotalAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ReceiveAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        Narration = c.String(),
                        BankDate = c.DateTime(nullable: false),
                        PostingDate = c.DateTime(nullable: false),
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
                .PrimaryKey(t => t.SecurityDepositDetailsId);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.SecurityDepositDetails");
        }
    }
}
