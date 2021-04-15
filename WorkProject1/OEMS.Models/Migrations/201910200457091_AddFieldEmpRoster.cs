namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddFieldEmpRoster : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Att_EmpRoster", "IsModifyApproved", c => c.Boolean(nullable: false));
            AddColumn("dbo.Att_EmpRoster", "ModifyStatus", c => c.String());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Att_EmpRoster", "ModifyStatus");
            DropColumn("dbo.Att_EmpRoster", "IsModifyApproved");
        }
    }
}
