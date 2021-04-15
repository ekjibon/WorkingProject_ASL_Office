namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Emp_DocumentArchive : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Emp_DocumentArchive",
                c => new
                    {
                        EmpDocumentID = c.Int(nullable: false, identity: true),
                        EmpID = c.Int(nullable: false),
                        DocumentName = c.String(),
                        File = c.Binary(),
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
                .PrimaryKey(t => t.EmpDocumentID);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.Emp_DocumentArchive");
        }
    }
}
