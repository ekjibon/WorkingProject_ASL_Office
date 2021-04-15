namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addclertmodel06102020 : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Common_AlertSetting",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        AlertType = c.String(),
                        FromAddress = c.String(),
                        ToAddress = c.String(),
                        CCAddress = c.String(),
                        BCCAddress = c.String(),
                        Subject = c.String(),
                        DestinationMobileNo = c.String(),
                        Body = c.String(),
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
            
            CreateTable(
                "dbo.Inv_Customer",
                c => new
                    {
                        CustomerId = c.Int(nullable: false, identity: true),
                        CustomerName = c.String(),
                        CustomerCode = c.String(),
                        BIN = c.String(),
                        CompanyName = c.String(),
                        ContactPersonName = c.String(),
                        ConatactPersonMobileNo = c.String(),
                        Email = c.String(),
                        Address = c.String(),
                        AccountCode = c.String(),
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
                .PrimaryKey(t => t.CustomerId);
            
            CreateTable(
                "dbo.Inv_ServiceSetup",
                c => new
                    {
                        ServiceSetupId = c.Int(nullable: false, identity: true),
                        ServiceName = c.String(),
                        ServiceCode = c.String(),
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
                .PrimaryKey(t => t.ServiceSetupId);
            
            AddColumn("dbo.Inv_Supplier", "BIN", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Inv_Supplier", "BIN");
            DropTable("dbo.Inv_ServiceSetup");
            DropTable("dbo.Inv_Customer");
            DropTable("dbo.Common_AlertSetting");
        }
    }
}
