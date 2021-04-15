namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AttendanceLog1502202111 : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Att_AttendanceLog",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        LogType = c.String(),
                        LogStatus = c.String(),
                        Description = c.String(),
                        LogDate = c.DateTime(nullable: false),
                        UserId = c.String(),
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
            
        }
        
        public override void Down()
        {
            DropTable("dbo.Att_AttendanceLog");
        }
    }
}
