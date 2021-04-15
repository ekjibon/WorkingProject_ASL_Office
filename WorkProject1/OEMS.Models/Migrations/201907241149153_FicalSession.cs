namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class FicalSession : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Fees_FiscalSession",
                c => new
                    {
                        FeesFiscalSessionId = c.Int(nullable: false, identity: true),
                        SessionId = c.Int(nullable: false),
                        ClassId = c.Int(nullable: false),
                        Session_StartDate = c.DateTime(nullable: false),
                        Session_EndDate = c.DateTime(nullable: false),
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
                .PrimaryKey(t => t.FeesFiscalSessionId);
            
            DropColumn("dbo.Fees_FeesSessionYear", "SessionName");
            DropColumn("dbo.Fees_FeesSessionYear", "SessionCode");
            DropColumn("dbo.Fees_FeesSessionYear", "ClassId");
            DropColumn("dbo.Fees_FeesSessionYear", "Session_StartDate");
            DropColumn("dbo.Fees_FeesSessionYear", "Session_EndDate");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Fees_FeesSessionYear", "Session_EndDate", c => c.DateTime(nullable: false));
            AddColumn("dbo.Fees_FeesSessionYear", "Session_StartDate", c => c.DateTime(nullable: false));
            AddColumn("dbo.Fees_FeesSessionYear", "ClassId", c => c.Int(nullable: false));
            AddColumn("dbo.Fees_FeesSessionYear", "SessionCode", c => c.String());
            AddColumn("dbo.Fees_FeesSessionYear", "SessionName", c => c.String());
            DropTable("dbo.Fees_FiscalSession");
        }
    }
}
