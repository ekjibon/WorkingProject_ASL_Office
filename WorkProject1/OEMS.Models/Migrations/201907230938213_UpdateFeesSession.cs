namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class UpdateFeesSession : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Fees_FeesSessionYear", "SessionName", c => c.String());
            AddColumn("dbo.Fees_FeesSessionYear", "SessionCode", c => c.String());
            AddColumn("dbo.Fees_FeesSessionYear", "ClassId", c => c.Int(nullable: false));
            AddColumn("dbo.Fees_FeesSessionYear", "Session_StartDate", c => c.DateTime(nullable: false));
            AddColumn("dbo.Fees_FeesSessionYear", "Session_EndDate", c => c.DateTime(nullable: false));
            AddColumn("dbo.Student_GuardianInfo", "E_GuardianImage", c => c.Binary());
            AddColumn("dbo.Student_GuardianInfo", "E_GuardianSignature", c => c.Binary());
            DropColumn("dbo.Fees_FeesSessionYear", "SessionId");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Fees_FeesSessionYear", "SessionId", c => c.Int(nullable: false));
            DropColumn("dbo.Student_GuardianInfo", "E_GuardianSignature");
            DropColumn("dbo.Student_GuardianInfo", "E_GuardianImage");
            DropColumn("dbo.Fees_FeesSessionYear", "Session_EndDate");
            DropColumn("dbo.Fees_FeesSessionYear", "Session_StartDate");
            DropColumn("dbo.Fees_FeesSessionYear", "ClassId");
            DropColumn("dbo.Fees_FeesSessionYear", "SessionCode");
            DropColumn("dbo.Fees_FeesSessionYear", "SessionName");
        }
    }
}
