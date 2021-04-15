namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class LocalGuardian : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Student_GuardianInfo", "LG2_Name", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG2_Relation", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG2_Address", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG2_Mobile", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG2_Email", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG2_TIN", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG2_NIDNo", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG2_GuardianImage", c => c.Binary());
            AddColumn("dbo.Student_GuardianInfo", "LG2_GuardianSignature", c => c.Binary());
            AddColumn("dbo.Student_GuardianInfo", "LG3_Name", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG3_Relation", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG3_Address", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG3_Mobile", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG3_Email", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG3_TIN", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG3_NIDNo", c => c.String());
            AddColumn("dbo.Student_GuardianInfo", "LG3_GuardianImage", c => c.Binary());
            AddColumn("dbo.Student_GuardianInfo", "LG3_GuardianSignature", c => c.Binary());
        }
        
        public override void Down()
        {
            DropColumn("dbo.Student_GuardianInfo", "LG3_GuardianSignature");
            DropColumn("dbo.Student_GuardianInfo", "LG3_GuardianImage");
            DropColumn("dbo.Student_GuardianInfo", "LG3_NIDNo");
            DropColumn("dbo.Student_GuardianInfo", "LG3_TIN");
            DropColumn("dbo.Student_GuardianInfo", "LG3_Email");
            DropColumn("dbo.Student_GuardianInfo", "LG3_Mobile");
            DropColumn("dbo.Student_GuardianInfo", "LG3_Address");
            DropColumn("dbo.Student_GuardianInfo", "LG3_Relation");
            DropColumn("dbo.Student_GuardianInfo", "LG3_Name");
            DropColumn("dbo.Student_GuardianInfo", "LG2_GuardianSignature");
            DropColumn("dbo.Student_GuardianInfo", "LG2_GuardianImage");
            DropColumn("dbo.Student_GuardianInfo", "LG2_NIDNo");
            DropColumn("dbo.Student_GuardianInfo", "LG2_TIN");
            DropColumn("dbo.Student_GuardianInfo", "LG2_Email");
            DropColumn("dbo.Student_GuardianInfo", "LG2_Mobile");
            DropColumn("dbo.Student_GuardianInfo", "LG2_Address");
            DropColumn("dbo.Student_GuardianInfo", "LG2_Relation");
            DropColumn("dbo.Student_GuardianInfo", "LG2_Name");
        }
    }
}
