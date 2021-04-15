namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddModelFeesHistory : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.FeesAdjustHistories",
                c => new
                    {
                        FeesAdjustId = c.Long(nullable: false, identity: true),
                        ProcessId = c.Int(nullable: false),
                        SessionId = c.Int(nullable: false),
                        MonthId = c.Int(nullable: false),
                        StudentIID = c.Long(nullable: false),
                        HeadId = c.Int(nullable: false),
                        FeesSessionYearId = c.Int(nullable: false),
                        TotalAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ProcessedAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        DueAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        NoModifiedDueAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ScholarshipAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        DiscountAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        PaidAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        AdvanceAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        IsEnrollment = c.Boolean(nullable: false),
                        IsOldStudent = c.Boolean(nullable: false),
                        IsCashCollection = c.Boolean(nullable: false),
                        InvoiceAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        IsPaid = c.Boolean(nullable: false),
                        IsCompleted = c.Boolean(nullable: false),
                        IsAdjust = c.Boolean(nullable: false),
                        IsRefund = c.Boolean(nullable: false),
                        IsResolved = c.Boolean(nullable: false),
                        Narration = c.String(),
                        Stutype = c.String(),
                        EmpId = c.String(),
                        IsVerification = c.Boolean(),
                        AppVerificationNo = c.String(),
                        AutomatedDays = c.Int(nullable: false),
                        AutomatedConsecutiveDays = c.Int(nullable: false),
                        IsPublished = c.Boolean(nullable: false),
                        IsLatePayPublished = c.Boolean(nullable: false),
                        IsLatePay = c.Boolean(nullable: false),
                        Year = c.Int(nullable: false),
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
                .PrimaryKey(t => t.FeesAdjustId);
            
            AddColumn("dbo.Fees_CollectionMaster", "IsAdjust", c => c.Boolean(nullable: false));
            AddColumn("dbo.Fees_CollectionMaster", "IsRefund", c => c.Boolean(nullable: false));
            AddColumn("dbo.Fees_CollectionMaster", "IsResolved", c => c.Boolean(nullable: false));
            AddColumn("dbo.Fees_CollectionMaster", "IsEnrollment", c => c.Boolean(nullable: false));
            AddColumn("dbo.Fees_CollectionMaster", "IsOldStudent", c => c.Boolean(nullable: false));
            AddColumn("dbo.Fees_CollectionMaster", "IsCashCollection", c => c.Boolean(nullable: false));
            AddColumn("dbo.Fees_Student", "IsAdjust", c => c.Boolean(nullable: false));
            AddColumn("dbo.Fees_Student", "IsRefund", c => c.Boolean(nullable: false));
            AddColumn("dbo.Fees_Student", "IsResolved", c => c.Boolean(nullable: false));
            AddColumn("dbo.Fees_Student", "FeesAdjustHistory_FeesAdjustId", c => c.Long());
            AddColumn("dbo.Fees_Student", "FeesAdjustHistory_FeesAdjustId1", c => c.Long());
            CreateIndex("dbo.Fees_Student", "FeesAdjustHistory_FeesAdjustId");
            CreateIndex("dbo.Fees_Student", "FeesAdjustHistory_FeesAdjustId1");
            AddForeignKey("dbo.Fees_Student", "FeesAdjustHistory_FeesAdjustId", "dbo.FeesAdjustHistories", "FeesAdjustId");
            AddForeignKey("dbo.Fees_Student", "FeesAdjustHistory_FeesAdjustId1", "dbo.FeesAdjustHistories", "FeesAdjustId");
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.Fees_Student", "FeesAdjustHistory_FeesAdjustId1", "dbo.FeesAdjustHistories");
            DropForeignKey("dbo.Fees_Student", "FeesAdjustHistory_FeesAdjustId", "dbo.FeesAdjustHistories");
            DropIndex("dbo.Fees_Student", new[] { "FeesAdjustHistory_FeesAdjustId1" });
            DropIndex("dbo.Fees_Student", new[] { "FeesAdjustHistory_FeesAdjustId" });
            DropColumn("dbo.Fees_Student", "FeesAdjustHistory_FeesAdjustId1");
            DropColumn("dbo.Fees_Student", "FeesAdjustHistory_FeesAdjustId");
            DropColumn("dbo.Fees_Student", "IsResolved");
            DropColumn("dbo.Fees_Student", "IsRefund");
            DropColumn("dbo.Fees_Student", "IsAdjust");
            DropColumn("dbo.Fees_CollectionMaster", "IsCashCollection");
            DropColumn("dbo.Fees_CollectionMaster", "IsOldStudent");
            DropColumn("dbo.Fees_CollectionMaster", "IsEnrollment");
            DropColumn("dbo.Fees_CollectionMaster", "IsResolved");
            DropColumn("dbo.Fees_CollectionMaster", "IsRefund");
            DropColumn("dbo.Fees_CollectionMaster", "IsAdjust");
            DropTable("dbo.FeesAdjustHistories");
        }
    }
}
