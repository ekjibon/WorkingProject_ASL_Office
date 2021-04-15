namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class collectionmaster : DbMigration
    {
        public override void Up()
        {
            AlterColumn("dbo.Fees_CollectionMaster", "IsAdjust", c => c.Boolean());
            AlterColumn("dbo.Fees_CollectionMaster", "IsRefund", c => c.Boolean());
            AlterColumn("dbo.Fees_CollectionMaster", "IsResolved", c => c.Boolean());
            AlterColumn("dbo.Fees_CollectionMaster", "IsEnrollment", c => c.Boolean());
            AlterColumn("dbo.Fees_CollectionMaster", "IsOldStudent", c => c.Boolean());
            AlterColumn("dbo.Fees_CollectionMaster", "IsCashCollection", c => c.Boolean());
            DropColumn("dbo.Fees_Student", "PartialAmount");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Fees_Student", "PartialAmount", c => c.Decimal(precision: 18, scale: 2));
            AlterColumn("dbo.Fees_CollectionMaster", "IsCashCollection", c => c.Boolean(nullable: false));
            AlterColumn("dbo.Fees_CollectionMaster", "IsOldStudent", c => c.Boolean(nullable: false));
            AlterColumn("dbo.Fees_CollectionMaster", "IsEnrollment", c => c.Boolean(nullable: false));
            AlterColumn("dbo.Fees_CollectionMaster", "IsResolved", c => c.Boolean(nullable: false));
            AlterColumn("dbo.Fees_CollectionMaster", "IsRefund", c => c.Boolean(nullable: false));
            AlterColumn("dbo.Fees_CollectionMaster", "IsAdjust", c => c.Boolean(nullable: false));
        }
    }
}
