namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addmodelPhonecall21122020111 : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Invoice_PhoneCallMaintain",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        ClientId = c.Int(nullable: false),
                        CallDate = c.DateTime(nullable: false),
                        ProbablePaymentDate = c.DateTime(nullable: false),
                        ContactNo = c.String(),
                        ContactPerson = c.String(),
                        Comments = c.String(),
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
            
            AddColumn("dbo.Invoice_CollectionMaster", "PaymentMethod", c => c.String());
            AddColumn("dbo.Invoice_CollectionMaster", "ChequeNo", c => c.String());
           
        }
        
        public override void Down()
        {
           
            DropColumn("dbo.Invoice_CollectionMaster", "ChequeNo");
            DropColumn("dbo.Invoice_CollectionMaster", "PaymentMethod");
            DropTable("dbo.Invoice_PhoneCallMaintain");
        }
    }
}
