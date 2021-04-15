namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class FeesAutomatedConfigFieldChanged : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Fees_AutomatedFeesConfig", "FeesSessionYearId", c => c.Int(nullable: false));
            AddColumn("dbo.Fees_AutomatedFeesConfig", "FeesFiscalSessionId", c => c.Int(nullable: false));
            AddColumn("dbo.Fees_AutomatedFeesConfig", "LateDate", c => c.DateTime(nullable: false));
            AddColumn("dbo.Fees_AutomatedFeesConfig", "Amount", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("dbo.Fees_AutomatedFeesConfig", "IsConfigChecked", c => c.Boolean(nullable: false));
            DropColumn("dbo.Fees_AutomatedFeesConfig", "SessionId");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "BranchId");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "ShiftId");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "ClassId");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "SectionId");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "FessGroupId");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "ProcessId");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "LatePayHeadId");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "LatePayDay");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "IsFixed");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "LatePayAmount");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "LatePayHeadIdAmount");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "LatePayHeadIdAmountIsPercentage");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "LatePayLongRange");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "LatePayLongRangeAmount");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "LatePayLongRangeAmountIsPercentage");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "LatePayLongRangeHeadIdAmount");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "LatePayIsPreviouseFine");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "LateInHead");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "LateInPeriod");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "LateInAmount");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "LateInHeadIdAmount");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "LateInHeadIdAmountIsPercentage");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "LateInAbsConfigDay");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "LateInConsecutiveDay");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "LateInConsecutiveAmount");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "LateInConsecutiveIsPercentage");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "LateInConsecutiveHeadId");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "AbsAHead");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "AbsPeriod");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "AbsAmount");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "AbsHeadIdAmount");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "AbsHeadIdAmountIsPercentage");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "AbsConsecutiveDay");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "AbsConsecutiveAmount");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "AbsConsecutiveIsPercentage");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "AbsConsecutiveHeadId");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "AbsConPeriod");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "AbsConAHead");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "AbsConAmount");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "AbsConHeadIdAmount");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "AbsConHeadIdAmountIsPercentage");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "AbsConConsecutiveDay");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "AbsConConsecutiveAmount");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "AbsConConsecutiveIsPercentage");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "AbsConConsecutiveHeadId");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "Type");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Fees_AutomatedFeesConfig", "Type", c => c.String());
            AddColumn("dbo.Fees_AutomatedFeesConfig", "AbsConConsecutiveHeadId", c => c.Int());
            AddColumn("dbo.Fees_AutomatedFeesConfig", "AbsConConsecutiveIsPercentage", c => c.Boolean(nullable: false));
            AddColumn("dbo.Fees_AutomatedFeesConfig", "AbsConConsecutiveAmount", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Fees_AutomatedFeesConfig", "AbsConConsecutiveDay", c => c.Int());
            AddColumn("dbo.Fees_AutomatedFeesConfig", "AbsConHeadIdAmountIsPercentage", c => c.Boolean(nullable: false));
            AddColumn("dbo.Fees_AutomatedFeesConfig", "AbsConHeadIdAmount", c => c.Int());
            AddColumn("dbo.Fees_AutomatedFeesConfig", "AbsConAmount", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Fees_AutomatedFeesConfig", "AbsConAHead", c => c.Int());
            AddColumn("dbo.Fees_AutomatedFeesConfig", "AbsConPeriod", c => c.Int());
            AddColumn("dbo.Fees_AutomatedFeesConfig", "AbsConsecutiveHeadId", c => c.Int());
            AddColumn("dbo.Fees_AutomatedFeesConfig", "AbsConsecutiveIsPercentage", c => c.Boolean(nullable: false));
            AddColumn("dbo.Fees_AutomatedFeesConfig", "AbsConsecutiveAmount", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Fees_AutomatedFeesConfig", "AbsConsecutiveDay", c => c.Int());
            AddColumn("dbo.Fees_AutomatedFeesConfig", "AbsHeadIdAmountIsPercentage", c => c.Boolean(nullable: false));
            AddColumn("dbo.Fees_AutomatedFeesConfig", "AbsHeadIdAmount", c => c.Int());
            AddColumn("dbo.Fees_AutomatedFeesConfig", "AbsAmount", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Fees_AutomatedFeesConfig", "AbsPeriod", c => c.Int());
            AddColumn("dbo.Fees_AutomatedFeesConfig", "AbsAHead", c => c.Int());
            AddColumn("dbo.Fees_AutomatedFeesConfig", "LateInConsecutiveHeadId", c => c.Int());
            AddColumn("dbo.Fees_AutomatedFeesConfig", "LateInConsecutiveIsPercentage", c => c.Boolean(nullable: false));
            AddColumn("dbo.Fees_AutomatedFeesConfig", "LateInConsecutiveAmount", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Fees_AutomatedFeesConfig", "LateInConsecutiveDay", c => c.Int());
            AddColumn("dbo.Fees_AutomatedFeesConfig", "LateInAbsConfigDay", c => c.Int());
            AddColumn("dbo.Fees_AutomatedFeesConfig", "LateInHeadIdAmountIsPercentage", c => c.Boolean(nullable: false));
            AddColumn("dbo.Fees_AutomatedFeesConfig", "LateInHeadIdAmount", c => c.Int());
            AddColumn("dbo.Fees_AutomatedFeesConfig", "LateInAmount", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Fees_AutomatedFeesConfig", "LateInPeriod", c => c.Int());
            AddColumn("dbo.Fees_AutomatedFeesConfig", "LateInHead", c => c.Int());
            AddColumn("dbo.Fees_AutomatedFeesConfig", "LatePayIsPreviouseFine", c => c.Boolean(nullable: false));
            AddColumn("dbo.Fees_AutomatedFeesConfig", "LatePayLongRangeHeadIdAmount", c => c.Int());
            AddColumn("dbo.Fees_AutomatedFeesConfig", "LatePayLongRangeAmountIsPercentage", c => c.Boolean(nullable: false));
            AddColumn("dbo.Fees_AutomatedFeesConfig", "LatePayLongRangeAmount", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Fees_AutomatedFeesConfig", "LatePayLongRange", c => c.Int());
            AddColumn("dbo.Fees_AutomatedFeesConfig", "LatePayHeadIdAmountIsPercentage", c => c.Boolean(nullable: false));
            AddColumn("dbo.Fees_AutomatedFeesConfig", "LatePayHeadIdAmount", c => c.Int());
            AddColumn("dbo.Fees_AutomatedFeesConfig", "LatePayAmount", c => c.Decimal(precision: 18, scale: 2));
            AddColumn("dbo.Fees_AutomatedFeesConfig", "IsFixed", c => c.Boolean(nullable: false));
            AddColumn("dbo.Fees_AutomatedFeesConfig", "LatePayDay", c => c.Int());
            AddColumn("dbo.Fees_AutomatedFeesConfig", "LatePayHeadId", c => c.Int());
            AddColumn("dbo.Fees_AutomatedFeesConfig", "ProcessId", c => c.Int(nullable: false));
            AddColumn("dbo.Fees_AutomatedFeesConfig", "FessGroupId", c => c.Int());
            AddColumn("dbo.Fees_AutomatedFeesConfig", "SectionId", c => c.Int());
            AddColumn("dbo.Fees_AutomatedFeesConfig", "ClassId", c => c.Int());
            AddColumn("dbo.Fees_AutomatedFeesConfig", "ShiftId", c => c.Int());
            AddColumn("dbo.Fees_AutomatedFeesConfig", "BranchId", c => c.Int());
            AddColumn("dbo.Fees_AutomatedFeesConfig", "SessionId", c => c.Int(nullable: false));
            DropColumn("dbo.Fees_AutomatedFeesConfig", "IsConfigChecked");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "Amount");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "LateDate");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "FeesFiscalSessionId");
            DropColumn("dbo.Fees_AutomatedFeesConfig", "FeesSessionYearId");
        }
    }
}
