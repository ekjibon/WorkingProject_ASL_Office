namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class SubjectComments : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Res_SubjectWiseComment",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        MainExamId = c.Int(nullable: false),
                        SubjectId = c.Int(nullable: false),
                        StudentId = c.Int(nullable: false),
                        Comments = c.String(),
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
            DropTable("dbo.Res_SubjectWiseComment");
        }
    }
}
