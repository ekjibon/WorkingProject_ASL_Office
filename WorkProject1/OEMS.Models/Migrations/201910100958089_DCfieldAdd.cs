namespace OEMS.Models.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class DCfieldAdd : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.ACC_TransactionDetail", "DC", c => c.Int());
            AlterColumn("dbo.ACC_Branchs", "Name", c => c.String(maxLength: 50));
        }
        
        public override void Down()
        {
            AlterColumn("dbo.ACC_Branchs", "Name", c => c.String());
            DropColumn("dbo.ACC_TransactionDetail", "DC");
        }
    }
}
