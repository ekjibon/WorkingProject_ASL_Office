namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class chngacc : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Acc_UserAccBranch",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        UserId = c.String(nullable: false),
                        AccBranchId = c.Int(nullable: false),
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
            
            AddColumn("dbo.ACC_RootGroup", "Length", c => c.Int(nullable: false,defaultValue:0));
            AddColumn("dbo.ACC_Transaction", "FiscalYearId", c => c.Int(nullable: false));
            AddColumn("dbo.ACC_Transaction", "AccBranchId", c => c.Int(nullable: false));
            AddColumn("dbo.ACC_Transaction", "TransNo", c => c.String(nullable: false, maxLength: 12));
            AddColumn("dbo.ACC_Transaction", "TransType", c => c.Int(nullable: false));
            AddColumn("dbo.ACC_Transaction", "PayMode", c => c.Int(nullable: false, defaultValue: 0));
            AddColumn("dbo.ACC_Transaction", "ApproveDate", c => c.DateTime(nullable: false));
            AddColumn("dbo.ACC_Transaction", "ApproveBy", c => c.String());
            AddColumn("dbo.ACC_Transaction", "IsApproved", c => c.Boolean(nullable: false));
            AddColumn("dbo.ACC_Transaction", "PayTo", c => c.String());
            AddColumn("dbo.ACC_Transaction", "RecivedBy", c => c.String());
            AddColumn("dbo.ACC_Transaction", "ChequeNo", c => c.String());
            AddColumn("dbo.ACC_Transaction", "ChequeDate", c => c.DateTime());
            AddColumn("dbo.ACC_Transaction", "Description", c => c.String());
            DropColumn("dbo.ACC_RootGroup", "Lenght");
            DropColumn("dbo.ACC_Transaction", "FiscalYear");
            DropColumn("dbo.ACC_Transaction", "BranchId");
            DropColumn("dbo.ACC_Transaction", "Number");
            DropColumn("dbo.ACC_Transaction", "Type");
            DropColumn("dbo.ACC_TransactionDetail", "Date");
            DropColumn("dbo.ACC_TransactionDetail", "IsDeleted");
            DropColumn("dbo.ACC_TransactionDetail", "AddBy");
            DropColumn("dbo.ACC_TransactionDetail", "AddDate");
            DropColumn("dbo.ACC_TransactionDetail", "UpdateBy");
            DropColumn("dbo.ACC_TransactionDetail", "UpdateDate");
            DropColumn("dbo.ACC_TransactionDetail", "Remarks");
            DropColumn("dbo.ACC_TransactionDetail", "Status");
            DropColumn("dbo.ACC_TransactionDetail", "IP");
            DropColumn("dbo.ACC_TransactionDetail", "MacAddress");
            DropTable("dbo.ACC_COATemp");
            DropTable("dbo.ACC_Entries");
            DropTable("dbo.ACC_EntryItems");
            DropTable("dbo.ACC_EntryTypes");
            DropTable("dbo.ACC_Intregation");
            DropTable("dbo.ACC_Groups");
        }
        
        public override void Down()
        {
            CreateTable(
                "dbo.ACC_Groups",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        ParentId = c.Int(),
                        Name = c.String(),
                        Code = c.String(),
                        Isparent = c.Boolean(nullable: false),
                        IsEdit = c.Boolean(nullable: false),
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
            
            CreateTable(
                "dbo.ACC_EntryTypes",
                c => new
                    {
                        EntryTypeId = c.Int(nullable: false, identity: true),
                        Label = c.String(),
                        Name = c.String(),
                        Description = c.String(),
                        BaseType = c.Boolean(nullable: false),
                        Numbering = c.Boolean(nullable: false),
                        Prefix = c.String(),
                        Surfix = c.String(),
                        ZeroPadding = c.Boolean(nullable: false),
                        RestrictionBankcash = c.Boolean(nullable: false),
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
                .PrimaryKey(t => t.EntryTypeId);
            
            CreateTable(
                "dbo.ACC_EntryItems",
                c => new
                    {
                        EntryItemId = c.Int(nullable: false, identity: true),
                        EntryId = c.Int(nullable: false),
                        LedgerId = c.Int(nullable: false),
                        Date = c.DateTime(nullable: false),
                        Amount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ReconciliationDate = c.DateTime(nullable: false),
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
                .PrimaryKey(t => t.EntryItemId);
            
            CreateTable(
                "dbo.ACC_Entries",
                c => new
                    {
                        EntryId = c.Int(nullable: false, identity: true),
                        TagId = c.Int(),
                        EntryTypeId = c.Int(nullable: false),
                        Number = c.Int(nullable: false),
                        Date = c.DateTime(nullable: false),
                        DrTotal = c.Decimal(nullable: false, precision: 18, scale: 2),
                        CrTotal = c.Decimal(nullable: false, precision: 18, scale: 2),
                        Narration = c.String(),
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
                .PrimaryKey(t => t.EntryId);
            
            CreateTable(
                "dbo.ACC_COATemp",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        Name = c.String(),
                        ParentId = c.Int(nullable: false),
                        Type = c.String(),
                        IsEdit = c.Boolean(nullable: false),
                        RootGroupId = c.Int(nullable: false),
                        DisplayOrder = c.Int(nullable: false),
                    })
                .PrimaryKey(t => t.Id);
            
            AddColumn("dbo.ACC_TransactionDetail", "MacAddress", c => c.String(maxLength: 50));
            AddColumn("dbo.ACC_TransactionDetail", "IP", c => c.String(maxLength: 50));
            AddColumn("dbo.ACC_TransactionDetail", "Status", c => c.String(maxLength: 20));
            AddColumn("dbo.ACC_TransactionDetail", "Remarks", c => c.String(maxLength: 100));
            AddColumn("dbo.ACC_TransactionDetail", "UpdateDate", c => c.DateTime());
            AddColumn("dbo.ACC_TransactionDetail", "UpdateBy", c => c.String(maxLength: 128));
            AddColumn("dbo.ACC_TransactionDetail", "AddDate", c => c.DateTime());
            AddColumn("dbo.ACC_TransactionDetail", "AddBy", c => c.String(maxLength: 128));
            AddColumn("dbo.ACC_TransactionDetail", "IsDeleted", c => c.Boolean(nullable: false));
            AddColumn("dbo.ACC_TransactionDetail", "Date", c => c.DateTime(nullable: false));
            AddColumn("dbo.ACC_Transaction", "Type", c => c.Int(nullable: false));
            AddColumn("dbo.ACC_Transaction", "Number", c => c.String());
            AddColumn("dbo.ACC_Transaction", "BranchId", c => c.Int(nullable: false));
            AddColumn("dbo.ACC_Transaction", "FiscalYear", c => c.Int(nullable: false));
            AddColumn("dbo.ACC_RootGroup", "Lenght", c => c.Int(nullable: false));
            DropColumn("dbo.ACC_Transaction", "Description");
            DropColumn("dbo.ACC_Transaction", "ChequeDate");
            DropColumn("dbo.ACC_Transaction", "ChequeNo");
            DropColumn("dbo.ACC_Transaction", "RecivedBy");
            DropColumn("dbo.ACC_Transaction", "PayTo");
            DropColumn("dbo.ACC_Transaction", "IsApproved");
            DropColumn("dbo.ACC_Transaction", "ApproveBy");
            DropColumn("dbo.ACC_Transaction", "ApproveDate");
            DropColumn("dbo.ACC_Transaction", "PayMode");
            DropColumn("dbo.ACC_Transaction", "TransType");
            DropColumn("dbo.ACC_Transaction", "TransNo");
            DropColumn("dbo.ACC_Transaction", "AccBranchId");
            DropColumn("dbo.ACC_Transaction", "FiscalYearId");
            DropColumn("dbo.ACC_RootGroup", "Length");
            DropTable("dbo.Acc_UserAccBranch");
        }
    }
}
