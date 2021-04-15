namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class modifycolumndurationapp04022021114 : DbMigration
    {
        public override void Up()
        {
            AlterColumn("dbo.HR_LeaveApplication", "TotalDays", c => c.Decimal(precision: 18, scale: 2));
            AlterColumn("dbo.HR_LeaveApplication", "TotalEffectDays", c => c.Decimal(precision: 18, scale: 2));
        }
        
        public override void Down()
        {
            AlterColumn("dbo.HR_LeaveApplication", "TotalEffectDays", c => c.Int());
            AlterColumn("dbo.HR_LeaveApplication", "TotalDays", c => c.Int(nullable: false));
        }
    }
}
