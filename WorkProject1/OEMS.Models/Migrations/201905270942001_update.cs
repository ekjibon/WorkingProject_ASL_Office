namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class update : DbMigration
    {
        public override void Up()
        {
         
        }
        
        public override void Down()
        {
            AddColumn("dbo.Res_MainExamMarks", "ConvertedMarksFraction", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamMarks", "ConvertedMarks_Round", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamMarks", "ConvertedMarks_Floor", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("dbo.Res_MainExamMarks", "ConvertedMarks_Ceiling", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            
        }
    }
}
