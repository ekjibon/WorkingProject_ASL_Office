namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class studentgurdian : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Student_GuardianInfo", "LG4_Name", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG4_Relation", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG4_Address", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG4_Mobile", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG4_Email", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG4_TIN", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG4_NIDNo", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG4_GuardianImage", c => c.Binary());
            AddColumn("dbo.Student_GuardianInfo", "LG4_GuardianSignature", c => c.Binary());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Student_GuardianInfo", "LG4_GuardianSignature");
            DropColumn("dbo.Student_GuardianInfo", "LG4_GuardianImage");
            DropColumn("dbo.Student_GuardianInfo", "LG4_NIDNo");
            DropColumn("dbo.Student_GuardianInfo", "LG4_TIN");
            DropColumn("dbo.Student_GuardianInfo", "LG4_Email");
            DropColumn("dbo.Student_GuardianInfo", "LG4_Mobile");
            DropColumn("dbo.Student_GuardianInfo", "LG4_Address");
            DropColumn("dbo.Student_GuardianInfo", "LG4_Relation");
            DropColumn("dbo.Student_GuardianInfo", "LG4_Name");
        }
    }
}
