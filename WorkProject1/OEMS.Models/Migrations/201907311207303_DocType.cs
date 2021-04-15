namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class DocType : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Res_MainExam", "IsLock", c => c.Boolean(nullable: false));
            AddColumn("dbo.Res_SubExam", "IsLock", c => c.Boolean(nullable: false));
            AddColumn("dbo.Portal_Document", "DocType", c => c.Int(nullable: false));
            AlterColumn("dbo.Ins_CSInfo", "VolunteerDate", c => c.DateTime());
        }
        
        public override void Down()
        {
            AlterColumn("dbo.Ins_CSInfo", "VolunteerDate", c => c.String());
            DropColumn("dbo.Portal_Document", "DocType");
            DropColumn("dbo.Res_SubExam", "IsLock");
            DropColumn("dbo.Res_MainExam", "IsLock");
        }
    }
}
