namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddSecurityDepositDetailsModel : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Fees_Student", "FeesStudent_FeesStudentId", c => c.Long());
            CreateIndex("dbo.Fees_Student", "FeesStudent_FeesStudentId");
            AddForeignKey("dbo.Fees_Student", "FeesStudent_FeesStudentId", "dbo.Fees_Student", "FeesStudentId");
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.Fees_Student", "FeesStudent_FeesStudentId", "dbo.Fees_Student");
            DropIndex("dbo.Fees_Student", new[] { "FeesStudent_FeesStudentId" });
            DropColumn("dbo.Fees_Student", "FeesStudent_FeesStudentId");
        }
    }
}
